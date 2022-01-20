@isTest
public class TestKugamonOrderTriggerHelper {
    @isTest
    public static void unitTest(){      
         
        Account accObj = TestDataFactory.createAccount('UnitTest', 'EUR');
        insert accObj;
        
        Contact conObj = TestDataFactory.createContact(accObj.id,'TestKugamonOrderTriggerHelper');
        conObj.MailingStreet = 'E5';
        conObj.MailingCity = 'Bengalore';
        conObj.MailingState = 'Karnataka';
        conObj.MailingCountry = 'India';
        Insert conObj;        
    
         //Renewal Opportunity
        Opportunity renewalOpp = TestDataFactory.createOpportunity(accObj, ' 1EE', 'Renewal');
        renewalOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        insert renewalOpp;        
        
        SBQQ__Quote__c renewalQuote = TestDataFactory.createCPQuote(renewalOpp);
        renewalQuote.SBQQ__Primary__c = true;
        Insert renewalQuote;    
                
        //Expansion Opportunity
        Opportunity expansionOpp = TestDataFactory.createOpportunity(accObj, ' 1EE', 'Add-on');
        expansionOpp.Value_Prop_ID__c = 'Test';
        expansionOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Expansion').getRecordTypeId();
        insert expansionOpp;
        
        SBQQ__Quote__c expansionQuote = TestDataFactory.createCPQuote(expansionOpp);
        expansionQuote.SBQQ__Primary__c = true;
        Insert expansionQuote;    
        
        Test.startTest();
        
        Product2 prod = TestDataFactory.createProduct('Copado Standard Edition','Licenses ',null);
        prod.kuga_sub__Renewable__c = true;
        Insert prod;        
        
        //kugo2p__AdditionalProductDetail__c testProductDetail1 = new kugo2p__AdditionalProductDetail__c();
        //testProductDetail1.kugo2p__ReferenceProduct__c = prod.Id;
        //insert testProductDetail1;    
        
        SBQQ__QuoteLine__c renewalQLine = TestDataFactory.createCPQQuoteLine(renewalQuote.Id,prod.Id);
        insert renewalQLine;   
        
        Product2 prod2 = TestDataFactory.createProduct('Copado Admin','Licenses ',null);
        Insert prod2;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=prod2.Id, UnitPrice=5, IsActive=true,CurrencyIsoCode='EUR');
        insert standardPrice;    
        
        SBQQ__QuoteLine__c expansionQLine = TestDataFactory.createCPQQuoteLine(expansionQuote.Id,prod2.Id);
        Insert expansionQLine ;  
        
        Test.stopTest(); 
        
        Pricebook2 pb = TestDataFactory.createPricebook(); 
        pb.CurrencyIsoCode = 'EUR';
        insert pb;  
        
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(pb.name);       
        insert testKugamonSetting ;     
        
        kugo2p__Warehouse__c wareObj = TestDataFactory.createWarehouse('test',testKugamonSetting.id);
        Insert wareObj;
        
        kugo2p__SalesOrder__c orderObj = TestDataFactory.createKugamonOrder(accObj.id);
        orderObj.kugo2p__ContactBilling__c = conObj.id;
        orderObj.kugo2p__ContactBuying__c = conObj.id;
        orderObj.kugo2p__ContactShipping__c = conObj.id;
        orderObj.kugo2p__Warehouse__c = wareObj.Id;        
        orderObj.RecordTypeId = Schema.SObjectType.kugo2p__SalesOrder__c.getRecordTypeInfosByName().get('Expansion').getRecordTypeId();
        orderObj.kuga_sub__GenerateSubscription__c = true;        
        orderObj.kuga_sub__GenerateRenewalOpportunity__c =true;
        Insert orderObj;
        orderObj.Quote__c = expansionQuote.Id;
        orderObj.kugo2p__Opportunity__c = expansionOpp.Id;
        orderObj.kuga_sub__RenewalOpportunity__c = renewalOpp.Id;
        orderObj.kugo2p__RecordStatus__c = 'Released';       
        List<kugo2p__SalesOrder__c> orderList = new List<kugo2p__SalesOrder__c>();
        orderList.add(orderObj);
        KugamonOrderTriggerHelper.createQuoteLineOnRenewalOpportuntiy(orderList);
        //Update orderObj;               
    }    
}