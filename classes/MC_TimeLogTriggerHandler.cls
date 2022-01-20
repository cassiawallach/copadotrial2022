/**
 * Created by kheidt on 2019-05-06.
 */

public with sharing class MC_TimeLogTriggerHandler implements ITrigger {

    String triggerName = 'MC_TimeLogTriggerHandler';
    MC_TimeLogHelper tlh = new MC_TimeLogHelper();

    public MC_TimeLogTriggerHandler() {
    }

    public void bulkBefore() {
    }

    public void bulkAfter() {
        system.debug(triggerName+ Trigger.new);
        if(Trigger.new != null){
            System.debug('about to call the helper');
            tlh.convertTimeLogsToConsumption( (Map<Id, amc__Time_Log__c>) Trigger.newMap);
        }
    }

    public void beforeInsert(SObject so) {
    }

    public void beforeUpdate(SObject oldSo, SObject so) {
    }
    public void beforeDelete(SObject so) {
    }

    public void afterInsert(SObject so) {
    }

    public void afterUpdate(SObject oldSo, SObject so) {
    }

    public void afterDelete(SObject so) {
        amc__Time_Log__c tl = (amc__Time_Log__c) so;
        tlh.deleteRelatedConsumption( tl );
    }
    public void andFinally() {
    }
}