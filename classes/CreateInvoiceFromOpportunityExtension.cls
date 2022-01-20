public class CreateInvoiceFromOpportunityExtension {
    public Opportunity opportunity{get;set;}
    public Invoice__c invoice {get;set;}
    public Invoice__c dummyInvoice {get;set;}
    public Account account {get;set;}
    public Contact accsPayableContact {get;set;}
    public boolean createVATitem {get;set;}
    public ApexPages.StandardController controller{get;set;}
    public List<Invoice_Line_Item__c> ilis {get;set;}
    
    public double invSubTotal{get;set;}
    public double invVatTotal{get;set;}
    public double invTotal{get;set;}
    
    public boolean showAccountsPayableFields {get;set;}
    
    public static final String[] FIELDS = new String[] {'Id','Name','AccountId','PO_Number__c', 'CurrencyIsoCode'};
    
    public CreateInvoiceFromOpportunityExtension(ApexPages.StandardController stdController){
        invoice = new Invoice__c();
        dummyInvoice = new Invoice__c();
        controller = stdController;
        createVATitem = false;
        showAccountsPayableFields = false;
        if(!Test.isRunningTest())stdController.addFields(FIELDS);
        this.opportunity = (Opportunity)stdController.getRecord();
        createPreviewData();
    }
    
    public static Account getAccount(Id accountId){
        return [SELECT Id, Name, Type, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, VAT_Number__c, Billing_Name__c, Billing_Contact__c FROM Account where Id=:accountId limit 1];
    }
    public PageReference refresh(){
        createPreviewData();
        return null;
    }
    public void createPreviewData(){
        if(dummyInvoice.Account__c!=null){
            account = getAccount(dummyInvoice.Account__c);
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Using Invoice Account (not Opportunity Account)'));
        }
        else{
            account = getAccount(opportunity.AccountId);
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Using Opportunity Account for invoicing'));
        }
    	
        if(account.Billing_Contact__c==null){
            showAccountsPayableFields = true;
            AccsPayableContact = new Contact(FirstName='Accounts', LastName='Payable', AccountId=account.Id);
        }
        
        invoice.Opportunity__c = opportunity.Id;
        invoice.Account__c = account.Id;
        invoice.Invoice_Date__c = system.today();
        invoice.Due_Date__c = system.today().addDays(30);
        invoice.PO_number__c = opportunity.PO_Number__c;
        invoice.CurrencyIsoCode = opportunity.CurrencyIsoCode;
        
        //Create invoice LineItems
        ilis = new List<Invoice_Line_Item__c>();
        List<OpportunityLineItem> olis = [SELECT Id, Product2.Name, CurrencyIsoCode, Name, Quantity, TotalPrice, UnitPrice, OpportunityId, ListPrice FROM OpportunityLineItem where OpportunityId=:opportunity.Id];
        List<SBQQ__Quote__c> cpquotes = [SELECT SBQQ__StartDate__c, SBQQ__EndDate__c FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c = :opportunity.Id];
        
		invSubTotal = 0;
        invTotal = 0;
        invVatTotal = 0;
        for(OpportunityLineItem oli : olis){
            Invoice_Line_Item__c ili = new Invoice_Line_Item__c();
            ili.Invoice__c = invoice.Id;
            ili.Name = oli.Product2.Name;
            ili.CurrencyIsoCode = invoice.CurrencyIsoCode;
            ili.Quantity__c = oli.Quantity;
            ili.Unit_Price__c = oli.UnitPrice;
            invSubTotal = invSubTotal + oli.TotalPrice;

            if (!cpquotes.isEmpty()) {
                ili.Start_Date__c = cpquotes[0].SBQQ__StartDate__c;
                ili.End_Date__c = cpquotes[0].SBQQ__EndDate__c;
            }

            ilis.add(ili);
        }
        if(createVATitem){
            Invoice_Line_Item__c ivat = new Invoice_Line_Item__c();
            ivat.Name = 'VAT - 21%';
            ivat.Is_VAT_Item__c = true;
            ivat.CurrencyIsoCode = invoice.CurrencyIsoCode;
            ivat.Quantity__c = 1;
            invVatTotal = invSubTotal / 100 * 21;
            ivat.Unit_Price__c = invVatTotal;
            ilis.add(ivat);
        }
        invTotal = invSubTotal + invVatTotal;
    }
    
    public void updateAccount(){
        update account;
    }
    public void showCreateAcountsPayableContact(){
        if(account.Billing_Contact__c!=null){
            accsPayableContact = [select Id, FirstName, LastName, Email, Title, AccountId from Contact where Id=:account.Billing_Contact__c];
        }
        showAccountsPayableFields = true;
    }
    public void saveAccsPayableContact(){
        try{
            upsert accsPayableContact;
            account.Billing_Contact__c = accsPayableContact.Id;
            update account;
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'Billing Contact Saved.'));
            showAccountsPayableFields = false;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ''+e.getMessage()));
        }
    }
    public PageReference createInvoice(){
        PageReference pageRef = new PageReference('/');
        try{
            insert invoice;
            for(Invoice_Line_Item__c i : ilis){
                i.Invoice__c = invoice.Id;
            }
            insert ilis;
            return new PageReference('/'+invoice.Id);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ''+e.getMessage()));
        	return null;
        }
    }
}