public with sharing class CustomStringSearchLookupController {
	@AuraEnabled(cacheable=true)
	public static CommunityWrapper.ResponseWrap getImpactedAreas(String searchKey, String formName, String sObjectApiName){
		try {
			List <CommunityWrapper.CustomSobject> returnList = new List <CommunityWrapper.CustomSobject>();
			if(String.isNotBlank(searchKey)) {
				if(String.isNotBlank(formName) && formName.equalsIgnoreCase('copadoSupport')) {
					String tempSearchKey = '%' + searchKey.trim() + '%';
					String formRecordTypeName = (CommunitySupportCaseController.getRecordTypeOfForm(formName) != null) ?
						CommunitySupportCaseController.getRecordTypeOfForm(formName).DeveloperName : null;
					String sQuery = 'SELECT Id, Keyword__c FROM ' + sObjectApiName + ' WHERE Keyword__c LIKE :tempSearchKey '
						+'AND RecordTypeName__c != NULL AND RecordTypeName__c = :formRecordTypeName';
						for (sObject obj: database.query(sQuery)) {
							returnList.add(new CommunityWrapper.CustomSobject(obj.Id, (String) obj.get('Keyword__c')));
						}
				}
			}
			return new CommunityWrapper.ResponseWrap(FALSE, NULL, returnList);
		} catch (Exception ex) {
			return new CommunityWrapper.ResponseWrap(TRUE, ex.getMessage());
		}
	}
}