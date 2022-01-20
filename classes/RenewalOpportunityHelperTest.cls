@isTest
public class RenewalOpportunityHelperTest{

    static testmethod void RenewalOpptyHelperMethod(){
    
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
                //qline.SBQQ__SubscriptionPercent__c= '';
                qline.Proposal_Segment_Index__c = 'Year  1';
                qline.Proposal_Segment_Label__c = 'Year  1 - Licenses & Support';
                //qline.SBQQ__Dimension__c = quot;
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
         
        /*SBQQ__QuoteLine__c renewQline = new SBQQ__QuoteLine__c();
                renewQline.SBQQ__Quote__c = quote.Id;
                renewQline.SBQQ__StartDate__c = system.today().addYears(1);
                renewQline.SBQQ__EndDate__c = endDate;
                renewQline.SBQQ__Product__c = p.Id;                         
                renewQline.SBQQ__ListPrice__c = 5;
                renewQline.SBQQ__Quantity__c = 1;
                renewQline.SBQQ__OriginalPrice__c = 5;
                renewQline.SBQQ__ProrateMultiplier__c= 12;
                renewQline.SBQQ__SegmentIndex__c= 1;
                renewQline.SBQQ__Description__c= 'test';
                renewQline.SBQQ__SubscriptionPricing__c = 'Fixed Price';
                renewQline.SBQQ__DefaultSubscriptionTerm__c = 1;
                //qline.SBQQ__SubscriptionPercent__c= '';
                renewQline.Proposal_Segment_Index__c = 'Year  1';
                renewQline.Proposal_Segment_Label__c = 'Year  1 - Licenses & Support';
                //qline.SBQQ__Dimension__c = quot;
                renewQline.SBQQ__PricebookEntryId__c = standardPrice.Id;
                renewQline.SBQQ__ProductSubscriptionType__c = 'Renewable';
                renewQline.SBQQ__SegmentKey__c = '1602758020922';
                renewQline.SBQQ__SegmentLabel__c = 'Year  1';
                renewQline.SBQQ__SubscriptionBase__c = 'List';
                renewQline.SBQQ__SubscriptionCategory__c = 'Licenses';
                renewQline.SBQQ__SubscriptionType__c = 'Renewable';
                renewQline.SBQQ__Uplift__c = 0;
                renewQline.SBQQ__PricingMethod__c = 'List';
                renewQline.SBQQ__NetPrice__c = 5;
                renewQline.SBQQ__Discount__c = 0;*/
        //insertQuLineList.add(renewQline);
        
        //insert insertQuLineList; 
        //system.debug('qline---'+insertQuLineList.size()+insertQuLineList+'*****'+qline+renewQline);
        
        kugo2p__KugamonSetting__c testKugamonSetting = new kugo2p__KugamonSetting__c();
        testKugamonSetting.Name = 'Kugamon Configuration';
        //testKugamonSetting.kugo2p__AccountingGroup__c = 'Business Sale';
        testKugamonSetting.kugo2p__Admin_User__c = UserInfo.getUserId();
        testKugamonSetting.kugo2p__AllowOverrideServiceDateUpdate__c = true;
        testKugamonSetting.kugo2p__BillingMethod__c = 'Email';
        testKugamonSetting.kugo2p__CompanyTextandTerms__c = 'Test';
        testKugamonSetting.kugo2p__CreditTerms__c = 'No Credit Check Required';
        testKugamonSetting.kugo2p__DateAvailabletoPromiseBasis__c = 'Date Required';
        testKugamonSetting.kugo2p__DaysTillPaymentDue__c = 0;
        testKugamonSetting.kugo2p__DeliveryTerms__c = 'FOB Origin';
        testKugamonSetting.kugo2p__InvoiceTextandTerms__c = 'test';
        testKugamonSetting.kugo2p__FirstInvoiceDateBasis__c = 'Order Date Required';
        testKugamonSetting.kugo2p__DayofRevenueRecognition__c = '31';
        testKugamonSetting.kugo2p__OnlinePaymentButton__c = 'Accept & Approve';
        testKugamonSetting.kugo2p__OnlineConfirmationTextandTerms__c = 'Test';
        testKugamonSetting.kugo2p__PaymentMethod__c = 'Check';
        testKugamonSetting.kugo2p__PaymentTerms__c = 'Due Upon Receipt';
        testKugamonSetting.kugo2p__PriceBookName__c = p2.Name;
        testKugamonSetting.kugo2p__RemitToCity__c = 'MyCity';
        testKugamonSetting.kugo2p__RemitToCountry__c = 'USA';
        testKugamonSetting.kugo2p__RemitToName__c = 'Test';
        testKugamonSetting.kugo2p__RemitToStateProvince__c = 'CA';
        testKugamonSetting.kugo2p__RemitToStreet__c = '123 My Street';
        testKugamonSetting.kugo2p__RemitToZipPostalCode__c = '91405';
        testKugamonSetting.kugo2p__ResetQuoteOrderTermsConditions__c = 'Update Matched Terms';
        testKugamonSetting.kugo2p__RestrictedBannerText__c = 'Test';
        testKugamonSetting.kugo2p__SalesQuoteValidOfferInDays__c = 10;
        testKugamonSetting.kugo2p__UnitofMeasure__c = 'Each';
        testKugamonSetting.kugo2p__UnitofTerm__c = 'Year';
        testKugamonSetting.kugo2p__UpdateOpportunityAmountBasis__c = 'Net AMount';
        insert testKugamonSetting;
       
        Test.startTest();
        Contract cont = new Contract(Opportunity__c=o.Id,AccountId=a.Id);
        insert cont;
         
        Id renewRecdTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Opportunity opp = new Opportunity(Name='My Opp', AccountId=a.Id, RecordTypeId = renewRecdTypeId , StageName='Marketing Qualification', CloseDate=Date.today()+10, CurrencyIsoCode='EUR');
        opp.Amount = 99.0;
        opp.LeadSource = 'Advertisement' ;
        opp.ContractId= cont.Id;
        insert opp;  
        
        SBQQ__Quote__c renewQuote = new SBQQ__Quote__c(SBQQ__Account__c = a.Id,SBQQ__Opportunity2__c=opp.id,SBQQ__SalesRep__c=usrId,SBQQ__Primary__c=true,SBQQ__PrimaryContact__c=con.Id,SBQQ__StartDate__c=system.today().addYears(1),SBQQ__EndDate__c = endDate.addYears(1));
        insert renewQuote;
        set<Id> renewQuoteIds = new set<Id>();
        set<Id> renewOpptyIds = new set<Id>();
        renewOpptyIds.add(opp.Id);
        renewQuoteIds.add(renewQuote.Id);
        system.debug('renewQuote---'+renewQuote);
       
        RenewalOpportunityHelper.RenewalOpportunityDetails(renewOpptyIds,renewQuoteIds);        
        Test.stopTest(); 
             
       
    }
}