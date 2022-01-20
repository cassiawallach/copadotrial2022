@isTest
public with sharing class TestLicenseHelper {

    /**
	 * This test references the method on class LicenseHelper.ConvertLeadToLicense(Id LicenseId);
	*/
    static testMethod void LicenseHelperConvertLeadToLicense() {
        
        Copado_Settings__c c = new Copado_Settings__c(Name='Default', Default_Lead_Owner__c=UserInfo.getUserId());
        insert c;
        
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org', OrgId__c='00D20000000m7c0EAA');
        insert org;

        Lead testLead = createTestLead();
        sfLma__License__c license = createTestLicense(testLead.Id);

        createPackageAndFeatures();
        
        Test.startTest();
        LicenseHelper.webServiceResult wsr = LicenseHelper.convertLeadToLicense(license.Id);
        Test.stopTest();
        
        system.assertEquals(201, wsr.status);
        system.assertEquals(true, wsr.isSuccess);
        
        sfLma__License__c result = getLicense(license.Id);
        system.assertEquals(null, result.sfLma__Lead__c);
        system.assertNotEquals(null, result.Salesforce_Org__c);
        system.assertNotEquals(null, result.Salesforce_User__c);
        
        // Validate that Account has been deleted.
        List<Account> accs = [select Id from Account];
        system.assertEquals(0, accs.size());
    }
    
    /**
	 * TestMethod for invalid json when privisioning licenses
	*/
    static testMethod void testlicenseProvisioningNullParams() {
        String input = '[{"test":{"test">1,test.test.}}]';
    	Test.startTest();
        LicenseHelper.webServiceResult wsr = LicenseHelper.provisionCopadoLicenses(null, input);
        system.assertEquals(500, wsr.status);
        system.assertEquals(false, wsr.isSuccess);
        
        wsr = new LicenseHelper.webServiceResult();
        wsr = LicenseHelper.provisionCopadoLicenses(null, '');
        system.assertEquals(500, wsr.status);
        system.assertEquals(false, wsr.isSuccess);
        Test.stopTest();
    }
    /**
	 * TestMethod for LicenseHelper.provisionCopadoLicenses
	 * @param licenseId			The license id to be provisioned
	 * @param body				The JSON content to be passed in for provisioning
	 * @return string			We will return HTTP Status codes as this method will be referenced in a WebService
	*/
    static testMethod void testlicenseProvisioning() {
        String input = getInput();
        
        Copado_Settings__c c = new Copado_Settings__c(Name='Default', Default_Lead_Owner__c=UserInfo.getUserId());
        insert c;
        
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org', OrgId__c='00D20000000m7c0EAA');
        insert org;

        Lead testLead = createTestLead();
        sfLma__License__c license = createTestLicense(testLead.Id);
		createPackageAndFeatures();
        LicenseHelper.convertLeadToLicense(license.Id);
        
        Test.startTest();
        LicenseHelper.webServiceResult wsr = LicenseHelper.provisionCopadoLicenses(license.Id, input);
        Test.stopTest();
        
        //system.assertEquals(201, wsr.status);
        
        List<sfFma__FeatureParameterInteger__c> fpiResult = [select Id, sfFma__FullName__c, sfFma__Value__c, Expiration_Date__c from sfFma__FeatureParameterInteger__c];
        for(sfFma__FeatureParameterInteger__c r : fpiResult) {
            if (r.sfFma__FullName__c=='copado__EE_Licenses_Enabled') {
                system.assertEquals(1, r.sfFma__Value__c);
            	system.assertEquals(Date.today().addDays(10), r.Expiration_Date__c);
            }
            else if (r.sfFma__FullName__c=='copado__CCM_Licenses_Enabled') {
                system.assertEquals(5, r.sfFma__Value__c);
            	system.assertEquals(Date.newInstance(2020, 12, 31), r.Expiration_Date__c);
            }	
        }        
    }
    
    /** 
     * TestMethod for LicenseHelper.parseBody used by the Playground Creation Wizard
     */
    static testMethod void testParseBody() {
    	Map<String, Map<String, Object>> result = new Map<String, Map<String, Object>>();
        String input = getInput();
        result = LicenseHelper.parseBody(input);
     	system.assertEquals(2, result.size()); // copado__EE_Licenses_Enabled and copado__CCM_Licenses_Enabled defined;
        Map<String, Object> eeExample = result.get('copado__EE_Licenses_Enabled');
        system.assertEquals(1, Integer.valueOf(eeExample.get('licenses')));
        system.assertEquals(10, Integer.valueOf(eeExample.get('expireIn')));
        system.assertEquals(null, Date.valueOf(eeExample.get('expirationDate')));
        
        Map<String, Object> ccmExample = result.get('copado__CCM_Licenses_Enabled');
        system.assertEquals(5, Integer.valueOf(ccmExample.get('licenses')));
        system.assertEquals(null, Integer.valueOf(ccmExample.get('expireIn')));
        Date d = Date.valueOf(ccmExample.get('expirationDate').toString());
        system.assertEquals(Date.newInstance(2020, 12, 31), d);
    }
    
    /**
	 * TestMethod for LicenseHelper to update licenses. If all is correct we return a 201, Success repsonse object.
	*/
    static testMethod void testLicenseUpdate() {
        String input = '{"status": "Active","forceactive": true,"licenses": -1}';
        
        Copado_Settings__c c = new Copado_Settings__c(Name='Default', Default_Lead_Owner__c=UserInfo.getUserId());
        insert c;
        
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org', OrgId__c='00D20000000m7c0EAA');
        insert org;

        Lead testLead = createTestLead();
        sfLma__License__c license = createTestLicense(testLead.Id);
        
        Test.startTest();
        LicenseHelper.webServiceResult wsr = LicenseHelper.updateLicense(license.Id, input);
        Test.stopTest();
        
        system.assertEquals(201, wsr.status);
        system.assertEquals(true, wsr.isSuccess);
    }
    /**
	 * TestMethod for LicenseHelper to update licenses. If all is correct we return a 201, Success repsonse object.
	*/
    static testMethod void testLicenseUpdate_errorParsinInput() {
        String input = '{"status": "Active","forceactive": "true","licenses": -1}';//true was made a string.
        
        Copado_Settings__c c = new Copado_Settings__c(Name='Default', Default_Lead_Owner__c=UserInfo.getUserId());
        insert c;
        
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org', OrgId__c='00D20000000m7c0EAA');
        insert org;

        Lead testLead = createTestLead();
        sfLma__License__c license = createTestLicense(testLead.Id);
        
        Test.startTest();
        LicenseHelper.webServiceResult wsr = LicenseHelper.updateLicense(license.Id, input);
        system.assertEquals(500, wsr.status);
        system.assertEquals(false, wsr.isSuccess);
        system.assertEquals('Error parsing JSON: Invalid conversion from runtime type String to Boolean', wsr.statusMessage);
        
        input = '{"status": "Active","forceactive": true,"licenses": -1}'; // changed back to valid json to test next try/catch
        wsr = LicenseHelper.updateLicense('00D00D00D00D00D', input);
        system.assertEquals(500, wsr.status);
        system.assertEquals(false, wsr.isSuccess);
        system.debug('%%%% '+wsr.statusMessage);
        system.assert(wsr.statusMessage.contains('A matching license record could not be found using the record Id'));
        Test.stopTest();
        
    }
    public static String getInput(){
        return '[{"copado__EE_Licenses_Enabled":{"licenses":1, "expireIn":10, "expirationDate":null},"copado__CCM_Licenses_Enabled":{"licenses": 5, "expireIn":null, "expirationDate":"2020-12-31"}}]';
    }
    public static Lead createTestLead() {
        Lead lead = new Lead(Company='MyPlaygroundOrg', FirstName='Philipp', LastName='Rackwitz', LeadSource='Package Installation', Email='pr@copa.do');
        lead.OrgId__c = '00D20000000m7c0EAA';
        lead.Rating='Tier 2';
        lead.NumberOfEmployees=100;
        lead.Industry='Bank and Finance';
        lead.Next_Contact__c=System.today();
        lead.Next_Step__c='Next Step';
        insert lead;
        return lead;
    }
    public static sfLma__License__c createTestLicense(Id leadId) {
        sfLma__License__c license = new sfLma__License__c();
        license.sfLma__Lead__c = leadId;
        license.sfLma__Status__c='Active';
        license.sfLma__Subscriber_Org_ID__c='00D20000000m7c0EAA';
        license.sfLma__Used_Licenses__c = 1;
        license.sfLma__Seats__c = -1;	         
        license.sfLma__Install_Date__c = system.today();
        license.sfLma__License_Type__c = 'Editable';
        license.sfLma__Package_License_ID__c = 'some package id';
        insert license;
        return license;
    }
    private static sfLma__License__c getLicense(Id licenseId) {
        return [select Id, Name, IsDeleted, sfLma__Lead__c, Salesforce_Org__c, Salesforce_User__c from sfLma__License__c where IsDeleted=false and Id=:licenseId limit 1];
    }
    public static void createPackageAndFeatures(){
        sfLma__Package__c pack = new sfLma__Package__c(Name='Copado Deployer', sfLma__Developer_Name__c='Copado BasePackage');
        insert pack;

        List<sfFma__FeatureParameter__c> fpList = new List<sfFma__FeatureParameter__c>();
		sfFma__FeatureParameter__c fpCCM = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__CCM_Licenses_Enabled',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpCCM);
		sfFma__FeatureParameter__c fpCAD = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__CAD_Licenses_Enabled',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpCAD);
		sfFma__FeatureParameter__c fpCCH = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__CCH_Licenses_Enabled',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpCCH);
		sfFma__FeatureParameter__c fpCSTL = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__CST_Licenses_Enabled',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpCSTL);
		sfFma__FeatureParameter__c fpEE = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__EE_Licenses_Enabled',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpEE);
        sfFma__FeatureParameter__c fpADD = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__ADD_Licenses_Enabled',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpADD);
		sfFma__FeatureParameter__c fpCSTM = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__CST_Minutes_Packages',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpCSTM);
		sfFma__FeatureParameter__c fpCBM = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__CBM_Branches',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpCBM);
        		sfFma__FeatureParameter__c fpFunctions = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__Functions',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpFunctions);
        		sfFma__FeatureParameter__c fpFunctionsHL = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__CustomFunctionHardCreditLimit',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpFunctionsHL);
        		sfFma__FeatureParameter__c fpFunctionsSL = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__CustomFunctionSoftCreditLimit',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpFunctionsSL);
        		sfFma__FeatureParameter__c fpFunctionsU = new sfFma__FeatureParameter__c(
				sfFma__FullName__c = 'copado__CustomFunctionCreditUsage',
				sfFma__DataType__c = 'Integer',
				sfFma__Namespace_Prefix__c = 'copado',
				sfFma__DataFlowDirection__c = 'LMO to Subscriber',
				sfFma__IntroducedInPackageVersion__c = '10.0',
				sfFma__Package__c = pack.Id
		);
		fpList.add(fpFunctionsU);
		insert fpList;
    }
}