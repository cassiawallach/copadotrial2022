public with sharing class invoicePDFextension {
    public Invoice__c invoice {get;set;}
    public List<Invoice_Line_Item__c> lineItems {get;set;}
    
    public invoicePDFextension(ApexPages.StandardController stdController) {
        invoice = (Invoice__c)stdController.getRecord();
        invoice = [SELECT Id, Name, Account__c, Account__r.Name, Account__r.VAT_Number__c, Account__r.Billing_Name__c,
                            Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingState, Account__r.BillingPostalCode, Account__r.BillingCountry, 
                            Invoice_Date__c, Days_to_Pay__c,Invoice_Amount__c, Total_Amount__c, VAT_Amount__c, Discounted_Amount__c
            FROM Invoice__c
            WHERE Id = :stdController.getId() LIMIT 1];
        lineItems = new List<Invoice_Line_Item__c>();
        lineItems = [SELECT Id, Name, Unit_Price__c, Quantity__c, Total_Price__c, Invoice__c, Start_Date__c, End_Date__c FROM Invoice_Line_Item__c WHERE Invoice__c = :invoice.Id AND Is_VAT_Item__c = false];
    }
}