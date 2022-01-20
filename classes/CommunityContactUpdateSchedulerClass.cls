global class CommunityContactUpdateSchedulerClass implements Schedulable {
    global void execute(SchedulableContext sc) {
        CommunityUserContactUpdateHandler batchCtrl = new CommunityUserContactUpdateHandler(); 
        Id BatchId = database.executebatch(batchCtrl);        
    }
}