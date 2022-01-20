global with sharing class BatchSettingDataMoveContactToUser implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('Select Id, Allowed_Playgrounds__c, Is_Playgrounds_Test_User__c, Contact.Allowed_Playgrounds__c, Contact.Is_Playgrounds_Test_User__c From User Where ContactId <> null AND Allowed_Playgrounds__c = null'+(Test.isRunningTest()?' LIMIT 1':''));
    }

    global void execute(Database.BatchableContext bc, List<User> users) {
        List<User> usersToBeUpdated = new List<User>();

        for (User u : users) {
            u.Allowed_Playgrounds__c = u.Contact.Allowed_Playgrounds__c;
            u.Is_Playgrounds_Test_User__c = u.Contact.Is_Playgrounds_Test_User__c;
            usersToBeUpdated.add(u);
        }

        if (!usersToBeUpdated.isEmpty()) {
            update usersToBeUpdated;
        }
    }

    global void finish(Database.BatchableContext bc) {
    }
}