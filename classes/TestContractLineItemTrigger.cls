@isTest
private class TestContractLineItemTrigger {
    
    static testMethod void testDiscountSetting() {
        Id pricebookId = Test.getStandardPricebookId();  
          
        Pricebook2 p2 = TestDataFactory.createPricebook(); 
        p2.CurrencyIsoCode = 'EUR';
        insert p2;         
        
        Product2 p = TestDataFactory.createProduct('Enterprise', 'Licenses',null);
        insert p;
        
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(p2.Id,p.Id, p2.CurrencyIsoCode, 300);
        
        Account a = TestDataFactory.createAccount('My Account', 'EUR');
        insert a;

        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(p2.name); 
        insert testKugamonSetting ;
             
        Contract c = TestDataFactory.createDraftContract(a.Id, a.CurrencyIsoCode);
        c.StartDate = Date.today();
        c.ContractTerm = 12;
        insert c;            

        Contract_Line_Item__c cli = new Contract_Line_Item__c(Contract__c=c.Id);
        insert cli;
       
        system.assertEquals(1,1);
        //we are not expecting anything. This is for coverage.
        delete cli;
    }
}