public with sharing class LeadTriggerHelper {
    public LeadTriggerHelper() {}
    public static Set<String> orgIds = new Set<String>();
    public static Set<Decimal> clickDeployUserIds = new Set<Decimal>();
    public static Set<Id> opptyIds = new Set<Id>();
    public static Map<String, Lead> mapIdLeads = new Map<String, Lead>();
    public static Map<Decimal, Lead> mapUserIdLeads = new Map<Decimal,Lead>();
    public static Map<String, Contact> mapOrgIdToContact = new Map<String, Contact>();
    public static Map<Decimal, Contact> mapUserIdContact = new Map<Decimal, Contact>();
    public static Map<String, Account> mapOrgIdAccount = new Map<String, Account>();
    public static Map<ID, Opportunity> mapOpptyIdOpportunity = new Map<Id, Opportunity>();
    public static LeadStatus ls = new LeadStatus();
    public static void prepareData(List<SObject> records){
        /*
        for(SObject so : records){
            Lead l = (Lead)so;
            if (l.ClickDeploy_Salesforce_Org_Id__c != null) {
                orgIds.add(l.ClickDeploy_Salesforce_Org_Id__c);
                mapIdLeads.put(l.ClickDeploy_Salesforce_Org_Id__c, l);  
            }
            if(l.ClickDeploy_User_Id__c!= null){
                clickDeployUserIds.add(l.ClickDeploy_User_Id__c);
                mapUserIdLeads.put(l.ClickDeploy_User_Id__c, l);
            }
        }
        ls= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        for(Account acc : [SELECT Id, Name, ClickDeploy_Salesforce_Org_Id__c 
            FROM Account WHERE 
            ClickDeploy_Salesforce_Org_Id__c IN :orgIds]) {
            mapOrgIdAccount.put(acc.ClickDeploy_Salesforce_Org_Id__c, acc);
        }
        for(Contact cnt : [SELECT Id, ClickDeploy_Salesforce_Org_Id__c 
            FROM Contact WHERE 
            ClickDeploy_Salesforce_Org_Id__c IN :orgIds]) {
            mapOrgIdToContact.put(cnt.ClickDeploy_Salesforce_Org_Id__c, cnt);
        }
        for(Contact cnt : [SELECT Id, ClickDeploy_User_Id__c, AccountId
            FROM Contact WHERE 
            ClickDeploy_User_Id__c IN :clickDeployUserIds]) {
            mapUserIdContact.put(cnt.ClickDeploy_User_Id__c, cnt);
        }
        */
    }
    public static void setFreeMQL(Lead mqlLead){
        /*
        if(mqlLead.ClickDeploy_Total_Success_Deploy_Attempt__c >=3 &&
            mqlLead.ClickDeploy_Total_Success_Deploy_Attempt__c <15  && 
            mqlLead.ClickDeploy_License_Type__c == 'Free'){
                mqlLead.Status = 'MQL';
                mqlLead.MQL__c = true;
                mqlLead.MQL_Date__c = Date.today();
                mqlLead.AVA__AVAAI_options__c = 'Stop';
            }
        */
    }
}