public with sharing class PsydoCaseTriggerHandler implements ITrigger{
 
    public PsydoCaseTriggerHandler() {
    }
    public void bulkBefore() {
    	if(Trigger.isInsert)PsydoCaseTriggerHelper.prepareData(Trigger.New);
    }
    public void bulkAfter() {
    }
    public void beforeInsert(SObject so){
    }
    public void beforeUpdate(SObject oldSo, SObject so){
    }
    public void beforeDelete(SObject so) {   
    }
    public void afterInsert(SObject so){
    	PsydoCaseTriggerHelper.doAction((Psydo_Case__c)so);
    }
    public void afterUpdate(SObject oldSo, SObject so){
    }
    public void afterDelete(SObject so){
    }
    public void andFinally(){
    	if(Trigger.isAfter && Trigger.isInsert && PsydoCaseTriggerHelper.updates != null)update PsydoCaseTriggerHelper.updates;
    	if(Trigger.isAfter && Trigger.isInsert && PsydoCaseTriggerHelper.ccs != null)insert PsydoCaseTriggerHelper.ccs;
    }
}