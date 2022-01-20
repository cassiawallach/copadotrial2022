public with sharing class ReleaseTriggerHelper {
	
	private static Map<Id, List<copado__User_Story__c>> releases = new Map<Id, List<copado__User_Story__c>>();
	public static List<copado__User_Story__c> userStoriesToUpdate = new List<copado__User_Story__c>();

	public static void changeUserStoriesStatus(copado__Release__c oldSoRelease, copado__Release__c soRelease){ 

		if(releases.containsKey(soRelease.Id) && 
			(oldSoRelease.copado__Status__c != soRelease.copado__Status__c && soRelease.copado__Status__c == 'Released')){
			for (copado__User_Story__c us :releases.get(soRelease.Id)){
				us.copado__Status__c='Released';
				userStoriesToUpdate.add(us);
			}
		}	
	}

	public static void prepareData (Set<Id>  releasesId){
	for (copado__User_Story__c userStory : [SELECT Id, copado__Status__c, copado__Release__c FROM copado__User_Story__c WHERE
		copado__Status__c !='Cancelled' AND ((copado__Environment__r.Name LIKE '%BP%' OR copado__Environment__r.Name LIKE '%Patch%') AND copado__Release__c IN :releasesId)]){

			if(releases.containsKey(userStory.copado__Release__c)){
				List<copado__User_Story__c> listOfUS = releases.get(userStory.copado__Release__c);
				listOfUS.add(userStory);
			}
			else {
				List<copado__User_Story__c> listOfUS = new List<copado__User_Story__c>();
				listOfUS.add(userStory);
				releases.put(userStory.copado__Release__c,listOfUS);
			}
		}	
	}

	public static void updateUserStoriesStatus (){
		update userStoriesToUpdate;
	}
}