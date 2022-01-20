global without sharing class SupportFeedback {
    
    public String comment {get;set;}
    public Boolean updated {get;set;}
    
    public PageReference UpdateCase() {
        String CaseId = ApexPages.currentPage().getParameters().get('CaseId');
        String CustomerDisagrees = ApexPages.currentPage().getParameters().get('CustomerDisagrees');
        
        List<Case> Lcase = [SELECT Customer_Feedback__c, Feedback_Reason__c FROM Case WHERE Id = :CaseId];
        
        if (!Lcase.isEmpty()) {
        
            if (CustomerDisagrees == 'true') {
            	Lcase[0].Customer_Feedback__c = System.Label.Customer_Feedback_Not_satisfied;
			}
            else {
                Lcase[0].Customer_Feedback__c = System.Label.Customer_Feedback_Satisfied;
            }
            
            if (Lcase[0].Feedback_Reason__c == null) {
                Lcase[0].Feedback_Reason__c = comment;
            }
            else {
                Lcase[0].Feedback_Reason__c += ' - ' + comment;
            }
            update Lcase;
        updated = true;
        }
        
        
        return null;
    }

}