global inherited sharing class cps_DeleteOlderPlaygroundBatch implements Database.Batchable<sObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Id, CreatedDate From Playground__c Where Playground_Configuration__c = \'Full Configuration - Scratch Orgs\' AND CreatedDate < LAST_N_DAYS:30 order by CreatedDate DESC';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Playground__c> playgrounds){
        if (!playgrounds.isEmpty()) {
            delete playgrounds;
        }
    }
   
    global void finish(Database.BatchableContext BC){
   
    }

    global void execute(SchedulableContext SC) {
        cps_DeleteOlderPlaygroundBatch cpsDeletePG = new cps_DeleteOlderPlaygroundBatch();
        Database.executebatch(cpsDeletePG);
    }
}