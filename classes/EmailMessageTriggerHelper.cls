public class EmailMessageTriggerHelper {
    public static List<Id> firstResponses = new List<Id>();
    public static List<Id> responses = new List<Id>();
    public EmailMessageTriggerHelper(){
        
    }
    public static void prepareData(List<SObject> records){
        if (UserInfo.getUserType() == 'Standard'){
            DateTime completionDate = System.now();
            Map<Id, String> emIds = new Map<Id, String>();
            for (EmailMessage em : (List<EmailMessage>)records){
                if(em.Incoming == false)
                    emIds.put(em.ParentId, em.ToAddress);
            }
            if (emIds.isEmpty() == false){
                Set <Id> emCaseIds = new Set<Id>();
                emCaseIds = emIds.keySet();
                List<Case> caseList = [Select c.Id, c.ContactId, c.Contact.Email,
                                       c.OwnerId, c.Status,
                                       c.EntitlementId,
                                       c.SlaStartDate, c.SlaExitDate
                                       From Case c where c.Id IN :emCaseIds];
                if (caseList.isEmpty()==false){
                    
                    for (Case caseObj:caseList) {
                        if ((emIds.get(caseObj.Id)==caseObj.Contact.Email)&&
                            (caseObj.Status == 'New')&&
                            (caseObj.EntitlementId != null)&&
                            (caseObj.SlaStartDate <= completionDate)&&
                            (caseObj.SlaStartDate != null)&&
                            (caseObj.SlaExitDate == null))
                            firstResponses.add(caseObj.Id);
                        if ((emIds.get(caseObj.Id)==caseObj.Contact.Email)&&
                            (caseObj.Status == 'In Progress')&&
                            (caseObj.EntitlementId != null)&&
                            (caseObj.SlaStartDate <= completionDate)&&
                            (caseObj.SlaStartDate != null)&&
                            (caseObj.SlaExitDate == null))
                            responses.add(caseObj.Id);
                    }
                }
            }
        } 
    }
    public static void completeMilestones(){
        DateTime completionDate = System.now();
        if(firstResponses.isEmpty() == false)milestoneUtils.completeMilestone(firstResponses,'First Response', completionDate);
        if(responses.isEmpty() == false)milestoneUtils.completeMilestone(responses,'Response Time', completionDate);
    }
}