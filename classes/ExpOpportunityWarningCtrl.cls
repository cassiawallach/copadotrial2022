//This extension controller has 'ExpOpportunityWarning' VF page is used to dispaly an alert for Lead Source when an Expansion Opportunity gets created.
public with sharing class ExpOpportunityWarningCtrl {

    public boolean warningMessage {get;set;}

    public ExpOpportunityWarningCtrl(ApexPages.StandardController controller) {      
        
    }
    
    public void updateOpportunity() {
        Id expansionId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Expansion').getRecordTypeId();        
        Id oppId = ApexPages.currentPage().getParameters().get('id');      
        if(oppId != null) { 
            List<Opportunity> oppList = [Select Id,ExpansionOppWarningLeadSource__c from Opportunity where Id=: oppId AND RecordTypeId =:expansionId LIMIT 1];
            if(!oppList.isEmpty() && oppList.size() > 0) {
                if(oppList[0].ExpansionOppWarningLeadSource__c == false) { 
                     warningMessage = true;  
                     oppList[0].ExpansionOppWarningLeadSource__c = true;
                     try {
                         update oppList[0];
                     } catch(Exception e) {
                         System.debug(e);
                     } 
                } else {
                    warningMessage = false;
                }
            }
        }
    }
}