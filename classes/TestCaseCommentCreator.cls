@isTest
private class TestCaseCommentCreator {
	
	static testMethod void createComment() {

		Case c = new Case(SuppliedEmail='casecommenttest@copado.org', SuppliedCompany='Copado Test', SuppliedName='Test User');
        insert c;
		
		List<EmailMessage> emailList = new List<EmailMessage>();
		EmailMessage email = new EmailMessage(
			FromAddress = 'copa@test.com',
			FromName = 'Test User',
			TextBody = 'Body Text',
			ParentId = c.Id);
		emailList.add(email);

		Test.startTest();
			CaseCommentCreator.createCaseCommentFromEmail(emailList);
			List<CaseComment> commentsList = [SELECT CommentBody FROM CaseComment WHERE ParentId = :c.Id];
			System.assertEquals(1, commentsList.size());
			System.assert(commentsList[0].CommentBody.contains('Body Text'));
		Test.stopTest();
	}
}