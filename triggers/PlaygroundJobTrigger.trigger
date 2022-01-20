trigger PlaygroundJobTrigger on Playground_Job__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(Playground_Job__c.sObjectType);
}