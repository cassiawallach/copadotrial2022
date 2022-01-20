global class CertificationResetSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      GenericCertificationReset classObj = new GenericCertificationReset(); 
     // database.executebatch(classObj);
   }
}