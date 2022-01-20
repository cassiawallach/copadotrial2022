trigger LearningAssignmentTrigger on redwing__Learning_Assignment__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        LearningAssignmentTriggerHelper.updateAchievementStatus(Trigger.new, Trigger.oldMap);
    }
}