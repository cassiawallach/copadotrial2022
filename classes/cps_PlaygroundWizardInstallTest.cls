@isTest
private class cps_PlaygroundWizardInstallTest {

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
                                TimezoneSidKey = 'America/Los_Angeles', Username = 'demo4959@handomdemodomainz.djw.cmq');

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
            List<Playground_Job__c> jobs = cps_PlaygroundWizardInstallController.GetPlaygroundJobs(playground.Id);
            cps_PlaygroundWizardInstallController.resetPlaygroundJobById(jobs.get(0).Id);
            
            cps_PlaygroundWizardInstallController.isPlaygroundJobRetriable(jobs.get(0).Id, jobs.get(0).Name);
            System.assertEquals(!jobs.isEmpty(), true);
            Test.stopTest();
        }
    }
}