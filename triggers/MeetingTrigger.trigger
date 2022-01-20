trigger MeetingTrigger on Demo__c (after insert, after update) {
	TriggerFactory.createHandler(Demo__c.sObjectType);

}