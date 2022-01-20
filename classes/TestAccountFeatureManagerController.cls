@isTest
private class TestAccountFeatureManagerController {
    
    @isTest static void testAFMC() {
        Account acc = TestDataFactory.createAccount('Fake needed acc', 'EUR');
        insert acc;
        
        Contact con = TestDataFactory.createContact(acc.id,'Fakecon');
        insert con;
        
        Salesforce_Org__c org = TestDataFactory.createSalesforceOrg('Test Method Org');
        org.OrgId__c = '00D1l0000000dkE';
        insert org;
        
        sfLma__License__c lic = TestDataFactory.createLicense(org.Id,5);
        lic.sfLma__Subscriber_Org_ID__c = '00D1l0000000dkE';
        lic.sfLma__Expiration__c = Date.today()+1;
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
        
        //CCM Feature Parameter
        sfFma__FeatureParameterInteger__c fpi = TestDataFactory.createFeatureParameterInteger('copado__CCM_Licenses_Enabled',lic.Id, fpCCM.Id);   
        fpi.External_Id__c = org.Id + '_' + 'copado__CCM_Licenses_Enabled';
        fpi.Expiration_Date__c = null;
        fpi.sfFma__Value__c = 0;
        insert fpi;
        
        //CAD Feature Parameter
        fpi = TestDataFactory.createFeatureParameterInteger('copado__CAD_Licenses_Enabled',lic.Id, fpCAD.Id);
        fpi.External_Id__c = org.Id + '_' + 'copado__CAD_Licenses_Enabled';
        fpi.Expiration_Date__c = null;
        fpi.sfFma__Value__c = 0;
        insert fpi;
        
        //CCH Feature Parameter
        fpi = TestDataFactory.createFeatureParameterInteger('copado__CCH_Licenses_Enabled',lic.Id, fpCCH.Id);
            fpi.External_Id__c = org.Id + '_' + 'copado__CCH_Licenses_Enabled';
            fpi.Expiration_Date__c = null;
            fpi.sfFma__Value__c = 0;
        insert fpi;
        
        //CST Licenses Feature Parameter
        fpi = TestDataFactory.createFeatureParameterInteger('copado__CST_Licenses_Enabled',lic.Id, fpCSTL.Id);
        fpi.External_Id__c = org.Id + '_' + 'copado__CST_Licenses_Enabled';
        fpi.Expiration_Date__c = null;
        fpi.sfFma__Value__c = 0;
        insert fpi;
        
        //EE Licenses Feature Parameter
        fpi = TestDataFactory.createFeatureParameterInteger('copado__EE_Licenses_Enabled',lic.Id, fpEE.Id);
        fpi.External_Id__c = org.Id + '_' + 'copado__EE_Licenses_Enabled';
        fpi.Expiration_Date__c = null;
        fpi.sfFma__Value__c = 0;
        insert fpi;
        
        //CST Minutes Packages Feature Parameter
        fpi = TestDataFactory.createFeatureParameterInteger('copado__CST_Minutes_Packages',lic.Id, fpCSTM.Id);
        fpi.External_Id__c = org.Id + '_' + 'copado__CST_Minutes_Packages';
        fpi.Expiration_Date__c = null;
        fpi.sfFma__Value__c = 0;
        insert fpi;
        
        //CBM Licenses Feature Parameter
        fpi = TestDataFactory.createFeatureParameterInteger('copado__CBM_Branches',lic.Id, fpCBM.Id);
            fpi.External_Id__c = org.Id + '_' + 'copado__CBM_Branches';
            fpi.Expiration_Date__c = null;
            fpi.sfFma__Value__c = 0;
        insert fpi;
        Test.startTest();
        
        Id pricebookId = Test.getStandardPricebookId();  
        Pricebook2 p2 = TestDataFactory.createPricebook(); 
        p2.CurrencyIsoCode = 'EUR';
        insert p2; 
        
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(p2.name); 
        insert testKugamonSetting ;
        
        Contract cont = TestDataFactory.createDraftContract(acc.Id, acc.CurrencyIsoCode);
        cont.Key_Contact__c = con.Id;
        cont.StartDate = Date.today()-1;
        cont.ContractTerm = 12;
        insert cont;
        
        AccountFeatureManagerController controller  = new AccountFeatureManagerController(new ApexPages.StandardController(org));
        System.assert(!testMethodUtilities.hasMessage('This org does not have a contract.'));
        
        controller.getorgFeatures();
        System.assertEquals(7, controller.orgFeatures.size());
        
        controller.updateorgFeatures();
        
        Test.stopTest();
    }
    
    @isTest static void testWithoutContract() {
        
        Salesforce_Org__c org = TestDataFactory.createSalesforceOrg('I have no contract!');
        insert org;
        
        Test.startTest();
        
        AccountFeatureManagerController controller = new AccountFeatureManagerController(new ApexPages.StandardController(org));
        System.assert(testMethodUtilities.hasMessage('This org does not have an activated contract.'));
        
        Test.stopTest();
    }
}