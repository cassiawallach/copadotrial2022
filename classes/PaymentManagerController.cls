public with sharing class PaymentManagerController {
	/*
	When contracts are created they are registered in Salesforce.
	We need to;
		- record what our debt to Salesforce is for outstanding contracts
		- easily calculate this month's payments to Salesforce
		- easily associate invoices received via email to contracts within 
	We need to controle
	*/
	public Batch_Payment__c batchPayment {get;set;}
	public List<Payable_Invoice__c> invoices {get;set;}
	public AsyncApexJob apexJob {get;set;}
	public boolean isProcessing {get;set;}
	public String apexJobId {get;set;}
	public boolean hasBatchPaymentId {get;set;}
	public String bpid{get;set;}

	public PaymentManagerController() {
		isProcessing = false;
		batchPayment = new Batch_Payment__c();
		bpid = ApexPages.currentPage().getParameters().get('bpid');
		hasBatchPaymentId = !String.isBlank(bpid);
		if(hasBatchPaymentId){
			try{
				batchPayment = [select Id, Name, Amount__c, Status__c, Payment_Date__c, Covering_Period_From__c, Covering_Period_To__c from Batch_Payment__c
			where Id=:bpid limit 1];
			}
			catch(Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ''+e.getMessage()));
			}
		}
	}
	public void getInvoices(){
		if(batchPayment.Covering_Period_From__c==null || batchPayment.Covering_Period_To__c==null){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select a "from" and "to" date range.'));
			return;
		}
		List<Payable_Invoice__c> tmp = [select Id, Name, Invoice_Amount__c, Status__c, Invoice_Date__c, Invoice_Due_Date__c, Related_Customer__r.Name, Batch_Payment__c from Payable_Invoice__c where Invoice_Due_Date__c >=:batchPayment.Covering_Period_From__c and Invoice_Due_Date__c <=:batchPayment.Covering_Period_To__c and Status__c='Pending Payment' and Account__r.Name='salesforce.com EMEA Limited' limit 3];
		if(tmp.size()==0){
			isProcessing = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no invoices in that date range.'));
			return;
		}
		//When the dates are selected we create a batch process to add the invoices to a job.
		AddInvoicesToPaymentBatch addInvoiceBatch = new AddInvoicesToPaymentBatch(batchPayment.Covering_Period_From__c, batchPayment.Covering_Period_To__c);
		ID batchprocessid = Database.executeBatch(addInvoiceBatch);
		AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =:batchprocessid ];
        isProcessing = true;
        apexJobId = batchprocessid;
		invoices = new List<Payable_Invoice__c>();
	}
	public void markAsPaid(){
		
	}
}