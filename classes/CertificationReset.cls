public without sharing class CertificationReset {
    
    @AuraEnabled
    Public static boolean checkResetIsRequire(String LearningAssignmentId){
        Id recordId = LearningAssignmentId;
        if(String.valueOf(recordId.getSobjectType())== 'redwing__Training_Plan__c'){
            list<redwing__Learning_Assignment__c> Learning_AssignmentList =  [SELECT Id , Name,redwing__Learning__r.Name FROM redwing__Learning_Assignment__c WHERE redwing__Training_Plan__c  =: LearningAssignmentId AND redwing__Training_Plan__c != NULL LIMIT 1];
            if(Learning_AssignmentList.SIZE()>0){ 
                Learning_AssignmentList =  [
                    SELECT Id, Name, redwing__User__c, redwing__Training_Plan__c 
                    FROM redwing__Learning_Assignment__c 
                    WHERE redwing__Evaluation_Result__c ='Failed' 
                    AND redwing__Evaluation_Times_Taken__c >1 
                    AND redwing__User__c =: UserInfo.getUserId()];
                
                list<redwing__Achievement_Assignment__c> ExpiredAchievementAssignmentList =  [
                    SELECT Id, redwing__Acquisition_Date__c
				    FROM redwing__Achievement_Assignment__c
				    WHERE redwing__User__c =: UserInfo.getUserId()
    				AND redwing__Training_Plan_Achievement__r.redwing__Training_Plan__c =: LearningAssignmentId
                    AND redwing__Status__c = 'Expired'];
                if(Learning_AssignmentList.SIZE()>0 || ExpiredAchievementAssignmentList.SIZE()>0){
                    RETURN TRUE;
                }
            }
        }
        RETURN FALSE;
    }
    
    @AuraEnabled
    Public static void UserCertificationRest(String trainingPlanId){
        list<redwing__Learning_Assignment__c> Learning_AssignmentList = [
			SELECT
            Id, Name, redwing__User__c, redwing__Training_Plan__c
            FROM redwing__Learning_Assignment__c
            WHERE
            ((redwing__Evaluation_Result__c ='Failed' AND redwing__Evaluation_Times_Taken__c >1)
              OR redwing__Training_Plan__c =: trainingPlanId) AND
            redwing__User__c =:UserInfo.getUserId()
        ];
        if(Learning_AssignmentList.size()>0){
            system.debug('Learning_AssignmentList>>'+Learning_AssignmentList);
            list<redwing__Training_Track_Assignment__c> Training_Track_AssignmentList = New list<redwing__Training_Track_Assignment__c>();
            list<redwing__Training_Plan_Assignment__c> Training_Plan_AssignmentList = New list<redwing__Training_Plan_Assignment__c>();
            set<String> Training_PlanIds = new set<String>();
            set<String> UserIds = new set<String>();
            list<String> Training_Track_Levelids  = new list<String>(); 
            for(redwing__Learning_Assignment__c LearningAssignment : Learning_AssignmentList){
                Training_PlanIds.add(LearningAssignment.redwing__Training_Plan__c);
                UserIds.add(LearningAssignment.redwing__User__c);
            }
            if(Training_PlanIds.size()>0){
                Training_Plan_AssignmentList = [
                    SELECT Id 
                    FROM 
                    redwing__Training_Plan_Assignment__c
                    WHERE redwing__Training_Plan__c IN:Training_PlanIds AND redwing__User__c IN:UserIds
                ]; 
                system.debug('Training_Plan_AssignmentList'+Training_Plan_AssignmentList);
                
                list<redwing__Training_Track_Level_Item__c> Training_Track_Level_ItemList = [
                    SELECT 
                    Id,redwing__Training_Track_Level__c 
                    FROM 
                    redwing__Training_Track_Level_Item__c
                    WHERE redwing__Training_Plan__c IN:Training_PlanIds
                ];
                if(Training_Track_Level_ItemList.size()>0){
                    for(redwing__Training_Track_Level_Item__c Training_Track_Level_Item : Training_Track_Level_ItemList){
                        Training_Track_Levelids.add(Training_Track_Level_Item.redwing__Training_Track_Level__c);
                    }
                    system.debug('Training_Track_Levelids:::'+Training_Track_Levelids);
                    if(Training_Track_Levelids.size()>0){
                        list<redwing__Training_Track_Level__c> Training_Track_LevelList = [
                            SELECT 
                            Id, redwing__Training_Track__c
                            FROM redwing__Training_Track_Level__c
                            WHERE Id IN: Training_Track_Levelids AND 
                            redwing__Training_Track__c !=NULL
                        ];
                        system.debug('Training_Track_LevelList'+Training_Track_LevelList);
                        if(Training_Track_LevelList.size()>0){
                            list<String> Training_TrackIds = new list<String>();
                            for(redwing__Training_Track_Level__c Training_Track_Level : Training_Track_LevelList){
                                Training_TrackIds.add(Training_Track_Level.redwing__Training_Track__c);
                            }
                            if(Training_TrackIds.size()>0){
                                list<redwing__Training_Track__c> Training_TrackList = [
                                    SELECT 
                                    Id 
                                    FROM 
                                    redwing__Training_Track__c
                                    WHERE
                                    Id IN: Training_TrackIds
                                ];
                                if(Training_TrackList.size()>0){
                                    if(Training_TrackIds.size()>0){
                                        Training_Track_AssignmentList = [
                                            SELECT 
                                            Id,redwing__Training_Track__c,redwing__User__c
                                            FROM
                                            redwing__Training_Track_Assignment__c
                                            WHERE 
                                            redwing__Training_Track__c IN:Training_TrackIds AND
                                            redwing__User__c IN:UserIds
                                        ];
                                        if(Training_Track_AssignmentList.size()>0){
                                            system.debug('Delete Training_Track_AssignmentList'+Training_Track_AssignmentList);
                                            system.debug('DELETE Training_Plan_AssignmentList'+Training_Plan_AssignmentList);
                                            system.debug('Delete Learning_AssignmentList>>'+Learning_AssignmentList);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
            
            
            if(Training_Track_AssignmentList.size()>0){
                system.debug('Delete Training_Track_AssignmentList'+Training_Track_AssignmentList);
                DELETE Training_Track_AssignmentList;
            }
            if(Training_Plan_AssignmentList.size()>0){
                system.debug('DELETE Training_Plan_AssignmentList'+Training_Plan_AssignmentList);
                DELETE Training_Plan_AssignmentList;
            }
            system.debug('Delete Learning_AssignmentList>>'+Learning_AssignmentList);
            system.debug('Delete Learning_AssignmentList Size >>'+Learning_AssignmentList.size());
        }
    }
}