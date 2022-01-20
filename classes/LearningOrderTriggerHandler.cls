public  with sharing  class LearningOrderTriggerHandler implements ITrigger {
    public LearningOrderTriggerHandler(){
    }
    
    public void bulkBefore(){
    }
    
    public void bulkAfter(){
        if(Trigger.new != null )LearningOrderTriggerHelper.prepareData(Trigger.new);
        if(Trigger.Old != null)LearningOrderTriggerHelper.prepareData(Trigger.Old);
    }
    
    public void beforeInsert(SObject so){
        LearningOrderTriggerHelper.InsertionPreventForTargetTypeLearner((ltcomm__Learning_Order__c)so);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
    }
    
    public void beforeDelete(SObject so){
    }
    
    public void afterInsert(SObject so){
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
    }
    
    public void afterDelete(SObject so){
    }
    
    public void andFinally(){
    }
}