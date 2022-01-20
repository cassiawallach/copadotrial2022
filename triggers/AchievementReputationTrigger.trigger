trigger AchievementReputationTrigger on redwing__Achievement_Assignment__c (before update, after update) {
    
    if(Trigger.isBefore && Trigger.isUpdate){
        AchievementAssignmentHandler.updateAchievementStatus(Trigger.new, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        AchievementAssignmentHandler.updateReputationPoints(Trigger.new, Trigger.oldMap);
    }
    
}