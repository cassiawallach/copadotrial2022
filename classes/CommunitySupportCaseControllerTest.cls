@IsTest
public class CommunitySupportCaseControllerTest {
	@IsTest
	public static void testGetOptions() {
		List<CommunitySupportCaseController.FieldConfig> fieldConfigList = new List<CommunitySupportCaseController.FieldConfig>();
		CommunitySupportCaseController.FieldConfig fieldConfig1 = new CommunitySupportCaseController.FieldConfig();
		fieldConfig1.fieldKey = 'percentageUsersAffected';
		CommunitySupportCaseController.FieldConfig fieldConfig2 = new CommunitySupportCaseController.FieldConfig();
		fieldConfig2.fieldKey = 'userPriority';
		CommunitySupportCaseController.FieldConfig fieldConfig3 = new CommunitySupportCaseController.FieldConfig();
		fieldConfig3.fieldKey = 'userTimezone';
		CommunitySupportCaseController.FieldConfig fieldConfig4 = new CommunitySupportCaseController.FieldConfig();
		fieldConfig4.fieldKey = 'caseReason';
		fieldConfigList.add(fieldConfig1);
		fieldConfigList.add(fieldConfig2);
		fieldConfigList.add(fieldConfig3);
		fieldConfigList.add(fieldConfig4);
		String fieldConfigString = JSON.Serialize(fieldConfigList);
		CommunityWrapper.ResponseWrap response = CommunitySupportCaseController.getOptions(fieldConfigString, 'copadoSupport');
		List<CommunitySupportCaseController.FieldConfig> returnList = (List<CommunitySupportCaseController.FieldConfig>) response.result;
		System.assertEquals(TRUE, returnList[0].fieldOptions != null);
		System.assertEquals(TRUE, returnList[1].fieldOptions != null);
	}

	@IsTest
	public static void testGetAcademyOrPlaygroundImpactedArea() {
		CommunityWrapper.ResponseWrap response = CommunitySupportCaseController.getAcademyOrPlaygroundImpactedArea('Certifications', 'academy');
		List<CommunityWrapper.PicklistEntry> returnList = (List<CommunityWrapper.PicklistEntry>)response.result;
		System.assertEquals(TRUE, returnList.size() > 0);
	}

	@IsTest
	public static void testGetCertificates() {
		// Insert a valid academy certificate
		Academy_Certification_Program__c certificate = new Academy_Certification_Program__c();
		certificate.Name = 'Test Certificate';
		certificate.Status__c = 'Valid';
		certificate.Copado_Version__c = '12';
		insert certificate;

		CommunityWrapper.ResponseWrap response = CommunitySupportCaseController.getCertificates(true);
		List<CommunityWrapper.PicklistEntry> returnList = (List<CommunityWrapper.PicklistEntry>)response.result;
		System.assertEquals(1, returnList.size());
	}

	@IsTest
	public static void testSaveInputsOfCaseForm() {
		CommunitySupportCaseController.CaseFormResponseWrap newCase = new CommunitySupportCaseController.CaseFormResponseWrap();
		// Get impacted area for case from custom metadata
		CommunityWrapper.ResponseWrap impactedAreaResponse = CustomStringSearchLookupController.getImpactedAreas('test','copadoSupport','Case_Impacted_Areas__mdt');
		List <CommunityWrapper.CustomSobject> returnList = (List <CommunityWrapper.CustomSobject>) impactedAreaResponse.result;
		// Set attachements
		List<CommunityWrapper.relatedFile> files = new List<CommunityWrapper.relatedFile>();
		CommunityWrapper.relatedFile file1 = new CommunityWrapper.relatedFile();
		file1.PathOnClient = 'Test File';
		file1.Title = 'Test File';
		file1.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body');
		files.add(file1);

		// Set the values for case form response
		newCase.impactedArea = returnList[0];
		newCase.subject = 'Test Subject';
		newCase.description = 'Test Description';
		newCase.orgId = 'Test OrgId';
		newCase.files = files;
		CommunityWrapper.ResponseWrap response = CommunitySupportCaseController.saveInputsOfCaseForm('copadoSupport', JSON.Serialize(newCase));
		Case createdCase = (Case) response.result;
		System.assertEquals(newCase.subject, createdCase.Subject);
		System.assertEquals(newCase.impactedArea.Name, createdCase.Impacted_Area__c);
	}
}