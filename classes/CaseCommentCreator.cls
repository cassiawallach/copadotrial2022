public class CaseCommentCreator {
	@InvocableMethod
	public static void createCaseCommentFromEmail (List<EmailMessage> emailInList) {

		List<CaseComment> commentsToInsert = new List<CaseComment>();

		for (EmailMessage email: emailInList) {
			String ccText = 'From: ';
			ccText += email.FromAddress;
			ccText += ' (' + email.FromName + ')\n\n';
			ccText += email.TextBody;
			if (ccText.length()>3750) {
				ccText = ccText.substring(0, 3750);
			}
			CaseComment cc = new CaseComment(CommentBody=ccText,ParentId=email.ParentId,IsPublished=true);
	        commentsToInsert.add(cc);
	    }

	    insert commentsToInsert;
	}
}