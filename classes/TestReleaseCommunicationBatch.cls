@isTest
public class TestReleaseCommunicationBatch {
    static testMethod void fullBatchTest(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='My test Account1', OrgId__c='00D170000009ePwEAI'));
        accounts.add(new Account(Name='My test Account2', OrgId__c='00D90000000qEvHEAU'));
        insert accounts;

        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(FirstName='Philipp1', LastName='Rackwitz1', Email='pr1@copa.do', AccountId=accounts[0].id, UserId__c='MyTestUserId1234', Receive_Release_Communication__c=false));
        contacts.add(new Contact(FirstName='Philipp2', LastName='Rackwitz2', Email='pr2@copa.do', AccountId=accounts[1].id, UserId__c='MyTestUserId1235', Receive_Release_Communication__c=false));
        contacts.add(new Contact(FirstName='Philipp3', LastName='Rackwitz3', Email='pr3@copa.do', AccountId=accounts[0].id, UserId__c='MyTestUserId1236', Receive_Release_Communication__c=true));
        insert contacts;
        
        List<sfLma__License__c> licenses = new List<sfLma__License__c>();
        system.debug('Contact 0'+contacts[0]);
        system.debug('Contact 1'+contacts[1]);
        system.debug('Contact 2'+contacts[2]);
        
        licenses.add(new sfLma__License__c(sfLma__Account__c=accounts[0].Id, sfLma__Contact__c=contacts.get(0).Id, sfLma__Status__c='Active', sfLma__Subscriber_Org_ID__c=accounts[0].OrgId__c.subString(0,15), sfLma__Used_Licenses__c = 1, sfLma__Seats__c = -1, sfLma__Install_Date__c = system.today(), sfLma__License_Type__c = 'Editable', sfLma__Package_License_ID__c = 'some package id'));
        licenses.add(new sfLma__License__c(sfLma__Account__c=accounts[1].Id, sfLma__Contact__c=contacts.get(1).Id, sfLma__Status__c='Active', sfLma__Subscriber_Org_ID__c=accounts[1].OrgId__c.subString(0,15), sfLma__Used_Licenses__c = 1, sfLma__Seats__c = -1, sfLma__Install_Date__c = system.today(), sfLma__License_Type__c = 'Editable', sfLma__Package_License_ID__c = 'some package id'));
        insert licenses;

        Release_Communication__c r = new Release_Communication__c(name ='test rc');
        insert r;
        
        Test.startTest();
        ReleaseCommunicationBatch batchApex = new ReleaseCommunicationBatch([select Id from EmailTemplate where IsActive=true limit 1].Id, r.id);   
        Database.executeBatch(batchApex);
        Test.stopTest(); 
        system.assertEquals(3, [select count() from contact where Last_Release_Communication_Sent__c=:r.id]);
        
    }
}