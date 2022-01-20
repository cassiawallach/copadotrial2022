trigger ValidationExecutionTrigger on Validation_Execution__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(Validation_Execution__c.sObjectType);
}