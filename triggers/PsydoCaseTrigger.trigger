trigger PsydoCaseTrigger on Psydo_Case__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(Psydo_Case__c.sObjectType);
}