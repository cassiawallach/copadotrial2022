public with sharing class StepExecutionTriggerHelper implements ITrigger {
    public void bulkBefore(){
    }
    
    public void bulkAfter(){}
    
    public void beforeInsert(SObject so){}
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Step_Execution__c oldSe = (Step_Execution__c)oldSo;
        Step_Execution__c se = (Step_Execution__c)so;
        StepExecutionService.resetJob(oldSe, se);
        StepExecutionService.checkPayload(oldSe, se);
    }
    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){}
    
    public void afterDelete(SObject so){}
    public void andFinally(){}
}