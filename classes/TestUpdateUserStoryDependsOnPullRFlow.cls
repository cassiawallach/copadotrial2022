@IsTest
public class TestUpdateUserStoryDependsOnPullRFlow {
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
        
		System.runAs(user) {
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
            copado__Pull_Request__c pullRequest = new copado__Pull_Request__c();
            pullRequest.copado__User_Story__c = createdUserStory.Id;
            pullRequest.copado__State__c = 'Opened';
            insert pullRequest; 
    }
    
    @IsTest
    static void testPullRequestMerged() {     
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        copado__Pull_Request__c createdPullRequest = [SELECT Id FROM copado__Pull_Request__c WHERE copado__User_Story__c = :createdUserStory.Id];
        createdPullRequest.copado__State__c = 'Merged';
        update createdPullRequest;
        
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Pull_Requests_Approved__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals(true, assertUserStory.copado__Pull_Requests_Approved__c);
    }
    
    @IsTest
    static void testPullRequestNotMerged() {     
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        copado__Pull_Request__c createdPullRequest = [SELECT Id FROM copado__Pull_Request__c WHERE copado__User_Story__c = :createdUserStory.Id];
        createdPullRequest.copado__State__c = 'Not Merged';
        update createdPullRequest;
        
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('Draft', assertUserStory.copado__Status__c);
    }
}