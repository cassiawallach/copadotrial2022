@isTest(SeeAllData=true)
public class TestCreateInvoiceFromOpportunityExt {
    static testMethod void createTestData(){
        Account testAccount = TestDataFactory.createAccount('My Company','EUR');      
        testAccount.Billing_Name__c='My Billing Name SL';
        testAccount.VAT_Number__c='';
        testAccount.BillingStreet = 'My Street';
        testAccount.BillingCity = 'My City';
        testAccount.BillingState = 'My State';
        testAccount.BillingPostalCode = 'My zip code';
        testAccount.BillingCountry = 'My country';
        testAccount.Billing_Contact__c = null;
        insert testAccount ;     
        
        Contact testContact = TestDataFactory.createContact(testAccount.Id, 'Payable'); 
        testContact.FirstName='Accounts';
        testContact.Email='pr@copa.do.test';
        insert testContact;        
        
        testAccount.Billing_Contact__c = testContact.Id;
        update testAccount;
      
        Pricebook2 newPB = TestDataFactory.createPricebook(); 
        newPB.CurrencyIsoCode = 'EUR';
        insert newPB ;  
        
        Opportunity testOpportunity = TestDataFactory.createOpportunity(testAccount, 'Test', 'New Customer');
        testOpportunity.CloseDate=System.today();
        testOpportunity.Main_Problems__c = 'Opp Main Problem';
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.Pricebook2Id = newPB.Id;
        testOpportunity.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE SObjectType='Opportunity' AND Name='Default'].Id;
        insert testOpportunity;          
       
        Product2 prod = TestDataFactory.createProduct('Enterprise Edition (12 months)', 'Licenses',null);
        prod.Credits_to_be_assigned__c=0;
        insert prod;        
            
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(newPB.Id, prod.Id, newPB.CurrencyIsoCode, 5);
        
        OpportunityLineItem oli = TestDataFactory.createOpportunityLineItem(testOpportunity.Id, standardPrice.Id);        
        insert oli;         
        
        PageReference pageRef = Page.CreateInvoiceFROMOpportunity;
        pageRef.getParameters().put('id',testOpportunity.Id);
        Test.setCurrentPage(pageRef);
        CreateInvoiceFromOpportunityExtension ext = new CreateInvoiceFromOpportunityExtension(new ApexPages.StandardController(testOpportunity));
        ext.createPreviewData();
        System.assertEquals(false, ext.showAccountsPayableFields);
        System.assertEquals(testAccount.Name, ext.account.Name);
        System.assertEquals(1, ext.ilis.size());
        System.assertEquals(testOpportunity.CurrencyIsoCode, ext.invoice.CurrencyIsoCode);
        
        ext.createVATitem = true;
        ext.createPreviewData();
        System.assertEquals(2, ext.ilis.size());
        
        ext.showAccountsPayableFields = false;
        ext.showCreateAcountsPayableContact();
        System.assertEquals(true, ext.showAccountsPayableFields);
        System.assertEquals('Accounts', ext.accsPayableContact.FirstName);
        System.assertEquals('Payable', ext.accsPayableContact.LastName);
        ext.accsPayableContact.Email = 'test@test.com';
        ext.saveAccsPayableContact();
        Account result = [SELECT Id, Billing_Contact__c, Billing_Contact__r.Email FROM Account WHERE Id=:testAccount.Id];
        System.assertEquals(ext.accsPayableContact.Id, result.Billing_Contact__c);
        System.assertEquals('test@test.com', result.Billing_Contact__r.Email);
        
    }
    static testMethod void createInvoiceNOVAT(){
        Account purchaser = TestDataFactory.createAccount('Company Purchaser','EUR');      
        purchaser.Billing_Name__c='Purchasing SL';
        purchaser.VAT_Number__c='';
        purchaser.BillingStreet = 'My Street';
        purchaser.BillingCity = 'My City';
        purchaser.BillingState = 'My State';
        purchaser.BillingPostalCode = 'My zip code';
        purchaser.BillingCountry = 'My country';
        purchaser.Billing_Contact__c = null;
        insert purchaser; 
        
        Account testAccount = TestDataFactory.createAccount('My Company','EUR');      
        testAccount.Billing_Name__c='My Billing Name SL';
        testAccount.VAT_Number__c='';
        testAccount.BillingStreet = 'My Street';
        testAccount.BillingCity = 'My City';
        testAccount.BillingState = 'My State';
        testAccount.BillingPostalCode = 'My zip code';
        testAccount.BillingCountry = 'My country';
        testAccount.Billing_Contact__c = null;
        insert testAccount ;
        
        Contact testContact = TestDataFactory.createContact(testAccount.Id, 'Rackwitz'); 
        testContact.FirstName='Phil';
        testContact.Email='pr@copa.do.test';
        insert testContact;     
           
        Id stdPricebookId = Test.getStandardPricebookId();
        
        Opportunity testOpportunity = TestDataFactory.createOpportunity(testAccount, 'Test', 'New Customer');
        testOpportunity.CloseDate=System.today();
        testOpportunity.Main_Problems__c = 'Opp Main Problem';       
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE SObjectType='Opportunity' AND Name='Default'].Id;
        insert testOpportunity;         
        
        Product2 prod = TestDataFactory.createProduct('Enterprise Edition (12 months)', 'Licenses',null);
        prod.Credits_to_be_assigned__c=0;
        insert prod;
        
        Pricebook2 newPB = TestDataFactory.createPricebook(); 
        newPB.CurrencyIsoCode = 'EUR';
        insert newPB ;        
       
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(newPB.Id, prod.Id, 'EUR', 5);
        OpportunityLineItem oli = TestDataFactory.createOpportunityLineItem(testOpportunity.Id, standardPrice.Id);        
        insert oli;
        
        PageReference pageRef = Page.CreateInvoiceFROMOpportunity;
        pageRef.getParameters().put('id',testOpportunity.id);
        Test.setCurrentPage(pageRef);
        CreateInvoiceFromOpportunityExtension ext = new CreateInvoiceFromOpportunityExtension(new ApexPages.StandardController(testOpportunity));
        ext.createPreviewData();
        System.assert(testMethodUtilities.hasMessage('Using Opportunity Account for invoicing'));
        System.assertEquals(true, ext.showAccountsPayableFields);
        System.assertEquals('Accounts', ext.accsPayableContact.FirstName);
        System.assertEquals('Payable', ext.accsPayableContact.LastName);
        System.assertEquals(testAccount.Name, ext.account.Name);
        System.assertEquals(1, ext.ilis.size());
        System.assertEquals(testOpportunity.CurrencyIsoCode, ext.invoice.CurrencyIsoCode);
        PageReference result = ext.createInvoice();
        System.assertEquals('/'+ext.invoice.Id, result.getUrl());
        Invoice__c inv = [SELECT Id, Name, Account__c, Total_Amount__c, VAT_Amount__c, Sub_total__c FROM Invoice__c WHERE Id=:ext.invoice.Id];
        List<Invoice_Line_Item__c> lineItems = [SELECT Id, Name, Quantity__c FROM Invoice_Line_Item__c WHERE Invoice__c=:ext.invoice.Id];
        System.assertEquals(inv.Sub_total__c, ext.invSubTotal);
        System.assertEquals(0, inv.VAT_Amount__c);
        System.assertEquals(1, lineItems.size());
        System.assertEquals(testAccount.Id, inv.Account__c);
        
        ext.account.BillingStreet = 'changed';
        ext.updateAccount();
        System.assertEquals('changed', [SELECT Id, BillingStreet FROM Account WHERE Id=:testAccount.Id LIMIT 1].BillingStreet);
    }
    static testMethod void createPurchaserInvoice(){
        Account purchaser = TestDataFactory.createAccount('Company Purchaser','EUR');      
        purchaser.Billing_Name__c='Purchasing SL';
        purchaser.VAT_Number__c='';
        purchaser.BillingStreet = 'My Street';
        purchaser.BillingCity = 'My City';
        purchaser.BillingState = 'My State';
        purchaser.BillingPostalCode = 'My zip code';
        purchaser.BillingCountry = 'My country';
        purchaser.Billing_Contact__c = null;
        insert purchaser;   
        
        Contact testContact = TestDataFactory.createContact(purchaser.Id, 'Rackwitz'); 
        testContact.FirstName='Phil';
        testContact.Email='pr@copa.do.test';
        insert testContact; 
        
        Account testAccount = TestDataFactory.createAccount('My Company','EUR');  
        testAccount.Billing_Name__c='My Billing Name SL';
        testAccount.VAT_Number__c='';
        testAccount.BillingStreet = 'My Street';
        testAccount.BillingCity = 'My City';
        testAccount.BillingState = 'My State';
        testAccount.BillingPostalCode = 'My zip code';
        testAccount.BillingCountry = 'My country';
        testAccount.Billing_Contact__c = null;
        insert testAccount;
        
        Contact purchaserContact = TestDataFactory.createContact(testAccount.Id, 'Rackwitz'); 
        purchaserContact.FirstName='Phil';      
        insert purchaserContact;
        
        Opportunity testOpportunity = TestDataFactory.createOpportunity(testAccount, 'Test', 'New Customer');
        testOpportunity.CloseDate=System.today();
        testOpportunity.Main_Problems__c = 'Opp Main Problem';       
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE SObjectType='Opportunity' AND Name='Default'].Id;
        insert testOpportunity; 
        
        Product2 prod = TestDataFactory.createProduct('Enterprise Edition (12 months)', 'Licenses',null);
        prod.Credits_to_be_assigned__c=0;
        insert prod;        
        
        Id stdPricebookId = Test.getStandardPricebookId();
        
        Pricebook2 newPB = TestDataFactory.createPricebook(); 
        newPB.CurrencyIsoCode = 'EUR';
        insert newPB ;  
        
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(newPB.Id, prod.Id, 'EUR', 5);  
        
        OpportunityLineItem oli = TestDataFactory.createOpportunityLineItem(testOpportunity.Id, standardPrice.Id);        
        insert oli;
        
        PageReference pageRef = Page.CreateInvoiceFROMOpportunity;
        pageRef.getParameters().put('id',testOpportunity.Id);
        Test.setCurrentPage(pageRef);
        CreateInvoiceFromOpportunityExtension ext = new CreateInvoiceFromOpportunityExtension(new ApexPages.StandardController(testOpportunity));
        ext.dummyInvoice.Account__c = purchaser.Id;
        ext.createPreviewData();
        System.assert(testMethodUtilities.hasMessage('Using Invoice Account (not Opportunity Account)'));
        System.assertEquals(true, ext.showAccountsPayableFields);
        System.assertEquals('Accounts', ext.accsPayableContact.FirstName);
        System.assertEquals('Payable', ext.accsPayableContact.LastName);
        System.assertEquals(purchaser.Name, ext.account.Name);
        System.assertEquals(1, ext.ilis.size());
        System.assertEquals(testOpportunity.CurrencyIsoCode, ext.invoice.CurrencyIsoCode);
        PageReference result = ext.createInvoice();
        System.assertEquals('/'+ext.invoice.Id, result.getUrl());
        Invoice__c inv = [SELECT Id, Name, Account__c, Total_Amount__c, VAT_Amount__c, Sub_total__c FROM Invoice__c WHERE Id=:ext.invoice.Id];
        List<Invoice_Line_Item__c> lineItems = [SELECT Id, Name, Quantity__c FROM Invoice_Line_Item__c WHERE Invoice__c=:ext.invoice.Id];
        System.assertEquals(inv.Sub_total__c, ext.invSubTotal);
        System.assertEquals(0, inv.VAT_Amount__c);
        System.assertEquals(1, lineItems.size());
        System.assertEquals(purchaser.Id, inv.Account__c);
        
        ext.account.BillingStreet = 'changed';
        ext.updateAccount();
        System.assertEquals('changed', [SELECT Id, BillingStreet FROM Account WHERE Id=:purchaser.Id LIMIT 1].BillingStreet);
    }
    static testMethod void createInvoiceWITHVAT(){
        Account testAccount = TestDataFactory.createAccount('My Company','EUR');      
        testAccount.Billing_Name__c='My Billing Name SL';
        testAccount.VAT_Number__c='';
        testAccount.BillingStreet = 'My Street';
        testAccount.BillingCity = 'My City';
        testAccount.BillingState = 'My State';
        testAccount.BillingPostalCode = 'My zip code';
        testAccount.BillingCountry = 'My country';
        testAccount.Billing_Contact__c = null;
        insert testAccount ; 
        
        Contact testContact = TestDataFactory.createContact(testAccount.Id, 'Rackwitz'); 
        testContact.FirstName='Phil';
        testContact.Email='pr@copa.do.test';
        insert testContact;         
        
        testAccount.Billing_Contact__c = testContact.Id;
        update testAccount;
        
        Pricebook2 newPB = TestDataFactory.createPricebook(); 
        newPB.CurrencyIsoCode = 'EUR';
        insert newPB ; 
        
        Opportunity testOpportunity = TestDataFactory.createOpportunity(testAccount, 'Test', 'New Customer');        
        testOpportunity.CloseDate=System.today();
        testOpportunity.Main_Problems__c = 'Opp Main Problem';     
        testOpportunity.AccountId=testAccount.Id;
        testOpportunity.Pricebook2Id = newPB.Id;
        testOpportunity.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE SObjectType='Opportunity' AND Name='Default'].Id;
        insert testOpportunity; 
        
        Product2 prod = TestDataFactory.createProduct('Enterprise Edition (12 months)', 'Licenses',null);
        prod.Credits_to_be_assigned__c=0;
        insert prod;
        
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(newPB.Id, prod.Id, 'EUR', 5);  
        
        OpportunityLineItem oli = TestDataFactory.createOpportunityLineItem(testOpportunity.Id, standardPrice.Id);        
        insert oli;   
        
        PageReference pageRef = Page.CreateInvoiceFromOpportunity;
        pageRef.getParameters().put('id',testOpportunity.Id);
        Test.setCurrentPage(pageRef);
        CreateInvoiceFromOpportunityExtension ext = new CreateInvoiceFromOpportunityExtension(new ApexPages.StandardController(testOpportunity));
        ext.createPreviewData();
        System.assertEquals(testAccount.Name, ext.account.Name);
        System.assertEquals(1, ext.ilis.size());
        System.assertEquals(testOpportunity.CurrencyIsoCode, ext.invoice.CurrencyIsoCode);
        
        ext.createVATitem = true;
        ext.createPreviewData();
        System.assertEquals(2, ext.ilis.size());
        
        PageReference result = ext.createInvoice();
        System.assertEquals('/'+ext.invoice.Id, result.getUrl());
        Invoice__c inv = [SELECT Id, Name, Account__c, Total_Amount__c, VAT_Amount__c, Sub_total__c FROM Invoice__c WHERE Id=:ext.invoice.Id];
        List<Invoice_Line_Item__c> lineItems = [SELECT Id, Name, Unit_Price__c,Quantity__c,Total_Price__c, Is_VAT_Item__c FROM Invoice_Line_Item__c WHERE Invoice__c=:ext.invoice.Id];
        
        //System.assertEquals(21.00, inv.VAT_Amount__c);
        System.assert(inv.VAT_Amount__c!= null);
        System.assertEquals(2, lineItems.size());
    }
}