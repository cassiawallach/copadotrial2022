@isTest
private class TestAutoConvertLead {
    
    @isTest static void testConversion() {
        
        Lead l = TestDataFactory.createLead('Test', 'Customer4Life Inc.');
        l.FirstName = 'Copado';
        l.NumberOfEmployees = 90;        
        l.LeadSource = 'Advertisement';
        l.Rating = 'Tier 2';
        l.Next_Step__c = 'Next';
        l.Next_Contact__c = System.today();        
        l.Industry = 'Banking and Finance';
        
        insert l;

        Demo__c meeting = TestDataFactory.createDemo();
        meeting.Name = 'Test Demo';
        meeting.Lead__c = l.Id;
        insert meeting;

        Test.startTest();

        AutoConvertLead.AutoConvertLeadsApex(new List<Id>{meeting.Id});

        Test.stopTest();
    }   
}