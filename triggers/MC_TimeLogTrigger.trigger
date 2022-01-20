/**
 * Created by kheidt on 2019-05-06.
 */

trigger MC_TimeLogTrigger on amc__Time_Log__c (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete
) {

    TriggerFactory.createHandler(amc__Time_Log__c.sObjectType);

}