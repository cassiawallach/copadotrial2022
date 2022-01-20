@isTest
public class TestCreateRenewalOpportunityExtension {
    static testmethod void cloneFailure_noContract(){
        Id pricebookId = Test.getStandardPricebookId();      
        
        Pricebook2 p2 = TestDataFactory.createPricebook(); 
        p2.CurrencyIsoCode = 'EUR';
        insert p2;   
        
        Product2 p = TestDataFactory.createProduct('My Test', 'Membership fees',null);
        p.Credits_to_be_assigned__c=0;
        insert p;   
        
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(p2.Id, p.Id, p2.CurrencyIsoCode, 5);          
        
        Account a = TestDataFactory.createAccount('My Account', 'EUR');
        insert a;      
        
        Opportunity o = TestDataFactory.createOpportunity(a, 'My Opp', 'New Customer');
        o.Main_Problems__c = 'Problem';
        o.closeDate = Date.today();
        o.AccountId=a.Id;
        insert o;                
                
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(p2.name); 
        insert testKugamonSetting ;
        
        Contract c = TestDataFactory.createDraftContract(a.Id, 'USD');
        c.StartDate = Date.today();
        c.ContractTerm = 12;
        c.Opportunity__c=o.Id;
        insert c; 
        
        Test.startTest();
        PageReference pref = Page.CreateRenewalOpportunity;
        pref.getParameters().put('id', o.id);
        //pref.getParameters().put('contractId', c.Id);
        Test.setCurrentPage(pref);
        
        CreateRenewalOpportunityExtension ext = new CreateRenewalOpportunityExtension(new ApexPages.StandardController(o));
        ext.createRenewal();
        system.assert(TestMethodUtilities.hasMessage('No contract record was found.'));
    }
    static testmethod void cloneFailure_noOpportunity(){
        Opportunity o = new Opportunity();
       
        Account a = TestDataFactory.createAccount('My Account', 'EUR');
        insert a;  
        
        Pricebook2 pb = TestDataFactory.createPricebook(); 
        pb.CurrencyIsoCode = 'EUR';
        insert pb; 
        
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(pb.name); 
        insert testKugamonSetting ;
        
        Contract c = TestDataFactory.createDraftContract(a.Id, 'USD');
        c.StartDate = Date.today();
        c.ContractTerm = 12;        
        insert c;          
        
        Test.startTest();
        PageReference pref = Page.CreateRenewalOpportunity;
        //pref.getParameters().put('id', o.id);
        pref.getParameters().put('contractId', c.Id);
        Test.setCurrentPage(pref);
        
        CreateRenewalOpportunityExtension ext = new CreateRenewalOpportunityExtension(new ApexPages.StandardController(o));
        ext.createRenewal();
        system.assert(TestMethodUtilities.hasMessage('No Opportunity specified to created a renewal record.'));
    }
    
    /*
    static testmethod void cloneSuccess(){
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 p2 = new Pricebook2(Name='Test', CurrencyIsoCode='EUR', IsActive=true);
        insert p2;
        
        Product2 p = new Product2(Name='My Test', IsActive=true, Family='Membership fees', Credits_to_be_assigned__c=0, RevenueScheduleType='Repeat', RevenueInstallmentPeriod='Monthly', NumberOfRevenueInstallments=12, CanUseRevenueSchedule=true);
        insert p;
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p.Id, UnitPrice=5, IsActive=true);
        insert standardPrice;
        
        PricebookEntry customPrice = new PriceBookEntry(Pricebook2Id=p2.Id, Product2Id=p.Id, UnitPrice=5, IsActive=true);
        insert customPrice;
        
        Account a = new Account(Name='My Account');
        insert a;
        
        Contact contact = new Contact(FirstName='Phil', LastName='Rackwitz', AccountId=a.Id);
        insert contact;
        
        Opportunity o = new Opportunity(Name='My Opp', AccountId=a.Id, StageName='Prospecting', CloseDate=Date.today(), CurrencyIsoCode='EUR');
        o.Amount = 99.0;
        insert o;
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=o.Id, PricebookEntryId=standardPrice.Id, UnitPrice=5.0, Quantity=5);
        insert oli;
        
        OpportunityContactRole ocr = new OpportunityContactRole(ContactId=contact.Id, OpportunityId=o.Id, Role='Influencer', isPrimary=true);
        insert ocr;

        Contract c = new Contract(AccountId=a.Id, StartDate=Date.today(), ContractTerm=12, CurrencyIsoCode='USD', Opportunity__c=o.Id);
        insert c;
        c = [select Id, StartDate, EndDate, ContractTerm, CurrencyIsoCode, Opportunity__c from Contract where Id=:c.Id limit 1];
        
        Test.startTest();
        PageReference pref = Page.CreateRenewalOpportunity;
        pref.getParameters().put('id', o.id);
        pref.getParameters().put('contractId', c.Id);
        Test.setCurrentPage(pref);
        
        CreateRenewalOpportunityExtension ext = new CreateRenewalOpportunityExtension(new ApexPages.StandardController(o));
        PageReference result = ext.createRenewal();
        system.debug('### messages '+ApexPages.getMessages());
        system.debug('### result: '+result);
        system.assert(result!=null);
        List<Opportunity> resultOs = [select Id, Name, CurrencyIsoCode from Opportunity where Type='Renewal'];
        List<OpportunityContactRole> resultOcrs = [select ContactId, OpportunityId, Role, isPrimary from OpportunityContactRole];
        system.assertEquals(1, resultOs.size());
        system.assert(resultOcrs.size()>0);
        //system.assertEquals(o.Name+' renewal '+c.EndDate.Year(), resultOs[0].Name);
        system.assertEquals(o.CurrencyIsoCode, resultOs[0].CurrencyIsoCode);
        
        List<OpportunityLineItem> resultOlis = [select Id, Quantity, UnitPrice, TotalPrice from OpportunityLineItem where OpportunityId=:resultOs[0].Id];
        system.assertEquals(1, resultOlis.size());
        system.assertEquals(5, resultOlis[0].Quantity);
        
    }*/
}