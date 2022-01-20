@isTest
private class TestMeetingTrigger {

private static Demo__c meeting = new Demo__c();
public static Account account = new Account();
private static Professional_Services_Allowance__c	psa = new Professional_Services_Allowance__c();

	
	static void prepareData() {
		account.Name = 'Account Name';
		insert account;
		System.debug('Account ID'+account.id);
		psa.Account__c = account.Id;
		psa.Hours_purchased__c = 69;
		insert psa;
	}
	
	@isTest static void testPSMeetingTrigger() {
		prepareData();
		meeting.Account__c = account.Id;
		System.debug('Meeting Account '+meeting.Account__c);
		meeting.Status__c ='Completed';
		meeting.Type__c = 'Professional Services';
		meeting.PS_Consumed_Time__c = 3;
		meeting.Date__c = Date.today();
		meeting.Demo_outcome__c ='';
		Demo__c m = meeting;
		System.debug(meeting);
		insert meeting;
		System.assertEquals([SELECT PS_Available_Hours__c FROM Account WHERE Id = :account.Id].PS_Available_Hours__c,66);
	}
	
}