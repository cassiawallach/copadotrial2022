@isTest
public without sharing class BatchSettingDataMoveContactToUserTest {
    
    static testMethod void testBatch(){
        
        Id communityProfileId = [SELECT Id FROM Profile WHERE Name = 'CUSTOM Customer Community Login User'].Id;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        
        Account account = new Account(Name = 'Test Account 1');
        insert account;
        
        Contact contact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@copado.com', AccountId = account.Id, Allowed_Playgrounds__c = 10);
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
            Username = 'demo9276@handomdemodomainz.djw.cmq',
            Allowed_Playgrounds__c = null
        );
        insert u;

        Test.startTest();
        Database.executeBatch(new BatchSettingDataMoveContactToUser());
        Test.stopTest();
    }
}