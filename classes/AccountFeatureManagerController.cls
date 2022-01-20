public with sharing class AccountFeatureManagerController {
    private Salesforce_Org__c org {get;set;}
	public List<sfFma__FeatureParameterInteger__c> orgFeatures {get;set;}
	public Contract contractForOrg {get;set;}

	public AccountFeatureManagerController(ApexPages.StandardController stdController) {
        org = (Salesforce_Org__c)stdController.getRecord();
		org = [SELECT Id, Parent_Account__c FROM Salesforce_Org__c WHERE Id = :org.Id];
		getorgFeatures();
		List<Contract> cs = [SELECT Id, ContractNumber, Custom_Salesforce_Org__c, StartDate, EndDate, Status
		  					   FROM Contract WHERE AccountId = :org.Parent_Account__c AND Status = 'Activated' ORDER BY EndDate DESC LIMIT 1];
		if(cs.size()== 1){
			contractForOrg = cs.get(0);
		}
		else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This org does not have an activated contract.'));
		}
	}
	public void getorgFeatures(){
		orgFeatures = new List<sfFma__FeatureParameterInteger__c>();
		orgFeatures = [select Id, sfFma__FullName__c, Expiration_Date__c, sfFma__Value__c, sfFma__License__c, sfFma__FeatureParameter__c
		from sfFma__FeatureParameterInteger__c
        where sfFma__License__r.Salesforce_Org__c =:org.Id
        and sfFma__FullName__c != null];
		for (sfFma__FeatureParameterInteger__c fpi: orgFeatures) {
			if (fpi.sfFma__Value__c == null) fpi.sfFma__Value__c = 0;
		}
		system.debug('### fetched records: '+orgFeatures.size());
	}
	public void updateorgFeatures(){
		update orgFeatures;
        syncFeatures(org.Id);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Features are being synchronised.'));
	}
    @future(callout=true)
	private static void syncFeatures(Id orgId){
		admin_utilities.syncFeatures(orgId);
	}

}