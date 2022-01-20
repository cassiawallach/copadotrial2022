public class ContactRelatedPlaygrounds {

    @AuraEnabled
    public static List<Playground__c> GetPlaygroundByContactId(String recordId){
        Id conOrUserId = Id.valueOf(recordId);
        Schema.sObjectType soType = conOrUserId.getSObjectType();
        
        if (String.valueOf(soType) == 'Contact') {
            List<User> user = [Select Id from User where ContactId = :conOrUserId limit 1];
            if (user.isEmpty()) {
                return new List<Playground__c>();
            }
            conOrUserId = user[0].Id;
        }
        RETURN [SELECT Id,Name,CreatedDate,Status__c,Org_Id__c FROM Playground__c WHERE User__c =:conOrUserId ];
    }
}