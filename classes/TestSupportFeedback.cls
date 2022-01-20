@isTest
private class TestSupportFeedback {
	
    private static TestMethod void UpdateCase() {
        
        Case c = new Case(Status = 'New',
                          Origin = 'Web');
        insert c;
        
        SupportFeedback sf = new SupportFeedback();

        Test.setCurrentPageReference(new PageReference('/SupportFeedback'));
        
        Test.startTest();
		System.currentPageReference().getParameters().put('CaseId', c.Id);
        System.currentPageReference().getParameters().put('CustomerDisagrees', 'false');
        sf.comment = 'Test';
        sf.UpdateCase();
        
        List<Case> Lcases = [SELECT Id, Feedback_Reason__c, Customer_Feedback__c FROM Case WHERE Id = :c.Id];
        System.assertEquals(System.Label.Customer_Feedback_Satisfied, Lcases[0].Customer_Feedback__c);
        System.assertEquals('Test', Lcases[0].Feedback_Reason__c);
        
        System.currentPageReference().getParameters().put('CustomerDisagrees', 'true');
        sf.comment = 'Test';
        sf.UpdateCase();
        
        Lcases = [SELECT Id, Feedback_Reason__c, Customer_Feedback__c FROM Case WHERE Id = :c.Id];
        System.assertEquals(System.Label.Customer_Feedback_Not_satisfied, Lcases[0].Customer_Feedback__c);
        System.assertEquals('Test - Test', Lcases[0].Feedback_Reason__c);
        
        Test.stopTest();
    }
}