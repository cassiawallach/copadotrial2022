@isTest
private class TestSalesforceOrgService {

    static testMethod void testSalesforceOrgService() {

        Copado_Settings__c custSet = TestDataFactory.createCopadoSetting();                
        custSet.Default_Lead_Owner__c = UserInfo.getUserId();
        insert custSet;
        
        Account a = TestDataFactory.createAccount('Fake Needed Account', 'EUR');
        insert a;

        Contact cntc = TestDataFactory.createContact(a.Id, 'Fake Needed Contact');
        cntc.Email = 'Theo' + 'testclass' + '@copa.do.testclass';
        insert cntc;

        Lead lead = TestDataFactory.createLead('Test', 'Copado Test');
        lead.FirstName = 'Org';
        lead.LeadSource = 'Package Installation';
        lead.Rating = 'Tier 2';
        lead.Next_Step__c = 'Next';
        lead.Next_Contact__c = System.today();
        lead.NumberOfEmployees = 98;
        lead.Industry = 'Banking and Finance';
        lead.Email = 'test@salesforce.org';
        insert lead;
        
        Salesforce_Org__c sforg = TestDataFactory.createSalesforceOrg('Test Method Org');
        sforg.OrgId__c = '00D1l0000000dkE';
        insert sforg;
        
        sfLma__License__c lic = TestDataFactory.createLicense(sforg.Id,5);
        lic.sfLma__Subscriber_Org_ID__c = 'COPADOTESTID';
        lic.sfLma__Expiration__c = Date.today()+1;
        lic.sfLma__Lead__c = lead.Id;
        insert lic;    
        
        sfLma__Package__c pack = TestDataFactory.craetePackage('Copado Deployer');
        pack.sfLma__Developer_Name__c = 'Copado BasePackage';
        insert pack;
        
        sfFma__FeatureParameter__c fpCCM = TestDataFactory.createFeatureParameter('copado__CCM_Licenses_Enabled',
                                                                                  'Integer','copado',
                                                                                  '10.0','LMO to Subscriber', pack.Id);
        insert fpCCM;
        
        sfFma__FeatureParameter__c fpCAD = TestDataFactory.createFeatureParameter('copado__CAD_Licenses_Enabled',
                                                                                  'Integer','copado',
                                                                                  '10.0','LMO to Subscriber', pack.Id);
        insert fpCAD;
        sfFma__FeatureParameter__c fpCCH = TestDataFactory.createFeatureParameter('copado__CCH_Licenses_Enabled',
                                                                                  'Integer','copado',
                                                                                  '10.0','LMO to Subscriber', pack.Id);
           
        insert fpCCH;
        sfFma__FeatureParameter__c fpCSTL = TestDataFactory.createFeatureParameter('copado__CST_Licenses_Enabled',
                                                                                  'Integer','copado',
                                                                                  '10.0','LMO to Subscriber', pack.Id);
         
        insert fpCSTL;
        sfFma__FeatureParameter__c fpEE =  TestDataFactory.createFeatureParameter('copado__EE_Licenses_Enabled',
                                                                                  'Integer','copado',
                                                                                  '10.0','LMO to Subscriber', pack.Id);
        
        insert fpEE;
        sfFma__FeatureParameter__c fpCSTM =  TestDataFactory.createFeatureParameter('copado__CST_Minutes_Packages',
                                                                                  'Integer','copado',
                                                                                  '10.0','LMO to Subscriber', pack.Id);
        insert fpCSTM;
        sfFma__FeatureParameter__c fpCBM = TestDataFactory.createFeatureParameter('copado__CBM_Branches',
                                                                                  'Integer','copado',
                                                                                  '10.0','LMO to Subscriber', pack.Id);
          
        insert fpCBM;
        Test.startTest();

        //We convert the Lead into the Salesforce Org that will create the empty feature parameter integers
        Database.BatchableContext dbc;
        List<sfLma__License__c> batch_scope = new List<sfLma__License__c>();
        batch_scope.add(lic);
        LeadConvertBatch batchApex = new LeadConvertBatch();
        batchApex.execute(dbc, batch_scope);

        Salesforce_User__c user = [SELECT Id FROM Salesforce_User__c WHERE Email__c = 'test@salesforce.org' LIMIT 1];
        System.assert(user != null);
        Salesforce_Org__c org = [SELECT Id, OrgId__c, Org_Type__c, Licensed_Seats__c, Trial_Expiration_Date__c, License_User__c, Type__c, Next_Top_Up_Date__c FROM Salesforce_Org__c WHERE OrgId__c = :LeadConvertBatch.ID15to18('COPADOTESTID') LIMIT 1];
        System.assertEquals('Production', org.Org_Type__c);
        System.assertEquals(Date.today()+1, org.Trial_Expiration_Date__c);

        org.Parent_Account__c = a.Id;
        
        Pricebook2 pb = TestDataFactory.createPricebook(); 
        pb.CurrencyIsoCode = 'EUR';
        insert pb;           
        
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(pb.name); 
        insert testKugamonSetting ;
        
        Contract c = TestDataFactory.createDraftContract(a.Id, a.CurrencyIsoCode);
        c.StartDate = Date.today();
        c.ContractTerm = 12;
        insert c;    
        
        Contract con = TestDataFactory.createDraftContract(a.Id, a.CurrencyIsoCode);
        con.Key_Contact__c = cntc.Id;
        con.StartDate = Date.today()-1;              
        insert con;
        con.Status = 'Activated';
        update con;

        org.Type__c = 'Customer';
        update org;

        org = [SELECT Id, OrgId__c, Org_Type__c, Licensed_Seats__c, Trial_Expiration_Date__c, License_User__c, Type__c, Next_Top_Up_Date__c FROM Salesforce_Org__c WHERE OrgId__c = :LeadConvertBatch.ID15to18('COPADOTESTID') LIMIT 1];
        System.assertEquals(con.StartDate.addMonths(1), org.Next_Top_Up_Date__c);

        org.Type__c = 'Prospect';
        update org;
        org = [SELECT Id, OrgId__c, Org_Type__c, Licensed_Seats__c, Trial_Expiration_Date__c, License_User__c, Type__c, Next_Top_Up_Date__c FROM Salesforce_Org__c WHERE OrgId__c = :LeadConvertBatch.ID15to18('COPADOTESTID') LIMIT 1];
        System.assertEquals(null, org.Next_Top_Up_Date__c);

        Test.stopTest();
    }
}