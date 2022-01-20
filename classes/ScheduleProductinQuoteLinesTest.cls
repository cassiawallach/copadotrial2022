@istest
class ScheduleProductinQuoteLinesTest{
    public static testMethod void testschedule() {
        Test.StartTest();
        
        Product2 p = new Product2(Name='My Test', IsActive=true, Family='Licenses', Credits_to_be_assigned__c=0,kuga_sub__Renewable__c=true);
        insert p;
                  
        Account a = new Account(Name='My Account');
        insert a;
        
        Contact con = new Contact(FirstName='Test', LastName='Test', AccountId=a.Id);
        insert con;
        
        Id RecdTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        Opportunity o = new Opportunity(Name='My Opp', AccountId=a.Id, RecordTypeId = RecdTypeId, StageName='Marketing Qualification', CloseDate=Date.today(), CurrencyIsoCode='EUR', Main_Problems__c='Problem', Amount = 99.0, LeadSource = 'Advertisement');  
        insert o;
            
        Id usrId = userinfo.getUserId();
        Date endDate = system.Today().addYears(2);
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Account__c = a.Id,SBQQ__Opportunity2__c=o.id,SBQQ__SalesRep__c=usrId,SBQQ__Primary__c=true,SBQQ__PrimaryContact__c=con.Id,SBQQ__StartDate__c=system.today(),SBQQ__EndDate__c = endDate);
        insert quote;
        
        SBQQ__Quote__c quote1 = new SBQQ__Quote__c(SBQQ__Account__c = a.Id,SBQQ__Opportunity2__c=o.id,SBQQ__SalesRep__c=usrId,SBQQ__Primary__c=true,SBQQ__PrimaryContact__c=con.Id,SBQQ__StartDate__c=system.today(),SBQQ__EndDate__c = endDate);
        insert quote1;
        
        SBQQ__QuoteLine__c qline1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quote1.Id,SBQQ__Product__c = p.Id,SBQQ__StartDate__c = system.today(),SBQQ__EndDate__c = system.today().addYears(1),SBQQ__Description__c= 'test',SBQQ__ProrateMultiplier__c=12);
        insert qline1;
        
        SBQQ__QuoteLine__c qline = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quote.Id,SBQQ__Product__c = p.Id,SBQQ__StartDate__c = system.today(),SBQQ__EndDate__c = system.today().addYears(1), OriginalQuoteLineId2__c = qline1.Id,SBQQ__Description__c= 'test',SBQQ__ProrateMultiplier__c=12);
        insert qline; 
        
       
        ScheduleProductinQuoteLines testsche = new ScheduleProductinQuoteLines();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}