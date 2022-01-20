/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchHandler implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global JBCXM.GSGlobalClasses.BatchJobInfo batchInfo;
    global String batchMethodName;
    global Map<String,Object> batchProp {
        get;
        set;
    }
    global Boolean isExecutedFromPostIntsall;
    global Map<String,String> otherParams {
        get;
        set;
    }
    global String queryStr;
    global BatchHandler() {

    }
    global void execute(Database.BatchableContext BC, List<SObject> recordInfo) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
