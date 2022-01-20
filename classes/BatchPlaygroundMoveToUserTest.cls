@isTest
public without sharing class BatchPlaygroundMoveToUserTest {
    
    static testMethod void testBatch(){
        
        Id communityProfileId = [SELECT Id FROM Profile WHERE Name = 'CUSTOM Customer Community Login User'].Id;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        
        Account account = new Account(Name = 'Test Account 1');
        insert account;
        
        Contact contact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@copado.com', AccountId = account.Id);
        insert contact;
        
        User u = new User(
            FirstName = contact.FirstName,
            LastName = contact.LastName,
            Email = contact.Email,
            CompanyName = account.Name,
            ContactId = contact.Id,
            Alias = 'myalias',
            IsActive = true,
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = communityProfileId,
            Country = 'US',
            TimezoneSidKey = 'America/Los_Angeles',
            Username = 'demo9276@handomdemodomainz.djw.cmq'
        );
        insert u;
        
        copado__Org__c o = new copado__Org__c(
            Name = 'TestOrg',
            copado__SFDC_Org_ID__c = '00Df4000003AqJXEA0_0050N000007nP8CQAU_3',
            copado__Org_Type__c = 'Production/Developer'
        );
        insert o;
        String orgId = o.Id;
        
        Playground__c pg = new Playground__c(Name = 'Test Playground', Org_Credential__c = orgId, Contact__c = contact.Id);
        insert pg;

        Test.startTest();
        Database.executeBatch(new BatchPlaygroundMoveToUser());
        Test.stopTest();
        Playground__c pg1 = [Select Id, User__c From Playground__c Limit 1];
        System.assertNotEquals(null, pg1.User__c);
    }
}