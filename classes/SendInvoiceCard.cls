global class SendInvoiceCard{
    
    public SendInvoiceCard(apexpages.StandardController std){
        
    }
	@RemoteAction
        global static boolean sendInvoiceAction(String invId){
            new SendInvoice(new apexpages.StandardController(new Invoice__c(id=invId))).send();
            return true;
        }
}