public with sharing class AccountFeatureService {
	
	/*public static void enforceValues(Account_Feature__c af){
		af.Name = af.Feature__c;
		af.Unique_Id__c = af.Salesforce_Org__c + '_' + af.Name;

	}
	public static void calcExpirationDate(Account_Feature__c af){
		Datetime startDate = af.Enabled_Since__c;
		if(startDate == null) startDate = af.CreatedDate;
		if(startDate == null) startDate = System.now();
		
		//set the right enabled since date
		if(af.Enabled_Since__c == null && af.Enabled__c){
			af.Enabled_Since__c = startDate.date();
		}

		//manually edited are not calculated
		if(af.Manually_Edited__c) return;
		

		//If we have trial days and an enabled date, but no expiration date we set the expiration date
		if(af.Enabled_Since__c!=null && af.Trial_Days__c!=null && af.Expiration_Date__c==null){
			af.Expiration_Date__c = af.Enabled_Since__c.addDays(Integer.valueOf(af.Trial_Days__c));	
		}

		//Handle expiration
		if(af.Expiration_Date__c!=null){
			//trial feature only
			af.Enabled__c = af.Expiration_Date__c >= System.today();
		}
		else{
			// We should always have an expiration date.
			// It's only possible if have no expiration date if Trial days == null
		}
	}*/
}