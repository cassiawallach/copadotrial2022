@isTest
private class cps_PlaygroundWizardControllerTest {

	@testSetup static void setup(){
		Id communityProfileId = [SELECT Id FROM Profile WHERE Name = 'CUSTOM Customer Community Login User'].Id;
		Id permissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Community_Playground_User'].Id;

        Account account = new Account(Name ='Test Account 1') ;
        insert account;

        Contact contact = new Contact(LastName ='TestContact', AccountId = account.Id, Allowed_Playgrounds__c = 10, Is_Playgrounds_Test_User__c = true);
        insert contact;

        User user = new User(
        						Alias = 'myalias', Email = 'testemail@emailtest.com',
                				EmailEncodingKey = 'UTF-8', LastName = 'TestUser',
                				LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                				ProfileId = communityProfileId, Country = 'United States',
                				IsActive = true, ContactId = contact.Id,
                				TimezoneSidKey = 'America/Los_Angeles', Username = 'demo7251@handomdemodomainz.djw.cmq');

        insert user;
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs(currentUser){
        	PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = permissionSetId);
        	insert psa;
        }
    }

	@isTest static void getSessionId() {
		User portalUser = [SELECT Id, Allowed_Playgrounds__c FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			Test.startTest();
			String sessionId = cps_PlaygroundWizardController.getSessionId();
			Test.stopTest();
			system.assert(sessionId!=null);
		}
	}

	@isTest static void getAllowedPlaygrounds() {
		User portalUser = [SELECT Id, Allowed_Playgrounds__c FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			Test.startTest();
			Decimal allowedPlaygrounds = cps_PlaygroundWizardController.GetAllowedPlaygrounds();
			System.assertEquals(allowedPlaygrounds, portalUser.Allowed_Playgrounds__c);
			Test.stopTest();
		}
	}

	@isTest static void getAvailablePlayground_NotNull() {
		User portalUser = [SELECT Id, ContactId FROM User WHERE Email = 'testemail@emailtest.com'];
		portalUser.Allowed_Playgrounds__c = 55;
		update portalUser;

		System.runAs(portalUser){
			Test.startTest();
			Decimal result = cps_PlaygroundWizardController.GetAvailablePlaygrounds();
			system.assertEquals(55, result);
			Test.stopTest();
		}
	}

	@isTest static void getAvailablePlayground_null() {
		User portalUser = [SELECT Id, ContactId FROM User WHERE Email = 'testemail@emailtest.com'];
		portalUser.Allowed_Playgrounds__c = null;
		update portalUser;

		System.runAs(portalUser){
			Test.startTest();
			Decimal result = cps_PlaygroundWizardController.GetAvailablePlaygrounds();
			system.assertEquals(0, result);
			Test.stopTest();
		}
	}

	@isTest static void deletePlayground() {
		User portalUser = [select Id from User where Email='testemail@emailtest.com'];
		System.runAs(portalUser){
			Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
		}
		Playground_Enviroment__c playgroundEnv = [select Id, Org_Id__c from Playground_Enviroment__c where Playground__r.Name='Test Playground' and Type__c='CoE_Org' limit 1];
		playgroundEnv.Org_Id__c = '00D000000000000000';
		update playgroundEnv;

		System.runAs(portalUser){
			Playground__c playground = [select Id, Name from Playground__c where Name='Test Playground'];

			cps_C1PJobMock mock = new cps_C1PJobMock(201, 'OK', '', new Map<String,String>());
        	Test.setMock(HttpCalloutMock.class, mock);

			Test.startTest();
			cps_PlaygroundWizardController.DeletePlayground(playground.Id);
			List<Playground__c> emptyPlaygroundList = [select Name from Playground__c where Id=:playground.Id];
			System.assert(emptyPlaygroundList.isEmpty());
			Test.stopTest();
		}
	}

	@isTest static void getPlayground() {
		User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
			Test.startTest();
			Playground__c queriedPlayground = cps_PlaygroundWizardController.getPlayground(playground.Id);
			System.assertEquals(queriedPlayground.Name, 'Test Playground');
			Test.stopTest();
		}
	}

	@isTest static void getMyPlaygrounds() {
		User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
			Playground__c playground2 = cps_PlaygroundWizardStartController.createPlayground('Test Playground 2', 'Full Configuration');
			Playground__c playground3 = cps_PlaygroundWizardStartController.createPlayground('Test Playground 3', 'Full Configuration');
			Test.startTest();
			List<Playground__c> queriedPlaygrounds = cps_PlaygroundWizardController.GetMyPlaygrounds();
			System.assertEquals(queriedPlaygrounds.size(), 3);
			Test.stopTest();
		}
	}

	@isTest static void updatePlaygroundStage() {
		User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
			Test.startTest();
			Playground__c updatedPlayground = cps_PlaygroundWizardController.updatePlaygroundStage(playground.Id, 'Completed');
			Playground__c queriedPlayground = [SELECT Stage__c FROM Playground__c WHERE Id =: playground.Id];
			System.assertEquals(updatedPlayground.Stage__c, queriedPlayground.Stage__c);
			Test.stopTest();
		}
	}

	@isTest static void updateJobStatus_InProgress() {
		User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
			List<Playground_Job__c> jobs = cps_PlaygroundWizardInstallController.GetPlaygroundJobs(playground.Id);
			Playground_Job__c job;
			Test.startTest();
			if(!jobs.isEmpty()){
				job = jobs.get(0);
			}
			Playground_Job__c updatedJob = cps_PlaygroundWizardController.updateJobStatus(playground.Id, job.Id, 'In Progress');
			System.assertEquals(updatedJob.Status__c, 'In Progress');
			Test.stopTest();
		}
	}

	@isTest static void updateJobStatus_Failed() {
		User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
			List<Playground_Job__c> jobs = cps_PlaygroundWizardInstallController.GetPlaygroundJobs(playground.Id);
			Playground_Job__c job;
			if(!jobs.isEmpty()) job = jobs.get(0);

			Test.startTest();
			Playground_Job__c updatedJob = cps_PlaygroundWizardController.updateJobStatus(playground.Id, job.Id, 'Failed');
			Playground__c result = [select Status__c from Playground__c where Id=:playground.Id limit 1];
			System.assertEquals('Failed', result.Status__c);
			Test.stopTest();
		}
	}

	@isTest static void getPlaygroundJobs() {
		User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
			Test.startTest();
			List<Playground_Job__c> jobs = cps_PlaygroundWizardController.GetPlaygroundJobs(playground.Id);
			System.assertEquals(!jobs.isEmpty(), true);
			Test.stopTest();
		}
	}

	@isTest static void getPlaygroundDetails() {
		User portalUser = [SELECT Id, Allowed_Playgrounds__c FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
			List<Playground_Enviroment__c> pgEnvs = [select Id from Playground_Enviroment__c where Playground__c=:playground.Id];
			Test.startTest();
			Map<String, Object> result = cps_PlaygroundWizardController.getPlaygroundDetails(playground.Id);
			Playground__c playgroundResult = (Playground__c)result.get('playground');
			List<Playground_Enviroment__c> envsResult = (List<Playground_Enviroment__c>)result.get('environments');
			Test.stopTest();

			System.assertEquals(pgEnvs.size(), envsResult.size());
		}
	}

	@isTest static void callStandardC1PAction() {
		User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
            Test.setMock(HttpCalloutMock.class, mock);
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
			Test.startTest();
			Playground_Job__c job = cps_PlaygroundWizardController.callStandardC1PAction(playground.Id, 'ExecutePostInstallScript');
			Playground_Job__c queriedJob = [SELECT Id, Status__c FROM Playground_Job__c WHERE Action__c = 'ExecutePostInstallScript'];
			System.assertEquals(job.Id, queriedJob.Id);
			System.assertEquals(job.Status__c, queriedJob.Status__c);
			Test.stopTest();
		}
	}

	@isTest static void getPlaygroundUnderMaintenanceTest() {
		User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
		System.runAs(portalUser){
			Test.startTest();
			Playground_Setting__mdt playgroundSetting = cps_PlaygroundWizardController.getPlaygroundUnderMaintenance();
			System.assert(!playgroundSetting.Are_Playgrounds_Under_Maintenance__c);
			Test.stopTest();
		}
	}

	private static String createSuccessResponseString() {
        String responseString = '{"isSuccess":"'+true+'", "copadoJobId":"430c0e95-4771-4c66-9b42-d1eb277186b5"}';
        return responseString;
    }
}