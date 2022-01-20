@isTest
public class TestContractLineItemImporter {
    static testMethod void runFullTest(){
        Id pricebookId = Test.getStandardPricebookId();
		Pricebook2 p2 = new Pricebook2(Name='Test', CurrencyIsoCode='EUR', IsActive=true);
        insert p2;
        
		Product2 p = new Product2(Name='My Test', IsActive=true, Family='Membership fees', Credits_to_be_assigned__c=0);
		insert p;
		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p.Id, UnitPrice=5, IsActive=true,CurrencyIsoCode='EUR');
        insert standardPrice;
        
        PricebookEntry customPrice = new PriceBookEntry(Pricebook2Id=p2.Id, Product2Id=p.Id, UnitPrice=5, IsActive=true,CurrencyIsoCode='EUR');
		insert customPrice;
        
		Account a = new Account(Name='My Account');
		insert a;
		Opportunity o = new Opportunity(Name='My Opp', AccountId=a.Id, StageName='Marketing Qualification', CloseDate=Date.today(), Main_Problems__c = 'Opp Main Problems',Amount = 99.0,CurrencyIsoCode='EUR',LeadSource='Customer');
		insert o;

		Quote q = new Quote(OpportunityId=o.Id, Name='My Quote', Pricebook2Id=p2.Id);
		insert q;

		QuoteLineItem qli = new QuoteLineItem(Custom_Discount__c=true, QuoteId=q.Id, Product2Id=p.Id, UnitPrice=5, Quantity=2, PricebookEntryId=customPrice.Id, Discount__c=10);
		insert qli;
        
        o.SyncedQuoteId = q.Id;
        update o;

        kugo2p__KugamonSetting__c testKugamonSetting = testMethodUtilities.createKugamonSetting(p2.name);
        
		Contract c = new Contract(AccountId=a.Id, StartDate=Date.today(), ContractTerm=12, CurrencyIsoCode='EUR', Opportunity__c=o.Id);
		insert c;
        
        PageReference pref = Page.ContractLineItemImporter;
        pref.getParameters().put('id',c.id);
        Test.setCurrentPage(pref); 
        
        test.startTest();
        ContractLineItemImporter ext = new ContractLineItemImporter(new ApexPages.StandardController(c));
        pref = ext.doImport();
        test.stopTest();
        
        List<Contract_Line_Item__c> result = [select Id, Name, Product__c, CurrencyIsoCode, Quantity__c, Unit_Price__c, Total_Price__c from Contract_Line_Item__c where Contract__c=:c.Id];
        system.assertEquals(1, result.size());
        List<Contract> contracts = [select Id, CurrencyIsoCode from Contract where Id=:c.Id];
        system.assertEquals('EUR', contracts[0].CurrencyIsoCode);
        system.debug('####' + ApexPages.getMessages());
        system.assertEquals('/'+c.Id, pref.getUrl());
    }
    static testMethod void testExceptions(){
        Id pricebookId = Test.getStandardPricebookId();
		Pricebook2 p2 = new Pricebook2(Name='Test', CurrencyIsoCode='EUR', IsActive=true);
        insert p2;
        
		Product2 p = new Product2(Name='My Test', IsActive=true, Family='Membership fees', Credits_to_be_assigned__c=0);
		insert p;
		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p.Id, UnitPrice=5, IsActive=true,CurrencyIsoCode='EUR');
        insert standardPrice;

		Account a = new Account(Name='My Account');
		insert a;
		Opportunity o = new Opportunity(Name='My Opp', AccountId=a.Id, StageName='Marketing Qualification', CloseDate=Date.today(), CurrencyIsoCode='EUR', Main_Problems__c='Problem',LeadSource='Customer');
		o.Amount = 99.0;
		insert o;

		Quote q = new Quote(OpportunityId=o.Id, Name='My Quote', Pricebook2Id=pricebookId);
		insert q;

		QuoteLineItem qli = new QuoteLineItem(Custom_Discount__c=true, QuoteId=q.Id, Product2Id=p.Id, UnitPrice=5, Quantity=2, PricebookEntryId=standardPrice.Id, Discount__c=10);
		insert qli;

        kugo2p__KugamonSetting__c testKugamonSetting = testMethodUtilities.createKugamonSetting(p2.name);
        
		Contract c = new Contract(AccountId=a.Id, StartDate=Date.today(), ContractTerm=12, CurrencyIsoCode='EUR');
		insert c;
        
        PageReference pref = Page.ContractLineItemImporter;
        pref.getParameters().put('id',c.id);
        Test.setCurrentPage(pref); 
        
        test.startTest();
        ContractLineItemImporter ext = new ContractLineItemImporter(new ApexPages.StandardController(c));
        pref = ext.doImport();
        system.debug('####' + ApexPages.getMessages());
        test.stopTest();
        
        List<Contract_Line_Item__c> result = [select Id, Name, Product__c, CurrencyIsoCode, Quantity__c, Unit_Price__c, Total_Price__c from Contract_Line_Item__c where Contract__c=:c.Id];
        system.assertEquals(0, result.size());
        system.assert(TestMethodUtilities.hasMessage('Opportunity needs to be defined to get quote'));
        system.assertEquals(null, pref);
    }
    static testMethod void testException_NoQuotes(){
        Id pricebookId = Test.getStandardPricebookId();
		Pricebook2 p2 = new Pricebook2(Name='Test', CurrencyIsoCode='EUR', IsActive=true);
        insert p2;
        
		Product2 p = new Product2(Name='My Test', IsActive=true, Family='Membership fees', Credits_to_be_assigned__c=0);
		insert p;
		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p.Id, UnitPrice=5, IsActive=true,CurrencyIsoCode='EUR');
        insert standardPrice;
        
        PricebookEntry customPrice = new PriceBookEntry(Pricebook2Id=p2.Id, Product2Id=p.Id, UnitPrice=5, IsActive=true,CurrencyIsoCode='EUR');
		insert customPrice;
        
		Account a = new Account(Name='My Account');
		insert a;
		Opportunity o = new Opportunity(Name='My Opp', AccountId=a.Id, StageName='Marketing Qualification', CloseDate=Date.today(), CurrencyIsoCode='EUR',Main_Problems__c='Problem',LeadSource='Customer');
		o.Amount = 99.0;
		insert o;

		Quote q = new Quote(OpportunityId=o.Id, Name='My Quote', Pricebook2Id=p2.Id);
		insert q;

		QuoteLineItem qli = new QuoteLineItem(Custom_Discount__c=true, QuoteId=q.Id, Product2Id=p.Id, UnitPrice=5, Quantity=2, PricebookEntryId=customPrice.Id, Discount__c=10);
		insert qli;
        
        kugo2p__KugamonSetting__c testKugamonSetting = testMethodUtilities.createKugamonSetting(p2.name);
        
		Contract c = new Contract(AccountId=a.Id, StartDate=Date.today(), ContractTerm=12, CurrencyIsoCode='EUR', Opportunity__c=o.Id);
		insert c;
        
        PageReference pref = Page.ContractLineItemImporter;
        pref.getParameters().put('id',c.id);
        Test.setCurrentPage(pref); 
        
        test.startTest();
        ContractLineItemImporter ext = new ContractLineItemImporter(new ApexPages.StandardController(c));
        pref = ext.doImport();
        test.stopTest();
        
        List<Contract_Line_Item__c> result = [select Id, Name, Product__c, CurrencyIsoCode, Quantity__c, Unit_Price__c, Total_Price__c from Contract_Line_Item__c where Contract__c=:c.Id];
        system.assertEquals(0, result.size());
        system.assert(TestMethodUtilities.hasMessage('No quotes found that are sync\'ed against opportunity'));
        system.assertEquals(null, pref);
    }
}