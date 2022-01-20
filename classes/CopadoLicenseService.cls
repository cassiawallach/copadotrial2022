@RestResource(urlMapping='/CopadoLicenseService/*')
global without sharing class CopadoLicenseService {
    @HttpGet
    global static String getLicenseByOrgId() {
        LicenseHelper.webServiceResult wsr = new LicenseHelper.webServiceResult();
		sfLma__License__c license = new sfLma__License__c();
        
        RestRequest req = RestContext.request;
        String orgId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        system.debug('@@@ '+orgId);
        try {
            license = [SELECT Id, Name, sfLma__Package_Version__r.sfLma__Version_Number__c, sfLma__Subscriber_Org_ID__c FROM sfLma__License__c where sfLma__Subscriber_Org_ID__c = :orgId limit 1];
            //system.debug('License found: '+license);
            //wsr.isSuccess = true;
            //wsr.status = 200;
            //wsr.statusMessage = 'Success';
            //wsr.body = String.valueOf(license);
            return license.sfLma__Package_Version__r.sfLma__Version_Number__c;
        }
        catch (Exception e) {
            //wsr.isSuccess = false;
            //wsr.status = 500;
            //wsr.statusMessage = 'Could not find license with orgId ("'+orgId+'"): '+e.getMessage();
            return null;//JSON.serialize(wsr);
        }
    }
	@HttpPost
    global static String enterMethods(){
        LicenseHelper.webServiceResult wsr = new LicenseHelper.webServiceResult();
        RestRequest req = RestContext.request;
        Map<String, String> reqHeaders = req.headers;
        Service_Tokens__c serviceToken = Service_Tokens__c.getValues('AcademyCommunityIntegration');
        if(!reqHeaders.containsKey('apiKey') || reqHeaders.get('apiKey')!= serviceToken.Token__c) {
            wsr.isSuccess = false;
            wsr.status = 401;
            wsr.statusMessage = 'UNAUTHORIZED: You must specify a valid "apiKey"';
            return JSON.serialize(wsr);
        }
        RestResponse res = Restcontext.response;
        String orgId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String uriString = String.valueOf(req.requestURI);
        
        sfLma__License__c license = new sfLma__License__c();
        try {
            license = [select Id, sfLma__Subscriber_Org_ID__c FROM sfLma__License__c where sfLma__Subscriber_Org_ID__c = :orgId limit 1];
            system.debug('License found: '+license);
        }
        catch (Exception e) {
            wsr.isSuccess = false;
            wsr.status = 500;
            wsr.statusMessage = 'Could not find license with orgId ("'+orgId+'"): '+e.getMessage();
            return JSON.serialize(wsr);
        }
        
        if(uriString.containsIgnoreCase('convertlead')) {
            system.debug('convertLead');
            wsr = LicenseHelper.convertLeadToLicense(license.Id);
        }
        else if(uriString.containsIgnoreCase('provisionlicenses')) {
            system.debug('provisionLicenses');
            if(req.requestBody == null) {
                wsr.isSuccess = false;
                wsr.status = 500;
                wsr.statusMessage = 'When doing a POST, the body cannot be left empty.';
                return JSON.serialize(wsr);
            }
            wsr = LicenseHelper.provisionCopadoLicenses(license.Id, req.requestBody.toString());
        }
        else if(uriString.containsIgnoreCase('updatelicense')) {
            system.debug('updateLicense');
            if(req.requestBody == null) {
                wsr.isSuccess = false;
                wsr.status = 500;
                wsr.statusMessage = 'When doing a POST, the body cannot be left empty.';
                return JSON.serialize(wsr);
            }
            wsr = LicenseHelper.updateLicense(license.Id, req.requestBody.toString());
        }
        else {
            wsr.isSuccess = false;
            wsr.status = 500;
            wsr.statusMessage = 'The URL was parsed but the "provisionLicenses", "convertLead", "updateLicense" strings were not found. URL received:'+req.requestURI;
        }
        return JSON.serialize(wsr);
	}
}