//This schedule class schedule our UpdateCaseBatch Class in every 5min
global with sharing class UpdateCaseBatchScheduleClass implements Schedulable {
    global void execute(SchedulableContext sc) {
        ID BatchId = Database.executeBatch(new UpdateCaseBatch(), 200);
    }
}