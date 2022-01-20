/*
 * This class has been intentionally written as without sharing
 * to write the data manipulation method where sharing rules need to be ignored.
*/
public without sharing class CommunitySupportCaseUtils {
	// Sharing modal for case is private for both internal and external.
	// Records which are fetched in this method are created by user itself, but due to
	// order of execution, after DML operation of insert case we are not able to query the inserted case
	// as there is criteria based sharing rule for case which do not works in same transaction.
	// So to overcome we write methods in this class.

	public static List<Case> getCreatedCase(Id caseId) {
		return [SELECT Id, Subject, CaseNumber, Impacted_Area__c FROM Case WHERE Id = :caseId];
	}

	public static void uploadFiles(String recordId, List<CommunityWrapper.relatedFile> files) {
		if(!files.isEmpty()) {
			List<ContentVersion> contentVersionList = new List<ContentVersion>();
			for(CommunityWrapper.relatedFile file : files) {
				ContentVersion contentVersionFile = new ContentVersion();
				contentVersionFile.ContentLocation = 'S';
				contentVersionFile.PathOnClient = file.PathOnClient;
				contentVersionFile.Title = file.Title;
				contentVersionFile.VersionData = file.VersionData;
				contentVersionList.add(contentVersionFile);
			}
			if(!contentVersionList.isEmpty()) {
				insert contentVersionList;
			}
			List<ContentDocumentLink> contentDocumentList = new List<ContentDocumentLink>();
			for(ContentVersion cv : [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionList]) {
				ContentDocumentLink conDocLink = New ContentDocumentLink();
				conDocLink.LinkedEntityId = recordId;
				conDocLink.ContentDocumentId = cv.ContentDocumentId;
				conDocLink.Visibility = 'AllUsers';
				conDocLink.shareType = 'V'; // V = Viewer, C = Collaborator, I = Inferred
				contentDocumentList.add(conDocLink);
			}
			if(!contentDocumentList.isEmpty()) {
				insert contentDocumentList;
			}
		}
	}
}