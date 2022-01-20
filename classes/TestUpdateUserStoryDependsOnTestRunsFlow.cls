@IsTest
public class TestUpdateUserStoryDependsOnTestRunsFlow {
    @testSetup static void setup() {      
        Profile p = [SELECT Id FROM Profile WHERE Name='Copado Admin']; 
        PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name='Scrum_Master'];
        
        User user = new User(Alias = 'newUser', Email='newuser666@copadoAPOproduct.com',
                             EmailEncodingKey='UTF-8', LastName='Jeldrik', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = p.Id, FirstName='Jeldrik',
                             TimeZoneSidKey='America/Los_Angeles', UserName='newuser666@copadoAPOproduct.com');
        insert user;
        
        System.runAs(user) {
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permissionSet.Id, AssigneeId = user.Id);
            insert psa;
        }

        List<User> users = new List<User>();
        for(Integer i=1;i<3;i++) {
            users.add(new User(Alias = 'User'+i, Email='user'+i+'@testorg.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='user'+i+System.now().getTime()+'@testorg.com'));
        }
        
        insert users; 
        User user1 = [SELECT Id FROM User WHERE Alias = 'User1'];
        
        System.runAs(user) 
        {
            Id recordTypeIdUserStory = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
            copado__User_Story__c myUserStory = new copado__User_Story__c();
            myUserStory.copado__User_Story_Title__c = 'UserStoryTest1';
            myUserStory.copado__Status__c = 'Draft';
            myUserStory.RecordTypeId = recordTypeIdUserStory;
            myUserStory.copado__Story_Points_Other__c = 2;
            myUserStory.copado__Story_Points_SFDC__c = 2;
            myUserStory.copado__Pull_Requests_Approved__c  = true;
            myUserStory.copado__Apex_Tests_Passed__c = true;
            myUserStory.copado__Manual_Tests_Passed__c  = true;
            myUserStory.copado__Documentation_Complete__c  = true;
            myUserStory.copado__Pull_Requests_Approved__c  = true;
            myUserStory.Module__c = TestDataFactory.createModule('TestModule').Id;
            myUserStory.copado__Theme__c = TestDataFactory.createTheme('TestTheme').Id;
            myUserStory.copado__Project__c = TestDataFactory.createProject('TestProject').Id;
            myUserStory.copado__Sprint__c = TestDataFactory.createSprint('TestSprint').Id;
            myUserStory.Documentation_Completed__c = 'Completed';
            insert myUserStory;
        }
        
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        copado__Test_Script__c testScript = new copado__Test_Script__c();
        testScript.copado__User_Story__c = createdUserStory.Id;
        insert testScript;       
        
        copado__Test_Script__c createdTestScript = [SELECT Id FROM copado__Test_Script__c WHERE copado__User_Story__c = :createdUserStory.Id];
        
        copado__Test_Script_Step__c step = new copado__Test_Script_Step__c();
        step.copado__Test_Script__c = createdTestScript.Id;
        insert step; 
        
        copado__Test_Run__c testRun1 = new copado__Test_Run__c();
        testRun1.copado__Status__c = 'Ready for testing';
        testRun1.copado__Type__c = 'Usability';
        testRun1.copado__Test_Phase__c = 'Developer';
        testRun1.copado__Tester__c = user1.Id;
        testRun1.copado__Test_Script__c = createdTestScript.Id;
        testRun1.copado__User_Story__c = createdUserStory.Id;
        insert testRun1; 
        
        User user2 = [SELECT Id FROM User WHERE Alias = 'User2'];
        copado__Test_Run__c testRun2 = new copado__Test_Run__c();
        testRun2.copado__Status__c = 'Ready for testing';
        testRun2.copado__Type__c = 'Usability';
        testRun2.copado__Test_Phase__c = 'Developer';
        testRun2.copado__Tester__c = user2.Id;
        testRun2.copado__Test_Script__c = createdTestScript.Id;
        testRun2.copado__User_Story__c = createdUserStory.Id;
        insert testRun2;
        
    }
    
    @IsTest
    static void testOneTestInProgress() {
        User user1 = [SELECT Id FROM User WHERE Alias = 'User1'];
        copado__Test_Run__c createdTestRun = [SELECT Id FROM copado__Test_Run__c WHERE copado__Tester__c = :user1.Id];
        createdTestRun.copado__Status__c = 'In Progress';
        update createdTestRun;
        
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('Testing in Progress', assertUserStory.copado__Status__c);
    }
    
    @IsTest
    static void testAllTestPassed() {
        User user1 = [SELECT Id FROM User WHERE Alias = 'User1'];
        copado__Test_Run__c createdTestRun1 = [SELECT Id FROM copado__Test_Run__c WHERE copado__Tester__c = :user1.Id];
        createdTestRun1.copado__Status__c = 'Passed';
        update createdTestRun1;
        
        User user2 = [SELECT Id FROM User WHERE Alias = 'User2'];
        copado__Test_Run__c createdTestRun2 = [SELECT Id FROM copado__Test_Run__c WHERE copado__Tester__c = :user2.Id];
        createdTestRun2.copado__Status__c = 'Passed with comments';
        update createdTestRun2;
        
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Manual_Tests_Passed__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals(true, assertUserStory.copado__Manual_Tests_Passed__c);
    }
    
    @IsTest
    static void testOneTestPassed() {     
        User user1 = [SELECT Id FROM User WHERE Alias = 'User1'];
        copado__Test_Run__c createdTestRun1 = [SELECT Id FROM copado__Test_Run__c WHERE copado__Tester__c = :user1.Id];
        createdTestRun1.copado__Status__c = 'Passed';
        update createdTestRun1;
        
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('Draft', assertUserStory.copado__Status__c);
    }
    
    @IsTest
    static void testOneTestDeleted() {     
        User user1 = [SELECT Id FROM User WHERE Alias = 'User1'];
        copado__Test_Run__c createdTestRun1 = [SELECT Id FROM copado__Test_Run__c WHERE copado__Tester__c = :user1.Id];
        delete createdTestRun1;
        
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('Draft', assertUserStory.copado__Status__c);
    }
    
    @IsTest
    static void testOneTestInProgressAndUserStoryCancelled() {
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        createdUserStory.copado__Status__c = 'Cancelled';
        createdUserStory.copado__Cancellation_Reason__c = 'Testing';
        update createdUserStory;
        
        User user1 = [SELECT Id FROM User WHERE Alias = 'User1'];
        copado__Test_Run__c createdTestRun = [SELECT Id FROM copado__Test_Run__c WHERE copado__Tester__c = :user1.Id];
        createdTestRun.copado__Status__c = 'In Progress';
        update createdTestRun;
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('Cancelled', assertUserStory.copado__Status__c);
    }
    
    @IsTest
    static void testOneTestInProgressAndUserStoryReleased() {
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        createdUserStory.copado__Status__c = 'Released';
        update createdUserStory;
        
        User user1 = [SELECT Id FROM User WHERE Alias = 'User1'];
        copado__Test_Run__c createdTestRun = [SELECT Id FROM copado__Test_Run__c WHERE copado__Tester__c = :user1.Id];
        createdTestRun.copado__Status__c = 'In Progress';
        update createdTestRun;
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('Released', assertUserStory.copado__Status__c);
    }
}