global class AcademyCertificateExpireScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        AcademyCertificateExpireBatch batchCtrl = new AcademyCertificateExpireBatch(); 
        Id BatchId = database.executebatch(batchCtrl);        
    }
}