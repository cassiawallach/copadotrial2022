@IsTest
public class TestUserStoryDevOps360forDevelopment {
@testSetup static void setup() { 
        Id recordTypeIdUserStory = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
        copado__User_Story__c myUserStory1 = new copado__User_Story__c();
        myUserStory1.copado__User_Story_Title__c = 'UserStoryTest1';
        myUserStory1.copado__Status__c = 'Ready for Planning';
        myUserStory1.RecordTypeId = recordTypeIdUserStory;
        insert myUserStory1;
          
        copado__Deployment_Flow__c myPipeline1 = new copado__Deployment_Flow__c();
        myPipeline1.Name = 'My Pipeline1';
        insert myPipeline1;
        
        copado__Project__c myProject1 = new copado__Project__c();
        myProject1.Name = 'My Project1';
        insert myProject1;
        myUserStory1.copado__Project__c = myProject1.Id;  
        update myUserStory1;
        myUserStory1.copado__Status__c = 'Released';
        update myUserStory1;
        
        copado__User_Story__c myUserStory2 = new copado__User_Story__c();
        myUserStory2.copado__User_Story_Title__c = 'My UserStory 2';
        myUserStory2.copado__Status__c = 'Ready for Planning';
        myUserStory2.copado__Project__c = myProject1.Id;
        insert myUserStory2;
        myUserStory2.copado__Status__c = 'Released';
        update myUserStory2; 
    }
    

    @IsTest
    static void testUSisReleasedWithPipeline() {     
   
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c, copadometrics__First_Time_Promoted_to_Production__c FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'My UserStory 2'];
        System.assertEquals('Released', assertUserStory.copado__Status__c);
        System.assertEquals(null, assertUserStory.copadometrics__First_Time_Promoted_to_Production__c); 
    }  

    @IsTest
    static void testDevelopmentIsComplete() {     
        copado__User_Story__c UserStoryTest1 = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        UserStoryTest1.copado__Status__c = 'Development In Progress';
        update UserStoryTest1;
        UserStoryTest1.copado__Status__c = 'Ready for Release';
        Test.startTest();
        update UserStoryTest1;
        Test.stopTest();
        copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c, copadometrics__Development_Complete__c FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1']; 
        System.assertEquals(True, assertUserStory.copadometrics__Development_Complete__c);
   
    }
   
    @IsTest
    static void testUSisReleased() {     
        
    copado__User_Story__c assertUserStory = [SELECT Id, copado__Status__c, copadometrics__First_Time_Promoted_to_Production__c FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1']; 
        System.assertEquals('Released', assertUserStory.copado__Status__c);
        System.assertNotEquals(null, assertUserStory.copadometrics__First_Time_Promoted_to_Production__c);
    }  
}