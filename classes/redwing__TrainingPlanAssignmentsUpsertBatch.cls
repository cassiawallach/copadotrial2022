/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TrainingPlanAssignmentsUpsertBatch implements Database.Batchable<SObject>, Database.Stateful {
    global String communityId;
    global Date dueDate;
    global String tPlanBatchOpId;
    global String trainingplanId;
    global TrainingPlanAssignmentsUpsertBatch(String tplanId, String tpboId) {

    }
    global TrainingPlanAssignmentsUpsertBatch(String tplanId, String tpboId, Id communityId, Date dueDate) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
