@IsTest
public class TestUserStoryChangesProcessBuilder {
    @testSetup static void setup() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Copado Admin']; 
        List<User> users = new List<User>();
        for(Integer i=0;i<2;i++) {
            users.add(new User(Alias = 'User'+i, Email='user'+i+'@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='user'+i+System.now().getTime()+'@testorg.com'));
        }
        insert users;       
        
        copado__User_Story__c myUserStory = new copado__User_Story__c();
        myUserStory.copado__User_Story_Title__c = 'UserStoryTest1';
        myUserStory.copado__Status__c = 'Draft';
        insert myUserStory;
    }
    
    @IsTest
    static void testStatusChanged() {
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        createdUserStory.copado__Status__c = 'Completed';
        update createdUserStory;
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Progress__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals(100, assertUserStory.copado__Progress__c);
    }
    
    @IsTest
    static void testDeveloperChanged() {
        copado__User_Story__c createdUserStory = [SELECT Id, OwnerId FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        User user = [SELECT Id FROM User WHERE Alias = 'User1'];
        
        createdUserStory.copado__Developer__c = user.Id;
        update createdUserStory;
        
        copado__User_Story__c assertUserStory = [SELECT Id, OwnerId FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals(user.Id, assertUserStory.OwnerId);
    }
    
    @IsTest
    static void testsubtaskStatusChanged() {
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        
        Id recordTypeIdUserStory = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('Subtask').getRecordTypeId();
        List<copado__User_Story__c> subtasks = new List<copado__User_Story__c>();
        for(Integer i=0;i<2;i++) {
            copado__User_Story__c subtask = new copado__User_Story__c();
        	subtask.copado__User_Story_Title__c = 'Subtask'+i;
        	subtask.copado__Status__c = 'Draft';
            subtask.RecordTypeId = recordTypeIdUserStory;
            subtask.Parent_User_Story__c = createdUserStory.Id;
            subtasks.add(subtask);
        }
        insert subtasks; 
        
        //Update one subtask to in progress
        copado__User_Story__c firstSubtask = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'Subtask0'];
        firstSubtask.copado__Status__c = 'Development In Progress';
        update firstSubtask;
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        System.assertEquals('Development In Progress', assertUserStory.copado__Status__c);
    }
}