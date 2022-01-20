@isTest
public class downloadCertifiedLogoImageTest {
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
        User user1 = new User();
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
            user1 = new User(
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
            
            Academy_Certification_Program__c Academy_Certification_Program = new Academy_Certification_Program__c();
            Academy_Certification_Program__c Academy_Certification_ProgramDev = new Academy_Certification_Program__c();
            SYSTEM.runAs(user1){
                Academy_Certification_Program.Name ='Test Administrator';
                Academy_Certification_Program.Copado_Version__c = '10';
                Academy_Certification_Program.Status__c = 'Valid';
                Insert Academy_Certification_Program;
                
                Academy_Certification_ProgramDev.Name ='Test Developer';
                Academy_Certification_ProgramDev.Copado_Version__c = '10';
                Academy_Certification_ProgramDev.Status__c = 'Valid';
                Insert Academy_Certification_ProgramDev;
                
                Academy_Certification_Student__c Academy_Certification_Student = new Academy_Certification_Student__c();
                Academy_Certification_Student.Contact__c = user1.ContactId;
                Academy_Certification_Student.Student_Email__c  = user1.Email;
                Insert Academy_Certification_Student;
                Academy_Certification_Student.Student_Id__c = Academy_Certification_Student.Id;
                Update Academy_Certification_Student;
                
                
                Academy_Certification__c  Academy_Certification = new Academy_Certification__c();
                Academy_Certification.Certification_Program__c = Academy_Certification_Program.Id;
                Academy_Certification.Certification_Student__c = Academy_Certification_Student.Id;
                //Academy_Certification.Certification_Examination__c = Academy_Certification_Examination.Id;
                Academy_Certification.Status__c = 'Valid';
                Insert Academy_Certification;
                
                Academy_Certification_Examination__c Academy_Certification_Examination = new Academy_Certification_Examination__c();
                Academy_Certification_Examination.Certification_Program__c = Academy_Certification_Program.Id;
                Academy_Certification_Examination.Certification_Student__c = Academy_Certification_Student.Id;
                Academy_Certification_Examination.Academy_Certification2__c = Academy_Certification.Id;
                Academy_Certification_Examination.Date__c = System.now();
                Academy_Certification_Examination.Grade__c = 80;
                Academy_Certification_Examination.Status__c = 'Approved';
                Insert Academy_Certification_Examination;
                
                Academy_Certification.Certification_Examination__c = Academy_Certification_Examination.Id;
                Update Academy_Certification;
                
                
                
                
                Academy_Certification__c  Academy_Certification1 = new Academy_Certification__c();
                Academy_Certification1.Certification_Program__c = Academy_Certification_ProgramDev.Id;
                Academy_Certification1.Certification_Student__c = Academy_Certification_Student.Id;
                //Academy_Certification.Certification_Examination__c = Academy_Certification_Examination.Id;
                Academy_Certification1.Status__c = 'Valid';
                Insert Academy_Certification1;

                Academy_Certification__c  Academy_Certification2 = new Academy_Certification__c();
                Academy_Certification2.Certification_Program__c = Academy_Certification_ProgramDev.Id;
                Academy_Certification2.Certification_Student__c = Academy_Certification_Student.Id;
                //Academy_Certification.Certification_Examination__c = Academy_Certification_Examination.Id;
                Academy_Certification2.Status__c = 'Expired';
                Insert Academy_Certification2;

                Academy_Certification_Examination__c Academy_Certification_Examination1 = new Academy_Certification_Examination__c();
                Academy_Certification_Examination1.Certification_Program__c = Academy_Certification_ProgramDev.Id;
                Academy_Certification_Examination1.Certification_Student__c = Academy_Certification_Student.Id;
                Academy_Certification_Examination1.Academy_Certification2__c = Academy_Certification1.Id;
                Academy_Certification_Examination1.Date__c = System.now();
                Academy_Certification_Examination1.Grade__c = 80;
                Academy_Certification_Examination1.Status__c = 'Approved';
                Insert Academy_Certification_Examination1;
                
                Academy_Certification1.Certification_Examination__c = Academy_Certification_Examination.Id;
                Update Academy_Certification1;
                system.debug(Academy_Certification1);
            }
            ContentVersion contentVersion_1 = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            SharingOption = 'A'
            
        );
        insert contentVersion_1;
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = Academy_Certification_Program.Id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
        
        }
    }
    @isTest
    public static void test1(){
        User loggedInUser = [SELECT Id ,FirstName from User WHERE email =: 'new.helloworld@test.com' LIMIT 1];
        system.assertNotEquals(null,loggedInUser.Id, 'system admin user not found in system.');
        User PortalUser = [SELECT Id ,Email,contactId,FirstName from User WHERE email =: 'test12345@test.com' LIMIT 1];
        system.assertNotEquals(null,PortalUser.Id, 'Portal user not found in system.');
        Test.startTest();
        system.runAs(PortalUser){
            downloadCertifiedLogoImage.checkUserIsCertified();
            downloadCertifiedLogoImage.downloadCertificate();
        }
        //system.assertNotEquals(null,ctrl, 'CommunityContactUpdateSchedulerClass controller instance is null.');
        Test.stopTest();
    }
    
}