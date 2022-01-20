@isTest
public class TestContractOrderExtension {
    static testMethod void validateErrorNoOrg(){
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 p2 = new Pricebook2(Name='Test', CurrencyIsoCode='EUR', IsActive=true);
        insert p2;
        
        Account ca = TestDataFactory.createAccount('Copado Solutions SL','EUR');
        ca.Billing_Name__c='Copado Solutions SL';
        ca.BillingStreet='Avenida de Valdemarin 140, Bajo C';
        ca.BillingCity='Madrid'; 
        ca.BillingState='Madrid'; 
        ca.BillingPostalCode='28023'; 
        ca.BillingCountry='ES';
        insert ca;
        
        Opportunity o = TestDataFactory.createOpportunity(ca, 'My Opp', 'New Customer');
        o.AccountId=ca.Id;
        o.CloseDate=Date.today();
        o.Main_Problems__c = 'Opp Main problem';
        o.Amount = 100;
        o.LeadSource='Customer';
        insert o;
        
        kugo2p__KugamonSetting__c testKugamonSetting = testMethodUtilities.createKugamonSetting(p2.name);
        
       	Contract c = TestDataFactory.createDraftContract(ca.Id,ca.CurrencyIsoCode);
        c.StartDate=Date.today();
        insert c;
        
        order testOrder = TestDataFactory.createOrder(ca.Id,c,p2,Date.today(),Date.today().addYears(1).addDays(-1));
        testOrder.Status='Draft';
        testOrder.OpportunityId = o.Id;
        insert testOrder;
        
        ContractOrderExtension ext = new ContractOrderExtension(new ApexPages.StandardController(testOrder));
        ext.init();
        System.assert(testMethodUtilities.hasMessage('You must add a Salesforce Org to the order before proceeding.'));
    }
    
    static testMethod void fullTest_withCreateCustomer(){
        User usAdmin = TestDataFactory.getAdminUser();
        System.runAs(usAdmin){
            System.debug('### fullTest_withCreateCustomer');
            Id pricebookId = Test.getStandardPricebookId();
            Pricebook2 p2 = new Pricebook2(Name='Test', CurrencyIsoCode='EUR', IsActive=true);
            insert p2;
            
            Product2 p = TestDataFactory.createProduct('My Test', 'Membership fees', null);
            insert p;
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p.Id, UnitPrice=5, IsActive=true,CurrencyIsoCode='EUR');
            insert standardPrice;
            
            PricebookEntry customPrice = new PricebookEntry(Pricebook2Id=p2.Id, Product2Id=p.Id, UnitPrice=5, IsActive=true,CurrencyIsoCode='EUR');
            insert customPrice;
            
            CHANNEL_ORDERS__Partner_Contract_Terms__c sfdcContract = TestDataFactory.createPartnerContractTerms('Ltd*_ISVForce_EUR2');
            insert sfdcContract;
            
            CHANNEL_ORDERS__Partner_Product_Catalog__c soli1=  TestDataFactory.createPartnerProductCatalog('EE license',sfdcContract.Id);
            insert soli1;
            p.Partner_Product_Catalog__c = soli1.Id;
            update p;
            
            Account ca = TestDataFactory.createAccount('Copado Solutions SL','EUR');
            ca.Billing_Name__c='Copado Solutions SL';
            ca.BillingStreet='Avenida de Valdemarin 140, Bajo C';
            ca.BillingCity='Madrid'; 
            ca.BillingState='Madrid'; 
            ca.BillingPostalCode='28023'; 
            ca.BillingCountry='ES';
            insert ca;
            
            Salesforce_Org__c sa = new Salesforce_Org__c(Name='ProductionOrg', Parent_Account__c=ca.Id, OrgId__c='00Db0000000IH73');
            insert sa;
            
            Opportunity o = TestDataFactory.createOpportunity(ca, 'My Opp', 'New Customer');
            o.AccountId=ca.Id;
            o.CloseDate=Date.today();
            o.Main_Problems__c = 'Opp Main problem';
            o.Amount = 100;
            o.LeadSource='Customer';
            insert o;
            
            OpportunityLineItem oli = TestDataFactory.createOpportunityLineItem(o.Id,customPrice.Id);
            insert oli;
            
            List<OpportunityLineItemSchedule> newOliSchedules = new List<OpportunityLineItemSchedule>();
            for(Integer i=0; i<p.NumberOfRevenueInstallments; i++){
                OpportunityLineItemSchedule oliSchedule = new OpportunityLineItemSchedule(OpportunityLineItemId=oli.Id, Type='Revenue');
                oliSchedule.ScheduleDate = oli.ServiceDate.addMonths(i);
                oliSchedule.Revenue = customPrice.UnitPrice * oli.Quantity;
                newOliSchedules.add(oliSchedule);
            }
            insert newOliSchedules;
            
            kugo2p__KugamonSetting__c testKugamonSetting = testMethodUtilities.createKugamonSetting(p2.name);
            
            Contract c = TestDataFactory.createDraftContract(ca.Id,ca.CurrencyIsoCode);
            c.StartDate=Date.today();
            c.Custom_Salesforce_Org__c=sa.Id;
            c.Opportunity__c=o.Id;
            insert c;
            
            order testOrder = TestDataFactory.createOrder(ca.Id,c,p2,Date.today(),Date.today().addYears(1).addDays(-1));
            testOrder.Status='Draft';
            testOrder.OpportunityId = o.Id;
            testOrder.Custom_Salesforce_Org__c = sa.Id;
            insert testOrder;
            
            orderItem oi = TestDataFactory.createOrderItem(customPrice,testOrder.Id,oli.Quantity,oli.UnitPrice);
            oi.SBQQ__UnproratedNetPrice__c = 5.48;
            insert oi;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(testOrder);
            ContractOrderExtension ext = new ContractOrderExtension(sc);
            ext.init();
            PageReference pageRef = ext.createOrder();
            
            List<CHANNEL_ORDERS__Customer__c> custs = [SELECT Id, CHANNEL_ORDERS__Customer_Org_ID__c FROM CHANNEL_ORDERS__Customer__c WHERE CHANNEL_ORDERS__Customer_Org_ID__c=:sa.OrgId__c.substring(0,15)];
            System.assertEquals(1, custs.size());
            
            CHANNEL_ORDERS__Partner_Contract_Terms__c testOrderPartnerContractTerm = new CHANNEL_ORDERS__Partner_Contract_Terms__c();
            insert testOrderPartnerContractTerm;
            
            CHANNEL_ORDERS__Service_Order__c  testChannelOrderServiceOrder =TestDataFactory.createChannelOrdersServiceOrder();
            testChannelOrderServiceOrder.CHANNEL_ORDERS__Customer_Org_ID__c=sa.OrgId__c;
            testChannelOrderServiceOrder.CHANNEL_ORDERS__Customer__c=custs[0].Id;
            testChannelOrderServiceOrder.CHANNEL_ORDERS__Created_with_new_COA__c=true;
            testChannelOrderServiceOrder.CHANNEL_ORDERS__Partner_Contract_Rules__c = sfdcContract.Id;
            testChannelOrderServiceOrder.CHANNEL_ORDERS__Order_Type__c = 'Initial';
            insert testChannelOrderServiceOrder;
            
            List<CHANNEL_ORDERS__Service_Order__c> result = [SELECT Id, Name, Contract__c, CHANNEL_ORDERS__Customer__c, CurrencyIsoCode, CHANNEL_ORDERS__Created_with_new_COA__c, CHANNEL_ORDERS__Customer_Org_ID__c, CHANNEL_ORDERS__Order_Type__c FROM CHANNEL_ORDERS__Service_Order__c WHERE Order__c=:testOrder.Id];
            System.assertEquals(1, result.size(), 'Service Order Size');
            System.assertEquals(true, result[0].CHANNEL_ORDERS__Created_with_new_COA__c);
            System.assertEquals(sa.OrgId__c, result[0].CHANNEL_ORDERS__Customer_Org_ID__c);
            System.assertEquals(custs[0].Id, result[0].CHANNEL_ORDERS__Customer__c);
        }
    }
    
    static testMethod void testConvertedCurrency(){
        Salesforce_Org__c sa = new Salesforce_Org__c(Name='ProductionOrg', OrgId__c='00Db0000000IH73');
        insert sa;
        
        ContractOrderExtension ext = new ContractOrderExtension(new ApexPages.StandardController(new Order(Custom_Salesforce_Org__c=sa.Id)));
        ext.init();
        
        List<CurrencyType> result = ext.getCurrencyRates();
        System.assertEquals(2, result.size());
        
        Double eur = ext.getConvertedAmount('GBP', Double.valueOf(9027.0));
        System.assertEquals(10620.0, eur);
    }
}