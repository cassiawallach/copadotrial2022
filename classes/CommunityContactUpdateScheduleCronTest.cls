@isTest
public class CommunityContactUpdateScheduleCronTest {

     @testSetup
    public static void setupMethod(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'ewrwertest2@test.com',
            Alias = 'batman',
            Email='new.helloworld@test.com',
            EmailEncodingKey='UTF-8',
            Firstname='test',
            Lastname='test',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        system.assertNotEquals(null,portalAccountOwner1.Id, 'System Administrator User can not created.');
        
        System.runAs ( portalAccountOwner1 ) {
            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
            system.assertNotEquals(null,portalAccount1.Id, 'Account can not created.');
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            system.assertNotEquals(null,contact1.Id, 'Contact can not created.');
            
            //Create Portal user
            Profile portalProfile = [SELECT Id FROM Profile where name='CUSTOM Community Guest Login' Limit 1];
            system.assertNotEquals(null,portalProfile.Id, 'CUSTOM Community Guest Login Profile not found in system.');
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
            system.assertNotEquals(null,user1.Id, 'Portal user not created.');
        }
    }
    static testMethod void testCronHandler(){
        User loggedInUser = [SELECT Id ,FirstName from User WHERE email =: 'new.helloworld@test.com' LIMIT 1];
        system.assertNotEquals(null,loggedInUser.Id, 'system admin user not found in system.');
        User u = [SELECT Id ,FirstName from User WHERE email =: 'test12345@test.com' LIMIT 1];
        system.assertNotEquals(null,u.Id, 'Portal user not found in system.');
        u.FirstName = 'testfirst';
        u.LastName ='testLast';
        u.Title = 'MR.';
        u.email = 'testnew@gmail.com';
        u.Street = 'street';
        u.City = 'city';
        u.State = 'state';
        u.Country = 'US';
        u.PostalCode = '432434';
        system.runAs(loggedInUser){
            update u;
        }
        Test.startTest();
        system.assertEquals('432434',u.PostalCode, 'Portal user not update.');
        CommunityContactUpdateScheduleCron ctrl = new CommunityContactUpdateScheduleCron();
        system.assertNotEquals(null,ctrl, 'CommunityContactUpdateScheduleCron controller instance is null.');
        Test.stopTest();
    }
    
}