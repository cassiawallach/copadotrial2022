@isTest
public class TestSendInvoice {
    static testMethod void fulltest(){
        Account purchaser = new Account(Name='Company Purchaser', CurrencyIsoCode='EUR', Billing_Name__c='Purchasing SL', VAT_Number__c='');
        purchaser.BillingStreet = 'My Street';
        purchaser.BillingCity = 'My City';
        purchaser.BillingState = 'My State';
        purchaser.BillingPostalCode = 'My zip code';
        purchaser.BillingCountry = 'My country';
        purchaser.Billing_Contact__c = null;
        purchaser.Invoice_Email_Subject__c = 'PO Number: __PO_Number__';
        insert purchaser;
        
        Contact testContact = new Contact(FirstName='Phil', LastName='Rackwitz', Email='pr@copado.test', AccountId=purchaser.Id);
        insert testContact;
        
        Invoice__c invoice = new Invoice__c(CurrencyIsoCode='EUR', Account__c=purchaser.Id, Status__c='Draft', Payment_method__c='Transfer');
        insert invoice;
        
        Test.setCurrentPageReference(new PageReference('/apex/SendInvoice?id='+invoice.Id));
		Test.startTest();
        
        SendInvoice ext = new SendInvoice(new Apexpages.StandardController(invoice));
        String result = ext.getEmailSubject('PONumber/Invoice', null);
        
        ext.send();
        testMethodUtilities.hasMessage('Invoices cannot be sent as draft.');
        
        invoice.Status__c = 'Pending Payment';
        update invoice;
        
		PageReference pageRef = ext.send();
        System.assertEquals(null, pageRef);
        testMethodUtilities.hasMessage('Invoice only Attached to the record. No email sent, no billing contact defined');
        
        purchaser.Billing_Contact__c = testContact.Id;
        update purchaser;
        
        ext = new SendInvoice(new Apexpages.StandardController(invoice));
        pageRef = ext.send();
        Test.stopTest();
        System.assertEquals('/'+invoice.Id, pageRef.getUrl());
    }
    static testMethod void testReplacePONumber(){
        Account a = new Account(Name='Company Purchaser',VAT_Number__c = '123445');
        insert a;
        
        Invoice__c invoice = new Invoice__c(CurrencyIsoCode='EUR', Account__c=a.Id, Status__c='Draft', Payment_method__c='Transfer');
        insert invoice;
        
        Test.setCurrentPageReference(new PageReference('/apex/SendInvoice?id='+invoice.Id));
		Test.startTest();
        
        SendInvoice ext = new SendInvoice(new Apexpages.StandardController(invoice));
        String result = ext.getEmailSubject('PONumber/Invoice', null);
        System.assertEquals('PONumber/Invoice', result);
        
        result = ext.getEmailSubject('My PO Number: __PO_NUMBER__', 'upperCase');
        System.assertEquals('My PO Number: upperCase', result);
        
        result = ext.getEmailSubject('My PO Number: __PO_Number__', 'mixedCase');
        System.assertEquals('My PO Number: mixedCase', result);
        
        result = ext.getEmailSubject('My PO Number: __po_number__', 'lowerCase');
        System.assertEquals('My PO Number: lowerCase', result);
        Test.stopTest();
    }
}