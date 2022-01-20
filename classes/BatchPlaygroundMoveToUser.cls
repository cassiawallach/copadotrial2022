global with sharing class BatchPlaygroundMoveToUser implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('Select Id, Contact__c, User__c From Playground__c Where User__c = null');
    }

    global void execute(Database.BatchableContext bc, List<Playground__c> playgrounds) {
        Set<String> contactIds = new Set<String>();
        Map<String, String> contactAndUserIdMap = new Map<String, String>();
        List<Playground__c> playgroundToBeUpdated = new List<Playground__c>();

        for (Playground__c pg : playgrounds) {
            contactIds.add(pg.Contact__c);
        }

        if (!contactIds.isEmpty()) {
            for (User u : [Select Id, ContactId From User Where ContactId IN :contactIds]) {
                contactAndUserIdMap.put(u.ContactId, u.Id);
            }

            for (Playground__c pg : playgrounds) {
                if (contactAndUserIdMap.containsKey(pg.Contact__c)) {
                    pg.User__c = contactAndUserIdMap.get(pg.Contact__c);
                    playgroundToBeUpdated.add(pg);
                }
            }

            if (!playgroundToBeUpdated.isEmpty()) {
                update playgroundToBeUpdated;
            }

        }
    }

    global void finish(Database.BatchableContext bc) {
    }
}