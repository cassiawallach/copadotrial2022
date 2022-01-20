trigger ConfigurationStepTrigger on Configuration_Step__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(Configuration_Step__c.sObjectType);
}