@isTest
private class cps_PlaygroundWizardSetupTest {

  @testSetup static void setup(){
    Id communityProfileId = [SELECT Id FROM Profile WHERE Name = 'CUSTOM Customer Community Login User'].Id;
    Id permissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Community_Playground_User'].Id;

    Account account = new Account(Name ='Test Account 1') ;
    insert account;

    Contact contact = new Contact(LastName ='TestContact', AccountId = account.Id);
    insert contact;

    User user = new User(
      Alias = 'myalias', Email = 'testemail@emailtest.com',
      EmailEncodingKey = 'UTF-8', LastName = 'TestUser',
      LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
      ProfileId = communityProfileId, Country = 'United States',
      IsActive = true, ContactId = contact.Id,
      TimezoneSidKey = 'America/Los_Angeles', Username = 'demo2990@handomdemodomainz.djw.cmq');

    insert user;
    User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
    System.runAs(currentUser){
      PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = permissionSetId);
      insert psa;
    }
  }

  @isTest static void getPlaygroundJobs() {
    User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
    System.runAs(portalUser){
      Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
      Test.startTest();
      List<Playground_Job__c> jobs = cps_PlaygroundWizardSetupController.GetPlaygroundJobs(playground.Id);
      System.assertEquals(!jobs.isEmpty(), true);
      Test.stopTest();
    }
  }

  @isTest static void getPlaygroundJobsScratchOrgs() {
    User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
    System.runAs(portalUser){
      Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration - Scratch Orgs');
      Test.startTest();
      List<Playground_Job__c> jobs = cps_PlaygroundWizardSetupController.GetPlaygroundJobs(playground.Id);
      System.assertEquals(!jobs.isEmpty(), true);
      Test.stopTest();
    }
  }

  @isTest static void updateJobStatus() {
    User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
    System.runAs(portalUser){
      Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
      List<Playground_Job__c> jobs = cps_PlaygroundWizardInstallController.GetPlaygroundJobs(playground.Id);
      Playground_Job__c job;
      Test.startTest();
      if(!jobs.isEmpty()){
        job = jobs.get(0);
      }
      Playground_Job__c updatedJob = cps_PlaygroundWizardSetupController.updateJobStatus(playground.Id, job.Id, 'In Progress');
      System.assertEquals(updatedJob.Status__c, 'In Progress');
      Test.stopTest();
    }
  }

  @isTest static void updateJobStatusScratchOrg() {
    User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
    System.runAs(portalUser){
      Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration - Scratch Orgs');
      List<Playground_Job__c> jobs = cps_PlaygroundWizardInstallController.GetPlaygroundJobs(playground.Id);
      Playground_Job__c job;
      Test.startTest();
      if(!jobs.isEmpty()){
        job = jobs.get(0);
      }
      Playground_Job__c updatedJob = cps_PlaygroundWizardSetupController.updateJobStatus(playground.Id, job.Id, 'In Progress');
      System.assertEquals(updatedJob.Status__c, 'In Progress');
      Test.stopTest();
    }
  }

  @isTest static void getEnvironmentAuthorizationLinks() {
    User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
    System.runAs(portalUser){
      cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
      Test.setMock(HttpCalloutMock.class, mock);
      Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
    }

    Playground__c playground = [SELECT Id FROM Playground__c WHERE Name = 'Test Playground'];
    List<Playground_Enviroment__c> environments = [SELECT Authorization_URL__c FROM Playground_Enviroment__c WHERE Playground__c = :playground.Id LIMIT 9];
    for(Playground_Enviroment__c env : environments){
      env.Authorization_URL__c = 'https://login.salesforce.com';
    }
    update environments;

    System.runAs(portalUser){
      Test.startTest();
      Test.setMock(HttpCalloutMock.class, new cps_GetAuthLinkMock());
      Map<String, String> retMap = cps_PlaygroundWizardSetupController.GetEnvironmentAuthorizationLinks(playground.Id);
      System.debug('####@@@@retMap: ' + retMap);

      System.assertEquals(retMap.get('Copado'), 'https://mockresponse.com/test&login_hint=null');
      Test.stopTest();
    }
  }

  @isTest static void getEnvironmentAuthorizationLinksFullConfigScratchOrg() {
    User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
    System.runAs(portalUser){
      cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
      Test.setMock(HttpCalloutMock.class, mock);
      Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration - Scratch Orgs');
    }

    Playground__c playground = [SELECT Id FROM Playground__c WHERE Name = 'Test Playground'];
    List<Playground_Enviroment__c> environments = [SELECT Authorization_URL__c FROM Playground_Enviroment__c WHERE Playground__c = :playground.Id LIMIT 9];
    for(Playground_Enviroment__c env : environments){
      env.Authorization_URL__c = 'https://test.salesforce.com';
      env.Access_Token__c = 'accesstoken';
      env.InstanceUrl__c = 'https://environment-url.my.salesforce.com/';
      env.Type__c = 'Scratch_Org';
    }
    update environments;

    System.runAs(portalUser){
      Test.startTest();
      Test.setMock(HttpCalloutMock.class, new cps_GetAuthLinkScratchOrgMock());
      Map<String, String> retMap = cps_PlaygroundWizardSetupController.GetEnvironmentAuthorizationLinks(playground.Id);
      System.debug('####@@@@retMap: ' + retMap);

      System.assertEquals(retMap.get('Production'), 'https://environment-url.my.salesforce.com/secur/frontdoor.jsp?sid=accesstoken&retURL=%2F&login_hint=null.production');
      Test.stopTest();
    }
  }

  private static String createSuccessResponseString() {
    String responseString = '{"isSuccess":"'+true+'", "copadoJobId":"430c0e95-4771-4c66-9b42-d1eb277186b5"}';
    return responseString;
  }

  @isTest static void getEnvironmentCoEAuthorizationLinkFullConfigScratchOrg() {
    User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
    System.runAs(portalUser){
      cps_C1PJobMock mock = new cps_C1PJobMock(200, 'OK', createSuccessResponseString(), new Map<String,String>());
      Test.setMock(HttpCalloutMock.class, mock);
      Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration - Scratch Orgs');
    }

    Playground__c playground = [SELECT Id FROM Playground__c WHERE Name = 'Test Playground'];
    List<Playground_Enviroment__c> environments = [SELECT Authorization_URL__c FROM Playground_Enviroment__c WHERE Playground__c = :playground.Id LIMIT 9];
    for(Playground_Enviroment__c env : environments){
      env.Authorization_URL__c = 'https://test.salesforce.com';
      env.Access_Token__c = 'accesstoken';
      env.InstanceUrl__c = 'https://environment-url.my.salesforce.com/';
      env.Type__c = 'Scratch_Org';
    }

    Playground_Enviroment__c env = environments[0];
      env.Authorization_URL__c = 'https://login.salesforce.com';
      env.Type__c = 'CoE_Org';

    update environments;
    update env;

    System.runAs(portalUser){
      Test.startTest();
      Test.setMock(HttpCalloutMock.class, new cps_GetCopadoAuthLinkWithFrontdoorMock());
      Map<String, String> retMap = cps_PlaygroundWizardSetupController.GetEnvironmentAuthorizationLinks(playground.Id);
      System.debug('####@@@@retMap: ' + retMap);

      System.assertEquals(retMap.get('Copado'), 'https://trialorgfrontdoor.my.salesforce.com/secur/frontdoor.jsp?sid=accesstoken&retURL=%2F&login_hint=null');
      Test.stopTest();
    }
  }
}