public class MeetingTriggerHelper {
	private static List<Demo__c> meetingList = new List<Demo__c>();
	private static List<Professional_Service_Consumption__c> professionalServicesConsumptionList 
	= new List<Professional_Service_Consumption__c>();   

	public static void prepareMeetingToMap(){
		if (Trigger.isDelete) return;
		for (SObject newMeeting : Trigger.new){
			Demo__c meeting = (Demo__c)newMeeting;
			meetingList.add(meeting);
		}
		professionalServicesConsumptionsToCreate();
	}

	public static void professionalServicesConsumptionsToCreate(){
		for (Demo__c m : meetingList){
			if (m.Account__c != null && m.PS_Consumed_Time__c != null && m.Status__c =='Completed'
				&& m.Type__c =='Professional Services' && m.Date__c != null){
				Professional_Service_Consumption__c psc = new Professional_Service_Consumption__c();
				psc.Account__c = m.Account__c;
				psc.Hours_consumed__c = m.PS_Consumed_Time__c;
				psc.Meeting_Id__c = m.id;
				psc.Meeting_Date__c =m.Date__c;
				psc.Meeting_Notes__c=m.Demo_outcome__c;
				professionalServicesConsumptionList.add(psc);
			}
		}
	}

	public static void insertProfessionalServicesConsumptions(){
		if(professionalServicesConsumptionList.size()>0){
			upsert professionalServicesConsumptionList Meeting_Id__c;
		}
	}

}