@isTest
private class TestSalesforceInvoiceEmailService {
    
    static testMethod void testInboundEmailParsing_success() {        
     
        Account test_SalesforceAccount = TestDataFactory.createAccount('salesforce.com EMEA Limited','EUR');
        test_SalesforceAccount.Name = 'salesforce.com EMEA Limited';
        insert test_SalesforceAccount;
        
        Account test_CustomerAccount = TestDataFactory.createAccount('2U, inc', 'EUR');
        test_CustomerAccount.SFDC_Account_Number__c='4-396489';
        insert test_CustomerAccount;
        
        Pricebook2 p2 = TestDataFactory.createPricebook(); 
        p2.CurrencyIsoCode = 'EUR';
        insert p2;      
        
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(p2.name); 
        insert testKugamonSetting ;
        
        Contract test_CustomerContract = TestDataFactory.createDraftContract(test_CustomerAccount.Id, test_CustomerAccount.CurrencyIsoCode);
        test_CustomerContract.StartDate = Date.today();
        test_CustomerContract.ContractTerm = 12;
        test_CustomerContract.SFDC_Contract_Number__c = '01086425';
        test_CustomerContract.CurrencyIsoCode = 'EUR';
        insert test_CustomerContract;
        
        Opportunity o = TestDataFactory.createOpportunity(test_CustomerAccount, 'My Opp', 'New Customer');
        o.closeDate = Date.today();
        insert o;         
        
        Order testOrder = TestDataFactory.createOrder(test_CustomerAccount.Id, test_CustomerContract, p2, o.CloseDate.addDays(1), o.CloseDate.addYears(1).addDays(-1));            
        testOrder.OpportunityId = o.Id;
        testOrder.OrderReferenceNumber = '01086425';
        testOrder.Status='Draft';
        insert testOrder ;

        String emailBody = SalesforceInvoiceEmailService.getTestEmail();

        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();

        // setup the data for the email
        email.subject = 'salesforce.com Invoice 07081129, 2U - !Hub';
        email.fromName = 'Billing';
        email.plainTextBody = emailBody;
        env.fromAddress = 'billing@emea.salesforce.com';
        
        // set the body of the attachment
        inAtt.body = Blob.valueOf('test');
        inAtt.fileName = 'my attachment name';
        inAtt.mimeTypeSubType = 'plain/txt';

        email.binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[] { inAtt };
        System.debug('###################### ');
        SalesforceInvoiceEmailService emailProcess = new SalesforceInvoiceEmailService();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email, env);
        
        //Now send same email again and expect no dupes
        SalesforceInvoiceEmailService emailProcess2 = new SalesforceInvoiceEmailService();
        Messaging.InboundEmailResult result2 = emailProcess2.handleInboundEmail(email, env);

        // Now test the resulting data.
        List<Payable_Invoice__c> resultInvoices = [SELECT Id, Name, Account__c, Related_Customer__c, Status__c, Invoice_Amount__c, Order__c, Invoice_Date__c, Invoice_Due_Date__c FROM Payable_Invoice__c];
        system.assert(resultInvoices.size()==1);
        system.assertEquals('Pending Payment', resultInvoices[0].Status__c);
        system.assertEquals(1045.0, resultInvoices[0].Invoice_Amount__c);
        system.assertEquals(Date.newInstance(2015, 5, 28), resultInvoices[0].Invoice_Date__c);
        system.assertEquals(Date.newInstance(2015, 6, 27), resultInvoices[0].Invoice_Due_Date__c);
        system.assertEquals('07081129', resultInvoices[0].Name);
        system.assertEquals(testOrder.Id, resultInvoices[0].Order__c);

        List<Attachment> resultAttachments = [select Id, Name, ParentId from Attachment where ParentId=:resultInvoices[0].Id];
        system.assertEquals(1, resultAttachments.size());
        system.assertEquals('SFDC Invoice - 07081129.pdf', resultAttachments[0].Name);
    }
    
    static testMethod void testInboundEmailParsing_missingAttachment() {
        string emailBody = SalesforceInvoiceEmailService.getTestEmail();

        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();

        // setup the data for the email
        email.subject = 'salesforce.com Invoice 07081129, 2U - !Hub';
        email.fromname = 'Billing';
        email.plainTextBody = emailBody;
        env.fromAddress = 'billing@emea.salesforce.com';
        
        SalesforceInvoiceEmailService emailProcess = new SalesforceInvoiceEmailService();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email, env);
        system.assertEquals(false, result.success);
        system.assertEquals('The email does not have an attachment.', result.message);
    }

    static testMethod void testInboundEmailParsing_MissingCustomerAccount() {
        string emailBody = SalesforceInvoiceEmailService.getTestEmail();

        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();

        // setup the data for the email
        email.subject = 'salesforce.com Invoice 07081129, 2U - !Hub';
        email.fromname = 'Billing';
        email.plainTextBody = emailBody;
        env.fromAddress = 'billing@emea.salesforce.com';
        
        // set the body of the attachment
        inAtt.body = blob.valueOf('test');
        inAtt.fileName = 'my attachment name';
        inAtt.mimeTypeSubType = 'plain/txt';

        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { inAtt }; 
        
        SalesforceInvoiceEmailService emailProcess = new SalesforceInvoiceEmailService();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email, env);
        system.assertEquals(false, result.success);
        system.assertEquals('The Account for Account Number "4-396489" could not be found.', result.message);
    }

    static testMethod void testInboundEmailParsing_MissingCustomerContract() {               
       
        Account test_SalesforceAccount = TestDataFactory.createAccount('salesforce.com EMEA Limited','EUR');
        test_SalesforceAccount.Name = 'salesforce.com EMEA Limited';
        insert test_SalesforceAccount;
        
        Account test_CustomerAccount = TestDataFactory.createAccount('2U, inc', 'EUR');
        test_CustomerAccount.SFDC_Account_Number__c='4-396489';
        insert test_CustomerAccount;

        string emailBody = SalesforceInvoiceEmailService.getTestEmail();

        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();

        // setup the data for the email
        email.subject = 'salesforce.com Invoice 07081129, 2U - !Hub';
        email.fromname = 'Billing';
        email.plainTextBody = emailBody;
        env.fromAddress = 'billing@emea.salesforce.com';
        
        // set the body of the attachment
        inAtt.body = blob.valueOf('test');
        inAtt.fileName = 'my attachment name';
        inAtt.mimeTypeSubType = 'plain/txt';

        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { inAtt }; 
        
        SalesforceInvoiceEmailService emailProcess = new SalesforceInvoiceEmailService();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email, env);
        system.assertEquals(false, result.success);
        system.assertEquals('The Order for Order Number "01086425" could not be found.', result.message);
    }
    static testMethod void testDateParsing(){
        String dateString = '27/06/2015';
        //SalesforceInvoiceEmailService emailProcess = new SalesforceInvoiceEmailService();
        Date result = SalesforceInvoiceEmailService.parseDate(dateString);
        system.assertEquals(result, Date.newInstance(2015, 6, 27));
    }
    static testMethod void parseStringToDouble(){
        String amountString = '1,045.33';
        Double result = SalesforceInvoiceEmailService.parseStringToDouble(amountString);
        system.assertEquals(1045.33, result);
    }
}