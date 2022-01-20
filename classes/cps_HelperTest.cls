@isTest
public class cps_HelperTest {
    /*
     * Setup for test. Creation of records.
     */
    @testSetup
    public static void testSetup() {
        cps_PlaygroundWizardStartControllerTest.setup();

        Id communityProfileId = [SELECT Id FROM Profile WHERE Name = 'CUSTOM Customer Community Login User'].Id;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

        Account account = new Account(Name = 'Test Account 1');
        insert account;

        Contact contact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@copado.com', AccountId = account.Id);
        insert contact;

        User u = new User(
            FirstName = contact.FirstName,
            LastName = contact.LastName,
            Email = contact.Email,
            CompanyName = account.Name,
            ContactId = contact.Id,
            Alias = 'myalias',
            IsActive = true,
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = communityProfileId,
            Country = 'US',
            TimezoneSidKey = 'America/Los_Angeles',
            Username = 'demo9276@handomdemodomainz.djw.cmq'
        );
        insert u;

        copado__Org__c o = new copado__Org__c(
            Name = 'TestOrg',
            copado__SFDC_Org_ID__c = '00Df4000003AqJXEA0_0050N000007nP8CQAU_3',
            copado__Org_Type__c = 'Production/Developer'
        );
        insert o;
        String orgId = o.Id;

        Playground__c pg = new Playground__c(Name = 'Test Playground', Org_Credential__c = orgId, Contact__c = contact.Id);
        insert pg;
        String pgId = pg.Id;
        //cps_PlaygroundWizardSetupController.SaveCopadoApiKey(pgId, 'e8284d79c0173d1a5dadd2c7ec3d9a22');

        List<Playground_Enviroment__c> playgroundEnvs = new List<Playground_Enviroment__c>();
        playgroundEnvs.add(
            new Playground_Enviroment__c(Name = 'Copado', Playground__c = pg.Id, Type__c = 'CoE_Org', Org_Id__c = '00Df4000003AqJXEA0')
        );

        Id defaultRecType = Schema.SObjectType.Playground_Job__c.getRecordTypeInfosByDeveloperName().get('Job').getRecordTypeId();
        Id c1pRecType = Schema.SObjectType.Playground_Job__c.getRecordTypeInfosByDeveloperName().get('C1P_Job').getRecordTypeId();
        Id sandboxCreationRecType = Schema.SObjectType.Playground_Job__c.getRecordTypeInfosByDeveloperName()
            .get('Environment_Creation')
            .getRecordTypeId();

        // Create all the playground jobs
        List<Playground_Job__c> jobsToInsert = new List<Playground_Job__c>();
        jobsToInsert.add(cps_Helper.createPlaygroundJob(1, 'Create Trial Org', 'CreateTrialOrg', pg.Id, defaultRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(10, 'Create Copado Credential', 'CreateCoeCredential', pg.Id, c1pRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(20, 'Log in with Salesforce', 'CoE_Authorization', pg.Id, defaultRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(30, 'Github Setup', 'GitSetup', pg.Id, c1pRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(40, 'Installing Copado', 'ExecutePostInstallScript', pg.Id, c1pRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(50, 'Provisioning Licenses', 'ProvisionLicenses', pg.Id, c1pRecType, null, null)); // Provision APO Licenses
        jobsToInsert.add(cps_Helper.createPlaygroundJob(60, 'Creating Org Credentials', 'CreateOrgCredentials', pg.Id, c1pRecType, null, null));

        jobsToInsert.add(
            cps_Helper.createPlaygroundJob(70, 'Connect to your Trial Org', 'AuthorizeSandbox', pg.Id, sandboxCreationRecType, null, 'Copado')
        );
        jobsToInsert.add(cps_Helper.createPlaygroundJob(90, 'Granting Permissions', 'AssignPermissionSet', pg.Id, c1pRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(130, 'Adding Finishing Touches', 'AddingFinishingTouches', pg.Id, c1pRecType, null, null));

        List<Playground_Sandbox__mdt> plSandboxes = [
            SELECT DeveloperName, Type__c, Order__c
            FROM Playground_Sandbox__mdt
            WHERE Active__c = true
            ORDER BY Order__c ASC
            LIMIT 10000
        ];

        for (Playground_Sandbox__mdt plSandbox : plSandboxes) {
            Integer createOrder = 50 + Integer.valueOf(plSandbox.Order__c);
            Integer authOrder = 70 + Integer.valueOf(plSandbox.Order__c);
            playgroundEnvs.add(new Playground_Enviroment__c(Name = plSandbox.DeveloperName, Playground__c = pg.Id, Type__c = 'Sandbox'));

            String createEnvName = 'Creating ' + plSandbox.DeveloperName + ' Sandbox';
            String authorizeName = 'Connect to your ' + plSandbox.DeveloperName + ' Sandbox';
            jobsToInsert.add(
                cps_Helper.createPlaygroundJob(
                    createOrder,
                    createEnvName,
                    'CreateEnvironment',
                    pg.Id,
                    sandboxCreationRecType,
                    null,
                    plSandbox.DeveloperName
                )
            );
            jobsToInsert.add(
                cps_Helper.createPlaygroundJob(
                    authOrder,
                    authorizeName,
                    'AuthorizeSandbox',
                    pg.Id,
                    sandboxCreationRecType,
                    null,
                    plSandbox.DeveloperName
                )
            );
        }

        try {
            insert jobsToInsert;
            insert playgroundEnvs;
            system.debug('### PlaygroundEnvs: ' + playgroundEnvs);
            system.debug('### PlaygroundEnvs[0]: ' + playgroundEnvs[0]);
        } catch (Exception e) {
            throw e;
        }
    }

    /*
     * Tests for startC1PJob method
     */

    // 1. Correct parameter
    static testMethod void testStartC1PJobGoodParameter() {
        List<copado__Org__c> orgId = [SELECT Id FROM copado__Org__c WHERE Name = 'TestOrg'];

        Map<String, String> paramBody = new Map<String, String>();
        paramBody.put('ACTION', 'CreateGitSnapshot');
        paramBody.put('C1P_ORGCREDENTIALID_CLIENT', orgId[0].Id);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        String res = cps_Helper.startC1PJob(paramBody);
        Test.stopTest();

        System.assertEquals(res, null);
    }

    // 2. Empty parameter Map
    static testMethod void testStartC1PJobEmptyParameters() {
        List<copado__Org__c> orgId = [SELECT Id FROM copado__Org__c WHERE Name = 'TestOrg'];

        Map<String, String> paramBody = new Map<String, String>();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        String res = cps_Helper.startC1PJob(paramBody);
        Test.stopTest();

        System.assertEquals(res, null);
    }

    /*
     * Tests for saveOrgIdFromOrgCredential method
     */

    // 1. Correct Playground Id
    static testMethod void testSaveOrgIdFromOrgCredentialGoodParameter() {
        List<Playground__c> pglist = [SELECT Id FROM Playground__c WHERE Name = 'Test Playground'];
        Id pgId = pglist[0].Id;

        Test.startTest();
        cps_Helper.saveOrgIdFromOrgCredential(pgId);
        Test.stopTest();

        Playground_Enviroment__c env = [SELECT Org_Id__c FROM Playground_Enviroment__c WHERE Type__c = 'CoE_Org' AND Playground__c = :pgId];
        String orgId = env.Org_Id__c;

        system.assertEquals('00Df4000003AqJXEA0', orgId);
    }

    // 2. Incorrect Playground Id
    static testMethod void testSaveOrgIdFromOrgCredentialBadParameter() {
        Id pgId = 'a8W1l001000AgBWEA0';
        String errorMsg = '';

        Test.startTest();
        try {
            cps_Helper.saveOrgIdFromOrgCredential(pgId);
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }
        Test.stopTest();

        system.assertEquals('List has no rows for assignment to SObject', errorMsg);
    }

    /*
     * Tests for getIntegrationUserOrgCredentialId method
     */
    static testMethod void testGetIntegrationUserOrgCredentialBadParameter() {
        Id userId = '005b0001000mjLABAY';
        String errorMsg = '';

        Test.startTest();
        try {
            Id orgCredId = cps_Helper.getIntegrationUserOrgCredentialId(userId);
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }
        Test.stopTest();

        system.assertEquals('List has no rows for assignment to SObject', errorMsg);
    }

    /*
     * Tests for makeRequest method
     */

    // 1. Correct parameters
    static testMethod void testMakeRequestGoodParameters() {
        List<copado__Org__c> orgId = [SELECT Id FROM copado__Org__c WHERE Name = 'TestOrg'];
        String endpoint = 'https://copado.secure.force.com/services/apexrest/CopadoLicenseService/convertLead/' + orgId[0].Id;
        String body = '';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        Integer res = cps_Helper.makeRequest(endpoint, 'e8284d79c0173d1a5dadd2c7ec3d9a22', body);
        Test.stopTest();

        System.assertEquals(200, res);
    }

    // 2. User Id from user who has no Org Credential Id
    static testMethod void testGetIntegrationUserOrgCredentialIdEmptyParameter() {
        Id userId = '0051l001000bTQSAA2';
        String errorMsg = '';

        Test.startTest();
        try {
            Id orgCredId = cps_Helper.getIntegrationUserOrgCredentialId(userId);
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }
        Test.stopTest();

        system.assertEquals('List has no rows for assignment to SObject', errorMsg);
    }

    /*
     * Tests for createPlaygroundJob method
     */

    // 1. Correct parameters
    static testMethod void testCreatePlaygroundJobGoodParameters() {
        List<Playground__c> pglist = [SELECT Id FROM Playground__c WHERE Name = 'Test Playground'];

        Boolean created = false;

        String name = 'User enablement';
        String action = 'EnableUser';
        Id playgroundId = pglist[0].Id;
        Id recordTypeId = '0121l0000008k3aAAA';
        String status = 'In progress';
        String sandboxName = 'Test';

        Test.startTest();
        Playground_Job__c res = cps_Helper.createPlaygroundJob(1, name, action, playgroundId, recordTypeId, status, sandboxName);
        Test.stopTest();

        if (res.Playground__c != null) {
            created = true;
        }

        System.assertEquals(true, created);
    }

    // 2. Inexisting Playground
    static testMethod void testCreatePlaygroundJobNoPlayground() {
        List<Playground__c> pglist = [SELECT Id FROM Playground__c WHERE Name = 'Test Playground'];

        Boolean created = false;

        String name = 'User enablement';
        String action = 'EnableUser';
        Id playgroundId = 'c8N1l000000AgxBBAS';
        Id recordTypeId = '0121l0000008k3aAAA';
        String status = 'In progress';
        String sandboxName = 'Test';

        Test.startTest();
        Playground_Job__c res = cps_Helper.createPlaygroundJob(1, name, action, playgroundId, recordTypeId, status, sandboxName);
        Test.stopTest();

        if (res.Id != null) {
            created = true;
        }

        System.assertEquals(false, created);
    }

    /*
     * Start tests for Process Builder code
     */
    static testMethod void callC1Pactions_CreateCoeCredential() {
        String action = 'CreateCoeCredential';
        User communityUser = [SELECT Id FROM User WHERE Username = 'demo9276@handomdemodomainz.djw.cmq'];
        System.runAs(communityUser) {
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playgroundabc', 'Full Configuration');
            newTrialSignupController.createSignupRequest('billthekid@cowboys.com.copado', 'nullbillthekid20191023837465', 'US', playground.Id);
        }
        Playground__c playground = [
            SELECT
                Id,
                Org_Credential__c,
                Custom_Signup_Request__c,
                Custom_Signup_Request__r.Created_Org_Id__c,
                Custom_Signup_Request__r.Username__c,
                Custom_Signup_Request__r.SF_Signup_Request_ID__c
            FROM Playground__c
            WHERE Name = 'Test Playgroundabc'
            LIMIT 1
        ];

        Signup_Request__c sr = new Signup_Request__c(Id = playground.Custom_Signup_Request__c, Status__c = 'Success');
        update sr;

        Playground_Job__c createOrgCredentialJob = [
            SELECT Id, Status__c
            FROM Playground_Job__c
            WHERE Playground__c = :playground.Id AND Action__c = :action
            LIMIT 1
        ];

        //List<cps_Helper.PlaygroundC1PRequest> reqs = processBuilderJobsSetup(action);

        Test.startTest();
        createOrgCredentialJob.Status__c = 'In progress';
        update createOrgCredentialJob;

        Test.stopTest();
        Playground_Job__c result = getPlaygroundJobById(createOrgCredentialJob.Id);
        //system.assertEquals('Completed', result.Status__c);

        Playground__c pgResult = getPlaygroundById(playground.Id);
        system.assertEquals('billthekid@cowboys.com.copado', pgResult.Org_Credential__r.copado__Username__c);
        system.assert(pgResult.Org_Credential__r.Name.contains('billthekid@cowboys.com.copado'));
    }

    static testMethod void callC1Pactions_InstallCopado() {
        String action = 'ExecutePostInstallScript';
        List<cps_Helper.PlaygroundC1PRequest> reqs = processBuilderJobsSetup(action);
        Test.startTest();
        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        cps_Helper.callC1Pactions(reqs);
        Test.stopTest();
        Playground_Job__c result = getPlaygroundJobById(reqs[0].playgroundJobId);
        system.assert(result.JobId__c != null);
    }

    static testMethod void callC1Pactions_AssignPermissionSet() {
        String action = 'AssignPermissionSet';
        List<cps_Helper.PlaygroundC1PRequest> reqs = processBuilderJobsSetup(action);
        Test.startTest();
        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        cps_Helper.callC1Pactions(reqs);
        Test.stopTest();
        Playground_Job__c result = getPlaygroundJobById(reqs[0].playgroundJobId);
        system.assert(result.JobId__c != null);
    }

    static testMethod void callC1Pactions_ProvisionLicenses() {
        String action = 'ProvisionLicenses';
        List<cps_Helper.PlaygroundC1PRequest> reqs = processBuilderJobsSetup(action);
        Test.startTest();
        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        cps_Helper.callC1Pactions(reqs);
        Test.stopTest();
        Playground_Job__c result = getPlaygroundJobById(reqs[0].playgroundJobId);
        system.assert(result.JobId__c != null);
    }

    static testMethod void callC1Pactions_CreateEnvironment() {
        String action = 'CreateEnvironment';
        List<cps_Helper.PlaygroundC1PRequest> reqs = processBuilderJobsSetup(action);
        Test.startTest();
        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        cps_Helper.callC1Pactions(reqs);
        Test.stopTest();
        Playground_Job__c result = getPlaygroundJobById(reqs[0].playgroundJobId);
        system.assert(result.JobId__c != null);
    }

    static testMethod void callC1Pactions_CreateOrgCredentials() {
        String action = 'CreateOrgCredentials';
        List<cps_Helper.PlaygroundC1PRequest> reqs = processBuilderJobsSetup(action);
        Test.startTest();
        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        cps_Helper.callC1Pactions(reqs);
        Test.stopTest();
        Playground_Job__c result = getPlaygroundJobById(reqs[0].playgroundJobId);
        system.assert(result.JobId__c != null);
    }

    static testMethod void callC1Pactions_AddingFinishingTouches() {
        String action = 'AddingFinishingTouches';
        Playground__c pg = [SELECT Id FROM Playground__c WHERE Name = 'Test Playground'];
        pg.Api_Key__c = 'dOMHQlXNUrLqSnuO5VvrZ0PJ3ZZJcaqf0AiRBZ7WB0QE3sHiu2pU8DG0LF5XQ6ekLCIrgfS0FVQv25Eh2DKRxw=='; //this is a random key.
        pg.Git_Token__c = 'ipc9vOWO1FfCycJClZuZzdSGcfEFmCjH3DUPlzJIY1BChj8zNr2hFjLkRYjwEaeoGcmgJv1yckWGtU7m8zuYvg==';
        pg.Git_Username__c = 'gitUser';
        update pg;
        List<Playground_Job__c> playgroundJobs = cps_PlaygroundWizardSetupController.GetPlaygroundJobs(pg.Id);
        Playground_Job__c thisPJ = selectJob(playgroundJobs, action);

        List<cps_Helper.PlaygroundC1PRequest> reqs = processBuilderJobsSetup(action);
        Test.startTest();
        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        cps_Helper.callC1Pactions(reqs);
        Test.stopTest();
        Playground_Job__c result = getPlaygroundJobById(reqs[0].playgroundJobId);
        system.assert(result.JobId__c != null);
    }

    private static Playground_Job__c selectJob(List<Playground_Job__c> jobs, String action) {
        for (Playground_Job__c pj : jobs) {
            if (pj.Action__c == action) {
                return pj;
            }
        }
        return null;
    }

    private static List<cps_Helper.PlaygroundC1PRequest> processBuilderJobsSetup(String action) {
        Playground__c pg = [SELECT Id FROM Playground__c WHERE Name = 'Test Playground'];
        List<Playground_Job__c> playgroundJobs = cps_PlaygroundWizardSetupController.GetPlaygroundJobs(pg.Id);
        Playground_Job__c thisPJ = selectJob(playgroundJobs, action);

        cps_Helper.PlaygroundC1PRequest c1pr = new cps_Helper.PlaygroundC1PRequest();
        c1pr.playgroundJobId = thisPJ.Id;
        c1pr.daysOfLicense = 30;

        List<cps_Helper.PlaygroundC1PRequest> c1prs = new List<cps_Helper.PlaygroundC1PRequest>();
        c1prs.add(c1pr);
        return c1prs;
    }

    private static Playground_Job__c getPlaygroundJobById(Id recordId) {
        return [SELECT Id, JobId__c, Status__c FROM Playground_Job__c WHERE Id = :recordId LIMIT 1];
    }
    private static Playground__c getPlaygroundById(Id recordId) {
        return [
            SELECT
                Id,
                Name,
                Contact__c,
                Api_Key__c,
                Commit_Hash__c,
                Git_Token__c,
                Git_Username__c,
                Org_Credential__c,
                Org_Credential__r.Name,
                Org_Credential__r.copado__Username__c,
                Stage__c,
                Status__c,
                Org_Id__c,
                All_Jobs_Completed__c,
                All_Sandboxes_Authorized__c,
                Playground_Jobs_Completed__c,
                Sandboxes_Authorized__c,
                Custom_Signup_Request__c
            FROM Playground__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }

    private static String createSuccessResponseString() {
        String responseString = '{"isSuccess":"' + true + '", "copadoJobId":"430c0e95-4771-4c66-9b42-d1eb277186b5"}';
        return responseString;
    }
}