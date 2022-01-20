public with sharing class ExpiredPlaygroundsSchedulable implements Schedulable {
    public void execute(SchedulableContext sc) {
        ExpiredPlaygroundsBatch expiredPlaygrounds = new ExpiredPlaygroundsBatch();
        database.executebatch(expiredPlaygrounds, 200);
    }
}