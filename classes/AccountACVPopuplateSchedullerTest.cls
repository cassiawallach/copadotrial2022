@isTest
private class AccountACVPopuplateSchedullerTest{
    @testSetup
    public static void setupMethod(){
        
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 p2 = TestDataFactory.createPricebook(); 
        p2.CurrencyIsoCode = 'EUR';
        insert p2; 
        
        Product2 p = TestDataFactory.createProduct('Enterprise', 'Licenses',null);
        p.Family='Membership fees';
        p.Credits_to_be_assigned__c=0;
        insert p;
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p.Id, UnitPrice=5, IsActive=true,CurrencyIsoCode='EUR');
        insert standardPrice;
        
        Account a = TestDataFactory.createAccount('My Account', 'EUR');
        insert a;
        
        Contact con = TestDataFactory.createContact(a.Id,'Test');
        insert con;
        
        Id RecdTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        Opportunity o = TestDataFactory.createOpportunity(a,'My Opp','New Customer');
        o.RecordTypeId = RecdTypeId;
        insert o;
        
        OpportunityLineItem oli = TestDataFactory.createOpportunityLineItem(o.Id,standardPrice.id);
        insert oli;
        
        SBQQ__Quote__c quote = TestDataFactory.createCPQuote(o);
        insert quote;
        
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(p2.name); 
        insert testKugamonSetting;
        
        //Create contract
        Contract c = TestDataFactory.createDraftContract(a.Id, a.CurrencyIsoCode);
        c.Key_Contact__c = con.Id;
        c.Opportunity__c = o.Id;
        Insert c;
        //Update contract
        c.Status = 'Activated';
        update c;
        
    }
    static testMethod void testScheduler(){
        Test.startTest();
        AccountACVPopuplateBatch cb = New AccountACVPopuplateBatch();
        list<contract> contracts  =  new list<contract>([SELECT Id,AccountId,Account.ACV__c, Opportunity__c, Opportunity__r.ACV__c FROM Contract]);
        Database.QueryLocator ql = cb.start(null);
        cb.execute(null,contracts);
        cb.Finish(null);
        
        // AccountACVPopuplateBatch batchCtrl = new AccountACVPopuplateBatch(); 
        //Id BatchId = database.executebatch(batchCtrl);       
        AccountACVPopuplateSchedullerCron ctrl = new AccountACVPopuplateSchedullerCron();      
        //String cronExp = '0 30 0 ? * * *';
        //system.schedule('Account ACV Popuplate Scheduller', cronExp, ctrl);
        // system.assertNotEquals(null,ctrl, 'AccountACVPopuplateSchedullerCron controller instance is null.');
        Test.stopTest();
    }
}