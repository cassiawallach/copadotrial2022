/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AdoptionAggregation implements Database.Batchable<SObject> {
    global List<JBCXM.Util.AdoptionAggregationColumnsInfo> adoptionAggregationCols;
    global String adoptionAggregationType;
    global String adpGranularity;
    global Map<String,Object> extraParameters;
    global Map<String,Object> fieldDetailsByObject;
    global Map<String,Object> getUsageIndicatorMap;
    global Set<String> periodSet;
    global Integer precedingPeriods;
    global String queryStr;
    global Integer selMonth;
    global Date selWeekLabel;
    global Integer selYear;
    global String title;
    global AdoptionAggregation(String q, String adpAggCols, String adpAggType, Integer month, Integer year) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> recordInfo) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
