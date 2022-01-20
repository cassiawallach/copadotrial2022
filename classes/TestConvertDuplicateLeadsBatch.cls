@isTest
public class TestConvertDuplicateLeadsBatch {
    static testMethod void testDupeConversion(){
        
        Group openLeadsQueue = getOpenLeadsQueue();
        User activeUser = getInternalActiveUser();
        
        Lead dupeLead = new Lead(FirstName='Philipp', LastName='Rackwitz', Company='Copado', Email='pr@copa.do', OwnerId=openLeadsQueue.Id,NumberOfEmployees = 100, Next_Contact__c = System.today(),Next_Step__c = 'Next',Industry = 'Banking and Finance');
        dupeLead.LeadSource='AppExchange Watch Demo';
        dupeLead.Status='Open';
        dupeLead.Rating='Tier 1';
        insert dupeLead;
        
        Account acc = new Account(Name='Copado Solutions SL');
        insert acc;
        
        Contact c = new Contact(LastName='Rack', Email='pr@copa.do', AccountId=acc.Id, OwnerId=activeUser.Id);
        insert c;
        System.debug('QUERY CHECK: '+[SELECT Id, Email, LeadSource FROM Lead WHERE LeadSource LIKE 'AppExchange%' AND Email!='' AND IsConverted=false].size());
        
        System.debug('IDS: '+dupeLead.Id+'  Contact: '+c);
        
        Test.startTest();
        ConvertDuplicateLeadsBatch batchApex = new ConvertDuplicateLeadsBatch();   
        Id batchprocessid = Database.executeBatch(batchApex, 1);
        Test.stopTest(); 
        
        Lead convertedLead = [SELECT Id, FirstName, LastName, Email, IsConverted, ConvertedAccountId, ConvertedContactId FROM Lead WHERE Id =:dupeLead.Id];
        System.assertEquals(true, convertedLead.IsConverted);
        System.assertEquals(acc.Id, convertedLead.ConvertedAccountId);
        System.assertEquals(c.Id, convertedLead.ConvertedContactId);
        
        //Contact contactResult = [select Id, FirstName FROM Contact WHERE Id=:c.Id LIMIT 1];
        //system.assertEquals(dupeLead.FirstName, c.FirstName);
        
    }
    
    private static Group getOpenLeadsQueue(){
        return [SELECT Id, Name, DeveloperName, Type FROM Group WHERE Name = 'Open Leads' AND Type='Queue' LIMIT 1];
    }
    private static User getInternalActiveUser(){
        return [SELECT IsActive, UserType, Id, Name FROM User WHERE IsActive=true AND UserType='StANDard' LIMIT 1];
    }
}