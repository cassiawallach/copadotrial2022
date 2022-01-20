public class assignFreeCreditsExtension {
    public ApexPages.StandardController stdController {get; set;}
    public Salesforce_Org__c org {get;set;}
    public boolean renderRefreshButton {get;set;}

    public assignFreeCreditsExtension(ApexPages.StandardController stdController) {
        org = (Salesforce_Org__c)stdController.getRecord();
        org = [SELECT Id, Name, OrgId__c, Selenium_Minutes__c, Credits__c, Copado_Server__c FROM Salesforce_Org__c WHERE Id = :org.Id LIMIT 1];
        renderRefreshButton = false;
    }
    public pageReference assignCredits(){
        if(org.Credits__c == null || org.Credits__c == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You must enter a credit amount to proceed.'));
            return null;
        }

        List<Salesforce_User__c> su = new List<Salesforce_User__c>();
        su = [select id, Salesforce_Org__c from Salesforce_User__c where Salesforce_Org__c=:org.id];
        if(su.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Salesforce_Org__c has no users.'));
            return null;
        }

        admin_utilities.addTransaction(org.Id, 'addCredits', org.Credits__c);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Credits assigned successfully.'));
        renderRefreshButton = true;
        return null;
    }
    public pageReference assignMinutes(){
        if(org.Selenium_Minutes__c == null || org.Selenium_Minutes__c == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You must enter Minutes to proceed.'));
            return null;
        }

        List<Salesforce_User__c> us = new List<Salesforce_User__c>();
        us = [select id, Salesforce_Org__c from Salesforce_User__c where Salesforce_Org__c=:org.id];
        if(us.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Salesforce_Org__c has no users.'));
            return null;
        }

        admin_utilities.addTransaction(org.Id, 'addMinutes', org.Selenium_Minutes__c);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Minutes assigned successfully.'));
        renderRefreshButton = true;
        return null;
    }

    public class AssignWrapper {
        public Decimal credits {get;set;}
        public Decimal minutes {get;set;}
    }
}