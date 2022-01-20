trigger LicenseTrigger on sfLma__License__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(sfLma__License__c.sObjectType);
}