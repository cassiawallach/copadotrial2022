@isTest
public without sharing class cps_InteractiveModule_UtilsTest {

    @testSetup 
    static void methodName() {
        copado.GlobalAPI.UserLicense copadoUserLicense = new copado.GlobalAPI.UserLicense(UserInfo.getUserId(),false,false,false,true,false);
        copado.GlobalAPI gapi = new copado.GlobalAPI();
        gapi.upsertCopadoLicense(UserInfo.getUserId(), copadoUserLicense);


        cps_PlaygroundWizardStartControllerTest.setup();
        User testUser = [select Id from User where Username='demo5645@handomdemodomainz.djw.cmq' limit 1];
        Playground__c thePlaygroundScratchOrg = new Playground__c();
        System.runAs(testUser){
            thePlaygroundScratchOrg = cps_PlaygroundWizardStartController.createPlayground('Test IV Playground Scratch Orgs', 'Full Configuration - Scratch Orgs');
            Test.setCreatedDate(thePlaygroundScratchOrg.Id, Date.today().addDays(-31));
        }

        Id adminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User adminUser = new User(
            Alias = 'myalias', Email = 'testadminemail@emailtest.com',
                EmailEncodingKey = 'UTF-8', LastName = 'TestUser',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = adminProfileId, Country='United States', IsActive =true,
                TimezoneSidKey='America/Los_Angeles', Username='testadminemail@handomdemodomainz.djw.cmq');

        insert adminUser;
        System.runAs(adminUser){
            thePlaygroundScratchOrg.Status__c = 'Activated';
            update thePlaygroundScratchOrg;
        }
    }
    
    static testMethod void unitTests () {
        cps_InteractiveModule_Utils.checkOrgType();

        String payload = '{"hasError":false}';
        cps_InteractiveModule_Utils.parsePayload(payload);

        User testUser = [select Id from User where Username='demo5645@handomdemodomainz.djw.cmq' limit 1];
        System.runAs(testUser){
            List<Playground__c> playgrounds = cps_InteractiveModule_Utils.getPlaygroundRecords();
        	system.assertEquals(1, playgrounds.size());
        }
    }

    static testMethod void testCreateFrontDoorRequest() {
        copado__Org__c o = new copado__Org__c(Name='test');
        insert o;
        
        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', '', new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
        test.startTest();
        cps_InteractiveModule_Utils.createFrontDoorRequest(o.Id, null);
        test.stopTest();
    }
    
    static testMethod void testGetPlaygroundEnv() {
        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', '', new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Playground__c playground = [SELECT Id FROM Playground__c WHERE Name = 'Test IV Playground Scratch Orgs'];
        List<Playground_Enviroment__c> playgroundEnvs = new List<Playground_Enviroment__c>();

        if (playground != null) {
            playgroundEnvs = cps_InteractiveModule_Utils.getPlaygroundEnv(playground.Id);
        }
        
        test.startTest();
        if (!playgroundEnvs.isEmpty()) {
            cps_InteractiveModule_Utils.getFrontDoorUrl(playgroundEnvs[0].Id);
        }
        test.stopTest();
    }
}