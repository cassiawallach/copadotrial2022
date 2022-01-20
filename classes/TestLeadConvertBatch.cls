@isTest
private class TestLeadConvertBatch {

    static testMethod void testLeadConversionWithOrgAndUser() {

        Copado_Settings__c custSet = new Copado_Settings__c(
                Name = 'Default',
                Default_Lead_Owner__c = UserInfo.getUserId());
        insert custSet;

        System.assertEquals('00D20000000m7c0EAA', LeadConvertBatch.ID15to18('00D20000000m7c0'));
        
        Salesforce_Org__c org = new Salesforce_Org__c(
            Name = 'Test Org',
            OrgId__c = '00D20000000m7c0EAA');
        insert org;

        Salesforce_User__c usr = new Salesforce_User__c(
            Email__c = 'pr@copa.do',
            Salesforce_Org__c = Org.Id);
        insert usr;
        
        Lead lead = new Lead(Company='My test Account',FirstName='test', LastName='Test',LeadSource='Package Installation',Rating = 'Tier 2',NumberOfEmployees = 100, Industry = 'Bank and Finance',Next_Contact__c = System.today(), Next_Step__c = 'Next Step',Email='pr@copa.do');
        insert lead;
        sfLma__License__c license = new sfLma__License__c();
        license.sfLma__Lead__c=lead.Id;
        license.sfLma__Status__c='Active';
        license.sfLma__Subscriber_Org_ID__c='00D20000000m7c0EAA';
        license.sfLma__Used_Licenses__c = 1;
        license.sfLma__Seats__c = -1;
        license.sfLma__Install_Date__c = System.today();
        license.sfLma__License_Type__c = 'Editable';
        license.sfLma__Package_License_ID__c = 'some package id';
        
        insert license;

        sfLma__Package__c pack = new sfLma__Package__c(
                Name = 'Copado Deployer',
                sfLma__Developer_Name__c = 'Copado BasePackage'
        );
        insert pack;

        sfFma__FeatureParameter__c fpCCM = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CCM_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCCM;
        sfFma__FeatureParameter__c fpCAD = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CAD_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCAD;
        sfFma__FeatureParameter__c fpCCH = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CCH_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCCH;
        sfFma__FeatureParameter__c fpCSTL = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CST_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCSTL;
        sfFma__FeatureParameter__c fpEE = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__EE_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpEE;
        sfFma__FeatureParameter__c fpADD = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__ADD_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpADD;
        sfFma__FeatureParameter__c fpCSTM = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CST_Minutes_Packages',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCSTM;
        sfFma__FeatureParameter__c fpCBM = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CBM_Branches',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCBM;
       

        Test.startTest();
        LeadConvertBatch batchApex = new LeadConvertBatch();   
        Id batchprocessid = Database.executeBatch(batchApex,1);
        Test.stopTest(); 
        
        Lead convertedLead = [SELECT Id, FirstName, LastName, Email, IsConverted, ConvertedAccountId, ConvertedContactId FROM Lead WHERE Id =:lead.Id];
        System.assertEquals(true, convertedLead.IsConverted);
        System.assert(convertedLead.ConvertedAccountId != null);
        System.assert(convertedLead.ConvertedContactId != null);
        
        List<sfLma__License__c> results = new List<sfLma__License__c>();
        results = [SELECT Id,sfLma__Lead__c,Salesforce_Org__c, Salesforce_User__c, Salesforce_Org__r.OrgId__c FROM sfLma__License__c WHERE Id=:license.Id];
        for(sfLma__License__c r : results){
            System.assertEquals(null, r.sfLma__Lead__c);
            System.assertEquals(org.Id, r.Salesforce_Org__c);
            System.assertEquals(usr.Id, r.Salesforce_User__c);
            System.assert(r.Salesforce_Org__r.OrgId__c != null);
        }
    }

    static testMethod void testLeadConversionNoOrgNorUser() {

        Copado_Settings__c custSet = new Copado_Settings__c(
                Name = 'Default',
                Default_Lead_Owner__c = UserInfo.getUserId());
        insert custSet;
        
        System.assertEquals('00D20000000m7c0EAA', LeadConvertBatch.ID15to18('00D20000000m7c0'));
        
        Lead lead = new Lead(Company='My test Account',FirstName='test', LastName='Test',LeadSource='Package Installation',Rating = 'Tier 2',NumberOfEmployees = 100, Industry = 'Bank and Finance',Next_Contact__c = System.today(), Next_Step__c = 'Next Step',Email='pr@copa.do');
        insert lead;
        sfLma__License__c license = new sfLma__License__c();
        license.sfLma__Lead__c=lead.Id;
        license.sfLma__Status__c='Active';
        license.sfLma__Subscriber_Org_ID__c='00D20000000m7c0EAA';
        license.sfLma__Used_Licenses__c = 1;
        license.sfLma__Seats__c = -1;
        license.sfLma__Install_Date__c = System.today();
        license.sfLma__License_Type__c = 'Editable';
        license.sfLma__Package_License_ID__c = 'some package id';
    
        insert license;

        sfLma__Package__c pack = new sfLma__Package__c(
                Name = 'Copado Deployer',
                sfLma__Developer_Name__c = 'Copado BasePackage'
        );
        insert pack;

        sfFma__FeatureParameter__c fpCCM = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CCM_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCCM;
        sfFma__FeatureParameter__c fpCAD = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CAD_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCAD;
        sfFma__FeatureParameter__c fpCCH = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CCH_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCCH;
        sfFma__FeatureParameter__c fpCSTL = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CST_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCSTL;
        sfFma__FeatureParameter__c fpEE = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__EE_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpEE;
        sfFma__FeatureParameter__c fpADD = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__ADD_Licenses_Enabled',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpADD;
        sfFma__FeatureParameter__c fpCSTM = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CST_Minutes_Packages',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCSTM;
        sfFma__FeatureParameter__c fpCBM = new sfFma__FeatureParameter__c(
                sfFma__FullName__c = 'copado__CBM_Branches',
                sfFma__DataType__c = 'Integer',
                sfFma__Namespace_Prefix__c = 'copado',
                sfFma__DataFlowDirection__c = 'LMO to Subscriber',
                sfFma__IntroducedInPackageVersion__c = '10.0',
                sfFma__Package__c = pack.Id
        );
        insert fpCBM;

        Test.startTest();
        LeadConvertBatch batchApex = new LeadConvertBatch();   
        Id batchprocessid = Database.executeBatch(batchApex,1);
        Test.stopTest(); 
        
        Lead convertedLead = [SELECT Id, FirstName, LastName, Email, IsConverted, ConvertedAccountId, ConvertedContactId FROM Lead WHERE Id =:lead.Id];
        System.assertEquals(true, convertedLead.IsConverted);
        System.assert(convertedLead.ConvertedAccountId != null);
        System.assert(convertedLead.ConvertedContactId != null);
        
        List<sfLma__License__c> results = new List<sfLma__License__c>();
        results = [SELECT Id,sfLma__Lead__c,Salesforce_Org__r.OrgId__c, Salesforce_Org__c, Salesforce_User__c FROM sfLma__License__c WHERE Id=:license.Id];
        for(sfLma__License__c r : results){
            System.assertEquals(null, r.sfLma__Lead__c);
            System.assertEquals('00D20000000m7c0EAA',r.Salesforce_Org__r.OrgId__c);
            System.assert(r.Salesforce_Org__c != null);
            System.assert(r.Salesforce_User__c != null);
        }
    }
}