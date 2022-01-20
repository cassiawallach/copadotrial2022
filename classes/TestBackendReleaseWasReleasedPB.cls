@IsTest
public class TestBackendReleaseWasReleasedPB {
	@testSetup static void setup() {      
        copado__Release__c release1 = new copado__Release__c();
        release1.Name = 'DemoTestParent';
        release1.copado__Status__c = 'Planned';
        insert release1;
        
        copado__Deployment_Flow__c flow = new copado__Deployment_Flow__c();
        flow.Name = 'TestFlow';
        insert flow;
        
        copado__Deployment_Flow__c createdFlow = [SELECT Id FROM copado__Deployment_Flow__c WHERE Name = 'TestFlow'];
        
        copado__Project__c project = new copado__Project__c();
        project.Name = 'ProjectTest';
        project.copado__Deployment_Flow__c = createdFlow.Id;
        insert project;
        
        copado__Release__c createdParentRelease = [SELECT Id FROM copado__Release__c WHERE Name = 'DemoTestParent'];
        copado__Release__c release2 = new copado__Release__c();
        release2.Name = 'DemoTestChild';
        release2.copado__Status__c = 'Planned';
        release2.Parent_Release__c = createdParentRelease.Id;
        insert release2;
        
        copado__Project__c createdProject = [SELECT Id FROM copado__Project__c WHERE Name = 'ProjectTest'];
        
        Id recordTypeIdUserStory = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
        copado__User_Story__c myUserStory1 = new copado__User_Story__c();
        myUserStory1.copado__User_Story_Title__c = 'UserStoryTest1';
        myUserStory1.copado__Status__c = 'Draft';
        myUserStory1.RecordTypeId = recordTypeIdUserStory;
        myUserStory1.copado__Release__c = createdParentRelease.Id;
        myUserStory1.copado__Project__c = createdProject.Id;
        insert myUserStory1;
        
        copado__Release__c createdChildRelease = [SELECT Id FROM copado__Release__c WHERE Name = 'DemoTestChild'];
        copado__User_Story__c myUserStory2 = new copado__User_Story__c();
        myUserStory2.copado__User_Story_Title__c = 'UserStoryTest2';
        myUserStory2.copado__Status__c = 'Draft';
        myUserStory2.RecordTypeId = recordTypeIdUserStory;
        myUserStory2.copado__Release__c = createdChildRelease.Id;
        myUserStory2.copado__Project__c = createdProject.Id;
        insert myUserStory2;
    }
    
    @IsTest
    static void testReleaseReleased() {     
        copado__Release__c createdParentRelease = [SELECT Id FROM copado__Release__c WHERE Name = 'DemoTestParent'];
        createdParentRelease.copado__Status__c = 'Released';
        update createdParentRelease;
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        System.assertEquals('Released', assertUserStory.copado__Status__c);
        
        copado__Release__c assertChildRelease = [SELECT Id, copado__Status__c FROM copado__Release__c WHERE Name = 'DemoTestChild'];
        System.assertEquals('Released', assertChildRelease.copado__Status__c);
	}
    
    @IsTest
    static void testReleaseBeta() {     
        copado__Release__c createdParentRelease = [SELECT Id FROM copado__Release__c WHERE Name = 'DemoTestParent'];
        createdParentRelease.copado__Status__c = 'Beta';
        update createdParentRelease;
        
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        System.assertEquals('Beta', assertUserStory.copado__Status__c);
        
        copado__Release__c assertChildRelease = [SELECT Id, copado__Status__c FROM copado__Release__c WHERE Name = 'DemoTestChild'];
        System.assertEquals('Beta', assertChildRelease.copado__Status__c);
	}
    
    @IsTest
    static void testReleaseReadyForTesting() {     
        copado__Release__c createdParentRelease = [SELECT Id FROM copado__Release__c WHERE Name = 'DemoTestParent'];
        createdParentRelease.copado__Status__c = 'Ready for Testing';
        update createdParentRelease;
       
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        System.assertEquals('Ready for Regression', assertUserStory.copado__Status__c);
        
        copado__Release__c assertChildRelease = [SELECT Id, copado__Status__c FROM copado__Release__c WHERE Name = 'DemoTestChild'];
        System.assertEquals('Ready for Testing', assertChildRelease.copado__Status__c);
	}
    
    @IsTest
    static void testReleaseReadyForRelease() { 
        copado__Release__c createdParentRelease = [SELECT Id FROM copado__Release__c WHERE Name = 'DemoTestParent'];
        createdParentRelease.copado__Status__c = 'Ready for Release';
        update createdParentRelease;
       
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        System.assertEquals('Ready for Release', assertUserStory.copado__Status__c);
        
        copado__Release__c assertChildRelease = [SELECT Id, copado__Status__c FROM copado__Release__c WHERE Name = 'DemoTestChild'];
        System.assertEquals('Ready for Release', assertChildRelease.copado__Status__c);
	}
    
    @IsTest
    static void testReleaseApprovedByQA() { 
        copado__Release__c createdParentRelease = [SELECT Id FROM copado__Release__c WHERE Name = 'DemoTestParent'];
        createdParentRelease.copado__Status__c = 'Approved by QA';
        update createdParentRelease;
       
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        System.assertEquals('Ready for Release', assertUserStory.copado__Status__c);
        
        copado__Release__c assertChildRelease = [SELECT Id, copado__Status__c FROM copado__Release__c WHERE Name = 'DemoTestChild'];
        System.assertEquals('Approved by QA', assertChildRelease.copado__Status__c);
	}
}