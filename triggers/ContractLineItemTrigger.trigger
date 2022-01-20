trigger ContractLineItemTrigger on Contract_Line_Item__c  (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	TriggerFactory.createHandler(Contract_Line_Item__c.sObjectType);
}