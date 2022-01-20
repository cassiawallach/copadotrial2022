@isTest
public class TestCopadoLicenseService {
    static testMethod void testAccessAuthorizationMissingKey(){
        sfLma__License__c license = testLicenseHelper.createTestLicense(null);
        String postBody = TestLicenseHelper.getInput();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CopadoLicenseService/updateLicense/'+license.sfLma__Subscriber_Org_ID__c; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(postBody);
        
        RestContext.request = req;
        RestContext.response= res;
    	
        Test.startTest();
        	String result = CopadoLicenseService.enterMethods();
        Test.stopTest();
        
        Object wsro = JSON.deserialize(result, System.Type.forName('LicenseHelper.webServiceResult'));
        LicenseHelper.webServiceResult wsr = (LicenseHelper.webServiceResult)wsro;
        String errorMessage = 'UNAUTHORIZED: You must specify a valid "apiKey"';
        system.assertEquals(401, wsr.status);
        system.assertEquals(false, wsr.isSuccess);
        system.assertEquals(errorMessage, wsr.statusMessage);
    }
    static testMethod void testAccessAuthorizationBadKey(){
        sfLma__License__c license = testLicenseHelper.createTestLicense(null);
        String postBody = TestLicenseHelper.getInput();
        String apiKey = generateAPIkey();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CopadoLicenseService/updateLicense/'+license.sfLma__Subscriber_Org_ID__c; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(postBody);
        req.addHeader('apiKey', 'badKey');
        
        RestContext.request = req;
        RestContext.response= res;
    	
        Test.startTest();
        	String result = CopadoLicenseService.enterMethods();
        Test.stopTest();
        
        Object wsro = JSON.deserialize(result, System.Type.forName('LicenseHelper.webServiceResult'));
        LicenseHelper.webServiceResult wsr = (LicenseHelper.webServiceResult)wsro;
        String errorMessage = 'UNAUTHORIZED: You must specify a valid "apiKey"';
        system.assertEquals(401, wsr.status);
        system.assertEquals(false, wsr.isSuccess);
        system.assertEquals(errorMessage, wsr.statusMessage);
    }
    static testMethod void testLicenseNotFoundException(){
        sfLma__License__c license = testLicenseHelper.createTestLicense(null);
        String postBody = TestLicenseHelper.getInput();
        String apiKey = generateAPIkey();
        RestRequest req = new RestRequest();
        req.addHeader('apiKey', apiKey);
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CopadoLicenseService/updateLicense/00DWrongId00D'; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(postBody);
        
        RestContext.request = req;
        RestContext.response= res;
    	
        Test.startTest();
        	String result = CopadoLicenseService.enterMethods();
        Test.stopTest();
        
        Object wsro = JSON.deserialize(result, System.Type.forName('LicenseHelper.webServiceResult'));
        LicenseHelper.webServiceResult wsr = (LicenseHelper.webServiceResult)wsro;
        String errorMessage = 'Could not find license with orgId ("00DWrongId00D"): List has no rows for assignment to SObject';
        system.assertEquals(500, wsr.status);
        system.assertEquals(false, wsr.isSuccess);
        system.assertEquals(errorMessage, wsr.statusMessage);
    }
    static testMethod void testGetMethodSuccess(){
        Lead testLead = TestLicenseHelper.createTestLead();
        sfLma__License__c license = TestLicenseHelper.createTestLicense(testLead.Id);

        String apiKey = generateAPIkey();
        RestRequest req = new RestRequest();
        req.addHeader('apiKey', apiKey);
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CopadoLicenseService/updateLicense/00D20000000m7c0EAA';
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
    	
        Test.startTest();
        	String licenseNumber = CopadoLicenseService.getLicenseByOrgId();
        Test.stopTest();
        
        system.assertEquals(license.sfLma__Package_Version__r.sfLma__Version_Number__c, licenseNumber);        
    }    
    static testMethod void testInvalidURL(){
        sfLma__License__c license = testLicenseHelper.createTestLicense(null);
        String postBody = TestLicenseHelper.getInput();
        String apiKey = generateAPIkey();
        RestRequest req = new RestRequest();
        req.addHeader('apiKey', apiKey);
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CopadoLicenseService/something/'+license.sfLma__Subscriber_Org_ID__c; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(postBody);
    
        RestContext.request = req;
        RestContext.response= res;
    	
        Test.startTest();
        	String result = CopadoLicenseService.enterMethods();
        Test.stopTest();
        
        Object wsro = JSON.deserialize(result, System.Type.forName('LicenseHelper.webServiceResult'));
        LicenseHelper.webServiceResult wsr = (LicenseHelper.webServiceResult)wsro;
        String errorMessage = 'The URL was parsed but the "provisionLicenses", "convertLead", "updateLicense" strings were not found. URL received:'+req.requestURI;
        system.assertEquals(500, wsr.status);
        system.assertEquals(false, wsr.isSuccess);
        system.assertEquals(errorMessage, wsr.statusMessage);
    }
    static testMethod void testPostEmptyBody_provisionLicenses(){
        sfLma__License__c license = testLicenseHelper.createTestLicense(null);
        String postBody = TestLicenseHelper.getInput();
        String apiKey = generateAPIkey();
        RestRequest req = new RestRequest();
        req.addHeader('apiKey', apiKey);
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CopadoLicenseService/provisionLicenses/'+license.sfLma__Subscriber_Org_ID__c; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = null;
    
        RestContext.request = req;
        RestContext.response= res;
    	
        Test.startTest();
        	String result = CopadoLicenseService.enterMethods();
        	Object wsro = JSON.deserialize(result, System.Type.forName('LicenseHelper.webServiceResult'));
        	LicenseHelper.webServiceResult wsr = (LicenseHelper.webServiceResult)wsro;
        	system.assertEquals(500, wsr.status);
        	system.assertEquals(false, wsr.isSuccess);
        	system.assertEquals( 'When doing a POST, the body cannot be left empty.', wsr.statusMessage);
        Test.stopTest();
    }
    static testMethod void testPostEmptyBody_updateLicense(){
        sfLma__License__c license = testLicenseHelper.createTestLicense(null);
        String postBody = TestLicenseHelper.getInput();
        String apiKey = generateAPIkey();
        RestRequest req = new RestRequest();
        req.addHeader('apiKey', apiKey);
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CopadoLicenseService/updateLicense/'+license.sfLma__Subscriber_Org_ID__c; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = null;
    
        RestContext.request = req;
        RestContext.response= res;
    	
        Test.startTest();
        	String result = CopadoLicenseService.enterMethods();
        	Object wsro = JSON.deserialize(result, System.Type.forName('LicenseHelper.webServiceResult'));
        	LicenseHelper.webServiceResult wsr = (LicenseHelper.webServiceResult)wsro;
        	system.assertEquals(500, wsr.status);
        	system.assertEquals(false, wsr.isSuccess);
        	system.assertEquals( 'When doing a POST, the body cannot be left empty.', wsr.statusMessage);
        Test.stopTest();
    }
    static testMethod void testPostSuccessProvisionLicenses(){
        
        Copado_Settings__c c = new Copado_Settings__c(Name='Default', Default_Lead_Owner__c=UserInfo.getUserId());
        insert c;
        
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org', OrgId__c=UserInfo.getOrganizationId());
        insert org;

        Lead testLead = testLicenseHelper.createTestLead();
        sfLma__License__c license = testLicenseHelper.createTestLicense(testLead.Id);
		testLicenseHelper.createPackageAndFeatures();
        LicenseHelper.convertLeadToLicense(license.Id);
        
        
        String postBody = TestLicenseHelper.getInput();
        String apiKey = generateAPIkey();
        RestRequest req = new RestRequest();
        req.addHeader('apiKey', apiKey);
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CopadoLicenseService/provisionLicenses/'+license.sfLma__Subscriber_Org_ID__c; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(postBody);
    
        RestContext.request = req;
        RestContext.response= res;
    	
        Test.startTest();
        	String result = CopadoLicenseService.enterMethods();
        	Object wsro = JSON.deserialize(result, System.Type.forName('LicenseHelper.webServiceResult'));
        	LicenseHelper.webServiceResult wsr = (LicenseHelper.webServiceResult)wsro;
        	//system.assertEquals(201, wsr.status);
        	//system.assertEquals(true, wsr.isSuccess);
        Test.stopTest();
    }
    static testMethod void testPostSuccessUpdateLicenses(){
        
        Copado_Settings__c c = new Copado_Settings__c(Name='Default', Default_Lead_Owner__c=UserInfo.getUserId());
        insert c;
        
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org', OrgId__c='00D20000000m7c0EAA');
        insert org;

        Lead testLead = testLicenseHelper.createTestLead();
        sfLma__License__c license = testLicenseHelper.createTestLicense(testLead.Id);
		testLicenseHelper.createPackageAndFeatures();
        LicenseHelper.convertLeadToLicense(license.Id);
        
        String postBody = '{"status":"Suspended", "forceactive":true, "licenses":10}';
        String apiKey = generateAPIkey();
        RestRequest req = new RestRequest();
        req.addHeader('apiKey', apiKey);
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CopadoLicenseService/updateLicense/'+license.sfLma__Subscriber_Org_ID__c; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(postBody);
    
        RestContext.request = req;
        RestContext.response= res;
    	
        Test.startTest();
        	String result = CopadoLicenseService.enterMethods();
        	Object wsro = JSON.deserialize(result, System.Type.forName('LicenseHelper.webServiceResult'));
        	LicenseHelper.webServiceResult wsr = (LicenseHelper.webServiceResult)wsro;
        	system.assertEquals(201, wsr.status);
        	system.assertEquals(true, wsr.isSuccess);
        	license = [select Id, Force_to_remain_Active__c, sfLma__Seats__c, sfLma__Status__c from sfLma__License__c where Id= :license.Id limit 1];
        	system.assertEquals(true, license.Force_to_remain_Active__c);
        	system.assertEquals(10, license.sfLma__Seats__c);
        	system.assertEquals('Suspended', license.sfLma__Status__c);
        Test.stopTest();
    }
    static testMethod void testPostSuccessConvertLead(){
        
        Copado_Settings__c c = new Copado_Settings__c(Name='Default', Default_Lead_Owner__c=UserInfo.getUserId());
        insert c;
        
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org', OrgId__c='00D20000000m7c0EAA');
        insert org;

        Lead testLead = TestLicenseHelper.createTestLead();
        sfLma__License__c license = TestLicenseHelper.createTestLicense(testLead.Id);

        TestLicenseHelper.createPackageAndFeatures();
        
        
        String postBody = TestLicenseHelper.getInput();
        String apiKey = generateAPIkey();
        RestRequest req = new RestRequest();
        req.addHeader('apiKey', apiKey);
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CopadoLicenseService/convertLead/'+license.sfLma__Subscriber_Org_ID__c; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(postBody);
    
        RestContext.request = req;
        RestContext.response= res;
    	
        Test.startTest();
        	String result = CopadoLicenseService.enterMethods();
        	Object wsro = JSON.deserialize(result, System.Type.forName('LicenseHelper.webServiceResult'));
        	LicenseHelper.webServiceResult wsr = (LicenseHelper.webServiceResult)wsro;
        	system.assertEquals(201, wsr.status);
        	system.assertEquals(true, wsr.isSuccess);
        	system.assertEquals('Lead successfully converted and Account deleted.', wsr.statusMessage);
        Test.stopTest();
    }

    private static String generateAPIkey(){
        Service_Tokens__c st = new Service_Tokens__c(Name='AcademyCommunityIntegration');
        st.Token__c = 'abcd1234';
		insert st;
        return st.Token__c;
    }
}