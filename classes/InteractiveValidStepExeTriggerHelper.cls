public with sharing class InteractiveValidStepExeTriggerHelper implements ITrigger {
    public void bulkBefore(){}
    
    public void bulkAfter(){}
    
    public void beforeInsert(SObject so){}
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Interactive_Validation_Step_Execution__c oldSe = (Interactive_Validation_Step_Execution__c)oldSo;
        Interactive_Validation_Step_Execution__c se = (Interactive_Validation_Step_Execution__c)so;
        InteractiveValidStepExeService.resetJob(oldSe, se);
        InteractiveValidStepExeService.checkPayload(oldSe, se);
    }
    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){
        Interactive_Validation_Step_Execution__c oldSe = (Interactive_Validation_Step_Execution__c)oldSo;
        Interactive_Validation_Step_Execution__c se = (Interactive_Validation_Step_Execution__c)so;
		InteractiveValidStepExeService.updateValidationonLAssignment(oldSe, se);
    }
    
    public void afterDelete(SObject so){}
    public void andFinally(){}
}