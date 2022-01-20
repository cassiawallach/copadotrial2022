public class AutoConvertLead {

	@InvocableMethod
	public static void AutoConvertLeadsApex(List<Id> MeetingIds) {

        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];

        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();

        List<Demo__c> Lmeetings = [SELECT Id, Lead__c, Account__c FROM Demo__c WHERE Id IN :MeetingIds];
        List<Id> LeadsId = new List<Id>();
        List<Opportunity> OpportunityToUpdate = new List<Opportunity>();

        for(Demo__c meeting: Lmeetings) {
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(meeting.Lead__c);
            LeadsId.add(Leadconvert.getLeadID()); 
            if (meeting.Account__c != null) { 
                Leadconvert.setAccountId(meeting.Account__c);
            }           
            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
            Leadconvert.setDoNotCreateOpportunity(FALSE);
            MassLeadconvert.add(Leadconvert);
        }
        
        if (!MassLeadconvert.isEmpty()) {
            List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert);

            for (Lead l : [SELECT Id, Description, Next_Step__c, ConvertedOpportunityId 
                                                        FROM Lead WHERE Id IN :LeadsId]){
                Opportunity Opp = new Opportunity(
                                                Id = l.ConvertedOpportunityId, 
                                                NextStep = l.Next_Step__c, 
                                                Description = l.Description,
                                                Main_Problems__c = 'Opportunity from Demo'
                                                );
                OpportunityToUpdate.add(Opp);
            }
            update OpportunityToUpdate;
        }
    }
}