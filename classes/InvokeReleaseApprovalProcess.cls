global with sharing class InvokeReleaseApprovalProcess {
    global with sharing class InvocableVariables {
        @InvocableVariable(label='User Story Id' required=true)
        global Id userStoryId;
    }
    
    @InvocableMethod(label='Execute Release Approval Process' description='Execute release approval process')
    public static List<ApprovalProcessResult> execute(List<InvocableVariables> variables) {
        copado__User_Story__c userStory = [SELECT Id,copado__Project__c, copado__Story_Points_Other__c, 
                                           copado__Story_Points_SFDC__c, copado__Release__c, Module__c, 
                                           copado__Theme__c, copado__Sprint__c, copado__Status__c, 
                                           copado__Project__r.Name, RecordTypeId, 
                                           copado__Technical_Specifications__c, Test_Runs_Counter__c,
                                           copado__Last_Validation_Deployment__c, copado__Apex_Tests_Passed__c,
                                           copado__Manual_Tests_Passed__c, copado__Documentation_Complete__c,
                                           copado__Pull_Requests_Approved__c
                                           FROM copado__User_Story__c WHERE Id = :variables[0].userStoryId];
        
        Id recordTypeIdUserStory = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('APO User Story').getRecordTypeId();
        
        List<ApprovalProcessResult> results= new List<ApprovalProcessResult>();
        String errors = '';
        
        if(Approval.isLocked(variables[0].userStoryId)){
            errors += 'User story is still currently in an Approval Process \n';
        }
        else
        {
            if(userStory.RecordTypeId != recordTypeIdUserStory)
            {
                errors += validationForCopadoApplicationProject(userStory);
            }
            else
            {
                errors += validationForAPOUserStories(userStory);
            }
        }
        ApprovalProcessResult result = new ApprovalProcessResult();
        result.ErrorMessage = errors == '' ? null : errors;
        results.add(result);
        return results;
    }
    
    private static string validationForCopadoApplicationProject(copado__User_Story__c userStory)
    {
        string errors = '';
        if (userStory.copado__Project__r.Name != 'Copado Application' && 
            userStory.copado__Project__r.Name != 'Copado Salesforce DX Extension') {
            errors +='Project must be Copado Application or Copado Salesforce DX Extension \n';
        }
        if (userStory.copado__Project__c == null) {
            errors +='Project cannot be null \n';
        }
        if (userStory.copado__Status__c != 'Ready for Packaging' && userStory.copado__Status__c != 'Completed') {
            errors +='Status must be Ready for Packaging or Completed \n';
        }
        if (userStory.Module__c == null) {
            errors +='Module cannot be null \n';
        }
        if (userStory.copado__Theme__c == null) {
            errors +='Theme cannot be null \n';
        }
        if (userStory.copado__Sprint__c == null) {
            errors +='Sprint cannot be null \n';
        }
        if (userStory.copado__Release__c == null) {
            errors += 'Realease cannot be null \n';
        }
        if (userStory.copado__Story_Points_Other__c == null) {
            errors += 'Planned Points cannot be null \n';
        }
        if (userStory.copado__Story_Points_SFDC__c == null) {
            errors += 'Actual Points cannot be null \n';
        }
        if (userStory.copado__Apex_Tests_Passed__c == false) {
            errors += 'Apex Test Passed checkbox should be checked \n';
        }
        if (userStory.copado__Manual_Tests_Passed__c  == false) {
            errors += 'Manual Test Passed checkbox should be checked \n';
        }
        if (userStory.copado__Documentation_Complete__c  == false) {
            errors += 'Documentation Complete checkbox should be checked \n';
        }
        if (userStory.copado__Pull_Requests_Approved__c  == false) {
            errors += 'Pull Request Approved checkbox should be checked \n';
        }
        return errors;
    }
    
    private static string validationForAPOUserStories(copado__User_Story__c userStory)
    {
        string errors = '';

        if (userStory.Test_Runs_Counter__c == null) {
            errors +='User Story should have a test run passed \n';
        }
        if (userStory.copado__Story_Points_Other__c == null) {
            errors += 'Planned Points cannot be null \n';
        }
        if (userStory.copado__Story_Points_SFDC__c == null) {
            errors += 'Actual Points cannot be null \n';
        }
        
        return errors;
    }
    
    global class ApprovalProcessResult {
        @InvocableVariable
        global String ErrorMessage;
    }
}