@isTest
public inherited sharing class cps_DeleteOlderPlaygroundBatchTest {

    @testSetup public static void testSetup() {
        cps_PlaygroundWizardStartControllerTest.setup();
        User testUser = [select Id from User where Username='demo5645@handomdemodomainz.djw.cmq' limit 1];
        System.runAs(testUser){
            Playground__c thePlaygroundScratchOrg = cps_PlaygroundWizardStartController.createPlayground('Test Playground Scratch Orgs', 'Full Configuration - Scratch Orgs');
            Test.setCreatedDate(thePlaygroundScratchOrg.Id, Date.today().addDays(-31));
        }
    }
    static testMethod void testDeletePlaygroundSchedule() {
        Test.StartTest();
        cps_DeleteOlderPlaygroundBatch sJob = new cps_DeleteOlderPlaygroundBatch();
        String sch = '0 0 23 * * ?';
        Id jobId = system.schedule('Test Delete Playground', sch, sJob);
        System.assertNotEquals(null, jobId);
        Test.stopTest(); 
    }
}