global class AccountACVPopuplateBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,AccountId,Account.ACV__c, Opportunity__c, Opportunity__r.ACV__c FROM Contract WHERE Status ='Activated' AND  Opportunity__r.ACV__c >0 AND Opportunity__c!='' ORDER BY AccountId]);
    }
    
    global void execute(Database.BatchableContext BC, List<Contract> scope){
       List<Account> updateACVAccountList = new List<Account>();
       Set<String> AccountIds = new Set<String>();
        for(Contract contractObj : scope){
            if(!AccountIds.contains(contractObj.AccountId)){
                AccountIds.add(contractObj.AccountId);
                Account accObj = new Account();
                accObj.Id = contractObj.AccountId;
                accObj.ACV__c =  contractObj.Opportunity__r.ACV__c;
                updateACVAccountList.add(accObj);
            }
        }
        if(updateACVAccountList.size()>0){
            UPDATE updateACVAccountList;
        }
    }
    global void finish(Database.BatchableContext BC){
    }
}