public class EmailMessageTriggerHandler implements ITrigger {	

	public EmailMessageTriggerHandler(){
    }
    
	public void bulkBefore(){
        if(Trigger.isInsert){
            EmailMessageTriggerHelper.prepareData(Trigger.new);
        }
    }
	
	public void bulkAfter(){}
		
    public void beforeInsert(SObject so){
    }
	
    public void beforeUpdate(SObject oldSo, SObject so){}
    
    public void beforeDelete(SObject so){}
	
	public void afterInsert(SObject so){}
	
	public void afterUpdate(SObject oldSo, SObject so){
    }
	
	public void afterDelete(SObject so){}
    
	public void andFinally(){
        EmailMessageTriggerHelper.completeMilestones();
    }
}