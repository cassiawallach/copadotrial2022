public class AchievementAssignmentHandler {
    /** 
    Updates the Achievement Status of the user based on the Learning assignment validation status. 
    */
    public static void updateAchievementStatus(List<redwing__Achievement_Assignment__c> updatedAcvAssignments, Map<Id, redwing__Achievement_Assignment__c> oldAcvAssignments){
        Map<Id, Id> trainingPlanAchievementIdWithUser = new Map<Id, Id>();
        Map<Id, Id> trainingPlanWithUser = new Map<Id, Id>();
        Map<Id, Id> trainingPlanWithTPAchivement = new Map<Id, Id>();
        Map<Id, Id> tPlanWithUserForInvalidLA = new Map<Id, Id>();

        for (redwing__Achievement_Assignment__c badge : updatedAcvAssignments) {
            if(oldAcvAssignments.get(badge.id).redwing__Status__c != badge.redwing__Status__c && badge.redwing__Status__c == 'Acquired'){
                trainingPlanAchievementIdWithUser.put(badge.redwing__Training_Plan_Achievement__c, badge.redwing__User__c);
            }
        }

        if (!trainingPlanAchievementIdWithUser.isEmpty()) {
            for(redwing__Training_Plan_Achievement__c trainingPlanAchievement : [Select Id, redwing__Training_Plan__c From redwing__Training_Plan_Achievement__c Where Id IN :trainingPlanAchievementIdWithUser.keySet()]) {
                if (trainingPlanAchievementIdWithUser.containsKey(trainingPlanAchievement.Id)) {
                    Id achievementUserId = trainingPlanAchievementIdWithUser.get(trainingPlanAchievement.Id);
                    trainingPlanWithUser.put(achievementUserId, trainingPlanAchievement.redwing__Training_Plan__c);
                    trainingPlanWithTPAchivement.put(trainingPlanAchievement.Id, trainingPlanAchievement.redwing__Training_Plan__c);
                }
            }
        }

        if (!trainingPlanWithUser.isEmpty()) {
            for(redwing__Learning_Assignment__c module : [SELECT Id, Validation_Status__c, redwing__Learning__r.Interactive_Validation__c, redwing__Learning__r.Is_Dynamic__c,
                                                            redwing__Training_Plan__c, redwing__User__c
                                                            FROM redwing__Learning_Assignment__c
                                                            WHERE Validation_Status__c <> 'Success' AND
                                                            redwing__User__c IN :trainingPlanWithUser.keySet() AND
                                                            redwing__Training_Plan__c IN :trainingPlanWithUser.values() AND
                                                            redwing__Learning__r.Is_Dynamic__c = true AND
                                                            redwing__Learning__r.Interactive_Validation__c != null AND 
                                                            redwing__Learning__r.Interactive_Validation__r.Status__c ='Active']) {
                tPlanWithUserForInvalidLA.put(module.redwing__Training_Plan__c, module.redwing__User__c);
            }
        }

        if (!tPlanWithUserForInvalidLA.isEmpty()) {
            for (redwing__Achievement_Assignment__c badge : updatedAcvAssignments) {
                Id trainingPlanId =  trainingPlanWithTPAchivement.containsKey(badge.redwing__Training_Plan_Achievement__c) ? trainingPlanWithTPAchivement.get(badge.redwing__Training_Plan_Achievement__c) : null;
                if(trainingPlanId != null && oldAcvAssignments.get(badge.id).redwing__Status__c != badge.redwing__Status__c && badge.redwing__Status__c == 'Acquired'
                 && tPlanWithUserForInvalidLA.containsKey(trainingPlanId) && tPlanWithUserForInvalidLA.get(trainingPlanId) == badge.redwing__User__c ) {
                    badge.redwing__Status__c = 'Eligible';
                }
            }
        }
    }
    /** 
    Updates the reputation points of the user based on the achievement reputation points. 
    */
    public static void updateReputationPoints(List<redwing__Achievement_Assignment__c> updatedAcvAssignments, Map<Id, redwing__Achievement_Assignment__c> oldAcvAssignments){
        Set<Id> memberIds = new Set<Id>();
        Set<Id> achievementIds = new Set<Id>();
        Map<Id, Set<Id>> memberToAchievementMap = new Map<Id, Set<Id>>();
        for (redwing__Achievement_Assignment__c badge : updatedAcvAssignments) {
            if(oldAcvAssignments.get(badge.id).redwing__Status__c != badge.redwing__Status__c && badge.redwing__Status__c == 'Acquired'){
                memberIds.add(badge.redwing__User__c);
                Set<Id> acvList = new Set<Id>{badge.redwing__Achievement__c};
                    if(memberToAchievementMap.get(badge.redwing__User__c) != null){
                        acvList.addAll(memberToAchievementMap.get(badge.redwing__User__c));
                    }
                memberToAchievementMap.put(badge.redwing__User__c, acvList);
                achievementIds.add(badge.redwing__Achievement__c);
            }
        }
        if(!memberIds.isEmpty() && !achievementIds.isEmpty()){
            Map<Id, redwing__Achievement__c> achievementMap = new Map<Id, redwing__Achievement__c>([SELECT Id, ReputationPoints__c 
                                                                                                    FROM redwing__Achievement__c 
                                                                                                    WHERE Id IN :achievementIds AND ReputationPoints__c != null]);
            List<NetworkMember> members = [SELECT Id, MemberId, ReputationPoints 
                                           FROM NetworkMember 
                                           WHERE MemberId IN :memberIds];
            For(NetworkMember member : members){
                if(memberToAchievementMap.get(member.MemberId) != null){
                    For(Id achievementId : memberToAchievementMap.get(member.MemberId)){
                        if(achievementMap.get(achievementId) != null){
                            member.ReputationPoints = member.ReputationPoints + achievementMap.get(achievementId).ReputationPoints__c;
                        } 
                    }
                }
            }
            update members;
        }
    }

}