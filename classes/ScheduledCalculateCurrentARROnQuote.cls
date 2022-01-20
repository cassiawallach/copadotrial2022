global class ScheduledCalculateCurrentARROnQuote implements Schedulable {
   global void execute(SchedulableContext sc) {
     System.enqueueJob(new CalculateCurrentARROnQuote());
   }
}