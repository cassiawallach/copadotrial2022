trigger PlatformJobExecutionTrigger on copado1p__Platform_Job_Execution__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(copado1p__Platform_Job_Execution__c.sObjectType);
}