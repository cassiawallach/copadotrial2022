@isTest
public class TrainingConsoleTest {
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
            
            // create an achievement
            redwing__Achievement__c badge = new redwing__Achievement__c();
            badge.Name = 'test badge';
            badge.redwing__Type__c = 'Achievements';
            badge.ReputationPoints__c = 3;
            insert badge;
            
            //create an achievement assginment 
            redwing__Achievement_Assignment__c badgea = new redwing__Achievement_Assignment__c();
            badgea.redwing__User__c = user1.Id;
            badgea.redwing__Achievement__c  = badge.Id;
            badgea.redwing__Status__c = 'Eligible';
            insert badgea;
            badgea.redwing__Status__c = 'Acquired';
            update badgea;
            
            NetworkMember nw = [SELECT Id, ReputationPoints FROM NetworkMember WHERE MemberId = :user1.Id];
            System.assertEquals(4, nw.ReputationPoints);
            
            User loggedInUser = [SELECT Id ,FirstName from User WHERE email =: 'new.helloworld@test.com' LIMIT 1];
            system.assertNotEquals(null,loggedInUser.Id, 'system admin user not found in system.');
            User PortalUser = [SELECT Id ,Email,contactId,FirstName from User WHERE email =: 'test12345@test.com' LIMIT 1];
            system.assertNotEquals(null,PortalUser.Id, 'Portal user not found in system.');
            contact conObj = [select id, email from contact where LastName='McTesty' LIMIT 1];
            
            
            Academy_Certification_Program__c Academy_Certification_Program = new Academy_Certification_Program__c();
            Academy_Certification_Program.Name ='Test Administrator';
            Academy_Certification_Program.Copado_Version__c = '10';
            Academy_Certification_Program.Status__c = 'Valid';
            Insert Academy_Certification_Program;
            
            Academy_Certification_Student__c Academy_Certification_Student = new Academy_Certification_Student__c();
            Academy_Certification_Student.Contact__c = PortalUser.ContactId;
            Academy_Certification_Student.Student_Email__c  = PortalUser.Email;
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
            system.debug(Academy_Certification);
            
            Product2 Product = new Product2();
            Product.Name = 'Test Product';
            Product.ProductCode = 'TEST001';
            Product.IsActive = TRUE;
            Product.SBQQ__DefaultQuantity__c = 1000;
            INSERT Product;
            
            redwing__Training_Track__c Training_Track = new redwing__Training_Track__c();
            Training_Track.Name = 'Test Developer';
            Training_Track.redwing__Status__c ='Active';
            Training_Track.ltcomm__Product__c = Product.Id;
            Training_Track.redwing__Enable_all_internal_users__c = TRUE;
            Training_Track.redwing__Enable_all_external_accounts__c = TRUE;
            Training_Track.redwing__Language__c ='en_US';
            INSERT Training_Track;
            
            redwing__Training_Track_Level__c Training_Track_Level = NEW redwing__Training_Track_Level__c();
            Training_Track_Level.Name = 'Test Developer';
            Training_Track_Level.redwing__Training_Track__c = Training_Track.Id;
            INSERT Training_Track_Level;
            
            redwing__Training_Plan__c Training_Plan = new redwing__Training_Plan__c();
            Training_Plan.Name = 'Test TrainingPlan';
            Training_Plan.redwing__Status__c = 'Active';
            Training_Plan.Is_Certification_Plan__c = TRUE;
            INSERT Training_Plan;
            
            redwing__Training_Track_Assignment__c Training_Track_Assignment = NEW redwing__Training_Track_Assignment__c();
            Training_Track_Assignment.redwing__User__c = UserInfo.getUserId();
            Training_Track_Assignment.redwing__Contact__c = conObj.Id;
            Training_Track_Assignment.redwing__Status__c = 'In Progress';
            Training_Track_Assignment.redwing__Training_Track__c = Training_Track.Id;
            INSERT Training_Track_Assignment;
            
            redwing__Training_Plan_Assignment__c Training_Plan_Assignment = NEW redwing__Training_Plan_Assignment__c();
            Training_Plan_Assignment.redwing__User__c = UserInfo.getUserId();
            Training_Plan_Assignment.redwing__Contact__c = conObj.Id;
            Training_Plan_Assignment.redwing__Training_Plan__c = Training_Plan.Id;
            Training_Plan_Assignment.redwing__Status__c = 'In Progress';
            Training_Plan_Assignment.redwing__Progress_Percentage__c =  0.00;
            INSERT Training_Plan_Assignment;
            
            redwing__Training_Track_Level_Item__c Training_Track_Level_Item = NEW redwing__Training_Track_Level_Item__c();
            Training_Track_Level_Item.redwing__Training_Track_Level__c = Training_Track_Level.Id;
            Training_Track_Level_Item.redwing__Training_Plan__c = Training_Plan.Id;
            INSERT Training_Track_Level_Item;
            
            redwing__Learning__c Learning = new redwing__Learning__c();
            Learning.Name   = 'Test Learning';
            Learning.redwing__Published__c = true;
            INSERT Learning;
            
            redwing__Learning__c ILTEvent_Learning = new redwing__Learning__c();
            ILTEvent_Learning.Name   = 'Test Event Learning';
            ILTEvent_Learning.redwing__Published__c = true;
            ILTEvent_Learning.RecordTypeId =  Schema.SObjectType.redwing__Learning__c.getRecordTypeInfosByDeveloperName().get('ILT_Event').getRecordTypeId();
            INSERT ILTEvent_Learning;
            
            redwing__ILT_Event__c ILT_Event = new redwing__ILT_Event__c();
            ILT_Event.redwing__Learning__c = ILTEvent_Learning.Id;
            ILT_Event.Name = 'ILT Event';
            Insert ILT_Event;
            
            redwing__Learning__c ILTClass_Learning = new redwing__Learning__c();
            ILTClass_Learning.Name   = 'Test Class Learning';
            ILTClass_Learning.redwing__Published__c = true;
            ILTClass_Learning.RecordTypeId =  Schema.SObjectType.redwing__Learning__c.getRecordTypeInfosByDeveloperName().get('ILT').getRecordTypeId();
            INSERT ILTClass_Learning;
            
            redwing__ILT_Event_Class__c ILT_Event_class = new redwing__ILT_Event_Class__c();
            ILT_Event_class.redwing__ILT_Event__c = ILT_Event.Id;
            ILT_Event_class.redwing__Learning__c = ILTClass_Learning.Id;
            Insert ILT_Event_class;
            
            redwing__ILT_Class__c ILT_Class = new redwing__ILT_Class__c();
            ILT_Class.redwing__Learning__c = ILTClass_Learning.Id;
            ILT_Class.Name = 'ILT Class';
            ILT_Class.redwing__Start_Date__c = system.today();
            ILT_Class.redwing__End_Date__c = system.today().addDays(10);
            Insert ILT_Class;
            
            redwing__ILT_Session__c ILT_Session = new redwing__ILT_Session__c();
            ILT_Session.redwing__ILT_Class__c = ILT_Class.Id;
            ILT_Session.CurrencyIsoCode = 'USD';
            ILT_Session.redwing__Date__c = system.today();
            ILT_Session.redwing__ILT_Class__c = ILT_Class.Id;
            ILT_Session.Name = 'Test Session';
            ILT_Session.redwing__Type__c = 'ILT';
            //Insert ILT_Session;
           
            
            
                
                
            redwing__Training_Plan_Section__c Training_Plan_Section = NEW redwing__Training_Plan_Section__c();
            Training_Plan_Section.Name = 'Test';
            Training_Plan_Section.redwing__Training_Plan__c =Training_Plan.Id;
            INSERT Training_Plan_Section;
            
            redwing__Training_Plan_Section_Assignment__c Training_Plan_Section_Assignment = NEW redwing__Training_Plan_Section_Assignment__c();
            Training_Plan_Section_Assignment.redwing__User__c = UserInfo.getUserId();
            Training_Plan_Section_Assignment.redwing__Status__c = 'In Progress';
            Training_Plan_Section_Assignment.redwing__Training_Plan_Section__c = Training_Plan_Section.Id;
            Training_Plan_Section_Assignment.redwing__Training_Plan_Assignment__c= Training_Plan_Assignment.Id;
            INSERT Training_Plan_Section_Assignment;
            
            redwing__Training_Plan_Section_Item__c Training_Plan_Section_Item = NEW redwing__Training_Plan_Section_Item__c();
            Training_Plan_Section_Item.redwing__Learning__c = Learning.Id;
            Training_Plan_Section_Item.redwing__Training_Plan_Section__c = Training_Plan_Section.Id;
            INSERT Training_Plan_Section_Item;
            
            redwing__Learning_Assignment__c Learning_Assignment = NEW redwing__Learning_Assignment__c();
            Learning_Assignment.redwing__Contact__c = conObj.Id;
            Learning_Assignment.redwing__User__c = UserInfo.getUserId();
            Learning_Assignment.redwing__Progress__c = '';
            Learning_Assignment.redwing__Progress_Percentage__c = 0.00;
            Learning_Assignment.redwing__Evaluation_Times_Taken__c = 0;
            Learning_Assignment.redwing__Evaluation_Result__c = 'N/A';  
            Learning_Assignment.redwing__Progress__c = 'In Progress';
            Learning_Assignment.redwing__Training_Plan__c = Training_Plan.Id;
            Learning_Assignment.redwing__Learning__c = Learning.Id;
            Learning_Assignment.redwing__Training_Plan_Section__c = Training_Plan_Section.Id;
            Learning_Assignment.redwing__Training_Plan_Section_Assignment__c =Training_Plan_Section_Assignment.Id;
            Learning_Assignment.redwing__Training_Plan_Section_Item__c = Training_Plan_Section_Item.Id;
            Learning_Assignment.redwing__Times_Launched__c =1;
            Learning_Assignment.redwing__Evaluation_Score__c =1; 
            INSERT Learning_Assignment;
            
            redwing__ILT_Roster__c ILT_Roster = new redwing__ILT_Roster__c();
            ILT_Roster.redwing__ILT_Class__c = ILT_Class.Id;
            ILT_Roster.redwing__Attended__c = true;
            ILT_Roster.redwing__Registered_Date__c = system.today();
            ILT_Roster.redwing__ILT_Session__c = ILT_Session.Id;
            ILT_Roster.redwing__Learning_Assignment__c = Learning_Assignment.Id;
            ILT_Roster.redwing__User__c = PortalUser.Id;
            INSERT ILT_Roster;
            
             
            redwing__Prerequisite__c Prerequisite = new redwing__Prerequisite__c();
            Prerequisite.redwing__Active__c = true;
            Prerequisite.CurrencyIsoCode = 'USD';
            Prerequisite.Name = 'test PreRequisite';
            Insert Prerequisite;
            
            redwing__Prerequisite_Item__c Prerequisite_Item = new redwing__Prerequisite_Item__c();
            Prerequisite_Item.redwing__Achievement__c = badge.Id;
            Prerequisite_Item.CurrencyIsoCode = 'USD';
            Prerequisite_Item.redwing__Learning__c = ILTEvent_Learning.Id;
            Prerequisite_Item.Name = 'test badge';
            Prerequisite_Item.redwing__Prerequisite__c = Prerequisite.Id;
            Prerequisite_Item.redwing__Required_Status__c = 'Eligible';
            Insert Prerequisite_Item;
            
            redwing__Learning_Prerequisite__c Learning_Prerequisite = NEW redwing__Learning_Prerequisite__c();
            Learning_Prerequisite.redwing__Achievement__c = badge.Id;
            Learning_Prerequisite.CurrencyIsoCode = 'USD';
            Learning_Prerequisite.redwing__Learning__c = ILTEvent_Learning.Id;
            Learning_Prerequisite.redwing__Training_Plan__c = Training_Plan.Id;
            Learning_Prerequisite.redwing__Training_Track__c = Training_Track.Id;
            Learning_Prerequisite.redwing__Prerequisite__c = Prerequisite.Id;
            Insert Learning_Prerequisite;
            
            Learning_Assignment.redwing__Evaluation_Times_Taken__c = 2;
            Learning_Assignment.redwing__Evaluation_Result__c = 'Failed';
            UPDATE Learning_Assignment;
            
            cps_PlaygroundWizardStartControllerTest.setup();
            copado__Org__c o = new copado__Org__c(
                Name = 'TestOrg',
                copado__SFDC_Org_ID__c = '00Df4000003AqJXEA0_0050N000007nP8CQAU_3',
                copado__Org_Type__c = 'Production/Developer'
            );
            insert o;
            String orgId = o.Id;
            List<Playground__c> pgs = new List<Playground__c>();
            pgs.add(new Playground__c(Name = 'Test Playground',Status__c='Activated', Org_Credential__c = orgId, User__c = PortalUser.Id));
            pgs.add(new Playground__c(Name = 'Test Playground1',Status__c='Activated', Org_Credential__c = orgId, User__c = PortalUser.Id));
            insert pgs;
        }
    }
    @isTest
    public static void testTrainingConsole(){
        
        list<redwing__ILT_Event__c> ILT_events=  TrainingConsole.getAllILTEvents();
        TrainingConsole.getPrerequistiteItemsByLearningId(ILT_events.get(0).redwing__Learning__c);
        TrainingConsole.GetILTCLassesByEventId(ILT_events.get(0).Id);
        User PortalUser = [SELECT Id ,Email,contactId,FirstName from User WHERE email =: 'test12345@test.com' LIMIT 1];
            system.assertNotEquals(null,PortalUser.Id, 'Portal user not found in system.');
        List<String> userIds = new list<String>();
        userIds.add(PortalUser.Id);
        TrainingConsole.getPlaygroundsListByUserIds(Json.serialize(userIds));
    }
}