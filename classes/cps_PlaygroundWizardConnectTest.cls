@isTest
private class cps_PlaygroundWizardConnectTest {
    
    @testSetup static void setup(){
        Id communityProfileId = [SELECT Id FROM Profile WHERE Name = 'CUSTOM Customer Community Login User'].Id;
        Id permissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Community_Playground_User'].Id;

        Account account = new Account(Name='Copado, Inc.') ;
        insert account; 
       
        Contact contact = new Contact(AccountId=account.Id, FirstName='John', LastName='Doe', Email='testemail@emailtest.com');
        insert contact;
                  
        User user = new User(FirstName=contact.FirstName, LastName=contact.LastName, Email=contact.Email, ContactId=contact.Id,
                                Alias='myalias', EmailEncodingKey = 'UTF-8',
                                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                ProfileId=communityProfileId, Country='United States', IsActive=true,
                                TimezoneSidKey='America/Los_Angeles', Username='demo1734@handomdemodomainz.djw.cmq');
       
        insert user;
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs(currentUser){
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = permissionSetId);
            insert psa;
        }
    }

    @isTest static void getPlaygroundJobs() {
        User portalUser = [SELECT Id FROM User WHERE Email='testemail@emailtest.com'];
        System.runAs(portalUser){
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
            Test.startTest();
            List<Playground_Job__c> jobs = cps_PlaygroundWizardConnectController.getPlaygroundJobs(playground.Id);
            System.assertEquals(!jobs.isEmpty(), true);
            Test.stopTest();
        }
    }

    @isTest static void updateJobStatus() {
        User portalUser = [SELECT Id FROM User WHERE Email='testemail@emailtest.com'];
        System.runAs(portalUser){
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
            List<Playground_Job__c> jobs = cps_PlaygroundWizardInstallController.GetPlaygroundJobs(playground.Id);
            Playground_Job__c job;
            Test.startTest();
            if(!jobs.isEmpty()){
                job = jobs.get(0);
            }
            Playground_Job__c updatedJob = cps_PlaygroundWizardConnectController.updateJobStatus(playground.Id, job.Id, 'In Progress');
            System.assertEquals(updatedJob.Status__c, 'In Progress');
            Test.stopTest();
        }
    }

    @isTest static void getAuthLink() {
        User communityUser = [SELECT Id FROM User WHERE Username = 'demo1734@handomdemodomainz.djw.cmq'];
        Test.startTest();
        System.runAs(communityUser){
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
        }
        Playground__c playground = [SELECT Org_Credential__c FROM Playground__c WHERE Name = 'Test Playground'];
        copado__Org__c orgCredential = new copado__Org__c(Name = 'CoE', copado__Validated_Date__c = System.today(), copado__SFDC_Org_ID__c = playground.Id);
        insert orgCredential;
        playground.Org_Credential__c = orgCredential.Id;
        update playground;
        Test.stopTest();
        /*
        System.runAs(communityUser){
            Map<String, Object> authLinkMap = cps_PlaygroundWizardConnectController.GetAuthLink(playground.Id, 'https://login.salesforce.com');
            Playground_Job__c queriedPlaygroundJob = [SELECT Status__c
                                                        FROM Playground_Job__c 
                                                        WHERE Playground__c =: playground.Id 
                                                        AND Action__c = 'CoE_Authorization'];
            Playground_Job__c plagroundJob = (Playground_Job__c) authlinkMap.get('job');

            System.assertEquals(plagroundJob.Status__c, queriedPlaygroundJob.Status__c);
        }
        */
    }
 
    @isTest static void getAuthLink_badOrg() {
        User communityUser = [select Id, ContactId, Email from User where Username='demo1734@handomdemodomainz.djw.cmq'];
        
        Signup_Request__c sr = new Signup_Request__c();
		sr.First_Name__c = 'John';
		sr.Last_Name__c = 'Doe';
        sr.Company__c = 'Copado, Inc.';
        sr.Email__c = communityUser.Email;
        sr.Contact__c = communityUser.contactId;
		sr.Username__c = 'expected@username.copado.com';
		sr.Country__c = 'US';
        sr.Created_Org_Id__c = '00D00000d3d3D12';
        sr.Template__c = '0TT1i00000269iK';
		insert sr;
        
        System.runAs(communityUser){
            system.debug('Creating Playground');
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
        }
        system.debug('Creating Org Credential');
        copado__Org__c orgCredential = new copado__Org__c(Name='CoE', copado__Validated_Date__c=null, copado__Org_Type__c='Production/Developer');
        orgCredential.copado__Validated_Date__c=System.today();
        orgCredential.copado__Username__c = 'actual@username.copado.com';
        orgCredential.copado__SFDC_Org_ID__c = '00Dxxxxxxxxxxxxxxx';
        
        copado__Environment__c env = new copado__Environment__c(Name=orgCredential.Name, copado__Org_ID__c=orgCredential.copado__SFDC_Org_ID__c);
        env.copado__Type__c = orgCredential.copado__Org_Type__c;
        insert env;
        
        orgCredential.copado__Environment__c = env.Id;
        insert orgCredential;
        
        Playground__c playground = [SELECT Id, Org_Credential__c, Using_Trial_Org__c FROM Playground__c WHERE Name='Test Playground'];
        playground.Org_Credential__c = orgCredential.Id;
        update playground;
        system.debug('@@@ Playground: '+playground);
        
        Test.startTest();
        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        system.debug('Getting authorization link');
        cps_PlaygroundWizardConnectController.getAuthLink(playground.Id, 'https://www.copado.com/someReturnUrl');
        Test.stopTest();

        Playground_Job__c authorizationJob = [SELECT Id, Status__c, Payload__c, Output__c from Playground_Job__c where Playground__c=:playground.Id and Action__c='CoE_Authorization'];
        Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(authorizationJob.Payload__c);
        Map<String, Object> dataResult = (Map<String, Object>)result.get('data');
        system.assertEquals('WRONG_ORG_AUTHENTICATED', authorizationJob.Output__c);
        system.assertEquals('Failed', authorizationJob.Status__c); //process builder will set this to in progress though.
        system.assertEquals('CoE_Authorization', result.get('action'));
        system.assertEquals(true, result.get('hasError'));
        String errorMessage = 'The Org that was just authenticated did not match the Copado Trial Org for this Playground. You must authenticate the Copado Trial Org created in the previous step to proceed.';
        system.assertEquals(errorMessage, dataResult.get('message'));        
    }

    @isTest static void getAuthLinkWithoutDate() {
        User communityUser = [SELECT Id FROM User WHERE Username = 'demo1734@handomdemodomainz.djw.cmq'];
        System.runAs(communityUser){
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
        }
        Playground__c playground = [SELECT Org_Credential__c FROM Playground__c WHERE Name = 'Test Playground'];
        copado__Org__c orgCredential = new copado__Org__c(Name = 'CoE', copado__SFDC_Org_ID__c = playground.Id);
        insert orgCredential;
        playground.Org_Credential__c = orgCredential.Id;
        update playground;

        System.runAs(communityUser){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new cps_GetAuthLinkMock());
            Map<String, Object> authLinkMap = cps_PlaygroundWizardConnectController.GetAuthLink(playground.Id, 'https://login.salesforce.com');

            Playground_Job__c queriedPlaygroundJob = [select Status__c from Playground_Job__c where Playground__c =: playground.Id and Action__c = 'CoE_Authorization'];
            Playground_Job__c plagroundJob = (Playground_Job__c) authlinkMap.get('job');
            
            //System.assertEquals(plagroundJob.Status__c, queriedPlaygroundJob.Status__c);
            System.assertEquals(authlinkMap.get('authorization_url'), 'https://mockresponse.com/test');
            Test.stopTest();
        }
    }

    @isTest static void setupGitWithCode() {
        User communityUser = [SELECT Id FROM User WHERE Username = 'demo1734@handomdemodomainz.djw.cmq'];
        System.runAs(communityUser){
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
        }
        Playground__c playground = [SELECT Org_Credential__c FROM Playground__c WHERE Name='Test Playground'];
        copado__Org__c orgCredential = new copado__Org__c(Name='CoE', copado__SFDC_Org_ID__c=playground.Id);
        insert orgCredential;
        playground.Org_Credential__c = orgCredential.Id;
        update playground;

        System.runAs(communityUser){
            Test.startTest();
            cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
            Test.setMock(HttpCalloutMock.class, mock);
            Playground_Job__c playgroundJob = cps_PlaygroundWizardConnectController.GitSetup(playground.Id, 'somecode');
            Playground_Job__c queriedPlaygroundJob = [SELECT Id, Status__c FROM Playground_Job__c WHERE Action__c = 'GitSetup'];
            System.assertEquals(playgroundJob.Id, queriedPlaygroundJob.Id);
            System.assertEquals(playgroundJob.Status__c, queriedPlaygroundJob.Status__c);
            Test.stopTest();
        }
    }

    @isTest static void setupGitWithoutCode() {
        User communityUser = [SELECT Id FROM User WHERE Username = 'demo1734@handomdemodomainz.djw.cmq'];
        System.runAs(communityUser){
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
        }
        Playground__c playground = [SELECT Org_Credential__c FROM Playground__c WHERE Name = 'Test Playground'];
        copado__Org__c orgCredential = new copado__Org__c(Name = 'CoE', copado__SFDC_Org_ID__c = playground.Id);
        insert orgCredential;
        playground.Org_Credential__c = orgCredential.Id;
        update playground;

        System.runAs(communityUser){
            Test.startTest();
            cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
            Test.setMock(HttpCalloutMock.class, mock);
            Playground_Job__c playgroundJob = cps_PlaygroundWizardConnectController.GitSetup(playground.Id, '');
            Playground_Job__c queriedPlaygroundJob = [SELECT Id, Status__c FROM Playground_Job__c WHERE Action__c = 'GitSetup'];
            System.assertEquals(playgroundJob.Id, queriedPlaygroundJob.Id);
            System.assertEquals(playgroundJob.Status__c, queriedPlaygroundJob.Status__c);
            Test.stopTest();
        }
    }

    @isTest static void getGithubSettings() {
        Test.startTest();
        Map<String, String> result = cps_PlaygroundWizardConnectController.getGithubSettings();
        system.assert(containsValue(result.keySet(), 'gitAuthUrl'));
        system.assert(containsValue(result.keySet(), 'gitClientId'));
        Test.stopTest();
    }

    private static boolean containsValue(Set<String> x, String y) {
        if (x.contains(y)) return true;
        else return false;
    }
    private static String createSuccessResponseString() {
        String responseString = '{"isSuccess":"'+true+'", "copadoJobId":"430c0e95-4771-4c66-9b42-d1eb277186b5"}';        
        return responseString;
    }
}