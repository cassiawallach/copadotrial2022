public with sharing class PsydoCaseTriggerHelper {
	
	public static Map<Id, Case> caseMap = new Map<Id, Case>();
	public static List<Case> updates = new List<Case>();
	public static List<CaseComment> ccs = new List<CaseComment>();

	public static void prepareData(List<SObject> records){
		Set<Id> ids = new Set<Id>();
		for(SObject so : records){
            Psydo_Case__c o = (Psydo_Case__c)so;
            ids.add(o.Record_Id__c);
        }
        caseMap = new Map<Id, Case>([select Id, Status from Case where Id IN:ids limit 1000]);
	}
	public static void doAction(Psydo_Case__c pc){
		Case c = caseMap.get(pc.Record_Id__c);
		c.Status = pc.Status__c;
		if(pc.Action__c=='Update'){
			updates.add(c);
			system.debug('#### Case Comment is: '+pc.CaseComment__c);
			if(pc.Status__c=='Closed' && pc.CaseComment__c!=null){
				CaseComment cc = new CaseComment(ParentId=pc.Record_Id__c, isPublished=false, CommentBody=pc.CaseComment__c);
				ccs.add(cc);
			}
		}
	}
}