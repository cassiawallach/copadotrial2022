/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SendGiftUtilityBatch implements Database.AllowsCallouts, Database.Batchable<SObject> {
    global Id accountId;
    global Id campaignId;
    global Id caseId;
    global Id contactId;
    global Id leadId;
    global Id OpportunityId;
    global String templateName;
    global SendGiftUtilityBatch(Id ldId, Id campId, String tempName) {

    }
    global SendGiftUtilityBatch(Id conId, Id campId, String tempName, Id accId, Id oppId, Id csId) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
