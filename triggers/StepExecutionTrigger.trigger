trigger StepExecutionTrigger on Step_Execution__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(Step_Execution__c.sObjectType);
}