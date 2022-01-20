trigger ConfigExecutionTrigger on Configuration_Execution__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(Configuration_Execution__c.sObjectType);
}