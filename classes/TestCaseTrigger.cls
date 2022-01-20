@isTest
public class TestCaseTrigger {
    @testSetup static void setupTestData(){
        testMethodUtilities.setupEntitlements();
    }
    static testMethod void createCaseNoContactMatch(){
    
        Case c = TestDataFactory.createCase('Email');
        c.SuppliedEmail='testNoWayNoMatch@123TREa-dsf.com';
        c.SuppliedCompany='TestNoWay-123';
        c.SuppliedName='Test User';
        insert c;
        
        Case result = [select Id, EntitlementId, ContactId, Contact.FirstName, Contact.LastName, AccountId, Account.Name from Case where Id=:c.Id];
        system.assertEquals(null, result.AccountId);
        system.assertEquals(null, result.ContactId);
    }
    static testMethod void createCaseOneMatch(){
       
        Account testAccount = TestDataFactory.createAccount('Test', 'EUR');
        insert testAccount;
        
        Contact testContact = TestDataFactory.createContact(testAccount.Id, 'Test');         
        testContact.Email='test@test.com';
        insert testContact;  
        
        Case c = TestDataFactory.createCase('Email');
        c.SuppliedEmail='test@test.com';
        c.SuppliedCompany='Test';
        c.SuppliedName='Test User';
        insert c;        
       
        Case result = [select Id, ContactId, AccountId, Subject from Case where Id=:c.Id];
        system.assertEquals(testAccount.Id, result.AccountId);
        system.assertEquals(testContact.Id, result.ContactId);
        
        result.Subject = 'Changed subject';
        update result;
        
        delete result;
        undelete result;
    }

    static testMethod void premierSupport(){
        Map<String, BusinessHours> bhMap = new Map<String, BusinessHours>();
        for(BusinessHours bh : [SELECT Id, Name, IsActive FROM BusinessHours]){
            bhMap.put(bh.Name, bh);
        }
        
        Account testAccount = TestDataFactory.createAccount('Premier Customer', 'EUR');
        insert testAccount;        
        Contact testContact = TestDataFactory.createContact(testAccount.Id, 'Test');         
        testContact.Email='test@test.com';
        insert testContact;   
        
        Id slaProcessId = [select Id, Name from SlaProcess where Name='Premier Support' and isActive=true limit 1].Id;
        Entitlement ent = TestDataFactory.createEntitlementPremier(testAccount.Id);      
        ent.Name='Premier Support';
        ent.SlaProcessId=slaProcessId;
        ent.StartDate=Date.today().addDays(-1);
        ent.EndDate=Date.today().addDays(2);
        ent.Access_Code__c = 123456;
        ent.BusinessHoursId = bhMap.get('Default - 24/7').Id;
        ent.Working_Business_Hours__c = bhMap.get('Working hours - UTC+1').Id;       
        insert ent;
        
        Test.startTest();
        Case testCase = TestDataFactory.createCase('Email');
        testCase.AccountId=testAccount.Id;
        testCase.ContactId=testContact.Id;
        testCase.Status='New';
        testCase.Subject='Premier From Subject CS123456';
        testCase.Priority='Critical';
        insert testCase;     
        testCase = getCaseById(testCase.Id);
        System.assertEquals(ent.Id, testCase.EntitlementId);
        
        testCase = TestDataFactory.createCase('Email');
        testCase.AccountId=testAccount.Id;
        testCase.ContactId=testContact.Id; 
        testCase.Status='New';
        testCase.Access_Code__c = 123456; 
        testCase.Subject='Premier From Code'; 
        testCase.Priority='Critical';
        insert testCase;
        testCase = getCaseById(testCase.Id);
        System.assertEquals(ent.Id, testCase.EntitlementId);
        System.assertEquals(true, testCase.Is_Premier_Support__c);
        
        //system.assertEquals(bhMap.get('Default - 24/7').Id, testCase.BusinessHoursId);
        
        testCase = updateCase(testCase, 'New', 'Urgent');
        //system.assertEquals(bhMap.get('Default - 24/7').Id, testCase.BusinessHoursId);
        
        testCase = updateCase(testCase, 'In progress', 'High');
        //system.assertEquals(bhMap.get('Working hours - UTC+1').Id, testCase.BusinessHoursId);      
        Test.stopTest();
    }

    private static Case updateCase(Case c, String s, String p){
        c.Priority = p;
        c.Status = s;
        update c;
        return getCaseById(c.Id);
    }

    private static Case getCaseById(Id cid){
        return [SELECT Id, BusinessHoursId, EntitlementId, Status, Is_Premier_Support__c FROM Case WHERE Id=:cid limit 1];
    }
    
    static testMethod void createUSfromCase(){        
        copado__User_Story__c us = TestDataFactory.createUserStories('Test','Draft');
        us.copado__Functional_Specifications__c = 'test';
        us.copado__Acceptance_Criteria__c = 'test';
        us.Business_Owner__c = userinfo.getUserId();       
        insert us;
        Case c = new Case(User_Story__c=us.Id, SuppliedEmail='testNoWayNoMatch@123TREa-dsf.com', SuppliedCompany='TestNoWay-123', SuppliedName='Test User');
        insert c;
        system.assertNotEquals(null, c.User_Story__c);        
    }
}