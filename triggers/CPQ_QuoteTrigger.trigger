/**
 * Created by kheidt on 24/01/2018.
 */

trigger CPQ_QuoteTrigger on SBQQ__Quote__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    System.debug('@@@ Entering Quote Trigger @@@');
    TriggerFactory.createHandler(SBQQ__Quote__c.sObjectType);
}