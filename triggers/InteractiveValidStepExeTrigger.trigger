trigger InteractiveValidStepExeTrigger on Interactive_Validation_Step_Execution__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(Interactive_Validation_Step_Execution__c.sObjectType);
}