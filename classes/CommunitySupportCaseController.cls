public with sharing class CommunitySupportCaseController {
	private static List<String> yesNoOptions = new List<String>{'Yes','No'};
	private static List<String> percentageUsersAffected = new List<String>{'0-20%', '20-40%', '40-60%', '60-80%' , 'Above 80%'};
	private static final Map<String, String> FIELD_KEY_API_NAME = new map<String, String> {
		'userPriority' => 'User_Priority__c',
		'productionDeployment' => 'Production_Deployment__c'
	};

	@AuraEnabled
	public static CommunityWrapper.ResponseWrap saveInputsOfCaseForm(String formName, String jsonFieldNameValue){
		try {
			CaseFormResponseWrap caseInputsValues = (CaseFormResponseWrap) System.JSON.deserialize(jsonFieldNameValue, CaseFormResponseWrap.class);
			Case newCase = createCase(formName, caseInputsValues);
			RecordType recordTypeOfForm = getRecordTypeOfForm(formName);
			if(recordTypeOfForm != null) {
				newCase.RecordTypeId = recordTypeOfForm.Id;
			}

			// Defining instance of DMLOptions class to trigger the user email,
			// when the owner of new case is changed based on recordtype.
			Database.DMLOptions dlo = new Database.DMLOptions();
			dlo.EmailHeader.triggerUserEmail = true;
			database.insert(newCase, dlo);

			// Updating user timezone if user wants that.
			if(caseInputsValues.updateTimezone != null && caseInputsValues.updateTimezone) {
				updateUserTimezone(caseInputsValues.userTimezone);
			}
			// Fetch the created case to return along with its case number
			List<Case> createdCase = CommunitySupportCaseUtils.getCreatedCase(newCase.Id);
			// Upload files corresponding to case.
			CommunitySupportCaseUtils.uploadFiles(createdCase[0].Id, caseInputsValues.files);
			return new CommunityWrapper.ResponseWrap(FALSE, NULL, createdCase[0]);
		} catch (Exception ex) {
			return new CommunityWrapper.ResponseWrap(TRUE, ex.getMessage());
		}
	}

	// Method to set the options for picklist fields for form,
	// options can be custom or fetched from existing fields
	@AuraEnabled
	public static CommunityWrapper.ResponseWrap getOptions(String jsonFieldConfig, String formName){
		try {
			List<FieldConfig> fieldConfigList = (List<FieldConfig>) System.JSON.deserialize(jsonFieldConfig, List<FieldConfig>.class);
			Map<String, Schema.SObjectField> fieldMap = getFieldMap('Case');
			for(FieldConfig config : fieldConfigList) {
				// Fetch the picklist options from existing fields
				if(FIELD_KEY_API_NAME.containsKey(config.fieldKey) && fieldMap.containsKey(FIELD_KEY_API_NAME.get(config.fieldKey))){
					Schema.DisplayType fieldDisplayType = fieldMap.get(FIELD_KEY_API_NAME.get(config.fieldKey)).getDescribe().getType();
					if(fieldDisplayType == Schema.DisplayType.PICKLIST) {
						config.fieldOptions = getActivePicklist(fieldMap.get(FIELD_KEY_API_NAME.get(config.fieldKey)));
					}
				}
				// set the custom options for fields for form
				else if(!FIELD_KEY_API_NAME.containsKey(config.fieldKey)){
					config.fieldOptions = getCustomOptions(config.fieldKey, formName);
					config.defaultOption = getDefaultOption(config.fieldKey);
				}
			}
			return new CommunityWrapper.ResponseWrap(FALSE, NULL, fieldConfigList);
		} catch (Exception ex) {
			return new CommunityWrapper.ResponseWrap(TRUE, ex.getMessage());
		}
	}

	// Mthod to fetch the impacted area keywords from custom metadata Case_Impacted_Areas__mdt,
	// based on caseReason of form
	@AuraEnabled(cacheable=true)
	public static CommunityWrapper.ResponseWrap getAcademyOrPlaygroundImpactedArea(String caseReason, String formName){
		try {
			List<CommunityWrapper.PicklistEntry> impactedAreaOptions = new List<CommunityWrapper.PicklistEntry>();
			RecordType recordTypeOfForm = getRecordTypeOfForm(formName);
			if(String.isNotBlank(caseReason) && recordTypeOfForm != null) {
				String recordTypeName = recordTypeOfForm.DeveloperName;
				List<Case_Impacted_Areas__mdt> impactedAreaMetadataList = [SELECT Keyword__c  FROM
																		   Case_Impacted_Areas__mdt WHERE RecordTypeName__c != NULL
																		   AND RecordTypeName__c = :recordTypeName AND Case_Reason__c != NULL
																		   AND Case_Reason__c = :caseReason];
				for(Case_Impacted_Areas__mdt impactedArea : impactedAreaMetadataList) {
					impactedAreaOptions.add(new CommunityWrapper.PicklistEntry(impactedArea.Keyword__c, impactedArea.Keyword__c));
				}
			}
			return new CommunityWrapper.ResponseWrap(FALSE, NULL, impactedAreaOptions);
		} catch (Exception ex) {
			return new CommunityWrapper.ResponseWrap(TRUE, ex.getMessage());
		}
	}

	// Mthod to fetch the valid certificates name
	@AuraEnabled(cacheable=true)
	public static CommunityWrapper.ResponseWrap getCertificates(Boolean fetchCertificates){
		try {
			List<CommunityWrapper.PicklistEntry> certificatesOptions = new List<CommunityWrapper.PicklistEntry>();
			if(fetchCertificates) {
				List<Academy_Certification_Program__c> certificationPrograms = [SELECT Name  FROM
																				Academy_Certification_Program__c WHERE Status__c != NULL
																				AND Status__c = 'Valid'];
				for(Academy_Certification_Program__c certificate : certificationPrograms) {
					certificatesOptions.add(new CommunityWrapper.PicklistEntry(certificate.Name, certificate.Name));
				}
			}
			return new CommunityWrapper.ResponseWrap(FALSE, NULL, certificatesOptions);
		} catch (Exception ex) {
			return new CommunityWrapper.ResponseWrap(TRUE, ex.getMessage());
		}
	}

	private static Map<String, Schema.SObjectField> getFieldMap (String objectApiName) {
		Schema.DescribeSObjectResult objDescription = Schema.describeSObjects(new List<String> {objectApiName})[0];
		return objDescription.fields.getMap();
	}

	// Method to fetch the active picklist values of a field
	private static List<CommunityWrapper.PicklistEntry> getActivePicklist(Schema.SObjectField field) {
		List<Schema.PicklistEntry> entries = new List<Schema.PicklistEntry>();
		entries = field.getDescribe().getPicklistValues();
		List<CommunityWrapper.PicklistEntry> activeEntries = getActivePicklistEntries(entries);
		return activeEntries;
	}

	// Method to fetch the active picklist entries of a field
	private static List<CommunityWrapper.PicklistEntry> getActivePicklistEntries(List<Schema.PicklistEntry> entries) {
		List<CommunityWrapper.PicklistEntry> activeStringEntries = new List<CommunityWrapper.PicklistEntry>();
		for(Schema.PicklistEntry entry : entries) {
			if(entry.isActive()) {
				activeStringEntries.add(new CommunityWrapper.PicklistEntry(entry.getLabel(), entry.getValue()));
			}
		}
		return activeStringEntries;
	}

	// Method to set the customOptions/picklist values for a field of form
	private static List<CommunityWrapper.PicklistEntry> getCustomOptions(String fieldKey, String formName) {
		List<CommunityWrapper.PicklistEntry> options = new List<CommunityWrapper.PicklistEntry>();
		if(fieldKey.equalsIgnoreCase('loginAccessGranted') || fieldKey.equalsIgnoreCase('isAffectDataIntegrity') ||
		  fieldKey.equalsIgnoreCase('haveWorkaround') || fieldKey.equalsIgnoreCase('isAffectCriticalFunctionality')) {
			for(String str : yesNoOptions) {
				CommunityWrapper.PicklistEntry option = new CommunityWrapper.PicklistEntry(str, str);
				options.add(option);
			}
			return options;
		}
		else if(fieldKey.equalsIgnoreCase('percentageUsersAffected')) {
			for(String str : percentageUsersAffected) {
				CommunityWrapper.PicklistEntry option = new CommunityWrapper.PicklistEntry(str, str);
				options.add(option);
			}
			return options;
		}
		else if(fieldKey.equalsIgnoreCase('userTimezone')) {
			return getTimezone();
		}
		else if(fieldKey.equalsIgnoreCase('caseReason')) {
			return getCaseReasonOfForm(formName);
		}
		return options;
	}

	// Method to return the caseReason from Case_Impacted_Areas__mdt,
	// based on recordtype of form
	private static List<CommunityWrapper.PicklistEntry> getCaseReasonOfForm(String formName) {
		List<CommunityWrapper.PicklistEntry> caseReasonOptions = new List<CommunityWrapper.PicklistEntry>();
		RecordType recordTypeOfForm = getRecordTypeOfForm(formName);
		if(recordTypeOfForm != null) {
			String recordTypeName = recordTypeOfForm.DeveloperName;
			List<Case_Impacted_Areas__mdt> impactedAreaMetadataList = [SELECT Case_Reason__c, Keyword__c  FROM
																	   Case_Impacted_Areas__mdt WHERE RecordTypeName__c != NULL
																	   AND RecordTypeName__c = :recordTypeName];
			Set<String> caseReasonsSet = new Set<String>();
			for(Case_Impacted_Areas__mdt impactedArea : impactedAreaMetadataList) {
				if(!caseReasonsSet.Contains(impactedArea.Case_Reason__c)) {
					caseReasonOptions.add(new CommunityWrapper.PicklistEntry(impactedArea.Case_Reason__c, impactedArea.Case_Reason__c));
					caseReasonsSet.add(impactedArea.Case_Reason__c);
				}
			}
		}
		return caseReasonOptions;
	}

	private static String getDefaultOption(String fieldKey) {
		if(fieldKey.equalsIgnoreCase('userTimezone')) {
			return String.valueOf(UserInfo.getTimeZone());
		}
		return null;
	}

	public static RecordType getRecordTypeOfForm(String formName) {
		if(formName.equalsIgnoreCase('copadoSupport')) {
			return retrieveRecordType('Case', 'Support_Case');
		}
		else if(formName.equalsIgnoreCase('academy')) {
			return retrieveRecordType('Case', 'Academy');
		}
		else if(formName.equalsIgnoreCase('playground')) {
			return retrieveRecordType('Case', 'Playground');
		}
		return null;
	}

	private static RecordType retrieveRecordType(String sobjectType, String devName) {
		List<RecordType> recordTypes = new List<RecordType>([SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = :sobjectType AND DeveloperName = :devName]);
		return recordTypes[0];
	}

	// Method to set the case reason and case module of a Case based on selected impacted area on form, form support cases.
	private static void mapCaseReasonAndModuleByImpactedArea(Id impactedAreaId, Case newCase) {
		List<Case_Impacted_Areas__mdt> impactedArea = [SELECT Case_Reason__c , Case_Module__c FROM Case_Impacted_Areas__mdt WHERE Id = :impactedAreaId];
		if(!impactedArea.isEmpty()) {
			newCase.Reason = impactedArea[0].Case_Reason__c;
			newCase.Module__c = impactedArea[0].Case_Module__c;
		}
	}

	// Method to set the priority of case
	private static void setPriority(Case newCase) {
		if(('0-20%'.equalsIgnoreCase(newCase.Business_Impact_Users__c)) ||
		('20-40%'.equalsIgnoreCase(newCase.Business_Impact_Users__c) && 'Yes'.equalsIgnoreCase(newCase.Business_Impact_Workaround__c))) {
			newCase.Priority = 'Low';
		}
		else if(('20-40%'.equalsIgnoreCase(newCase.Business_Impact_Users__c) && 'No'.equalsIgnoreCase(newCase.Business_Impact_Workaround__c)) ||
		('40-60%'.equalsIgnoreCase(newCase.Business_Impact_Users__c) && 'Yes'.equalsIgnoreCase(newCase.Business_Impact_Workaround__c))) {
			newCase.Priority = 'Medium';
		}
		else if(('40-60%'.equalsIgnoreCase(newCase.Business_Impact_Users__c) && 'No'.equalsIgnoreCase(newCase.Business_Impact_Workaround__c)) ||
		('60-80%'.equalsIgnoreCase(newCase.Business_Impact_Users__c) && 'Yes'.equalsIgnoreCase(newCase.Business_Impact_Workaround__c))) {
			newCase.Priority = 'High';
		}
		else if(('60-80%'.equalsIgnoreCase(newCase.Business_Impact_Users__c) && 'No'.equalsIgnoreCase(newCase.Business_Impact_Workaround__c)) ||
		('Above 80%'.equalsIgnoreCase(newCase.Business_Impact_Users__c) && 'Yes'.equalsIgnoreCase(newCase.Business_Impact_Workaround__c))) {
			newCase.Priority = 'Urgent';
		}
		else if(('Above 80%'.equalsIgnoreCase(newCase.Business_Impact_Users__c) && 'No'.equalsIgnoreCase(newCase.Business_Impact_Workaround__c))) {
			newCase.Priority = 'Critical';
		}
	}

	private static Case createCase(String formName, CaseFormResponseWrap caseInputs) {
		Case newCase = new Case();
		newCase.Subject = caseInputs.subject;
		newCase.Description_Rich__c = caseInputs.description;
		if(formName.equalsIgnoreCase('copadoSupport')) {
			newCase.Production_Deployment__c = caseInputs.productionDeployment;
			newCase.Organization_Id__c = caseInputs.orgId;
			newCase.Source_Org__c = caseInputs.sourceOrgId;
			newCase.Target_Org__c = caseInputs.targetOrgId;
			newCase.Login_Access_Granted__c = (caseInputs.loginAccessGranted != null) ? caseInputs.loginAccessGranted.equalsIgnoreCase('Yes') : false;
			newCase.User_Priority__c = caseInputs.userPriority;
			newCase.Business_Impact_Users__c = caseInputs.percentageUsersAffected;
			newCase.Business_Impact_Data_Integrity__c = caseInputs.isAffectDataIntegrity;
			newCase.Business_Impact_Workaround__c = caseInputs.haveWorkaround;
			newCase.Business_Impact_Critical_Functionality__c = caseInputs.isAffectCriticalFunctionality;
			newCase.Affected_Records__c = caseInputs.affectedRecords;
			if(String.isNotBlank(caseInputs.userTimezone) && Timezone.getTimeZone(caseInputs.userTimezone) != null) {
				newCase.User_Timezone__c = Timezone.getTimeZone(caseInputs.userTimezone).getDisplayName();
			}
			setPriority(newCase);
			if(caseInputs.impactedArea != null) {
				newCase.Impacted_Area__c = caseInputs.impactedArea.Name;
				mapCaseReasonAndModuleByImpactedArea(caseInputs.impactedArea.Id, newCase);
			}
			return newCase;
		}
		if(formName.equalsIgnoreCase('academy') || formName.equalsIgnoreCase('playground')) {
			newCase.Impacted_Area__c = caseInputs.academyOrPlaygroundImpactedArea;
			newCase.Reason = caseInputs.caseReason;
			newCase.Affected_Certificate_Name__c = caseInputs.certificate;
			newCase.Affected_Module_Name__c = caseInputs.module;
		}
		return newCase;
	}

	// Method to return all the available timeZone in PicklistEntry type
	private static List<CommunityWrapper.PicklistEntry> getTimeZone(){
		List<CommunityWrapper.PicklistEntry> timezoneOptions = new List<CommunityWrapper.PicklistEntry>();
		Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getDescribe();
		List<Schema.PicklistEntry> pkListEntry = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry  pkEnt : pkListEntry) {
			timezoneOptions.add(new CommunityWrapper.PicklistEntry(pkEnt.getLabel(), pkEnt.getValue()));
		}
		return timezoneOptions;
	}

	// Method to update the time zone of user based on selection of new timezone
	private static void updateUserTimezone(String timezone) {
		User loginUser = new User(Id=UserInfo.getUserId());
		loginUser.TimeZoneSidKey = timezone;
		update loginUser;
	}

	// Form response wrapper class
	public class CaseFormResponseWrap{
		@AuraEnabled public CommunityWrapper.CustomSobject impactedArea;
		@AuraEnabled public String academyOrPlaygroundImpactedArea;
		@AuraEnabled public String subject;
		@AuraEnabled public String caseReason;
		@AuraEnabled public String certificate;
		@AuraEnabled public String module;
		@AuraEnabled public String productionDeployment;
		@AuraEnabled public String orgId;
		@AuraEnabled public String sourceOrgId;
		@AuraEnabled public String targetOrgId;
		@AuraEnabled public String loginAccessGranted;
		@AuraEnabled public String userPriority;
		@AuraEnabled public String percentageUsersAffected;
		@AuraEnabled public String isAffectDataIntegrity;
		@AuraEnabled public String haveWorkaround;
		@AuraEnabled public String isAffectCriticalFunctionality;
		@AuraEnabled public String affectedRecords;
		@AuraEnabled public String description;
		@AuraEnabled public String userTimezone;
		@AuraEnabled public Boolean updateTimezone;
		@AuraEnabled public List<CommunityWrapper.relatedFile> files;
	}

	// Field wrapper class, used to store the field name of UI in fieldKey
	// ,fieldOptions and defaultOption
	public class FieldConfig {
		@AuraEnabled public String fieldKey;
		@AuraEnabled public Object fieldOptions;
		@AuraEnabled public String defaultOption;
	}
}