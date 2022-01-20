public class TaskTriggerHelper {
    
    //public static Map<Id, Lead> leadMap = new Map<Id, Lead>();
    public static Set<Id> leadIdSet = new Set<Id>();
    public static String lead_prefix = Schema.SObjectType.Lead.getKeyPrefix();
    public static Id openLeadsQueueId = [select Id, Name, DeveloperName from Group where Name='Open Leads' limit 1].Id;
    
    public static void prepareData(List<SObject> records){
        for(SObject so : records){
            Task t = (Task)so;
            if(t.WhoId!=null && ((String)t.WhoId).startsWith(lead_prefix)){
                leadIdSet.add(t.WhoId);
            }
        }
    }
    public static void updateAffectedLeadsWithContactsMade(){
        Map<Id, Lead> leadMap = new Map<Id, Lead>([select Id, OwnerId, Contacts_made__c from Lead where isConverted=false and OwnerId!=:openLeadsQueueId and Id IN :leadIdSet]);
        system.debug('@@@ LEADS FOUND: '+leadMap);
        List<Task> tsks = [select Id, OwnerId, WhoId from Task where (Action__c='Email: ' or Action__c='→ ') and WhoId IN :leadMap.keySet() order by WhoId];
    	system.debug('@@@ TASKS FOUND: '+tsks);
        
        Map<Id, Integer> countOfContacts = new Map<Id, Integer>();
        for(Id leadId : leadMap.keySet()){
            countOfContacts.put(leadId, 0);
        }
        for(Task t : tsks){
            Integer i = countOfContacts.get(t.WhoId);
            if(t.OwnerId==leadMap.get(t.WhoId).OwnerId)i++; // we only count the tasks for the current leadOwner.  If lead is reassigned, counter restarts.
            countOfContacts.put(t.WhoId, i);
        }
        List<Lead> updates = new List<Lead>();
        for(Id leadId : countOfContacts.keySet()){
            Lead l = new Lead(Id=leadId, Contacts_made__c=countOfContacts.get(leadId));
            updates.add(l);
        }
        system.debug('@@@ UPDATES SIZE: '+updates);
        update updates;
    }
}