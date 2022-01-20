public with sharing class LearningAssignmentTriggerHelper {
    /** 
    Updates the Achievement Status of the user based on the Learning assignment validation status. 
    */
    public static void updateAchievementStatus(List<redwing__Learning_Assignment__c> updatedLearningAssignments, Map<Id, redwing__Learning_Assignment__c> oldLearningAssignments){
        Set<Id> memberIds = new Set<Id>();
        Set<Id> memberIdsForAchivement = new Set<Id>();
        Map<Id, Set<Id>> learningPlanUserIds = new Map<Id, Set<Id>>();
        Map<Id, Id> learningPlanwithAchivIds = new Map<Id, Id>();
        List<redwing__Achievement_Assignment__c> achivAssignments = new List<redwing__Achievement_Assignment__c>();
        
        for (redwing__Learning_Assignment__c learningAssignment : updatedLearningAssignments) {
            if(oldLearningAssignments.get(learningAssignment.id).Validation_Status__c != learningAssignment.Validation_Status__c && learningAssignment.Validation_Status__c == 'Success'){
                memberIds.add(learningAssignment.redwing__User__c);
                if (!learningPlanUserIds.containsKey(learningAssignment.redwing__Training_Plan__c)) {
                    learningPlanUserIds.put(learningAssignment.redwing__Training_Plan__c, new Set<Id>());
                }
                learningPlanUserIds.get(learningAssignment.redwing__Training_Plan__c).add(learningAssignment.redwing__User__c);
            }
        }

        if (!learningPlanUserIds.isEmpty()) {
            for(redwing__Learning_Assignment__c module : [SELECT Id, Validation_Status__c, redwing__Learning__r.Interactive_Validation__c, redwing__Learning__r.Is_Dynamic__c,
                                                            redwing__Training_Plan__c, redwing__User__c
                                                            FROM redwing__Learning_Assignment__c
                                                            WHERE ID <> :oldLearningAssignments.keySet() AND
                                                            Validation_Status__c <> 'Success' AND
                                                            redwing__User__c IN :memberIds AND
                                                            redwing__Training_Plan__c IN :learningPlanUserIds.keySet() AND
                                                            redwing__Learning__r.Is_Dynamic__c = true AND
                                                            redwing__Learning__r.Interactive_Validation__c != null AND 
                                                            redwing__Learning__r.Interactive_Validation__r.Status__c ='Active']) {
                if(learningPlanUserIds.containsKey(module.redwing__Training_Plan__c)){
                    Set<Id> userIds = learningPlanUserIds.get(module.redwing__Training_Plan__c);
                    if (userIds.size() > 1) {
                        userIds.remove(module.redwing__User__c);
                    } else {
                        learningPlanUserIds.remove(module.redwing__Training_Plan__c);
                    }
                }
            }
        }

        if (!learningPlanUserIds.isEmpty()) {
            for (redwing__Training_Plan_Achievement__c learningPlanAchiv : [Select Id, redwing__Training_Plan__c From redwing__Training_Plan_Achievement__c Where redwing__Training_Plan__c IN :learningPlanUserIds.keySet()]) {
                learningPlanwithAchivIds.put(learningPlanAchiv.redwing__Training_Plan__c, learningPlanAchiv.Id);
            }
        }

        if (!learningPlanwithAchivIds.isEmpty()) {
            for(Id lpId : learningPlanUserIds.keySet()){
                memberIdsForAchivement.addAll(learningPlanUserIds.get(lpId));
            }
            for (redwing__Achievement_Assignment__c achivAssignment : [Select Id, redwing__Status__c 
                                                                        From redwing__Achievement_Assignment__c 
                                                                        Where redwing__Status__c = 'Eligible' AND
                                                                        redwing__Training_Plan_Achievement__c IN :learningPlanwithAchivIds.values() AND
                                                                        redwing__User__c IN :memberIdsForAchivement]) {
                achivAssignment.redwing__Status__c = 'Acquired';
                achivAssignments.add(achivAssignment);
            }

            if (!achivAssignments.isEmpty()) {
                update achivAssignments;
            }
        }
    }
}