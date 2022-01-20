public with sharing class AccountService {
    public static boolean accountTriggerActive = true;
    public static Map<Id, sfLma__License__c> licenseMap;
    public static Map<Id, Contract> accountContractMap;
    public static List<Account> accountsToUpdate = new List<Account>();
    public static List<User> AccountHealthRedChatterPostUsers;
    public static Map<Id,User> userMap;
    public static Id corpRecordTypeId = [select Id, Name, SObjectType from RecordType where Name='Corporate Entity' and SobjectType='Account'].Id;
    public static void prepareData(Map<Id,SObject> AccountOldMap,Map<Id,sObject> AccountNewMap){  
        Set<String> AccountOwnerIds = new set<String>();
        Account AccountNewValue;
        Account AccountOldValue;
        for(String accountId : AccountNewMap.keyset()){
            AccountNewValue = (Account)AccountNewMap.get(accountId);
            AccountOldValue = (Account)AccountOldMap.get(accountId);
            if(AccountNewValue.Account_Health__c != AccountOldValue.Account_Health__c && AccountNewValue.Account_Health__c =='Red'){
                AccountOwnerIds.add(AccountNewValue.OwnerId);
            }
        }
        if(AccountOwnerIds.size()>0){
            userMap = new Map<Id,User>([SELECT Id,Name FROM USER WHERE ID IN : AccountOwnerIds]);
            AccountHealthRedChatterPostUsers = new List<User>([SELECT Id,email,username FROM USER WHERE userName LIKE '%athompson@copa%' OR userName LIKE '%sgillert@copa%' OR userName LIKE '%sgidwani@copa%' OR userName LIKE '%kgarratt@copa%' ]);
        }
    }
    
    public static void prepareAccountContractData(List<SObject> records){
        accountContractMap= New Map<Id, Contract>();
        for(SObject so : records){
            Account newa = (Account)so;
            if(newa.RecordTypeId==corpRecordTypeId){
                accountContractMap.put(newa.Id, new Contract());
            } 
        }
        for(Contract c : [select Id, AccountId, EndDate from Contract where AccountId IN :accountContractMap.keySet() and Status='Activated' order by EndDate DESC]){
            accountContractMap.put(c.AccountId, c);
        }
        
    }
    
    
    public static void setContractExpirationDate(Account a){
        if(accountContractMap.containsKey(a.Id)){
            Date endDate = accountContractMap.get(a.Id).EndDate;
            system.debug('### Setting contract expiration date: '+endDate);
            a.Contract_Expiration_Date__c = null;
            a.Contract_Expiration_Date__c = (endDate==null)?null:endDate;
        }
    }    
    public static void setAccountType(Account a){
        // This logic was update by Phil 2018-11-06 to avoid auto changing Partner picklist selections.
        if(a.RecordTypeId==corpRecordTypeId && a.Contract_Expiration_Date__c==null && (a.Type=='' || a.Type=='Customer') ){
            a.Type = 'Prospect';
        }
        else if(a.RecordTypeId==corpRecordTypeId && a.Contract_Expiration_Date__c>Date.today() && a.Type=='Prospect'){
            a.Type = 'Customer';
        }
    }
   
}