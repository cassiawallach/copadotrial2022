@isTest
public class TestOpportunityLineItemTriggerHandler {
    @isTest
    public static void unitTest(){
        Product2 Prod =  new Product2();
        Prod.Name='NewProd';
        Prod.CanUseRevenueSchedule  = true;
        Prod.NumberOfRevenueInstallments = 10;
        Prod.RevenueScheduleType = 'Divide';
        Prod.RevenueInstallmentPeriod = 'Monthly';
        Prod.IsActive=True;
        insert Prod;
        System.debug('Prod'+Prod);
        
        
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id=Prod.Id;
        pbe.IsActive=True;
        pbe.UnitPrice=70;
        pbe.Pricebook2Id = standardPricebook.Id;//[Select Id from Pricebook2 where IsStandard=true].Id;//;Test.getStandardPricebookId();
        System.debug('Prod@@2'+pbe.Pricebook2Id );
        pbe.UseStandardPrice=false;
        insert pbe;
        
        Account accObj = New Account();
        accObj.Name= 'Test';
        Insert accObj;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Marketing Qualification';
        opp.Amount =120;
        opp.AccountId = accObj.Id;
        opp.CloseDate = DateTime.now().Date();
        opp.LeadSource = 'AE Prospecting';
        insert opp;
        
        OpportunityLineItem opli = new OpportunityLineItem();
        opli.UnitPrice = 57;
        opli.Quantity = 12;
        opli.OpportunityId=opp.Id;
        opli.PricebookEntryId=pbe.id;
        insert opli;
        //Delete opli;
        OpportunityLineItemSchedule schedule = New OpportunityLineItemSchedule();
        schedule.OpportunityLineItemId = opli.id;
        schedule.ScheduleDate = system.today();
        schedule.Type = 'Revenue';
        schedule.Revenue = 2345;
       
        //Insert schedule;
      
    }
    
}