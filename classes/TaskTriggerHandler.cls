public class TaskTriggerHandler implements ITrigger {   
    
    public TaskTriggerHandler(){}
    
    public void bulkBefore(){
    	if(Trigger.new != null)TaskTriggerHelper.prepareData(Trigger.new);
    }
    
    public void bulkAfter(){
        if(Trigger.old != null)TaskTriggerHelper.prepareData(Trigger.old);
    }
        
    public void beforeInsert(SObject so){
        //TaskTriggerHelper.setToCorporateContact((Task)so);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        //TaskTriggerHelper.setToCorporateContact((Task)so);
    }
    
    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){}
    
    public void afterDelete(SObject so){}
    
    public void andFinally(){
        TaskTriggerHelper.updateAffectedLeadsWithContactsMade();
    }
}