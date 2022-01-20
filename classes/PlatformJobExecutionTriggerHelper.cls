public with sharing class PlatformJobExecutionTriggerHelper implements ITrigger {
    public PlatformJobExecutionTriggerHelper() {

    }

    public void bulkBefore(){
    }
    
    public void bulkAfter(){
    }
    
    public void beforeInsert(SObject so){
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
    }
    public void beforeDelete(SObject so){
    }
    
    public void afterInsert(SObject so){
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        copado1p__Platform_Job_Execution__c oldPje = (copado1p__Platform_Job_Execution__c)oldSo;
        copado1p__Platform_Job_Execution__c newPje = (copado1p__Platform_Job_Execution__c)so;
        PlatformJobExecutionService.updateRelatedStepExecution(oldPje, newPje);
    }
    
    public void afterDelete(SObject so){
    }
    public void andFinally(){
    }
}