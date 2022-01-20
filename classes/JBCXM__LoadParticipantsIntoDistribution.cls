/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LoadParticipantsIntoDistribution implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global Map<String,String> configMap;
    global Boolean isCustomObject;
    global Boolean isRoleFromContact;
    global Integer participantsCount;
    global String queryStr;
    global String relType;
    global String roleField;
    global String surveyId;
    global LoadParticipantsIntoDistribution(String q, Map<String,String> omc, String sid, String rlName, Boolean isRoleFromCon, Boolean isCustObj) {

    }
    global LoadParticipantsIntoDistribution(String q, Map<String,String> omc, String sid, String rlName, Boolean isRoleFromCon, Boolean isCustObj, String relTypeId) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> recordInfo) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
