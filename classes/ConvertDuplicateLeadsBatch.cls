global class ConvertDuplicateLeadsBatch implements Database.Batchable<sObject>{

    global final LeadStatus convertStatus;
    global ConvertDuplicateLeadsBatch(){
        convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select Id, Email, LeadSource from Lead where LeadSource LIKE 'AppExchange%' and Email!='' and IsConverted=false]);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope) {
        system.debug('SCOPE SIZE: '+scope.size());
        Set<String> emailSet = new Set<String>();
        Map<String, List<Lead>> emailLeadsMap = new Map<String, List<Lead>>();
        
        for(Lead l : scope){
            emailSet.add(l.Email);
            List<Lead> tmp = (!emailLeadsMap.containsKey(l.Email))?new List<Lead>() : emailLeadsMap.get(l.Email);
            tmp.add(l);
            emailLeadsMap.put(l.Email, tmp);
     	}
        system.debug(''+emailLeadsMap);
        
        List<Contact> contacts = [select Id, Email, Account.Name, AccountId, OwnerId from Contact where Email IN :emailSet];
        system.debug('CONTACTS FOUND: '+contacts.size());
        Map<Id,Contact> leadsToConvertWithContact = new Map<Id,Contact>();
        for(Contact c : contacts){
            List<Lead> dupes = emailLeadsMap.get(c.Email);
            system.debug('dupes found: '+dupes.size());
            for(Lead l : dupes){
                leadsToConvertWithContact.put(l.Id, c);
            }
        }
        
        List<Database.LeadConvert> leadConversions = new List<Database.LeadConvert>();
        for(Id leadId : leadsToConvertWithContact.keySet()){
            Contact c = leadsToConvertWithContact.get(leadId);
        	Database.LeadConvert lc = new Database.LeadConvert();
        	lc.setLeadId(leadId);
            lc.setAccountId(c.AccountId);
            lc.setContactId(c.Id);
            lc.setOwnerId(c.OwnerId);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            lc.setDoNotCreateOpportunity(true);
            leadConversions.add(lc);
        }
        system.debug('LEAD CONVERSIONS: '+leadConversions.size());
        
        List<Database.LeadConvertResult> results = Database.convertLead(leadConversions);
        system.debug('Lead conversion results: '+results);
        for(Database.LeadConvertResult lcr : results){
            if(!lcr.isSuccess()){
                system.debug('Error converting lead: '+ lcr.getLeadId() + ' : '+lcr.getErrors());
            }
        }    
    }
    global void finish(Database.BatchableContext bc){}
}