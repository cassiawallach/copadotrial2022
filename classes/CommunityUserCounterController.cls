/* 
 * This class is used to fetch the number of active users.
*/
public without sharing class CommunityUserCounterController {
    // Method for fetching the active users count.
    @AuraEnabled
    public static Integer getUserRecords() {
        List<AggregateResult> usersCount = [SELECT Count(Id) users FROM User WHERE IsActive = TRUE];
        if(!usersCount.isEmpty()) {
            return Integer.valueOf(usersCount[0].get('users'));
        }
        return 0;
    }
}