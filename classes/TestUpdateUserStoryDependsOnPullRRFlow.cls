@IsTest
public class TestUpdateUserStoryDependsOnPullRRFlow {
@testSetup static void setup() {      
        Id recordTypeIdUserStory = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
        copado__User_Story__c myUserStory = new copado__User_Story__c();
        myUserStory.copado__User_Story_Title__c = 'UserStoryTest1';
        myUserStory.copado__Status__c = 'Draft';
        myUserStory.RecordTypeId = recordTypeIdUserStory;
        insert myUserStory;
        
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        copado__Pull_Request__c pullRequest = new copado__Pull_Request__c();
        pullRequest.copado__User_Story__c = createdUserStory.Id;
    	pullRequest.copado__State__c = 'Opened';
		insert pullRequest;

    }
    
    @IsTest
    static void testPullRequestReviewApproved() {   
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        copado__Pull_Request__c createdPullRequest = [SELECT Id FROM copado__Pull_Request__c WHERE copado__User_Story__c = :createdUserStory.Id];
		copado__Pull_Request_Review__c createdPullRequestReview = new copado__Pull_Request_Review__c();
        createdPullRequestReview.copado__Review_Id__c = 'frantest1';
        createdPullRequestReview.copado__Pull_Request__c = createdPullRequest.Id;
        createdPullRequestReview.copado__Review_Action__c = 'Approved';
        createdPullRequestReview.copado__Username__c = 'fnunez';
        insert createdPullRequestReview;
        
        
        copado__User_Story__c assertUserStory = [SELECT Id, Pull_Requests_Counter__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('1/1', assertUserStory.Pull_Requests_Counter__c);
	}
    
    @IsTest
    static void testPullRequestReviewApprovedPullRequestClosed() {   
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        copado__Pull_Request__c createdPullRequest = [SELECT Id FROM copado__Pull_Request__c WHERE copado__User_Story__c = :createdUserStory.Id];
        createdPullRequest.copado__State__c = 'Closed';
        update createdPullRequest;
        
		copado__Pull_Request_Review__c createdPullRequestReview = new copado__Pull_Request_Review__c();
        createdPullRequestReview.copado__Review_Id__c = 'frantest1';
        createdPullRequestReview.copado__Pull_Request__c = createdPullRequest.Id;
        createdPullRequestReview.copado__Review_Action__c = 'Approved';
        createdPullRequestReview.copado__Username__c = 'fnunez';
        insert createdPullRequestReview;
        
        
        copado__User_Story__c assertUserStory = [SELECT Id, Pull_Requests_Counter__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals(null, assertUserStory.Pull_Requests_Counter__c);
	}
    
     @IsTest
    static void testPullRequestReviewTwoApproved() {   
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        copado__Pull_Request__c createdPullRequest = [SELECT Id FROM copado__Pull_Request__c WHERE copado__User_Story__c = :createdUserStory.Id];
        update createdPullRequest;
        
		copado__Pull_Request_Review__c createdPullRequestReview = new copado__Pull_Request_Review__c();
        createdPullRequestReview.copado__Review_Id__c = 'frantest1';
        createdPullRequestReview.copado__Pull_Request__c = createdPullRequest.Id;
        createdPullRequestReview.copado__Review_Action__c = 'Approved';
        createdPullRequestReview.copado__Username__c = 'fnunez';
        insert createdPullRequestReview;
        
        copado__Pull_Request_Review__c createdPullRequestReview2 = new copado__Pull_Request_Review__c();
        createdPullRequestReview2.copado__Review_Id__c = 'frantest2';
        createdPullRequestReview2.copado__Pull_Request__c = createdPullRequest.Id;
        createdPullRequestReview2.copado__Review_Action__c = 'Approved';
        createdPullRequestReview2.copado__Username__c = 'fnunez';
        insert createdPullRequestReview2;        
        
        copado__User_Story__c assertUserStory = [SELECT Id, Pull_Requests_Counter__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('2/1', assertUserStory.Pull_Requests_Counter__c);
	}
    
    @IsTest
    static void testPullRequestReviewApprovedAndNotApproved() {   
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'UserStoryTest1'];
        copado__Pull_Request__c createdPullRequest = [SELECT Id FROM copado__Pull_Request__c WHERE copado__User_Story__c = :createdUserStory.Id];
        update createdPullRequest;
        
		copado__Pull_Request_Review__c createdPullRequestReview = new copado__Pull_Request_Review__c();
        createdPullRequestReview.copado__Review_Id__c = 'frantest1';
        createdPullRequestReview.copado__Pull_Request__c = createdPullRequest.Id;
        createdPullRequestReview.copado__Review_Action__c = 'Approved';
        createdPullRequestReview.copado__Username__c = 'fnunez';
        insert createdPullRequestReview;
        
        copado__Pull_Request_Review__c createdPullRequestReview2 = new copado__Pull_Request_Review__c();
        createdPullRequestReview2.copado__Review_Id__c = 'frantest2';
        createdPullRequestReview2.copado__Pull_Request__c = createdPullRequest.Id;
        createdPullRequestReview2.copado__Review_Action__c = 'Not Approved';
        createdPullRequestReview2.copado__Username__c = 'fnunez';
        insert createdPullRequestReview2;        
        
        copado__User_Story__c assertUserStory = [SELECT Id, Pull_Requests_Counter__c FROM copado__User_Story__c WHERE Id = :createdUserStory.Id];
        System.assertEquals('1/1', assertUserStory.Pull_Requests_Counter__c);
	}
    
    
}