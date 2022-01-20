trigger ReleaseTrigger on copado__Release__c (before insert, before update, before delete, after insert, after update, after delete, after undelete ) {

	TriggerFactory.createHandler(copado__Release__c.sObjectType);


}