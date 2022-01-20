public with sharing class ClickDeployLeadConversion {
    public ClickDeployLeadConversion() {} 

    public static Set<String> orgIds = new Set<String>();
    public static Set<Decimal> clickDeployUserIds = new Set<Decimal>();
    public static Map<String, Lead> mapIdLeads = new Map<String, Lead>();
    public static Map<Decimal, Lead> mapUserIdLeads = new Map<Decimal,Lead>();
    public static Map<Decimal, Contact> mapUserIdContact = new Map<Decimal, Contact>();
    public static Map<String, Account> mapOrgIdAccount = new Map<String, Account>();
    public static LeadStatus ls = new LeadStatus();

    @InvocableMethod
    public static void convertLead(List<Lead> LeadIds){
                /*

        ls= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        
        for (lead l: LeadIds){
            
            if (l.ClickDeploy_Salesforce_Org_Id__c != null) {
                orgIds.add(l.ClickDeploy_Salesforce_Org_Id__c);
                mapIdLeads.put(l.ClickDeploy_Salesforce_Org_Id__c, l);                  
            }

            if(l.ClickDeploy_User_Id__c!= null){
                clickDeployUserIds.add(l.ClickDeploy_User_Id__c);
                mapUserIdLeads.put(l.ClickDeploy_User_Id__c, l);
            }
        }

        for(Account acc : [SELECT Id, Name, ClickDeploy_Salesforce_Org_Id__c 
            FROM Account WHERE 
            ClickDeploy_Salesforce_Org_Id__c IN :orgIds]) {
            mapOrgIdAccount.put(acc.ClickDeploy_Salesforce_Org_Id__c, acc);
        }


        for(Contact cnt : [SELECT Id, ClickDeploy_User_Id__c, AccountId
            FROM Contact WHERE 
            ClickDeploy_User_Id__c IN :clickDeployUserIds]) {
            mapUserIdContact.put(cnt.ClickDeploy_User_Id__c, cnt);
        }
        
        for (Lead l : LeadIds){
        
            if(l.isConverted == false){
                Contact cont = mapUserIdContact.get(l.ClickDeploy_User_Id__c);
            
                System.debug(cont.Id);
                System.debug(cont.AccountId);
                
                Database.LeadConvert Leadconvert =
                    new Database.LeadConvert();
                
                Leadconvert.setLeadId(l.Id);
                Leadconvert.setConvertedStatus(ls.MasterLabel);
                Leadconvert.setAccountId(cont.AccountId);
                Leadconvert.setContactId(cont.Id);
                
                Leadconvert.setDoNotCreateOpportunity(TRUE);

                Database.LeadConvertResult Leadconverts;

                try{
                    Leadconverts = 
                        Database.convertLead(Leadconvert);

                } catch(Exception e){
                    
                    System.debug(e.getMessage());
                    throw e;
                } 
                
                //System.assert(Leadconverts.isSuccess());
            }

        }
                */
        
    }
}