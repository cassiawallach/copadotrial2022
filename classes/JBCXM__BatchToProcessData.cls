/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchToProcessData implements Database.Batchable<Object>, Database.Stateful {
    global String actionType;
    global String areaName;
    global Map<String,Object> cachedData;
    global List<Object> dataSetToProcess;
    global Boolean isExecutedFromPostIntsall;
    global Map<String,Object> otherParams;
    global static Map<String,Object> result;
    global BatchToProcessData(List<Object> dataSet) {

    }
    global void execute(Database.BatchableContext BC, List<Object> recordInfo) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global System.Iterable start(Database.BatchableContext BC) {
        return null;
    }
global class CollectionSetIterable implements System.Iterable<Object> {
    global List<Object> iterableRS;
    global CollectionSetIterable(List<Object> dataSet) {

    }
    global System.Iterator Iterator() {
        return null;
    }
}
global class CollectionSetIterator implements System.Iterator<Object> {
    global Integer indx;
    global List<Object> irs;
    global CollectionSetIterator(List<Object> dataSet) {

    }
    global Boolean hasNext() {
        return null;
    }
    global Object next() {
        return null;
    }
}
}
