global class AccountACVPopuplateScheduller implements Schedulable {
    global void execute(SchedulableContext sc) {
        AccountACVPopuplateBatch batchCtrl = new AccountACVPopuplateBatch(); 
        Id BatchId = database.executebatch(batchCtrl);        
    }
}