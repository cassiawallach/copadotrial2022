@isTest
private class cps_PlaygroundWizardFinishTest {

    /*
     * Setup for test. Creation of records.
     */
    @testSetup public static void testSetup() {
        cps_PlaygroundWizardStartControllerTest.setup();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        Contact c = new Contact(LastName = 'Test');
        insert c;
        
        User u = new User(Alias = 'standt1',
                          Country='United Kingdom',
                          Email='demo8339@handomdemodomainz.djw.cmq',
                          EmailEncodingKey='UTF-8',
                          LastName='Testing',
                          ProfileId = p.Id,
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US',
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='demo8339@handomdemodomainz.djw.cmq');
        insert u;
        
        copado__Org__c o = new copado__Org__c(
            Name = 'TestOrg',
            copado__SFDC_Org_ID__c = '00Df4000003AqJXEA0_0050N000007nP8CQAU_3',
            copado__Org_Type__c = 'Production/Developer');
        insert o;
        String orgId = o.Id;
        
        Playground__c pg = new Playground__c(Name='Test Playground', Org_Credential__c=orgId, Contact__c=c.Id);
        insert pg;
        String pgId = pg.Id;
        //cps_PlaygroundWizardSetupController.SaveCopadoApiKey(pgId, 'e8284d79c0173d1a5dadd2c7ec3d9a22');
        
        Playground_Job__c pgJob = new Playground_Job__c(Name='Playground Job Test', JobId__c='818bcb93-1ac9-4d36-8261-eb83030fe75c', Playground__c=pgId);
        insert pgJob;
        String pgJobId = pgJob.Id;
        String copadoJobId = pgJob.JobId__c;
        
        Playground_Enviroment__c pgEnv = new Playground_Enviroment__c(Name='Playground Environment Test', Type__c='CoE_Org', Playground__c=pgId, Org_Credential__c=orgId, Org_Id__c='00D20000000m7c0EAA');
        insert pgEnv;

        sfLma__License__c license = new sfLma__License__c();
        license.sfLma__Status__c='Active';
        license.sfLma__Subscriber_Org_ID__c='00D20000000m7c0EAA';
        license.sfLma__Used_Licenses__c = 1;
        license.sfLma__Seats__c = -1;	         
        license.sfLma__Install_Date__c = system.today();
        license.sfLma__License_Type__c = 'Editable';
        license.sfLma__Package_License_ID__c = 'some package id';
        insert license;
    }
    
    @isTest static void testActivatePlayground() {
        List<Playground__c> pglist = [SELECT Id FROM Playground__c WHERE Name = 'Test Playground'];
        Id pgId = pglist[0].Id;
        
        Test.startTest();
            cps_PlaygroundWizardFinishController.ActivatePlayground(pgId);
            Playground__c pg = [SELECT Status__c, Stage__c FROM Playground__c WHERE Id =: pgId LIMIT 1];
            System.assertEquals(pg.Status__c, 'Activated');
            System.assertEquals(pg.Stage__c, 'Completed');
        Test.stopTest();
    }
    
    @isTest static void testDeletePlayground() {
        List<Playground__c> pglist = [SELECT Id FROM Playground__c WHERE Name = 'Test Playground'];
        Id pgId = pglist[0].Id;
        String errorMsg = '';
        
        Test.startTest();
            cps_PlaygroundWizardFinishController.DeletePlayground(pgId);
            try {
                Playground__c pg = [SELECT Id FROM Playground__c WHERE Id =: pgId LIMIT 1];
            } catch (Exception e) {
                errorMsg = e.getMessage();
            }
            System.assertEquals(errorMsg, 'List has no rows for assignment to SObject');
        Test.stopTest();
    }
    
    
}