global class AddInvoicesToPaymentBatch implements Database.Batchable<sObject> {
	
	String query;
	global final  Date fromDate;
	global final  Date toDate;
	
	global AddInvoicesToPaymentBatch(Date fd, Date td) {
		fromDate = fd;
		toDate = td;
		query = 'select Id, Name, Invoice_Amount__c, Status__c, Invoice_Date__c, Invoice_Due_Date__c, Related_Customer__r.Name, Batch_Payment__c from Payable_Invoice__c where Invoice_Due_Date__c >='+String.valueOf(fromDate)+' and Invoice_Due_Date__c <='+String.valueOf(toDate)+' and Status__c=\'Pending Payment\' and Account__r.Name=\'salesforce.com EMEA Limited\'';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		if(fromDate==null || toDate==null){
   			system.debug('Nothing to run. One of the dates was null: fromDate('+fromDate+') toDate('+toDate+')');
   			return;
   		}
		if(scope.size()>0){
			// First create Batch_Payment.
			Batch_Payment__c batchPayment = new Batch_Payment__c();
			List<Batch_Payment__c> bps = [select Id, Name, Amount__c, Status__c, Payment_Date__c, Covering_Period_From__c, Covering_Period_To__c from Batch_Payment__c
			where Covering_Period_From__c=:fromDate and Covering_Period_To__c=:toDate and Status__c='Draft'];
			system.debug('### bps returned '+bps);
			if(bps.size()>0){
				system.debug('### TAKING FIRST PAYMENT: '+bps[0]);
				batchPayment = bps[0];
			}
			else{
				system.debug('### CREATING NEW PAYMENT: ');
				batchPayment.Covering_Period_From__c = fromDate;
				batchPayment.Covering_Period_To__c = toDate;
				batchPayment.Status__c = 'Draft';
				insert batchPayment;
			}
			system.debug('### USING THIS PAYMENT: '+batchPayment);
			// Then add invoices to batch payment.
			batchPayment.Amount__c = 0;
			for(SObject so : scope){
				Payable_Invoice__c i = (Payable_Invoice__c)so;
				system.debug('### ITERATING SCOPE: '+i);
				i.Batch_Payment__c = batchPayment.Id;
				batchPayment.Amount__c = batchPayment.Amount__c+i.Invoice_Amount__c;
			}

			system.debug('### UPDATING SCOPE: '+scope);
			update scope;

			system.debug('### UPDATING batchPayment: '+batchPayment);
			update batchPayment;
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}