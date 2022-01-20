@isTest
public with sharing class tms_TrailModuleValidationControllerTest {

    
    static testMethod void unitTests () {
        tms_TrailModuleValidationController.getSessionId();
        String result = tms_TrailModuleValidationController.hasIMValidationConfigStep(null);
        system.assertEquals(null, result);
    }
    
    static testMethod void testRunApexJob() {
        Account testAccount = new Account(Name='Test');
        insert testAccount;
        
        Contact testContact = new Contact(LastName='test', AccountId=testAccount.Id);
        insert testContact;
        
        Playground__c pg = new Playground__c(Name='Test 1', Contact__c=testContact.Id, Api_Key__c='mXEC3iw2QqCz1VtQb2jT9UeZRHLBfyozNRsR63bjdNzde0pTtRpxnkD8j1Ofl33VyqYHXd3S3xF50QncfkwPkA==');
        insert pg;
        
        Playground_Enviroment__c playgroundEnv = new Playground_Enviroment__c(Name = 'Dev1', Playground__c = pg.Id, Type__c = 'Scratch_Org', Org_Id__c = '00Df4000003AqJXEA0',
                                                                             Authorization_URL__c = 'https://app-api.copado.com/Authorize/loginCustomRedirect?orgId=a0k4L000000LwqgQAC&copadoOrgId=00D4L000000FqAkUAK&copadoUserId=0054L000000xFzXQAU&startURL=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&url=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&sandbox=false');
        insert playgroundEnv;
        
        Interactive_Validation__c validation = new Interactive_Validation__c(Name='IV Config Step Deff', Status__c = 'Active');
        insert validation;
        
        List<Interactive_Validation_Step__c> configSteps = new List<Interactive_Validation_Step__c>();
        configSteps.add(new Interactive_Validation_Step__c(Interactive_Validation__c=validation.Id, Name='Step A', ExecutionOrder__c=1, Environment__c='Dev1', Type__c='Validate Data', ExecutionDetails__c='test'));
        configSteps.add(new Interactive_Validation_Step__c(Interactive_Validation__c=validation.Id, Name='Step B', ExecutionOrder__c=2, Environment__c='Dev1', Type__c='Validate Metadata', ExecutionDetails__c='test'));
        insert configSteps;
        
        redwing__Training_Plan__c trainingPlan = TestDataFactory.createTrainingPlan('Test Developer');
        INSERT trainingPlan;
        
        redwing__Training_Plan_Assignment__c trainingPlanAssignment = TestDataFactory.createTrainingPlanAssignment(userinfo.getUserId(),testContact.Id,trainingPlan.Id);
        INSERT trainingPlanAssignment;
        
        redwing__Learning__c learning = TestDataFactory.createLearning('Test Learning');
        learning.Interactive_Validation__c = validation.Id;
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
        
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        
        test.startTest();
        String jobRes = tms_TrailModuleValidationController.runIVOrgConfigurationStep(pg.Id, learningAssignment.Id);
        tms_TrailModuleValidationController.getInteractiveValidationStepExecution(pg.Id, learningAssignment.Id);
        test.stopTest();
        System.assertEquals('Validation Steps Execution Started', jobRes);
    }
    
    static testMethod void testRunApexJobWithoutStep() {
        Account testAccount = new Account(Name='Test');
        insert testAccount;
        
        Contact testContact = new Contact(LastName='test', AccountId=testAccount.Id);
        insert testContact;
        
        Playground__c pg = new Playground__c(Name='Test 1', Contact__c=testContact.Id, Api_Key__c='mXEC3iw2QqCz1VtQb2jT9UeZRHLBfyozNRsR63bjdNzde0pTtRpxnkD8j1Ofl33VyqYHXd3S3xF50QncfkwPkA==');
        insert pg;
        
        Playground_Enviroment__c playgroundEnv = new Playground_Enviroment__c(Name = 'Dev1', Playground__c = pg.Id, Type__c = 'Scratch_Org', Org_Id__c = '00Df4000003AqJXEA0',
                                                                             Authorization_URL__c = 'https://app-api.copado.com/Authorize/loginCustomRedirect?orgId=a0k4L000000LwqgQAC&copadoOrgId=00D4L000000FqAkUAK&copadoUserId=0054L000000xFzXQAU&startURL=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&url=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&sandbox=false');
        insert playgroundEnv;
        
        Interactive_Validation__c validation = new Interactive_Validation__c(Name='IV Config Step Deff', Status__c = 'Active');
        insert validation;
        
        redwing__Training_Plan__c trainingPlan = TestDataFactory.createTrainingPlan('Test Developer');
        INSERT trainingPlan;
        
        redwing__Training_Plan_Assignment__c trainingPlanAssignment = TestDataFactory.createTrainingPlanAssignment(userinfo.getUserId(),testContact.Id,trainingPlan.Id);
        INSERT trainingPlanAssignment;
        
        redwing__Learning__c learning = TestDataFactory.createLearning('Test Learning');
        learning.Interactive_Validation__c = validation.Id;
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
        
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        
        test.startTest();
        String jobRes = tms_TrailModuleValidationController.runIVOrgConfigurationStep(pg.Id, learningAssignment.Id);
        test.stopTest();
        System.assertEquals('Interactive Validation Configure Steps not setup yet', jobRes);
    }
    
    static testMethod void testRunApexJobWithValidationExe() {
        Account testAccount = new Account(Name='Test');
        insert testAccount;
        
        Contact testContact = new Contact(LastName='test', AccountId=testAccount.Id);
        insert testContact;
        
        Playground__c pg = new Playground__c(Name='Test 1', Contact__c=testContact.Id, Api_Key__c='mXEC3iw2QqCz1VtQb2jT9UeZRHLBfyozNRsR63bjdNzde0pTtRpxnkD8j1Ofl33VyqYHXd3S3xF50QncfkwPkA==');
        insert pg;
        
        Playground_Enviroment__c playgroundEnv = new Playground_Enviroment__c(Name = 'Dev1', Playground__c = pg.Id, Type__c = 'Scratch_Org', Org_Id__c = '00Df4000003AqJXEA0',
                                                                             Authorization_URL__c = 'https://app-api.copado.com/Authorize/loginCustomRedirect?orgId=a0k4L000000LwqgQAC&copadoOrgId=00D4L000000FqAkUAK&copadoUserId=0054L000000xFzXQAU&startURL=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&url=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&sandbox=false');
        insert playgroundEnv;
        
        Interactive_Validation__c validation = new Interactive_Validation__c(Name='IV Config Step Deff', Status__c = 'Active');
        insert validation;
        
        List<Interactive_Validation_Step__c> configSteps = new List<Interactive_Validation_Step__c>();
        configSteps.add(new Interactive_Validation_Step__c(Interactive_Validation__c=validation.Id, Name='Step A', ExecutionOrder__c=1, Environment__c='Dev1', Type__c='Validate Data', ExecutionDetails__c='test'));
        configSteps.add(new Interactive_Validation_Step__c(Interactive_Validation__c=validation.Id, Name='Step B', ExecutionOrder__c=2, Environment__c='Dev1', Type__c='Validate Metadata', ExecutionDetails__c='test'));
        insert configSteps;
        
        redwing__Training_Plan__c trainingPlan = TestDataFactory.createTrainingPlan('Test Developer');
        INSERT trainingPlan;
        
        redwing__Training_Plan_Assignment__c trainingPlanAssignment = TestDataFactory.createTrainingPlanAssignment(userinfo.getUserId(),testContact.Id,trainingPlan.Id);
        INSERT trainingPlanAssignment;
        
        redwing__Learning__c learning = TestDataFactory.createLearning('Test Learning');
        learning.Interactive_Validation__c = validation.Id;
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
        
        Validation_Execution__c validationExecutionToBeInsert = new Validation_Execution__c(
            Learning_Assignment__c = learningAssignment.Id,
            Playground__c = pg.Id,
            Interactive_Validation__c = validation.Id,
            Status__c = 'Failed'
        );
        
        insert validationExecutionToBeInsert;
        
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        
        test.startTest();
        String jobRes = tms_TrailModuleValidationController.runIVOrgConfigurationStep(pg.Id, learningAssignment.Id);
        test.stopTest();
    }
}