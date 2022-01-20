trigger KugaOrderTrigger on kugo2p__SalesOrder__c (after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(kugo2p__SalesOrder__c.sObjectType);
}