@isTest
public class tms_TrailModuleSetupControllerTest {
    
    @testSetup 
    static void methodName() {
        copado.GlobalAPI.UserLicense copadoUserLicense = new copado.GlobalAPI.UserLicense(UserInfo.getUserId(),false,false,false,true,false);
        copado.GlobalAPI gapi = new copado.GlobalAPI();
        gapi.upsertCopadoLicense(UserInfo.getUserId(), copadoUserLicense);
      
        
        Account testAccount = new Account(Name='Test');
        insert testAccount;
        
        Contact testContact = new Contact(LastName='test', AccountId=testAccount.Id);
        insert testContact;
        
        Playground__c pg = new Playground__c(Name='Test 1', Contact__c=testContact.Id, Api_Key__c='mXEC3iw2QqCz1VtQb2jT9UeZRHLBfyozNRsR63bjdNzde0pTtRpxnkD8j1Ofl33VyqYHXd3S3xF50QncfkwPkA==');
        insert pg;
        
        List<Playground_Enviroment__c> playgroundEnvs = new List<Playground_Enviroment__c>();
        Playground_Enviroment__c playgroundEnv = new Playground_Enviroment__c(Name = 'Copado', Playground__c = pg.Id, Type__c = 'CoE_Org', Org_Id__c = '00Df4000003AqJXEA0',
                                                                             Authorization_URL__c = 'https://app-api.copado.com/Authorize/loginCustomRedirect?orgId=a0k4L000000LwqgQAC&copadoOrgId=00D4L000000FqAkUAK&copadoUserId=0054L000000xFzXQAU&startURL=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&url=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&sandbox=false');
        playgroundEnvs.add(playgroundEnv);
        Playground_Enviroment__c playgroundEnv1 = new Playground_Enviroment__c(Name = 'Dev1', Playground__c = pg.Id, Type__c = 'Scratch_Org', Org_Id__c = '00Df4000003AqJXEA1',
                                                                             Authorization_URL__c = 'https://app-api.copado.com/Authorize/loginCustomRedirect?orgId=a0k4L000000LwqgQAC&copadoOrgId=00D4L000000FqAkUAK&copadoUserId=0054L000000xFzXQAU&startURL=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&url=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&sandbox=false');
        playgroundEnvs.add(playgroundEnv1);
        insert playgroundEnvs;
        
        Configuration_Steps_Definition__c configStepDef = new Configuration_Steps_Definition__c(Name='Config Step Deff', Status__c = 'Active');
        insert configStepDef;
        
        List<Configuration_Step__c> configSteps = new List<Configuration_Step__c>();
        configSteps.add(new Configuration_Step__c(Configuration_Steps_Definition__c=configStepDef.Id, Name='Step A', Order__c=1, Org__c='Dev1', Type__c='Package Installation', Package_Id__c='test'));
        configSteps.add(new Configuration_Step__c(Configuration_Steps_Definition__c=configStepDef.Id, Name='Step B', Order__c=2, Org__c='Dev1', Type__c='Package Installation', Package_Id__c='test'));
        insert configSteps;
        
        redwing__Training_Plan__c trainingPlan = TestDataFactory.createTrainingPlan('Test Developer');
        INSERT trainingPlan;
        
        redwing__Training_Plan_Assignment__c trainingPlanAssignment = TestDataFactory.createTrainingPlanAssignment(userinfo.getUserId(),testContact.Id,trainingPlan.Id);
        INSERT trainingPlanAssignment;
        
        redwing__Learning__c learning = TestDataFactory.createLearning('Test Learning');
        learning.Configuration_Steps_Definition__c = configStepDef.Id;
        learning.Is_Dynamic__c = true;
        INSERT learning;
        
        redwing__Training_Plan_Section__c trainingPlanSection = TestDataFactory.createTrainigPlanSection('Test',trainingPlan.Id);
        INSERT trainingPlanSection;
        
        redwing__Training_Plan_Section_Assignment__c trainingPlanSectionAssignment = TestDataFactory.createTrainingPlanSectionAssignment(userinfo.getUserId(),trainingPlanSection.Id,trainingPlanAssignment.Id);
        INSERT trainingPlanSectionAssignment;
        
        redwing__Training_Plan_Section_Item__c trainingPlanSectionItem = TestDataFactory.createTrainingPlanSectionItem(learning.Id,trainingPlanSection.Id);
        INSERT trainingPlanSectionItem;
        
        redwing__Learning_Assignment__c learningAssignment = TestDataFactory.createLearningAssignment(testContact.Id,userinfo.getUserId(),trainingPlan.Id,learning.Id,trainingPlanSection.Id,trainingPlanSectionAssignment.Id,trainingPlanSectionItem.Id);
        INSERT learningAssignment;
        
    }
    
    static testMethod void unitTests () {
        tms_TrailModuleSetupController.getSessionId();
        String result = tms_TrailModuleSetupController.hasConfigStep(null);
        system.assertEquals(null, result);
    }
    
    static testMethod void testRunApexJob() {
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        
        redwing__Learning_Assignment__c learningAssignment = [Select Id From redwing__Learning_Assignment__c Limit 1];
        Playground__c pg = [Select Id From Playground__c Limit 1];

        test.startTest();
        String jobStartResponse = tms_TrailModuleSetupController.runOrgConfigurationStep(pg.Id, learningAssignment.Id);
        tms_TrailModuleSetupController.assignCredits(pg.Id);
        tms_TrailModuleSetupController.getStepExecution(pg.Id, learningAssignment.Id);
        System.assertEquals('Execution Started', jobStartResponse);
        test.stopTest();

        Configuration_Execution__c ce = [Select Id, Status__c From Configuration_Execution__c limit 1];
        ce.Status__c = 'Failed';
        update ce;

        jobStartResponse = tms_TrailModuleSetupController.runOrgConfigurationStep(pg.Id, learningAssignment.Id);
        System.assertEquals('Setup Execution Restarted', jobStartResponse);
    }
    
    static testMethod void testCreateFrontDoorRequest() {
        Playground__c playground = [SELECT Id FROM Playground__c LIMIT 1];
        
        cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', '', new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
        test.startTest();
        tms_TrailModuleSetupController.createFrontDoorRequest(playground.Id);
        test.stopTest();
    }
}