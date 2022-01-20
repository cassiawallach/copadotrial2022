@isTest
private class MassLeadConverterControllerTest {

    @isTest
    static void massLeadTest() {
        
        // set up account
        Account acc = TestDataFactory.createAccount('Acme Account Test', 'EUR');
        acc.BillingCountry = 'US';
        acc.ShippingCountry = 'US';
        acc.BillingState = 'IL';
        insert acc;
        
        // set up leads
        List<Lead> testLeads = new List<Lead>();
        Lead lead1 = TestDataFactory.createLead('Martha', 'Test 1 New Company');       
        lead1.Industry = 'Banking and Finance';
        lead1.Rating = 'Tier2';
        lead1.NumberOfEmployees = 10;
        lead1.Next_Contact__c = System.today();
        lead1.Next_Step__c = 'Next';


        lead1.LeadSource = 'Not Converted';
        testLeads.add(lead1);
        
        Lead lead2 = TestDataFactory.createLead('Jordan', 'Test 12');        
        lead2.LeadSource = 'Not Converted';
        lead2.Industry = 'Banking and Finance';
        lead2.Rating = 'Tier2';
        lead2.NumberOfEmployees = 10;
        lead2.Next_Contact__c = System.today();
        lead2.Next_Step__c = 'Next';
        testLeads.add(lead2);
        
        Lead lead3 = TestDataFactory.createLead('Paul', 'Test 3'); 
        lead3.LeadSource = 'Not Converted';
        lead3.Industry = 'Banking and Finance';
        lead3.Rating = 'Tier2';
        lead3.NumberOfEmployees = 10;
        lead3.Next_Contact__c = System.today();
        lead3.Next_Step__c = 'Next';
        testLeads.add(lead3);    
        
        Test.startTest();
        insert testLeads;        
        
        // set up extension
        List<Lead> selectedLeads = new List<Lead>();
        selectedLeads.add(lead1);
        selectedLeads.add(lead2);
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(selectedLeads);
        con.setSelected(selectedLeads);
        MassLeadConverterController mlc = new MassLeadConverterController(con);
        
        // try with new account
        mlc.leadTask.ActivityDate = System.today();
        mlc.leadTask.Subject = 'hi';
        mlc.leadTask.Status = 'In Progress';            
        mlc.leadTask.Priority = 'High';
        mlc.oppOption = 'Create an opportunity for each lead';
        mlc.convertLeads();
        
        List<Contact> resultingContacts = [SELECT Id FROM Contact WHERE Account.Name = 'Test 1 New Company'];
        System.assertEquals(2, resultingContacts.size()); 
        List<Opportunity> resultingOpp = [SELECT Id FROM Opportunity WHERE Opportunity.Name = 'Test 1 New Company'];
        System.assertEquals(2, resultingOpp.size());   
        
         // re-set up extension
        selectedLeads = new List<Lead>();
        selectedLeads.add(lead3);
        con = new ApexPages.StandardSetController(selectedLeads);
        con.setSelected(selectedLeads);
        mlc = new MassLeadConverterController(con);
        
        // try with existing account and do not create opportunity
        mlc.accOption = 'Add to existing account';
        mlc.con.AccountId = acc.Id;
        mlc.leadTask.ActivityDate = System.today();
        mlc.leadTask.Subject = 'hi';
        mlc.leadTask.Status = 'In Progress';            
        mlc.leadTask.Priority = 'High';
        mlc.oppOption = 'Do not create new opportunity';        
        mlc.convertLeads();        
        resultingContacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        System.assertEquals(1, resultingContacts.size()); 
        resultingOpp = [SELECT Id FROM Opportunity WHERE Opportunity.Name = 'Acme Account Test'];
        System.assertEquals(0, resultingOpp.size());          
        Test.stopTest(); 
    }   
}