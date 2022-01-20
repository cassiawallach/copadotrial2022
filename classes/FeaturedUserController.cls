public class FeaturedUserController {
    
    @AuraEnabled
    Public Static List<User> GetFeaturedUsers(String UserId){
        List<User> Users = new list<User>();
        /*Set<Id> userIds = new Set<Id>();
List<AggregateResult> AggregateResultList = [SELECT count(Id),redwing__User__c FROM redwing__achievement_assignment__c WHERE redwing__User__r.IsPortalEnabled = TRUE AND redwing__Status__c = 'Acquired' GROUP BY redwing__User__c  HAVING count(Id) > 30];
if(AggregateResultList != null && AggregateResultList.size() > 0){ 
for(AggregateResult aggr:AggregateResultList){             
userIds.add((String)aggr.get('redwing__User__c'));
} 
if(userIds.size()>0){
Users = [SELECT Id,Name,Title,AboutMe,FullPhotoUrl FROM USER WHERE ID IN: userIds];
}
}*/
        if(UserId!=''){
            Users = [SELECT Id,Name,Title,AboutMe,FullPhotoUrl FROM USER WHERE ID =: UserId LIMIT 1];
        }
        RETURN Users;
    }
}