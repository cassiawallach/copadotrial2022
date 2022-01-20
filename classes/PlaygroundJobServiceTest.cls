@isTest
public class PlaygroundJobServiceTest {

    /*
     * Setup for test. Creation of records.
     */
    @testSetup public static void testSetup() {
        cps_PlaygroundWizardStartControllerTest.setup();
        User testUser = [select Id from User where Username='demo5645@handomdemodomainz.djw.cmq' limit 1];
        System.runAs(testUser){
            Playground__c thePlayground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
            Playground__c thePlaygroundScratchOrg = cps_PlaygroundWizardStartController.createPlayground('Test Playground Scratch Orgs', 'Full Configuration - Scratch Orgs');
        }
    }

    static testMethod void action_StatusSetCompleted() {
        copado__Org__c testOrg = new copado__Org__c(Name='TestOrgCred', copado__Org_Type__c='CoE_Org', copado__SFDC_Org_ID__c='00D4T000000EzmsUAC_005b0000000dr2PAAQ');
        insert testOrg;

        User testUser = [select username,email, contactid from User where Username='demo5645@handomdemodomainz.djw.cmq' limit 1];
        Signup_Request__c sr = new Signup_Request__c();
		sr.First_Name__c = 'John';
		sr.Last_Name__c = 'Doe';
        sr.Company__c = 'Copado, Inc.';
        sr.Email__C = testuser.email;
        sr.contact__c = testuser.contactid;
        sr.username__c = testuser.username;
		sr.Country__c = 'US';
        sr.Created_Org_Id__c = '00D00000d3d3D12';
        sr.Template__c = '0TT1i00000269iK';
		insert sr;

        String action = 'ExecutePostInstallScript';
        Playground__c pg = [select Id from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'ApexSystemTest';
        pg.Org_Credential__c = testOrg.Id;
        pg.Custom_Signup_Request__c = sr.ID;
        update pg;
        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);

        List<Playground_Enviroment__c> pges = [select Id, Org_Id__c from Playground_Enviroment__c where PLayground__c=:pg.Id];
        Integer i=0;
        for(Playground_Enviroment__c pge : pges) {
            pge.Org_Id__c = '00D'+i+'T000000EzmsUAC';
            i++;
        }
        update pges;

        LicenseHelper.webServiceResult wsr = new LicenseHelper.webServiceResult();
        wsr.isSuccess = true;
        wsr.status = 201;

        cps_C1PJobMock mock = new cps_C1PJobMock(201, 'OK', JSON.serialize(wsr), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        playgroundJob.Payload__c = '{"action":"'+action+'","hasError":false,"data":{"message":"success"}}';
        update playgroundJob;
        Test.stopTest();

        Playground_Job__c result = getPlaygroundJob(pg.Id, action);
        system.assertEquals('Completed', result.Status__c);
    }

    static testMethod void action_GitSetup() {
        String action = 'GitSetup';
        Playground__c pg = [select Id from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        update pg;
        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);

        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        playgroundJob.Payload__c = '{"action":"'+action+'","hasError":false,"data":{"username":"gitUser", "token":"myToken"}}';
        update playgroundJob;
        Test.stopTest();

        Playground__c result = getPlayground(pg.Id);
        system.assertEquals('gitUser', result.Git_Username__c);
        system.assertEquals('myToken', cps_Crypto.decryptString(result.Git_Token__c));

        Playground_Job__c result2 = getPlaygroundJob(pg.Id, action);
        system.assertEquals(null, result2.Payload__c);
        system.assertEquals('continue=true', result2.Output__c);
    }

    static testMethod void action_GitSetup_fail() {
        String action = 'GitSetup';
        Playground__c pg = [select Id from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        update pg;
        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);

        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        playgroundJob.Payload__c = '{"action":"GitSetup","hasError":true,"data":{"message":"Repository creation failed.","errors":[{"resource":"Repository","code":"custom","field":"name","message":"name already exists on this account"}],"documentation_url":"https://developer.github.com/v3/repos/#create"}}';
        update playgroundJob;
        Test.stopTest();

        Playground_Job__c result = getPlaygroundJob(pg.Id, action);
        system.assertEquals('Failed', result.Status__c);
        system.assertEquals('DUPLICATE_GIT_REPOSITORY', result.Output__c);
    }

    static testMethod void action_FinishingTouch_Success() {
        String action = 'AddingFinishingTouches';
        Playground__c pg = [select Id, Git_Token__c, Git_Username__c from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'gitUser';
        update pg;

        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);

        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        playgroundJob.Payload__c = '{"installVSMInstallation":{"action":"installVSM","hasError":false,"data":"The VSM package has been successfully installed"},"enableUser":{"action":"EnableUser","hasError":false,"data":{"executionResponse":{"line":-1,"column":-1,"compiled":true,"success":true,"compileProblem":null,"exceptionStackTrace":null,"exceptionMessage":null},"success":true,"user_api_key":"fb4ed18f18411f5a76f79d91801f7790"}},"gitRepoFinalSetup":{"action":"GitSetupFinish","passDuplicated":false,"hasError":false,"data":{"commitHash":"2348218e2f7b78b0cdb0114104037dc591a38df4"}},"createGitSnapshot":{"action":"CreateGitSnapshot","hasError":false,"data":{"commitHash":"57c775ead13820aa73f309aa5d656386959f7ce8"}},"createBranches":{"action":"CreateBranches","hasError":false,"data":{"results":[{"ok":"Webhook accepted","copadoJobId":"7336b242-3d74-421c-8469-4afcf40f9061","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2cd3d5e4-c8c5-49f8-801b-1b40d2e56938","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"237514c3-9b05-4afb-a6fa-47b648545b86","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"ba314373-e0c5-4a17-b137-82350b2e884b","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2b336df8-3735-4216-9ef1-5a3a274a821c","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"cfb1ecf6-8054-4d1e-9b8d-c17387d899b9","status":"Queued","isFinished":false}]}},"createBoilerplate":{"data":{"status":"pending"},"hasError":false}}';
        update playgroundJob;
        Test.stopTest();

        Playground__c result = getPlayground(pg.Id);
        system.assertEquals('fb4ed18f18411f5a76f79d91801f7790', cps_Crypto.decryptString(result.Api_Key__c));
    }

    static testMethod void action_FinishingTouch_Fail1() {
        String action = 'AddingFinishingTouches';
        Playground__c pg = [select Id, Git_Token__c, Git_Username__c from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'gitUser';
        update pg;

        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);
        system.debug('#### '+playgroundJob);

        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        playgroundJob.Payload__c = '{"installVSMInstallation":"","enableUser":{"action":"EnableUser","hasError":false,"data":{"executionResponse":{"line":-1,"column":-1,"compiled":true,"success":true,"compileProblem":null,"exceptionStackTrace":null,"exceptionMessage":null},"success":true,"user_api_key":"fb4ed18f18411f5a76f79d91801f7790"}},"gitRepoFinalSetup":{"action":"GitSetupFinish","passDuplicated":false,"hasError":false,"data":{"commitHash":"2348218e2f7b78b0cdb0114104037dc591a38df4"}},"createGitSnapshot":{"action":"CreateGitSnapshot","hasError":false,"data":{"commitHash":"57c775ead13820aa73f309aa5d656386959f7ce8"}},"createBranches":{"action":"CreateBranches","hasError":false,"data":{"results":[{"ok":"Webhook accepted","copadoJobId":"7336b242-3d74-421c-8469-4afcf40f9061","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2cd3d5e4-c8c5-49f8-801b-1b40d2e56938","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"237514c3-9b05-4afb-a6fa-47b648545b86","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"ba314373-e0c5-4a17-b137-82350b2e884b","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2b336df8-3735-4216-9ef1-5a3a274a821c","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"cfb1ecf6-8054-4d1e-9b8d-c17387d899b9","status":"Queued","isFinished":false}]}},"createBoilerplate":{"data":{"status":"pending"},"hasError":false}}';
        update playgroundJob;
        Test.stopTest();

        Playground__c result = getPlayground(pg.Id);
        system.assertEquals('fb4ed18f18411f5a76f79d91801f7790', cps_Crypto.decryptString(result.Api_Key__c));
    }

    static testMethod void action_FinishingTouch_Fail2() {
        String action = 'AddingFinishingTouches';
        Playground__c pg = [select Id, Git_Token__c, Git_Username__c from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'gitUser';
        update pg;

        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);
        system.debug('#### '+playgroundJob);

        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        playgroundJob.Payload__c = '{"installVSMInstallation":{"action":"installVSM","hasError":false,"data":"The VSM package has been successfully installed"},"enableUser":"","gitRepoFinalSetup":{"action":"GitSetupFinish","passDuplicated":false,"hasError":false,"data":{"commitHash":"2348218e2f7b78b0cdb0114104037dc591a38df4"}},"createGitSnapshot":{"action":"CreateGitSnapshot","hasError":false,"data":{"commitHash":"57c775ead13820aa73f309aa5d656386959f7ce8"}},"createBranches":{"action":"CreateBranches","hasError":false,"data":{"results":[{"ok":"Webhook accepted","copadoJobId":"7336b242-3d74-421c-8469-4afcf40f9061","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2cd3d5e4-c8c5-49f8-801b-1b40d2e56938","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"237514c3-9b05-4afb-a6fa-47b648545b86","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"ba314373-e0c5-4a17-b137-82350b2e884b","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2b336df8-3735-4216-9ef1-5a3a274a821c","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"cfb1ecf6-8054-4d1e-9b8d-c17387d899b9","status":"Queued","isFinished":false}]}},"createBoilerplate":{"data":{"status":"pending"},"hasError":false}}';
        update playgroundJob;
        Test.stopTest();
    }

    static testMethod void action_FinishingTouch_Fail3() {
        String action = 'AddingFinishingTouches';
        Playground__c pg = [select Id, Git_Token__c, Git_Username__c from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'gitUser';
        update pg;

        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);
        system.debug('#### '+playgroundJob);

        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        playgroundJob.Payload__c = '{"installVSMInstallation":{"action":"installVSM","hasError":false,"data":"The VSM package has been successfully installed"},"enableUser":{"action":"EnableUser","hasError":false,"data":{"executionResponse":{"line":-1,"column":-1,"compiled":true,"success":true,"compileProblem":null,"exceptionStackTrace":null,"exceptionMessage":null},"success":true,"user_api_key":"fb4ed18f18411f5a76f79d91801f7790"}},"gitRepoFinalSetup":"","createGitSnapshot":{"action":"CreateGitSnapshot","hasError":false,"data":{"commitHash":"57c775ead13820aa73f309aa5d656386959f7ce8"}},"createBranches":{"action":"CreateBranches","hasError":false,"data":{"results":[{"ok":"Webhook accepted","copadoJobId":"7336b242-3d74-421c-8469-4afcf40f9061","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2cd3d5e4-c8c5-49f8-801b-1b40d2e56938","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"237514c3-9b05-4afb-a6fa-47b648545b86","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"ba314373-e0c5-4a17-b137-82350b2e884b","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2b336df8-3735-4216-9ef1-5a3a274a821c","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"cfb1ecf6-8054-4d1e-9b8d-c17387d899b9","status":"Queued","isFinished":false}]}},"createBoilerplate":{"data":{"status":"pending"},"hasError":false}}';
        update playgroundJob;
        Test.stopTest();

        Playground__c result = getPlayground(pg.Id);
        system.assertEquals('fb4ed18f18411f5a76f79d91801f7790', cps_Crypto.decryptString(result.Api_Key__c));
    }

    static testMethod void action_FinishingTouch_Fail4() {
        String action = 'AddingFinishingTouches';
        Playground__c pg = [select Id, Git_Token__c, Git_Username__c from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'gitUser';
        update pg;

        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);
        system.debug('#### '+playgroundJob);

        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        playgroundJob.Payload__c = '{"installVSMInstallation":{"action":"installVSM","hasError":false,"data":"The VSM package has been successfully installed"},"enableUser":{"action":"EnableUser","hasError":false,"data":{"executionResponse":{"line":-1,"column":-1,"compiled":true,"success":true,"compileProblem":null,"exceptionStackTrace":null,"exceptionMessage":null},"success":true,"user_api_key":"fb4ed18f18411f5a76f79d91801f7790"}},"gitRepoFinalSetup":{"action":"GitSetupFinish","passDuplicated":false,"hasError":false,"data":{"commitHash":"2348218e2f7b78b0cdb0114104037dc591a38df4"}},"createGitSnapshot":"","createBranches":{"action":"CreateBranches","hasError":false,"data":{"results":[{"ok":"Webhook accepted","copadoJobId":"7336b242-3d74-421c-8469-4afcf40f9061","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2cd3d5e4-c8c5-49f8-801b-1b40d2e56938","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"237514c3-9b05-4afb-a6fa-47b648545b86","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"ba314373-e0c5-4a17-b137-82350b2e884b","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2b336df8-3735-4216-9ef1-5a3a274a821c","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"cfb1ecf6-8054-4d1e-9b8d-c17387d899b9","status":"Queued","isFinished":false}]}},"createBoilerplate":{"data":{"status":"pending"},"hasError":false}}';
        update playgroundJob;
        Test.stopTest();

        Playground__c result = getPlayground(pg.Id);
        system.assertEquals('fb4ed18f18411f5a76f79d91801f7790', cps_Crypto.decryptString(result.Api_Key__c));
    }

    static testMethod void action_FinishingTouch_Fail5() {
        String action = 'AddingFinishingTouches';
        Playground__c pg = [select Id, Git_Token__c, Git_Username__c from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'gitUser';
        update pg;

        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);
        system.debug('#### '+playgroundJob);

        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        playgroundJob.Payload__c = '{"installVSMInstallation":{"action":"installVSM","hasError":false,"data":"The VSM package has been successfully installed"},"enableUser":{"action":"EnableUser","hasError":false,"data":{"executionResponse":{"line":-1,"column":-1,"compiled":true,"success":true,"compileProblem":null,"exceptionStackTrace":null,"exceptionMessage":null},"success":true,"user_api_key":"fb4ed18f18411f5a76f79d91801f7790"}},"gitRepoFinalSetup":{"action":"GitSetupFinish","passDuplicated":false,"hasError":false,"data":{"commitHash":"2348218e2f7b78b0cdb0114104037dc591a38df4"}},"createGitSnapshot":{"action":"CreateGitSnapshot","hasError":false,"data":{"commitHash":"57c775ead13820aa73f309aa5d656386959f7ce8"}},"createBranches":"","createBoilerplate":{"data":{"status":"pending"},"hasError":false}}';
        update playgroundJob;
        Test.stopTest();

        Playground__c result = getPlayground(pg.Id);
        system.assertEquals('fb4ed18f18411f5a76f79d91801f7790', cps_Crypto.decryptString(result.Api_Key__c));
    }

    static testMethod void action_FinishingTouch_Fail6() {
        String action = 'AddingFinishingTouches';
        Playground__c pg = [select Id, Git_Token__c, Git_Username__c from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'gitUser';
        update pg;

        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);
        system.debug('#### '+playgroundJob);

        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        playgroundJob.Payload__c = '{"installVSMInstallation":{"action":"installVSM","hasError":false,"data":"The VSM package has been successfully installed"},"enableUser":{"action":"EnableUser","hasError":false,"data":{"executionResponse":{"line":-1,"column":-1,"compiled":true,"success":true,"compileProblem":null,"exceptionStackTrace":null,"exceptionMessage":null},"success":true,"user_api_key":"fb4ed18f18411f5a76f79d91801f7790"}},"gitRepoFinalSetup":{"action":"GitSetupFinish","passDuplicated":false,"hasError":false,"data":{"commitHash":"2348218e2f7b78b0cdb0114104037dc591a38df4"}},"createGitSnapshot":{"action":"CreateGitSnapshot","hasError":false,"data":{"commitHash":"57c775ead13820aa73f309aa5d656386959f7ce8"}},"createBranches":{"action":"CreateBranches","hasError":false,"data":{"results":[{"ok":"Webhook accepted","copadoJobId":"7336b242-3d74-421c-8469-4afcf40f9061","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2cd3d5e4-c8c5-49f8-801b-1b40d2e56938","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"237514c3-9b05-4afb-a6fa-47b648545b86","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"ba314373-e0c5-4a17-b137-82350b2e884b","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"2b336df8-3735-4216-9ef1-5a3a274a821c","status":"Queued","isFinished":false},{"ok":"Webhook accepted","copadoJobId":"cfb1ecf6-8054-4d1e-9b8d-c17387d899b9","status":"Queued","isFinished":false}]}},"createBoilerplate":""}';
        update playgroundJob;
        Test.stopTest();

        Playground__c result = getPlayground(pg.Id);
        system.assertEquals('fb4ed18f18411f5a76f79d91801f7790', cps_Crypto.decryptString(result.Api_Key__c));
    }

    static testMethod void action_CreateScratchOrgEnvironment_Success() {
        String action = 'CreateScratchOrgEnvironment';
        Playground__c pg = [select Id, Git_Token__c, Git_Username__c from Playground__c where Name='Test Playground Scratch Orgs'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'ApexSystemTest';
        update pg;
        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);
		Test.startTest();
        playgroundJob.Payload__c = '{"Dev1":{"action":"CreateScratchOrgEnvironment","hasError":false,"data":{"status":0,"result":{"username":"akumar-avkdev35@force.com.dev1","id":"00D1D00000070fdUAA","expirationDate":"2021-03-06","connectedStatus":"Connected","accessToken":"00D1D00000070fd!AQsAQH1UvQ_1DDhju7vybm8kB.dzGIsX_urk.BiH7MMIwarUL7PEsljSDfQGleHhShaBgpE1OULntahf5O3tpZ5drCSPrGnb","instanceUrl":"https://efficiency-data-6753.cs68.my.salesforce.com/","clientId":"PlatformCLI","alias":"Dev1"}}},"UAT":{"action":"CreateScratchOrgEnvironment","hasError":false,"data":{"status":0,"result":{"username":"akumar-avkdev35@force.com.uat","id":"00D17000000PeewEAC","expirationDate":"2021-03-06","connectedStatus":"Connected","accessToken":"00D17000000Peew!AREAQL0tBhVJa9BHJngDdl4nIxHvziUDnb6.AHksmAroOhgN7PsdR3v4iiaekCS8N1EfU7jrDuzfXTmfpN39GyO2ylibYBFB","instanceUrl":"https://drive-force-5512.cs22.my.salesforce.com/","clientId":"PlatformCLI","alias":"UAT"}}},"Hotfix":{"action":"CreateScratchOrgEnvironment","hasError":false,"data":{"status":0,"result":{"username":"akumar-avkdev35@force.com.hotfix","id":"00D1100000C7UYREA3","expirationDate":"2021-03-06","connectedStatus":"Connected","accessToken":"00D1100000C7UYR!ARIAQAggwdbi_JX2ovoaDU42kty2i8Kd4i8o8b2AXfs5F0qbEnm9dja8vbZXHeTR2K6Aqes.hTenfL489eV18R4JfjW4SRH_","instanceUrl":"https://page-agility-607.cs18.my.salesforce.com/","clientId":"PlatformCLI","alias":"Hotfix"}}},"Production":{"action":"CreateScratchOrgEnvironment","hasError":false,"data":{"status":0,"result":{"username":"akumar-avkdev35@force.com.production","id":"00D1F000000MryUUAS","expirationDate":"2021-03-06","connectedStatus":"Connected","accessToken":"00D1F000000MryU!AR4AQObgkTpAkvWMFtwlyJEN2BWDikqw.tIMoZilk3e5jOqhVVeeKs._EL4ouoAzGQB7C0grC9JrRigFD4Cmaok6n5BMN6wy","instanceUrl":"https://java-flow-46052.cs90.my.salesforce.com/","clientId":"PlatformCLI","alias":"Production"}}},"Dev2":{"action":"CreateScratchOrgEnvironment","hasError":false,"data":{"status":0,"result":{"username":"akumar-avkdev35@force.com.dev2","id":"00D1F000000MryPUAS","expirationDate":"2021-03-06","connectedStatus":"Connected","accessToken":"00D1F000000MryP!AR0AQJlzAH6Jpp5y5UC3ifi2s9_gRwTQ.aIN5VI6OXhI.COUCqYtUNe2Ku.BFDffRBELTLkqdt_g.8ASO6rr7wqD5T8E0X0X","instanceUrl":"https://java-data-7913.cs90.my.salesforce.com/","clientId":"PlatformCLI","alias":"Dev2"}}}}';
        update playgroundJob;
        Test.stopTest();
        
        List<Playground_Enviroment__c> result = getPLaygroundEnvironments(pg.Id);
        for(Playground_Enviroment__c pe : result) {
            if(pe.Name != 'Copado')
            system.assertNotEquals(null, pe.InstanceUrl__c);
        }
    }

    static testMethod void action_CreateEnvironment() {
        String action = 'CreateEnvironment';
        Playground__c pg = [select Id, Git_Token__c, Git_Username__c from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'ApexSystemTest';
        update pg;
        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);
		Test.startTest();
        playgroundJob.Payload__c = '{"action":"CreateEnvironment","hasError": true,"data": {"name":"StatusCodeError", "statusCode": 400, "message":"400 - [{\"message\":\"\\nSandboxInfoId,Status,SandboxName FROM SandboxProcess WHERE SandboxName=\'Production\'\\n ^\\nERROR at Row:1:Column:46\\nsObject type \'SandboxProcess\' is not supported. If you are attempting to use a custom object, be sure to append the \'__c\' after the entity name. Please reference your WSDL or the describe call for the appropriate names.\",\"errorCode\":\"INVALID_TYPE\"}]", "error": [{ "message":"\nSandboxInfoId,Status,SandboxName FROM SandboxProcess WHERE SandboxName=\'Production\'\n ^\nERROR at Row:1:Column:46\nsObject type \'SandboxProcess\' is not supported. If you are attempting to use a custom object, be sure to append the \'__c\' after the entity name. Please reference your WSDL or the describe call for the appropriate names.", "errorCode":"INVALID_TYPE" }]}}';
        update playgroundJob;
        Test.stopTest();
        Playground_Job__c result = getPlaygroundJob(pg.Id, action);
        system.assertEquals('Failed', result.Status__c);
        system.assertEquals('SANDBOXES_NOT_SUPPORTED_FOR_ORG', result.Output__c);
    }

    static testMethod void action_CreateEnvironment_Success() {
        String action = 'CreateEnvironment';
        Playground__c pg = [select Id, Git_Token__c, Git_Username__c from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'ApexSystemTest';
        update pg;
        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);
		Test.startTest();
        playgroundJob.Payload__c = '{"Hotfix":{"action":"CreateEnvironment","hasError":false,"data":null},"UAT":{"action":"CreateEnvironment","hasError":false,"data":null},"Dev1":{"action":"CreateEnvironment","hasError":false,"data":null},"Production":{"action":"CreateEnvironment","hasError":false,"data":null},"Dev2":{"action":"CreateEnvironment","hasError":false,"data":null}}';
        update playgroundJob;
        Test.stopTest();
        Playground_Job__c result = getPlaygroundJob(pg.Id, action);
        system.assertEquals('Completed', result.Status__c);
    }

    static testMethod void action_CreateOrgCredentials() {
        String action = 'CreateOrgCredentials';
        Playground__c pg = [select Id from Playground__c where Name='Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'ApexSystemTest';
        update pg;
        Playground_Job__c playgroundJob = getPlaygroundJob(pg.Id, action);

        Test.startTest();
        playgroundJob.Payload__c = '{"action":"'+action+'","hasError":false,"data":{"Copado":"url=Copado","Production":"url=Production","Hotfix":"url=Hotfix","UAT":"url=UAT","Dev1":"url=Dev1","Dev2":"url=Dev2"}}';
        update playgroundJob;
        Test.stopTest();

        List<Playground_Enviroment__c> result = getPLaygroundEnvironments(pg.Id);
        for(Playground_Enviroment__c pe : result) {
            system.assertEquals('Created', pe.Status__c);
            system.assertEquals('url='+pe.Name, pe.Authorization_URL__c);
        }
    }

    private static Playground_Job__c getPlaygroundJob(Id playgroundId, String action) {
        return [select Id, Name, Payload__c, Status__c, Action__c, JobId__c, Platform_Job_Execution__c, Output__c, Remaining_Retry_Attempts__c from Playground_Job__c where Playground__c=:playgroundId and Action__c=:action Limit 1];
    }

    private static Playground__c getPlayground(Id recordId) {
        return [select Id, Name, Status__c, Stage__c, Git_Username__c, Git_Token__c, Commit_Hash__c, Api_Key__c from Playground__c where Id=:recordId limit 1];
    }

    private static List<Playground_Enviroment__c> getPLaygroundEnvironments(Id playgroundId) {
        return [select Id, Name, Authorization_URL__c, Status__c, Access_Token__c, InstanceUrl__c from Playground_Enviroment__c where Playground__c=:playgroundId];
    }

    private static String createSuccessResponseString() {
        String responseString = '{"isSuccess":"'+true+'", "copadoJobId":"430c0e95-4771-4c66-9b42-d1eb277186b5"}';
        return responseString;
    }
}