trigger slack_Value_Stream_Map on copadovsm__Value_Stream_Map__c (after insert, after update, before delete) {
    if(trigger.isAfter && trigger.isInsert || trigger.isAfter && trigger.isUpdate || trigger.isBefore && trigger.isDelete) {
        slackv2__.utilities.startSubscriptionQueue(trigger.newMap, trigger.oldMap, trigger.operationType, 'copadovsm__Value_Stream_Map__c');
    }
}