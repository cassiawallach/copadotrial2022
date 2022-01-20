@isTest
public class TestCalculateCurrentARROnQuote {
    static testmethod void test1() {
        
        
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 p2 = new Pricebook2(Name='Test', CurrencyIsoCode='EUR', IsActive=true);
        insert p2;
        
        Product2 p = new Product2(Name='My Test', IsActive=true, Family='Licenses', Credits_to_be_assigned__c=0,kuga_sub__Renewable__c=true);
        insert p;
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p.Id, UnitPrice=5, IsActive=true,CurrencyIsoCode='EUR');
        insert standardPrice;
        
        Account a = new Account(Name='My Account');
        insert a;
        
        Contact con = new Contact(FirstName='Test', LastName='Test', AccountId=a.Id);
        insert con;
        
        Id RecdTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        Opportunity o = new Opportunity(Name='My Opp', AccountId=a.Id, RecordTypeId = RecdTypeId, StageName='Marketing Qualification', CloseDate=Date.today(), CurrencyIsoCode='EUR', Main_Problems__c='Problem', Amount = 99.0,LeadSource = 'Advertisement');       
        insert o;       
        
        Id usrId = userinfo.getUserId();
        Date endDate = system.Today().addYears(1);
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Account__c = a.Id,SBQQ__Opportunity2__c=o.id,SBQQ__SalesRep__c=usrId,SBQQ__Primary__c=true,SBQQ__PrimaryContact__c=con.Id,SBQQ__StartDate__c=system.today(),SBQQ__EndDate__c = endDate);
        insert quote;
        
        quote.Current_ARR__c = 45000;
        Update quote;
        
        SBQQ__QuoteLine__c qline = new SBQQ__QuoteLine__c();
        qline.SBQQ__Quote__c = quote.Id;
        qline.SBQQ__StartDate__c = system.today();
        qline.SBQQ__EndDate__c = system.today().addYears(1);
        qline.SBQQ__Product__c = p.Id;                         
        qline.SBQQ__ListPrice__c = 5;
        qline.SBQQ__Quantity__c = 1;
        qline.SBQQ__OriginalPrice__c = 5;
        qline.SBQQ__ProrateMultiplier__c= 12;
        qline.SBQQ__SegmentIndex__c= 1;
        qline.SBQQ__Description__c= 'test';
        qline.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        qline.SBQQ__DefaultSubscriptionTerm__c = 1;
        qline.Proposal_Segment_Index__c = 'Year  1';
        qline.Proposal_Segment_Label__c = 'Year  1 - Licenses & Support';
        qline.ARR__c = 45000;
        qline.SBQQ__PricebookEntryId__c = standardPrice.Id;
        qline.SBQQ__ProductSubscriptionType__c = 'Renewable';
        qline.SBQQ__SegmentKey__c = '1602758020922';
        qline.SBQQ__SegmentLabel__c = 'Year  1';
        qline.SBQQ__SubscriptionBase__c = 'List';
        qline.SBQQ__SubscriptionCategory__c = 'Licenses';
        qline.SBQQ__SubscriptionType__c = 'Renewable';
        qline.SBQQ__Uplift__c = 0;
        qline.SBQQ__PricingMethod__c = 'List';
        qline.SBQQ__NetPrice__c = 5;
        qline.SBQQ__Discount__c = 0; 
        
        insert qline;
        
        Test.startTest();        
        System.enqueueJob(new CalculateCurrentARROnQuote());
        Test.stopTest();
    }
}