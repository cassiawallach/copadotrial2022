@isTest
private class TestPsydoCaseTrigger {
	static testMethod void runTest_WITH_Comments(){
		Account testAccount = testMethodUtilities.createAccount('TestMethodCopadoTestMethod', '123orgId123');
        Contact testContact = testMethodUtilities.createContact(testAccount.Id,'Mark','Benioff','ceo@salesforce.com', '123userId123');
        Case testCase = new Case(AccountId=testAccount.Id, ContactId=testContact.Id);
        testCase.Subject = 'test subject';
        testCase.Description = 'My Description';
        testCase.Origin = 'Email';
        testCase.Status = 'New';
        testCase.Type = 'Question';
		testCase.Priority = 'High';
		insert testCase;

		String caseNumber = [select Id, CaseNumber from Case where Id=:testCase.Id limit 1].CaseNumber;

		Psydo_Case__c pc = new Psydo_Case__c(Record_Id__c=testCase.Id);
		pc.Status__c = 'Closed';
		pc.Action__c = 'Update';
		pc.CaseComment__c = 'My Comment';
		Test.startTest();
		insert pc;
		Test.stopTest();
		Case result = [select Id, Status from Case where Id=:testCase.Id limit 1];
		List<CaseComment> ccsResult = [select Id, ParentId, CommentBody from CaseComment where ParentId=:result.Id];
		system.assertEquals(1, ccsResult.size());
		system.assertEquals('Closed', result.Status);
	}
	static testMethod void runTest_WITHOUT_Comments(){
		Account testAccount = testMethodUtilities.createAccount('TestMethodCopadoTestMethod', '123orgId123');
        Contact testContact = testMethodUtilities.createContact(testAccount.Id,'Mark','Benioff','ceo@salesforce.com', '123userId123');
        Case testCase = new Case(AccountId=testAccount.Id, ContactId=testContact.Id);
        testCase.Subject = 'test subject';
        testCase.Description = 'My Description';
        testCase.Origin = 'Email';
        testCase.Status = 'New';
        testCase.Type = 'Question';
		testCase.Priority = 'High';
		insert testCase;

		String caseNumber = [select Id, CaseNumber from Case where Id=:testCase.Id limit 1].CaseNumber;

		Psydo_Case__c pc = new Psydo_Case__c(Record_Id__c=testCase.Id);
		pc.Status__c = 'Closed';
		pc.Action__c = 'Update';
		pc.CaseComment__c = null;
		Test.startTest();
		insert pc;
		Test.stopTest();
		Case result = [select Id, Status from Case where Id=:testCase.Id limit 1];
		List<CaseComment> ccsResult = [select Id, ParentId, CommentBody from CaseComment where ParentId=:result.Id];
		system.assertEquals(0, ccsResult.size());
		system.assertEquals('Closed', result.Status);
	}
	static testMethod void testUnusedMethods(){
		Account testAccount = testMethodUtilities.createAccount('TestMethodCopadoTestMethod', '123orgId123');
        Contact testContact = testMethodUtilities.createContact(testAccount.Id,'Mark','Benioff','ceo@salesforce.com', '123userId123');
        Case testCase = new Case(AccountId=testAccount.Id, ContactId=testContact.Id);
        testCase.Subject = 'test subject';
        testCase.Description = 'My Description';
        testCase.Origin = 'Email';
        testCase.Status = 'New';
        testCase.Type = 'Question';
		testCase.Priority = 'High';
		insert testCase;
		Psydo_Case__c pc = new Psydo_Case__c(Record_Id__c=testCase.Id);
		insert pc;
		Test.startTest();
		update pc;
		delete pc;
		undelete pc;
		Test.stopTest();
	}
}