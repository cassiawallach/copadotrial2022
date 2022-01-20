@isTest
private class TestLicenseTrigger {

    static testMethod void testFeatureParameterIntegers() {

        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org', OrgId__c='00D20000000m7c0EAA');
        insert org;

		sfLma__License__c license = TestLicenseHelper.createTestLicense(null);

        TestLicenseHelper.createPackageAndFeatures();

        Test.startTest();

        license.Salesforce_Org__c = org.Id;
        update license;

        Map<String, Id> fpMap = new Map<String, Id>();
        for (sfFma__FeatureParameter__c p : [select Id, sfFma__FullName__c from sfFma__FeatureParameter__c]) {
            fpMap.put(p.sfFma__FullName__c, p.Id);
        }
        
        for (sfFma__FeatureParameterInteger__c fpi : [SELECT sfFma__License__c, sfFma__FeatureParameter__c, sfFma__FullName__c,sfFma__Value__c FROM sfFma__FeatureParameterInteger__c]) {
            System.assertEquals(license.Id, fpi.sfFma__License__c, 'Assertian failed for '+fpi.sfFma__FullName__c);
            System.assertEquals(fpMap.get(fpi.sfFma__FullName__c), fpi.sfFma__FeatureParameter__c, 'Assertian failed for '+fpi.sfFma__FullName__c);
            System.assertEquals(0, fpi.sfFma__Value__c, 'Assertian failed for '+fpi.sfFma__FullName__c);
        }
        
		Test.stopTest();
        
        List<Salesforce_Org__c> orgL = [SELECT Id, Org_Edition__c, Name FROM Salesforce_Org__c WHERE Id = :org.Id];
        System.assertEquals(1, orgL.size());
        System.assertEquals(license.sfLma__Org_Edition__c, orgL[0].Org_Edition__c);
        System.assertEquals(orgL[0].Name, 'Test Org');
    }
}