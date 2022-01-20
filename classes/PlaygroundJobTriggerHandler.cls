public with sharing class PlaygroundJobTriggerHandler implements ITrigger {
    public PlaygroundJobTriggerHandler(){
		if(Trigger.new!=null)PlaygroundJobService.prepareData(Trigger.new);
	}

	public void bulkBefore(){
	}

	public void bulkAfter(){
	}

	public void beforeInsert(SObject so){
	}

	public void beforeUpdate(SObject oldSo, SObject so){
        Playground_Job__c oldPj = (Playground_Job__c)oldSo;
        Playground_Job__c pj = (Playground_Job__c)so;
		PlaygroundJobService.resetJob(oldPj, pj);
		PlaygroundJobService.checkActionPayload(oldPj, pj);
	}

	public void beforeDelete(SObject so){
	}

	public void afterInsert(SObject so){
	}

	public void afterUpdate(SObject oldSo, SObject so){
		Playground_Job__c oldPj = (Playground_Job__c)oldSo;
        Playground_Job__c pj = (Playground_Job__c)so;
		PlaygroundJobService.callC1P(oldPj, pj);
	}

	public void afterDelete(SObject so){
	}

	public void andFinally(){
		PlaygroundJobService.updatePlaygrounds();
		PlaygroundJobService.updatePlaygroundEnvironments();
	}
}