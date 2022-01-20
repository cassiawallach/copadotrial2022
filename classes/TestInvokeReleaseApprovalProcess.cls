@IsTest
public class TestInvokeReleaseApprovalProcess {
    @testSetup static void setup() {      
         copado__User_Story__c userStory = TestDataFactory.createUserStories('InvokeReleaseApprovalProcess1', 'Draft');
         insert userStory; 
    }
    
    @IsTest
    static void executionSuccessNotAPO() {
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'InvokeReleaseApprovalProcess1'];
        createdUserStory.RecordTypeId = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
        createdUserStory.copado__Story_Points_Other__c = 2;
        update createdUserStory;
        
        InvokeReleaseApprovalProcess.InvocableVariables input = new InvokeReleaseApprovalProcess.InvocableVariables();
        input.userStoryId = createdUserStory.Id;
        List<InvokeReleaseApprovalProcess.InvocableVariables> inputs = new List<InvokeReleaseApprovalProcess.InvocableVariables>();
        inputs.add(input);
        List<InvokeReleaseApprovalProcess.ApprovalProcessResult> results = InvokeReleaseApprovalProcess.execute(inputs);

        System.assert(!results[0].ErrorMessage.contains('EPIC cannot be null'),results[0].ErrorMessage);
        System.assert(!results[0].ErrorMessage.contains('Planned Points cannot be null'),results[0].ErrorMessage);
        System.assert(results[0].ErrorMessage.contains('Realease cannot be null'),results[0].ErrorMessage);
    }
    
    @IsTest
    static void executionSuccessAPO() {
        copado__User_Story__c createdUserStory = [SELECT Id FROM copado__User_Story__c WHERE copado__User_Story_Title__c = 'InvokeReleaseApprovalProcess1'];
        createdUserStory.RecordTypeId = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('APO User Story').getRecordTypeId();
        createdUserStory.copado__Story_Points_Other__c = 2;
        update createdUserStory;
        
        InvokeReleaseApprovalProcess.InvocableVariables input = new InvokeReleaseApprovalProcess.InvocableVariables();
        input.userStoryId = createdUserStory.Id;
        List<InvokeReleaseApprovalProcess.InvocableVariables> inputs = new List<InvokeReleaseApprovalProcess.InvocableVariables>();
        inputs.add(input);
        List<InvokeReleaseApprovalProcess.ApprovalProcessResult> results = InvokeReleaseApprovalProcess.execute(inputs);

        System.assert(!results[0].ErrorMessage.contains('Planned Points cannot be null'),results[0].ErrorMessage);
    }
}