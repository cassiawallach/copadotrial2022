/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ILTRosterImportUpdateBatch implements Database.Batchable<SObject>, Database.Stateful {
    global Id ILTClassId {
        get;
        set;
    }
    global List<redwing__ILT_Roster__c> listImportRosters {
        get;
        set;
    }
    global Set<Id> userIds {
        get;
        set;
    }
    global ILTRosterImportUpdateBatch(List<redwing__ILT_Roster__c> listImportRosters, String ILTClassId, Set<Id> userIds) {

    }
    global void execute(Database.BatchableContext BC, List<redwing__ILT_Roster__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
