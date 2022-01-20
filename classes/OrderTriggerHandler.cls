public class OrderTriggerHandler implements ITrigger {

    public OrderTriggerHandler(){}
    
    public void bulkBefore(){
		if(Trigger.new!=null)OrderTriggerHelper.prepareData(Trigger.new);
	}
	
	public void bulkAfter(){
	}
		
	public void beforeInsert(SObject so){
	}
	
	public void beforeUpdate(SObject oldSo, SObject so){
	}
	public void beforeDelete(SObject so){
	}
	
	public void afterInsert(SObject so){
	}
	
	public void afterUpdate(SObject oldSo, SObject so){
        Order oldo = (Order)oldSo;
        Order newo = (Order)so;
        //OrderTriggerHelper.createRenewalOpportunityProcess(oldo, newo);
	}
	
	public void afterDelete(SObject so){
        Order o = (Order)so;
        System.debug('Init account value to 0 for AccountId: ' + o.AccountId);
        OrderTriggerHelper.accountValueMap.put(o.AccountId, 0.0);
	}
	public void andFinally(){
        //no need to recalculate accounts here
        AccountService.accountTriggerActive = false;
        
        //OrderTriggerHelper.createRenewalOpportunities();
        //OrderTriggerHelper.updateRenewalOpportunities();
        //this has to be after the opportunities since calculation is based on the opps
        OrderTriggerHelper.updateAccountsWithOrderValue();
        //OrderTriggerHelper.updateContracts();
	}
}