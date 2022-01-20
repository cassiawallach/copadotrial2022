global class CertificationExpirationSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CertificationExpirationBatch classObj = new CertificationExpirationBatch(); 
      database.executebatch(classObj);
   }
}