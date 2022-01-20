@isTest
public class StepExecutionServiceTest {
    
    @testSetup 
    static void testDataSetup() {
        copado.GlobalAPI.UserLicense copadoUserLicense = new copado.GlobalAPI.UserLicense(UserInfo.getUserId(),false,false,false,true,false);
        copado.GlobalAPI gapi = new copado.GlobalAPI();
        gapi.upsertCopadoLicense(UserInfo.getUserId(), copadoUserLicense);
        
        Account testAccount = new Account(Name='Test');
        insert testAccount;
        
        Contact testContact = new Contact(LastName='test', AccountId=testAccount.Id);
        insert testContact;
        
        Playground__c pg = new Playground__c(Name='Test Step', Contact__c=testContact.Id, Api_Key__c='mXEC3iw2QqCz1VtQb2jT9UeZRHLBfyozNRsR63bjdNzde0pTtRpxnkD8j1Ofl33VyqYHXd3S3xF50QncfkwPkA==');
        insert pg;
        
        Playground_Enviroment__c playgroundEnv = new Playground_Enviroment__c(Name = 'Dev1', Playground__c = pg.Id, Type__c = 'Scratch_Org', Org_Id__c = '00Df4000003AqJXEA0',
                                                                             Authorization_URL__c = 'https://app-api.copado.com/Authorize/loginCustomRedirect?orgId=a0k4L000000LwqgQAC&copadoOrgId=00D4L000000FqAkUAK&copadoUserId=0054L000000xFzXQAU&startURL=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&url=https://pgsdev-customer-success.cs173.force.com/success/s/playground/a9a7Y000000PB3aQAG/avkdev48?name=Copado&sandbox=false');
        insert playgroundEnv;
        
        Configuration_Steps_Definition__c configStepDef = new Configuration_Steps_Definition__c(Name='Config Step Deff', Status__c = 'Active');
        insert configStepDef;
        
        List<Configuration_Step__c> configSteps = new List<Configuration_Step__c>();
        configSteps.add(new Configuration_Step__c(Configuration_Steps_Definition__c=configStepDef.Id, Name='Step A', Order__c=1, Org__c='Dev1', Type__c='Package Installation', Package_Id__c='test'));
        configSteps.add(new Configuration_Step__c(Configuration_Steps_Definition__c=configStepDef.Id, Name='Step B', Order__c=2, Org__c='Dev1', Type__c='Anonymous Apex', Apex_Script__c='test'));
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

        Configuration_Execution__c configExecutionToBeInsert = new Configuration_Execution__c(
            Learning_Assignment__c = learningAssignment.Id,
            Playground__c = pg.Id,
            Configuration_Steps_Definition__c = configStepDef.Id
        );
        insert configExecutionToBeInsert;
        
        List<Step_Execution__c> stepExecutionToBeInsert = new List<Step_Execution__c>();

        for (Configuration_Step__c configStep : configSteps) {
            stepExecutionToBeInsert.add(new Step_Execution__c(
                Name = configStep.Name,
                Configuration_Step__c = configStep.Id,
                OrgCredentialId__c = pg.Org_Credential__c,
                ApiKey__c = pg.Api_Key__c,
                Target_Instance_URL__c = 'https://enterprise-data-7401.cs87.my.salesforce.com/',
                Trial_Org_Credential_Id__c = pg.Org_Credential__c,

                Configuration_Execution__c = configExecutionToBeInsert.Id

            ));
        }

        insert stepExecutionToBeInsert;

        copado__Git_Repository__c gr = new copado__Git_Repository__c();
        insert gr;

        copado1p__Platform_Job__c pj = new copado1p__Platform_Job__c(Name='C1P Rules Job');
        pj.copado1p__isActive__c = true;
        pj.copado1p__Git_Repository__c = gr.id;
        pj.copado1p__Branch__c = 'master';
        pj.copado1p__VM_Provider__c = 'Heroku';
        pj.copado1p__Branch__c = 'standard-1x';
        insert pj;

        copado1p__Platform_Job_Execution__c pje = new copado1p__Platform_Job_Execution__c(copado1p__Platform_Job__c=pj.Id, copado1p__Status__c = 'Running', copado1p__Copado_Job_ID__c = '12345678');
        insert pje;
    }
    
    static testMethod void testRunApexJobInProgress() {
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        
        copado1p__Platform_Job_Execution__c pje = [Select Id, copado1p__Status__c From copado1p__Platform_Job_Execution__c Where copado1p__Copado_Job_ID__c = '12345678'];
        pje.copado1p__Status__c = 'Failure';
        update pje;

        test.startTest();

        List<Step_Execution__c> stepExecutionExisting = [Select Id, Name, Status__c, Configuration_Step__r.Order__c From Step_Execution__c Order By Configuration_Step__r.Order__c ASC];
        stepExecutionExisting[0].Status__c = 'In progress';
        stepExecutionExisting[1].Status__c = 'In progress';
        update stepExecutionExisting;

        test.stopTest();
        List<Step_Execution__c> stepExecutionExisting1 = [Select Id, Name, Status__c, Configuration_Step__r.Order__c From Step_Execution__c Order By Configuration_Step__r.Order__c ASC];
        System.assertEquals('In progress', stepExecutionExisting1[0].Status__c);
    }
    
    static testMethod void testRunApexJobFinish() {
        Test.setMock(HttpCalloutMock.class, new cps_MockHttpResponseGeneratorC1P());
        copado1p__Platform_Job_Execution__c pje = [Select Id, copado1p__Status__c From copado1p__Platform_Job_Execution__c Where copado1p__Copado_Job_ID__c = '12345678'];
        pje.copado1p__Status__c = 'Starting';
        update pje;

        test.startTest();

        List<Step_Execution__c> stepExecutionExisting = [Select Id, Name, Status__c, Configuration_Step__r.Order__c From Step_Execution__c Order By Configuration_Step__r.Order__c ASC];
        stepExecutionExisting[0].Payload__c = '{"hasError":false}';
        stepExecutionExisting[1].Payload__c = '{"hasError":true}';
        update stepExecutionExisting;

        test.stopTest();
    
        stepExecutionExisting[0].Status__c = 'Pending';
        update stepExecutionExisting;

        List<Step_Execution__c> stepExecutionExisting1 = [Select Id, Name, Status__c, Payload__c, Configuration_Step__r.Order__c From Step_Execution__c Order By Configuration_Step__r.Order__c ASC];

        System.assertEquals(null, stepExecutionExisting1[0].Payload__c);
    }
}