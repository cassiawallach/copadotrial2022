@isTest
public class cps_PlaygroundWizardStartControllerTest {
    
    @testSetup public static void setup(){
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
                                    ProfileId = communityProfileId, Country='United States',
                                    IsActive =true, ContactId = contact.Id,
                                    TimezoneSidKey='America/Los_Angeles', Username='demo5645@handomdemodomainz.djw.cmq');
           
            insert user;
            User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
            System.runAs(currentUser){
                    User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
                PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = portalUser.Id, PermissionSetId = permissionSetId);
                insert psa;
            }
    }

    @isTest public static void testPlaygroundCreationFull() {
        User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
        System.runAs(portalUser){
            Test.startTest();
            Playground__c p = cps_PlaygroundWizardStartController.createPlayground('TestPlayground', 'Full Configuration');
            Test.stopTest();

            List<Playground_Job__c> jobs = [SELECT Id FROM Playground_Job__c WHERE Playground__c =: p.Id];
            // Has to return one record
            Playground_Enviroment__c pe = [SELECT Name, Type__c FROM Playground_Enviroment__c WHERE Playground__c =: p.Id AND Type__c =: 'CoE_Org'];
            
            System.assertEquals(p.Name, 'TestPlayground');
            System.assertEquals(p.User__c, portalUser.Id);
            System.assertEquals(!jobs.isEmpty(), true);
            System.assertEquals(16, jobs.size());
            System.assertEquals(pe.Name, 'Copado');
        }
    }
    
    @isTest public static void testPlaygroundCreationFullScratchOrgs() {
      User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
      System.runAs(portalUser){
        Test.startTest();
        Playground__c p = cps_PlaygroundWizardStartController.createPlayground('TestPlayground', 'Full Configuration - Scratch Orgs');
        Test.stopTest();

        List<Playground_Job__c> jobs = [SELECT Id FROM Playground_Job__c WHERE Playground__c =: p.Id];
        // Has to return one record
        Playground_Enviroment__c pe = [SELECT Name, Type__c FROM Playground_Enviroment__c WHERE Playground__c =: p.Id AND Type__c =: 'CoE_Org'];
        List<Playground_Enviroment__c> peScrachOrgList = [SELECT Name, Type__c FROM Playground_Enviroment__c WHERE Playground__c =: p.Id AND Type__c =: 'Scratch_Org'];

        System.assertEquals(p.Name, 'TestPlayground');
        System.assertEquals(p.User__c, portalUser.Id);
        System.assertEquals(!jobs.isEmpty(), true);
        System.assertEquals(16, jobs.size());
        System.assertEquals(pe.Name, 'Copado');
        System.assertEquals(5, peScrachOrgList.size());
      }
    }


    @isTest public static void testPlaygroundCreationLight() {
        User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
        System.runAs(portalUser){
            Test.startTest();
            Playground__c p = cps_PlaygroundWizardStartController.createPlayground('TestPlayground', 'Light Configuration');
            Test.stopTest();

            List<Playground_Job__c> jobs = [SELECT Id FROM Playground_Job__c WHERE Playground__c =: p.Id];
            // Has to return one record
            Playground_Enviroment__c pe = [SELECT Name, Type__c FROM Playground_Enviroment__c WHERE Playground__c =: p.Id AND Type__c =: 'CoE_Org'];
            
            System.assertEquals(p.Name, 'TestPlayground');
            System.assertEquals(p.User__c, portalUser.Id);
            System.assertEquals(!jobs.isEmpty(), true);
            System.assertEquals(7, jobs.size());
            System.assertEquals(pe.Name, 'Copado');
        }
    }

    @isTest static void testPlaygroundCreationWithEmptyName() {
        User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
        System.runAs(portalUser){
            Test.startTest();
            Playground__c p = cps_PlaygroundWizardStartController.createPlayground('','');
            Test.stopTest();

            List<Playground_Job__c> jobs = [SELECT Id FROM Playground_Job__c WHERE Playground__c =: p.Id];

            System.assertEquals(p.Name, '');
            System.assertEquals(p.User__c, portalUser.Id);
            System.assertEquals(!jobs.isEmpty(), true);
        }
    }

    @isTest static void testPlaygroundCreationWithNullName() {
        User portalUser = [SELECT Id FROM User WHERE Email = 'testemail@emailtest.com'];
        System.runAs(portalUser){
            Test.startTest();
            Playground__c p = cps_PlaygroundWizardStartController.createPlayground(null, null);
            Test.stopTest();

            List<Playground_Job__c> jobs = [SELECT Id FROM Playground_Job__c WHERE Playground__c =: p.Id];

            System.assertEquals(p.Name, null);
            System.assertEquals(p.User__c, portalUser.Id);
            System.assertEquals(!jobs.isEmpty(), true);
        }
    }
    @isTest static void testfetchPlaygroundSetting() {
        cps_PlaygroundWizardStartController.fetchPlaygroundSetting();    
    }
}