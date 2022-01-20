@isTest
public class TestOrderItemImporterExtension {
    static testMethod void successScenario(){
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 p2 = TestDataFactory.createPricebook(); 
        p2.CurrencyIsoCode = 'EUR';
        insert p2;    
        
        Product2 p = TestDataFactory.createProduct('Enterprise', 'Licenses',null);
        p.Family='Membership fees'; 
        p.Credits_to_be_assigned__c=0;
        p.NumberOfRevenueInstallments = 12;
        p.CanUseRevenueSchedule = true;
        p.RevenueInstallmentPeriod = 'Monthly';
        p.RevenueScheduleType = 'Repeat';
        insert p;
        
        PricebookEntry standardPrice = new PricebookEntry(CurrencyIsoCode = 'EUR',Pricebook2Id=pricebookId, Product2Id=p.Id, UnitPrice=5, IsActive=true);
        insert standardPrice;
        
        PricebookEntry customPrice = new PricebookEntry(CurrencyIsoCode = 'EUR',Pricebook2Id=p2.Id, Product2Id=p.Id, UnitPrice=100, IsActive=true);
        insert customPrice;
        
        Account a = TestDataFactory.createAccount('My Account', 'EUR');
        insert a;
        
        Opportunity o = TestDataFactory.createOpportunity(a,'My Opp','New Customer');
        o.Main_Problems__c= 'Opp main problems';
        insert o;
        
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(p2.name); 
        insert testKugamonSetting;
        
        OpportunityLineItem oli = TestDataFactory.createOpportunityLineItem(o.Id,customPrice.id);
        insert oli;
        
		List<OpportunityLineItemSchedule> newOliSchedules = new List<OpportunityLineItemSchedule>();
        for(Integer i=0; i<p.NumberOfRevenueInstallments; i++){
            OpportunityLineItemSchedule oliSchedule = new OpportunityLineItemSchedule(OpportunityLineItemId=oli.Id, Type='Revenue');
            oliSchedule.ScheduleDate = oli.ServiceDate.addMonths(i);
            oliSchedule.Revenue = customPrice.UnitPrice * oli.Quantity;
            newOliSchedules.add(oliSchedule);
        }
        insert newOliSchedules;
        
        Contract c = TestDataFactory.createDraftContract(a.Id, o.CurrencyIsoCode);
        c.StartDate = Date.today();
        c.Opportunity__c = o.Id;
        c.ContractTerm = 12;
        insert c; 
  
        
        Order testOrder = TestDataFactory.createOrder(a.Id,c,p2,Date.today(),Date.today().addYears(1).addDays(-1) );
            //new Order(AccountId=a.Id, Pricebook2Id=p2.Id, CurrencyIsoCode=o.CurrencyIsoCode, ContractId=c.Id, Status='Draft');
        //testOrder.EffectiveDate = o.CloseDate.addDays(1);
        //testOrder.EndDate = o.CloseDate.addYears(1).addDays(-1);
        testOrder.OpportunityId = o.Id;
        //testOrder.Pricebook2Id = null;
        insert testOrder;
        
        System.debug('Test Order inserted: ' + testOrder);
        
        PageReference pref = Page.OrderItemImporter;
        pref.getParameters().put('id', testOrder.Id);
        Test.setCurrentPage(pref); 
        
        Test.startTest();
        OrderItemImporterExtension ext = new OrderItemImporterExtension(new ApexPages.StandardController(testOrder));
        pref = ext.doImport();
        Test.stopTest();
        
        List<OrderItem> result = [SELECT Id, Quantity, UnitPrice, Recurring_Monthly_Price__c, Order.Pricebook2Id FROM OrderItem WHERE OrderId=:testOrder.Id];
        System.debug('result: ' + result);
        System.debug('page reference: ' + pref);
        System.assertEquals('/'+testOrder.Id, pref.getUrl());
        System.assertEquals(1, result.size());
        System.assertEquals(p2.Id, result[0].Order.Pricebook2Id);
        System.assertEquals(2, result[0].Quantity);
        System.assertEquals(100, result[0].Recurring_Monthly_Price__c);
    }
}