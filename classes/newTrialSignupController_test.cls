@isTest
public with sharing class newTrialSignupController_test {

    @testSetup static void setup(){
        Id communityProfileId = [SELECT Id FROM Profile WHERE Name = 'CUSTOM Customer Community Login User'].Id;
        Id permissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Community_Playground_User'].Id;

        Account account = new Account(Name='Copado, Inc.') ;
        insert account; 
       
        Contact contact = new Contact(FirstName='John', LastName='Doe', Email='john.doe@copado.com', AccountId=account.Id);
        insert contact;
                  
        User user = new User(FirstName=contact.FirstName, LastName=contact.LastName, Email=contact.Email, CompanyName=account.Name, ContactId=contact.Id,
                                Alias='myalias', IsActive=true, 
                                EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId=communityProfileId, Country='US',
                                TimezoneSidKey='America/Los_Angeles', Username='demo1734@rand3141592654.abc.def');
        insert user;
        User currentUser = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        
        System.runAs(currentUser){
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = permissionSetId);
            insert psa;
        }
    }

    static testMethod void getUserInfo() {
        User u = newTrialSignupController.getUserInfo();
        system.assertEquals(UserInfo.getUserId(), u.Id);
    }
    static testMethod void getSignupRequest() {
        Signup_Request__c sr = new Signup_Request__c();
        sr.First_Name__c = 'John';
        sr.Last_Name__c = 'Doe';
        sr.Company__c = 'Copado, Inc.';
        sr.Country__c = 'US';
        sr.Email__c = 'john.doe@copado.com';
        sr.Username__c = 'jon.doe@copado.com.test';
        sr.Template__c = '0TT1i00000269iK';
        insert sr;

        test.startTest();
        Signup_Request__c result = newTrialSignupController.getSignupRequest(sr.Id);
        system.assertEquals(sr.Id, result.Id);
        system.assertEquals('New', result.Status__c); //default status;
        test.stopTest();
    }
    static testMethod void createSignupRequest_goodUserName() {
        User portalUser = [select Id, FirstName, LastName, Email, CompanyName, Country, ContactId from User where Email='john.doe@copado.com'];
        System.runAs(portalUser){
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
            List<Playground_Job__c> jobs = cps_PlaygroundWizardInstallController.GetPlaygroundJobs(playground.Id);
            
            String username = generateRandomString(10) + '@company.com';
            String domain = 'testdomain';
            String country = 'US';

            test.startTest();
            newTrialSignupController.createSignupRequest(username, domain, country, playground.Id);
            test.stopTest();
            Signup_Request__c result = getSignupRequestResult();
            system.assertNotEquals(null, result.Id);
            system.assertEquals('New', result.Status__c);
            system.assertEquals(portalUser.FirstName, result.First_Name__c);
            system.assertEquals(portalUser.LastName, result.Last_Name__c);
            system.assertEquals(portalUser.Email, result.Email__c);
            system.assertEquals(username.toLowerCase(), result.Username__c);
            system.assertEquals(portalUser.CompanyName, result.Company__c);
            system.assertEquals(portalUser.Id, result.User__c);
            system.assert( result.Domain__c.length()<=33 );
            system.assert( result.Template__c.startsWith('0TT') );
            
            portalUser = [select Id, Country from User where Email='john.doe@copado.com'];
            system.assertEquals(country, portalUser.Country);
        }
    }
    static testMethod void createSignupRequest_baddomain() {
        User portalUser = [select Id, FirstName, LastName, Email, CompanyName, Country, ContactId from User where Email='john.doe@copado.com'];
        System.runAs(portalUser){
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
            List<Playground_Job__c> jobs = cps_PlaygroundWizardInstallController.GetPlaygroundJobs(playground.Id);
            
            String username = generateRandomString(10) + '@company.com';
            String domain = 'test     domain';
            String country = 'US';

            test.startTest();
            try {
                newTrialSignupController.createSignupRequest(username, domain, country, playground.Id);
            }
            catch(Exception e) {
                String expectedException = 'Invalid Subdomain. Select a name that does not contain double hyphens, spaces, end in a hyphen, include restricted words (e.g. sfdc) or exceed 22 characters.';
                system.assertEquals(expectedException, e.getMessage());
            }
            test.stopTest();
            try {
            	Signup_Request__c result = getSignupRequestResult();
            }
            catch(Exception e){
                //record should not have saved.
                system.assertEquals('List has no rows for assignment to SObject', e.getMessage());
            }
        }
    }
    static testMethod void createSignupRequest_badUsername() {
        User portalUser = [select Id, FirstName, LastName, Email, CompanyName, Country, ContactId from User where Email='john.doe@copado.com'];
        System.runAs(portalUser){
            Playground__c playground = cps_PlaygroundWizardStartController.createPlayground('Test Playground', 'Full Configuration');
            List<Playground_Job__c> jobs = cps_PlaygroundWizardInstallController.GetPlaygroundJobs(playground.Id);
            
            String username = 'company.com';
            String domain = 'testdomain';
            String country = 'US';

            test.startTest();
            try {
                newTrialSignupController.createSignupRequest(username, domain, country, playground.Id);
            }
            catch(Exception e) {
                String expectedException = 'The username provided is not in a valid email address format.  Please see the example provided in the help text.';
                system.assertEquals(expectedException, e.getMessage());
            }
            test.stopTest();
            try {
            	Signup_Request__c result = getSignupRequestResult();
            }
            catch(Exception e){
                //record should not have saved.
                system.assertEquals('List has no rows for assignment to SObject', e.getMessage());
            }
        }
    }

    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    private static Signup_Request__c getSignupRequestResult() {
        return [select Id, First_Name__c, Last_Name__c, Email__c, Company__c, User__c, Country__c, Domain__c, Username__c, Status__c, Template__c from Signup_Request__c limit 1];
    }
}