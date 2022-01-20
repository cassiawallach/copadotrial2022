/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchToExport implements Database.Batchable<SObject>, Database.Stateful {
    global JBCXM.ExportBatchController.BatchToExportProperties btepObj;
    global Document docObj;
    global Map<String,String> docObjListMap;
    global BatchToExport() {

    }
    global void execute(Database.BatchableContext BC, List<SObject> recordInfo) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
