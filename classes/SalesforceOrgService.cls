/**
 * This class is a replacement for the former AccountService
 */
public with sharing class SalesforceOrgService {

    public static Map<Id, sfLma__License__c> licenseMap;
    public static Map<Id, Contract> contractMap;
    public static boolean salesforceOrgTriggerActive = true;

    public static void prepareData(List<SObject> records) {

        licenseMap = new Map<Id, sfLma__License__c>();
        contractMap = new Map<Id, Contract>();
        Set<Id> orgIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();

        for(SObject so : records){
            Salesforce_Org__c newOrg = (Salesforce_Org__c)so;
            orgIds.add(newOrg.Id);
            accIds.add(newOrg.Parent_Account__c);
        }

        List<sfLma__License__c> licenses = [select Id, Salesforce_Org__c, Salesforce_User__c, sfLma__Contact__c, sfLma__License_Status__c, sfLma__Install_Date__c, sfLma__Licensed_Seats__c, sfLma__Expiration__c from sfLma__License__c where Salesforce_Org__c IN :orgIds];
        for(sfLma__License__c l : licenses){
            licenseMap.put(l.Salesforce_Org__c, l);
        }

        try {
            List<Contract> cs = [
                    SELECT Id, StartDate, AccountId
                    FROM Contract
                    WHERE AccountId IN :accIds AND Status = 'Activated'
                    ORDER BY EndDate DESC
            ];

            for (Contract cont : cs) {
                contractMap.put(cont.AccountId, cont);
            }
        }
        catch (QueryException e) {
            //This exception happens when the running user has no permissions on Contracts (LicenseManagerApp user actually...)
            //We ignore this exception so that the LMA user won't have to update the Next Top Up date, Sales will.
        }

    }


    public static void updateOrgLicensingInfo(Salesforce_Org__c o) {

        sfLma__License__c l = licenseMap.get(o.Id);

        if(l != null){
            o.Org_Type__c = (l.sfLma__Licensed_Seats__c=='Site License')?'Sandbox':'Production';
            if(l.sfLma__License_Status__c=='Uninstalled'){
                o.Account_Status__c = 'Inactive';
                o.Licensed_Seats__c = 0;
                o.Credits_Top_Up__c = 0;
                o.Type__c = 'Prospect';
            }
            else if(l.sfLma__License_Status__c=='Suspended'){
                o.Account_Status__c = 'Suspended';
            }
            o.Trial_Expiration_Date__c = l.sfLma__Expiration__c;
            if(o.License_User__c==null)o.License_User__c=l.Salesforce_User__c;

        }
    }

    public static void setTopUpDate(Salesforce_Org__c o) {
        if (o.Type__c == 'Customer' && o.Next_Top_Up_Date__c == null) {
            if (contractMap.containsKey(o.Parent_Account__c)) {
                if (contractMap.get(o.Parent_Account__c).StartDate != null) {
                    o.Next_Top_Up_Date__c = contractMap.get(o.Parent_Account__c).StartDate.addMonths(1);
                }
            }
        }
        else if (o.Type__c == 'Prospect') {
            o.Next_Top_Up_Date__c = null;
        }
    }
}