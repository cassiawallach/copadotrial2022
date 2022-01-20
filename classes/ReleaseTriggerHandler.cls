public class ReleaseTriggerHandler implements ITrigger {

	public ReleaseTriggerHandler(){		//prepareData
	}
    
	public void bulkBefore(){}
	
	public void bulkAfter(){
		if(Trigger.isUpdate){
			ReleaseTriggerHelper.prepareData(Trigger.newMap.keySet());
		}		
	}
		
    public void beforeInsert(SObject so){}
	
    public void beforeUpdate(SObject oldSo, SObject so){}
    
    public void beforeDelete(SObject so){}
	
	public void afterInsert(SObject so){}
	
	public void afterUpdate(SObject oldSo, SObject so){
        ReleaseTriggerHelper.changeUserStoriesStatus((copado__Release__c)oldSo, (copado__Release__c)so);
    }
	
	public void afterDelete(SObject so){}
    
	public void andFinally(){
		if(ReleaseTriggerHelper.userStoriesToUpdate.size() > 0){
			ReleaseTriggerHelper.updateUserStoriesStatus();
		}
	}
}