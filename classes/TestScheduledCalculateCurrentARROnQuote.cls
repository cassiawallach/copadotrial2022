@isTest
public class TestScheduledCalculateCurrentARROnQuote {
    public static testmethod void test1(){
        Test.startTest();      
        // This test runs a scheduled job at 12 AM daily
        String CRON_EXP = '0 0 0 ? * * *';
        // Schedule the test job
        String jobId = System.schedule('TestScheduledCalculateCurrentARROnQuote', CRON_EXP, new ScheduledCalculateCurrentARROnQuote());
        Test.stopTest();        
    }
}