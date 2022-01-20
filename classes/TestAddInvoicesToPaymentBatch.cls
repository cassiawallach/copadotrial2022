@isTest
private class TestAddInvoicesToPaymentBatch {
    

    static testMethod void test_method_one() {      
        
        Pricebook2 p2 = TestDataFactory.createPricebook(); 
        p2.CurrencyIsoCode = 'EUR';
        insert p2;      
        
        Account sfdcAccount = TestDataFactory.createAccount('salesforce.com EMEA Limited','EUR');
        sfdcAccount.Name = 'salesforce.com EMEA Limited';
        sfdcAccount.Billing_Name__c='My Billing Name SL';
        sfdcAccount.VAT_Number__c='';
        insert sfdcAccount ;     
        
        Opportunity o = TestDataFactory.createOpportunity(sfdcAccount, 'My Opp', 'New Customer');
        o.closeDate = Date.today();
        insert o;          
        
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(p2.name);
        insert testKugamonSetting ;
        
        Contract testContract = TestDataFactory.createDraftContract(sfdcAccount.Id, sfdcAccount.CurrencyIsoCode);
        testContract.StartDate = Date.today();
        testContract.ContractTerm = 12;        
        testContract.CurrencyIsoCode = 'EUR';
        insert testContract;
        
        Order testOrder = TestDataFactory.createOrder(sfdcAccount.Id, testContract, p2,o.CloseDate.addDays(1),o.CloseDate.addYears(1).addDays(-1));
        insert testOrder;
        
        List<Payable_Invoice__c> invoices = new List<Payable_Invoice__c>();  
        Payable_Invoice__c pi = TestDataFactory.createPayableInvoice(sfdcAccount.Id,testOrder.Id,'Pending Payment');
        pi.CurrencyIsoCode='EUR';
        pi.Invoice_Amount__c = 200.0;
        invoices.add(pi);
        
        insert invoices;

        Date fromDate = Date.newInstance(2015, 5, 1);
        Date toDate = Date.newInstance(2015, 5, 31);
        Test.startTest();
        List<Payable_Invoice__c> batch_scope = new List<Payable_Invoice__c>();
        batch_scope.addAll(invoices);
        AddInvoicesToPaymentBatch batch = new AddInvoicesToPaymentBatch(fromDate, toDate); 
        Database.BatchableContext dbc;
        batch.start(dbc);
        batch.execute(dbc, batch_scope);
        batch.finish(dbc);
        Test.stopTest();

        List<Batch_Payment__c> result_payments = [select Id, Name, Amount__c, Status__c, Payment_Date__c, Covering_Period_From__c, Covering_Period_To__c from Batch_Payment__c
            where Covering_Period_From__c=:fromDate and Covering_Period_To__c=:toDate and Status__c='Draft'];
        System.assertEquals(1, result_payments.size());
        System.assertEquals(200, result_payments[0].Amount__c);

        List<Payable_Invoice__c> result_invoices = [select Id, Batch_Payment__c from Payable_Invoice__c];
        for(Payable_Invoice__c i : result_invoices){
            System.assert(i.Batch_Payment__c!=null);
        }

    }
    
}