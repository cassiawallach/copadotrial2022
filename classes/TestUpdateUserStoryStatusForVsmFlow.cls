@IsTest
public class TestUpdateUserStoryStatusForVsmFlow {
    @testSetup static void setup() {      
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Copado Admin'];
        User user = new User(Alias = 'newUser', Email='newuser666@copadoAPOproduct.com',
                             EmailEncodingKey='UTF-8', LastName='Jeldrik', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = p.Id, FirstName='Jeldrik',
                             TimeZoneSidKey='America/Los_Angeles', UserName='newuser666@copadoAPOproduct.com');
        insert user;
        
        
        
        copado__Sprint__c mySprint2 = new copado__Sprint__c();
        mySprint2.Name = 'Sprint1';
        insert mySprint2;
        
        copado__Project__c project = TestDataFactory.createProject('Test');
        copado__Theme__c theme = TestDataFactory.createTheme('Test');
        Module__c module = TestDataFactory.createModule('Test');
        
        Id recordTypeIdUserStory = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
        copado__User_Story__c myUserStory = new copado__User_Story__c();
        myUserStory.copado__User_Story_Title__c = 'UserStoryTest1';
        myUserStory.copado__Status__c = 'Draft';
        myUserStory.copado__Project__c = project.Id;
        myUserStory.copado__Theme__c = theme.Id;
        myUserStory.Module__c = module.Id;
        myUserStory.RecordTypeId = recordTypeIdUserStory;
        insert myUserStory;
        
        PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name='Scrum_Master'];
        System.runAs(user) {
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permissionSet.Id, AssigneeId = user.Id);
            insert psa;
        }
        
    }
    
    @IsTest
    static void testUserStoryMovedToSprint() {
        copado__Sprint__c createdSprint = [SELECT Id FROM copado__Sprint__c WHERE Name = 'Sprint1'];
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        
        User user = [SELECT Id FROM user WHERE email = 'newuser666@copadoAPOproduct.com'];
        System.runAs(user) 
        {
            createdUserStory.copado__Sprint__c = createdSprint.Id;
            createdUserStory.Documentation_Completed__c = 'Completed';
            update createdUserStory;
        }
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('Ready for Development', assertUserStory.copado__Status__c);
    }
    
    @IsTest
    static void testInvestigationMovedToSprint() {
        copado__Sprint__c createdSprint = [SELECT Id FROM copado__Sprint__c WHERE Name = 'Sprint1'];
        Id recordTypeIdInvestigation = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('Investigation').getRecordTypeId();
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        
        User user = [SELECT Id FROM user WHERE email = 'newuser666@copadoAPOproduct.com'];
        System.runAs(user) 
        {
            createdUserStory.copado__Sprint__c = createdSprint.Id;
            createdUserStory.RecordTypeId = recordTypeIdInvestigation;
            update createdUserStory;
        }
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('Ready for Investigation', assertUserStory.copado__Status__c);
    }
    
    @IsTest
    static void testBugMovedToSprint() {
        copado__Sprint__c createdSprint = [SELECT Id FROM copado__Sprint__c WHERE Name = 'Sprint1'];
        Id recordTypeIdBug = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('Bug').getRecordTypeId();
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        
        User user = [SELECT Id FROM user WHERE email = 'newuser666@copadoAPOproduct.com'];
        System.runAs(user) 
        {
            createdUserStory.copado__Sprint__c = createdSprint.Id;
            createdUserStory.RecordTypeId = recordTypeIdBug;
            createdUserStory.Documentation_Completed__c = 'Completed';
            update createdUserStory;
        }
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('Ready for Development', assertUserStory.copado__Status__c);
    }   
    
    @IsTest
    static void testBugMovedToSprintAndStatusChanged() {
        copado__Sprint__c createdSprint = [SELECT Id FROM copado__Sprint__c WHERE Name = 'Sprint1'];
        Id recordTypeIdBug = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('Bug').getRecordTypeId();
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        
        User user = [SELECT Id FROM user WHERE email = 'newuser666@copadoAPOproduct.com'];
        System.runAs(user) 
        {
            createdUserStory.copado__Sprint__c = createdSprint.Id;
            createdUserStory.RecordTypeId = recordTypeIdBug;
            createdUserStory.copado__Status__c = 'Completed';
            createdUserStory.Documentation_Completed__c = 'Completed';
            update createdUserStory;
        }
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('Completed', assertUserStory.copado__Status__c);
    } 
}