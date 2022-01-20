public class CaseTriggerHandler implements ITrigger {   

    public CaseTriggerHandler(){
        if(Trigger.new!=null)CaseTriggerHelper.prepareData(Trigger.new, Trigger.isBefore && Trigger.isInsert);
    }
    
    public void bulkBefore(){}
    
    public void bulkAfter(){}
        
    public void beforeInsert(SObject so){
        CaseTriggerHelper.setCaseContact((Case)so);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        CaseTriggerHelper.updateCaseBusinessHours((Case)oldSo, (Case)so);
    }
    
    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){
        CaseTriggerHelper.CompleteResolutionTimeMilestone((Case)so);
    }
    
    public void afterDelete(SObject so){}
    
    public void andFinally(){
        CaseTriggerHelper.completeMilestones();
    }
}