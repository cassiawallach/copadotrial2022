@isTest
public class TestOrderTrigger {
    static testMethod void testOrderActivation(){
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 p2 = TestDataFactory.createPricebook(); 
        p2.CurrencyIsoCode = 'EUR';
        insert p2;         
        
        Product2 p = TestDataFactory.createProduct('Enterprise', 'Licenses',null);
        p.IsActive=true;
        p.Family='Membership fees';
        p.Credits_to_be_assigned__c=0;
        p.NumberOfRevenueInstallments = 1;
        p.CanUseRevenueSchedule = true;
        p.RevenueInstallmentPeriod = 'Monthly';
        p.RevenueScheduleType = 'Repeat';
        insert p;
        
        PricebookEntry customPrice = TestDataFactory.createPricebookEntry(p2.Id,p.Id, p2.CurrencyIsoCode, 300);
            
        Account a = TestDataFactory.createAccount('My Account', 'EUR');
        insert a;
        
        Opportunity o = TestDataFactory.createOpportunity(a,'My Opp','New Customer');
        o.Main_Problems__c= 'The problem';
        insert o;
       
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(p2.name); 
        insert testKugamonSetting ;
        
        Contract c = TestDataFactory.createDraftContract(a.Id, o.CurrencyIsoCode);
        c.StartDate = Date.today();
        c.ContractTerm = 12;
        insert c;   
        c.Status = 'Activated';
        update c;
        
        Order testOrder =  TestDataFactory.createOrder(a.Id,c,p2,Date.today(),Date.today().addYears(1).addDays(-1) );
        testOrder.EffectiveDate = Date.today();
        testOrder.OpportunityId = o.Id;
        insert testOrder;
      
        OrderItem oi = TestDataFactory.createOrderItem(customPrice,testOrder.id,2,3600);
        insert oi;
        
        Order testOrder2 = TestDataFactory.createOrder(a.Id,c,p2,Date.today(),Date.today().addYears(1).addDays(-1) );
        testOrder2.EffectiveDate = Date.today();
        testOrder2.OpportunityId = o.Id;
        insert testOrder2;
        
        OrderItem oi2 = TestDataFactory.createOrderItem(customPrice,testOrder2.id,1,3600);
        insert oi2;
            
        Test.startTest();
        OrderTriggerHelper.inTrigger = false;
        testOrder.Status = 'Provisioned';
        update testOrder;
        
        testOrder2.Status = 'Provisioned';
        update testOrder2;
       
        Test.stopTest();
        
        for (Order order:[select Id, AccountId, CurrencyIsoCode, TotalAmount from Order where Status='Provisioned' and AccountId = :a.Id]){
            System.debug('**** Contract Total Amount: ' + order.TotalAmount);
        }
        
        Account result = [select Id, Total_Account_Value_EUR__c from Account where Id=:a.Id limit 1];
        System.assertEquals(10800.0, result.Total_Account_Value_EUR__c);
    }
}