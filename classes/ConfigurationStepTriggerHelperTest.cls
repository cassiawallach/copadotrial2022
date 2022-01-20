@isTest
public with sharing class ConfigurationStepTriggerHelperTest {
	@testSetup 
    static void testDataSetup(){
        copado.GlobalAPI.UserLicense copadoUserLicense = new copado.GlobalAPI.UserLicense(UserInfo.getUserId(),false,false,false,true,false);
        copado.GlobalAPI gapi = new copado.GlobalAPI();
        gapi.upsertCopadoLicense(UserInfo.getUserId(), copadoUserLicense);
        
        Configuration_Steps_Definition__c configStepDef = new Configuration_Steps_Definition__c(Name='My Config Step Definition', Status__c = 'Active');
        insert configStepDef;
    }
    
     static testMethod void testPackageKeyEncryptiongOnInsertUpdate() {
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        Configuration_Steps_Definition__c configStepDef = [Select Id From Configuration_Steps_Definition__c Where Name = 'My Config Step Definition']; 

        String packageInstallationKey = 'test#123#$';
        Configuration_Step__c cs = new Configuration_Step__c(Configuration_Steps_Definition__c = configStepDef.Id, Name = 'Package with Key', Order__c = 1, Org__c = 'Dev1', Type__c = 'Package Installation', Package_Id__c = 'test', Package_Installation_Key__c = packageInstallationKey);
        test.startTest();
        insert cs;
        cs = [Select Id, Package_Installation_Key__c From Configuration_Step__c Where Name = 'Package with Key'];
		
		// Verify Package Installation Key value encrypted while saving 
        System.assertNotEquals(packageInstallationKey, cs.Package_Installation_Key__c);
        
        String packageInstallationKeyUpdated = 'new-test#123';
        cs.Package_Installation_Key__c = packageInstallationKeyUpdated;
        
        update cs;
        test.stopTest();
        
		cs = [Select Id, Package_Installation_Key__c From Configuration_Step__c Where Name = 'Package with Key'];
		
        // Verify Package Installation Key value encrypted while updating with new value
        System.assertNotEquals(packageInstallationKeyUpdated, cs.Package_Installation_Key__c);
    }
    
    static testMethod void testPackageWithoutKey() {
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        Configuration_Steps_Definition__c configStepDef = [Select Id From Configuration_Steps_Definition__c Where Name = 'My Config Step Definition']; 

        Configuration_Step__c cs = new Configuration_Step__c(Configuration_Steps_Definition__c = configStepDef.Id, Name = 'Package without Key', Order__c = 1, Org__c = 'Dev1', Type__c = 'Package Installation', Package_Id__c = 'test', Package_Installation_Key__c = null);
        test.startTest();
        insert cs;
        cs = [Select Id, Package_Installation_Key__c From Configuration_Step__c Where Name = 'Package without Key'];
		test.stopTest();
        
		// Verify no encryption for null value of Package Installation Key
        System.assertEquals(null, cs.Package_Installation_Key__c);
    }
    
    static testMethod void testCSDelete() {
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        Configuration_Steps_Definition__c configStepDef = [Select Id From Configuration_Steps_Definition__c Where Name = 'My Config Step Definition']; 

        Configuration_Step__c cs = new Configuration_Step__c(Configuration_Steps_Definition__c = configStepDef.Id, Name='Apex Script', Order__c = 1, Org__c = 'Dev1', Type__c = 'Anonymous Apex', Apex_Script__c = 'test script');
        insert cs;
        test.startTest();
        cs = [Select Id, Name From Configuration_Step__c Where Name = 'Apex Script'];
        System.assertNotEquals(null, cs);
        delete cs;
        test.stopTest();
        
        // Configuration Step deleted successfully
		cs = [Select Id, IsDeleted from Configuration_Step__c WHERE Id = :cs.Id ALL ROWS];
		System.assertEquals(cs.IsDeleted, true);
    }
}