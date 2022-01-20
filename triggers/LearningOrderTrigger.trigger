trigger LearningOrderTrigger on ltcomm__Learning_Order__c(before insert, before update, before delete, after insert, after update, after delete, after undelete){
    TriggerFactory.createHandler(ltcomm__Learning_Order__c.sObjectType);
}