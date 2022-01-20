public with sharing class ExpiredPlaygroundsBatch implements Database.batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            [SELECT Id FROM Playground__c WHERE Custom_Signup_Request__r.Is_Expired__c = true AND Status__c != 'Expired']
        );
    }

    public void execute(Database.BatchableContext BC, List<Playground__c> scope) {
        for (Playground__c playgroundItem : scope) {
            playgroundItem.Status__c = 'Expired';
        }
        update scope;
    }

    public void finish(Database.BatchableContext BC) {
    }
}