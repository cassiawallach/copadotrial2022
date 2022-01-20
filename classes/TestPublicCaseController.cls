@isTest
private class TestPublicCaseController {
	
	static testMethod void testFullProcess_WithComment() {
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
		PageReference pageRef =Page.PublicCase;
		pageRef.getParameters().put('cn', caseNumber);
		pageRef.getParameters().put('ce', testContact.Email);
		Test.setCurrentPage(pageRef); 
		Test.startTest();
		PublicCaseController con = new PublicCaseController();
		system.assertEquals(false, con.renderStep1);
		system.assertEquals(true, con.renderStep2);
		system.assertEquals(false, con.renderCaseClosure );

		//now we close case
		con.closeCase();
		system.assertEquals(false, con.renderStep1);
		system.assertEquals(false, con.renderStep2);
		system.assertEquals(true, con.renderCaseClosure );

		// Now leave comment and close case
		con.psydoCase.CaseComment__c = 'my comment';
		con.confirmCloseCase();
		system.assertEquals(false, con.renderStep1);
		system.assertEquals(true, con.renderStep2);
		system.assertEquals(false, con.renderCaseClosure );
		system.assert(testMethodUtilities.hasMessage('Your case has been closed.'));
		Test.stopTest();

		Case result = [select Id, Status from Case where Id=:testCase.Id limit 1];
		List<CaseComment> ccsResult = [select Id, ParentId, CommentBody from CaseComment where ParentId=:result.Id];
		system.assertEquals(1, ccsResult.size());
		system.assertEquals('Closed', result.Status);
	}
	static testMethod void testFullProcess_noComment() {
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
		PageReference pageRef =Page.PublicCase;
		pageRef.getParameters().put('cn', caseNumber);
		pageRef.getParameters().put('ce', testContact.Email);
		Test.setCurrentPage(pageRef); 
		Test.startTest();
		PublicCaseController con = new PublicCaseController();
		system.assertEquals(false, con.renderStep1);
		system.assertEquals(true, con.renderStep2);
		system.assertEquals(false, con.renderCaseClosure );

		//now we close case
		con.closeCase();
		system.assertEquals(false, con.renderStep1);
		system.assertEquals(false, con.renderStep2);
		system.assertEquals(true, con.renderCaseClosure );

		// Now leave comment and close case
		con.psydoCase.CaseComment__c = null;
		con.confirmCloseCase();
		system.assertEquals(false, con.renderStep1);
		system.assertEquals(true, con.renderStep2);
		system.assertEquals(false, con.renderCaseClosure );
		system.assert(testMethodUtilities.hasMessage('Your case has been closed.'));
		Test.stopTest();

		Case result = [select Id, Status from Case where Id=:testCase.Id limit 1];
		List<CaseComment> ccsResult = [select Id, ParentId, CommentBody from CaseComment where ParentId=:result.Id];
		system.assertEquals(0, ccsResult.size());
		system.assertEquals('Closed', result.Status);
	}
	static testMethod void testBadParams() {
		PageReference pageRef =Page.PublicCase;
		pageRef.getParameters().put('cn', 'test');
		pageRef.getParameters().put('ce', 'test');
		Test.setCurrentPage(pageRef); 
		Test.startTest();
		PublicCaseController con = new PublicCaseController();
		system.assertEquals(true, con.renderStep1);
		system.assertEquals(false, con.renderStep2);
		system.assertEquals(false, con.renderCaseClosure );
		system.assert(testMethodUtilities.hasMessage('No case found'));
		Test.stopTest();
	}
	
}