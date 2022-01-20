/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TrainingPlanAssignmentsDeleteBatch implements Database.Batchable<SObject>, Database.Stateful {
    global Set<Id> tPlanAssignmentIds;
    global String tPlanBatchOpId;
    global String trainingplanId;
    global static Map<String,Map<Id,Set<String>>> vILTProvidersParamsMapStatic;
    global TrainingPlanAssignmentsDeleteBatch(Set<Id> tPlanAssignmentIds, String tpboId) {

    }
    global TrainingPlanAssignmentsDeleteBatch(String tplanId, String tpboId) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
