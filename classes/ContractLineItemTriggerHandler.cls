public with sharing class ContractLineItemTriggerHandler implements ITrigger {	
	
	public ContractLineItemTriggerHandler(){
	}
	public void bulkBefore(){
		if(Trigger.new!=null)ContractLineItemTriggerHelper.prepareData(Trigger.new);
	}
	
	public void bulkAfter(){
	}
		
	public void beforeInsert(SObject so){
		ContractLineItemTriggerHelper.setProductLookup((Contract_Line_Item__c)so);
		ContractLineItemTriggerHelper.setCurrency((Contract_Line_Item__c)so);
	}
	
	public void beforeUpdate(SObject oldSo, SObject so){
	}
	public void beforeDelete(SObject so){	
	}
	
	public void afterInsert(SObject so){
	}
	
	public void afterUpdate(SObject oldSo, SObject so){
	}
	
	public void afterDelete(SObject so){
	}
	public void andFinally(){
	}
}