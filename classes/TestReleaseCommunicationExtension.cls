@isTest
private class TestReleaseCommunicationExtension{
    
    static testMethod void testCodeToEnd(){
        Account testAccount = TestDataFactory.createAccount('My Account', 'EUR');
        insert testAccount;
        system.debug('@@@'+testAccount);
        Contact testContact = TestDataFactory.createContact(testAccount.Id,'Benioff');
        testContact.UserId__c = 'userId123';
        Insert testContact;

        Contact testContact2 = TestDataFactory.createContact(testAccount.Id,'Benioff2');
        testContact2.UserId__c = 'userId1234';
        Insert testContact2;
            
        Contact testContact3 = TestDataFactory.createContact(testAccount.Id,'Benioff3');
        testContact3.UserId__c = 'userId12345';
        Insert testContact3;
           
       
        Lead testLead = TestDataFactory.createLead('test','Test company');
        testLead.Email='test@copa.do.test';
        insert testLead;
        
        /*sfLma__License__c license1 = new sfLma__License__c();
        license1.sfLma__Account__c = testAccount.Id;
        license1.sfLma__Contact__c = testContact.Id;
        license1.sfLma__Status__c = 'Active';
        //insert license1;
        
        sfLma__License__c license2 = new sfLma__License__c();
        license2.sfLma__Lead__c = testLead.Id;
        license2.sfLma__Status__c = 'Active';
        //insert license2;
        
        sfLma__License__c license3 = new sfLma__License__c();
        license3.sfLma__Lead__c = testLead.Id;
        license3.sfLma__Status__c = 'Active';
        //insert license3;

        sfLma__License__c license4 = new sfLma__License__c();
        license4.sfLma__Account__c = testAccount.Id;
        license4.sfLma__Contact__c = testContact2.Id;
        license4.sfLma__Status__c = 'Active';
        //insert license4;*/

        Release_Communication__c release = new Release_Communication__c();
        release.Name = 'best release ever';
        insert release;
        
        PageReference pageRef = Page.communicateRelease;
        pageRef.getParameters().put('id',release.id);
        Test.setCurrentPage(pageRef);
        Test.startTest();
        ReleaseCommunicationExtension ext = new ReleaseCommunicationExtension(new ApexPages.StandardController(release));
        system.debug('### all email templates: '+ext.emailTemplates);
        system.debug('### 1st Email template: '+ext.emailTemplates[0]);
        ext.selectedEmailTemplateId = ext.emailTemplates[1].getValue();
        system.debug('### selectedEmailTemplateId: '+ext.selectedEmailTemplateId);
        ext.sendEmails();
        pageRef = ext.cancel();
        Test.stopTest();
        String expected = release.Id;
        system.assertEquals('/'+expected.subString(0,15), pageRef.getUrl());
        
    }       
}