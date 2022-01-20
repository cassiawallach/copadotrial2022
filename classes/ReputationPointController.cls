public without sharing class ReputationPointController {

    @AuraEnabled
    Public static Decimal getReputationPointByLearningPlanId(String LearningPlanId){
        Id recordId = LearningPlanId;
        List<redwing__Training_Plan_Achievement__c> Training_Plan_AchievementList = new List<redwing__Training_Plan_Achievement__c>();
        if(String.valueOf(recordId.getSobjectType())== 'redwing__Training_Plan__c'){
          Training_Plan_AchievementList = [SELECT Id,redwing__Achievement__r.ReputationPoints__c FROM redwing__Training_Plan_Achievement__c WHERE redwing__Training_Plan__c = :LearningPlanId AND redwing__Achievement__c !=NUll  LIMIT 1];
            if(Training_Plan_AchievementList.size()>0){
                RETURN Training_Plan_AchievementList[0].redwing__Achievement__r.ReputationPoints__c;
            }
        }
        RETURN Null;
        
    }
        
}