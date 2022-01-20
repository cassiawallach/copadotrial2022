public class TrainingConsole {
      
    //Get All Events List
    @AuraEnabled
    public static list<redwing__ILT_Event__c> getAllILTEvents(){
        RETURN [SELECT Id,name,redwing__Learning__c,redwing__Learning__r.Name, (SELECT Id,Name,redwing__Learning__c,redwing__Learning__r.Name FROM redwing__ILT_Event_Classes__r) FROM redwing__ILT_Event__c];
    }
    
    //get All Not Completed Prerequistite Items By LearningId
    @AuraEnabled
    public static PrerequisiteRequestResponse getPrerequistiteItemsByLearningId(String ILTEventLearningId){
        PrerequisiteRequestResponse PreResponse = new PrerequisiteRequestResponse();
        list<AchievementAssignmentWrap> AchievementAssignmentList = new list<AchievementAssignmentWrap>();
        List<redwing__Prerequisite_Item__c> Prerequisite_Items = new List<redwing__Prerequisite_Item__c>([SELECT Id ,Name,redwing__Prerequisite__c  FROM redwing__Prerequisite_Item__c WHERE redwing__Achievement__r.redwing__Type__c!= 'Certifications' AND redwing__Required_Status__c !='Completed' AND redwing__Prerequisite__c IN (SELECT redwing__Prerequisite__c FROM redwing__Learning_Prerequisite__c WHERE redwing__Learning__c =:ILTEventLearningId)]);
        PreResponse.Prerequisite_Items= new List<redwing__Prerequisite_Item__c>(Prerequisite_Items);
        List<String> PrequistiteItemNames = new List<String>();
        for(redwing__Prerequisite_Item__c Item : Prerequisite_Items){
            PrequistiteItemNames.add(Item.Name);
        }
        if(PrequistiteItemNames.size()>0){
           list<redwing__Achievement__c> Achievements = new list<redwing__Achievement__c>([SELECT Id,Name,(SELECT Id, Name,redwing__User__c,redwing__User__r.Name, redwing__Achievement__c, redwing__Acquisition_Date__c, redwing__Contact__c, redwing__Status__c,redwing__Achievement__r.redwing__Type__c FROM redwing__Achievement_Assignments__r) FROM redwing__Achievement__c WHERE Name In : PrequistiteItemNames]);
            for(redwing__Achievement__c Achievement : Achievements){
                for(redwing__Achievement_Assignment__c Assignment : Achievement.redwing__Achievement_Assignments__r){
                    if(Assignment.redwing__Achievement__r.redwing__Type__c!='Certifications'){
                        AchievementAssignmentWrap  achivementWrap = new AchievementAssignmentWrap();
                        achivementWrap.UserId = Assignment.redwing__User__c;
                        achivementWrap.UserName = Assignment.redwing__User__r.Name;
                        achivementWrap.PrerequisiteId = Achievement.Id ;
                        achivementWrap.PrerequisiteName = Achievement.Name;
                        achivementWrap.PrerequisiteItemId = Assignment.Id;
                        achivementWrap.status = Assignment.redwing__Status__c;
                        AchievementAssignmentList.add(achivementWrap);
                    }
                }
            }
        }
        PreResponse.AchievementAssignmentList= new List<AchievementAssignmentWrap>(AchievementAssignmentList);
        RETURN PreResponse;
    }
    
    //Training Console
    @AuraEnabled
    public static NewResponse GetILTCLassesByEventId(String eventId){
        NewResponse response = new NewResponse();
        Map<String,String> LearningIdWithEventClass = new Map<String,String>();
        MAP<Id,redwing__ILT_Event__c> ILTEventRecordMap = NEW MAP<Id,redwing__ILT_Event__c>([SELECT Id,name,redwing__Learning__c,redwing__Learning__r.Name, (SELECT Id,Name,redwing__Learning__c,redwing__Learning__r.Name FROM redwing__ILT_Event_Classes__r) FROM redwing__ILT_Event__c WHERE Id =:eventId]);
        for(String ILTEventId : ILTEventRecordMap.keyset()){
            if(ILTEventRecordMap.get(ILTEventId).redwing__ILT_Event_Classes__r!=NULL){
                for(redwing__ILT_Event_Class__c EventClass : ILTEventRecordMap.get(ILTEventId).redwing__ILT_Event_Classes__r){
                    LearningIdWithEventClass.put(EventClass.redwing__Learning__c,EventClass.Id);
                }
            }
        }
        response.AcademyCertificationPrograms = new List<Academy_Certification_Program__c>([SELECT Id,name FROM Academy_Certification_Program__c WHERE Status__c = 'Valid']);
        if(LearningIdWithEventClass.size()>0){
            List<String> ContactIds = new List<String>();
            Map<String,redwing__ILT_Roster__c> ContactIdWithRoaster = new Map<String,redwing__ILT_Roster__c>();
            MAP<Id,redwing__ILT_Class__c> ILTClasses = NEW MAP<Id,redwing__ILT_Class__c>([SELECT Id,name,redwing__Learning__c,redwing__Learning__r.Name,(SELECT  Id, Name, redwing__Attended__c, redwing__Learning_Assignment__c, redwing__Grade__c, redwing__ILT_Class__c, redwing__ILT_Session__c,redwing__ILT_Session__r.Name, redwing__Status__c, redwing__User__c,redwing__User__r.Name,redwing__User__r.ContactId, redwing__Registered_Date__c FROM redwing__ILT_Rosters__r) FROM redwing__ILT_Class__c WHERE redwing__Learning__c IN: LearningIdWithEventClass.keySet()]);
            system.debug(ILTClasses);
            response.ILTClasses = New  List<redwing__ILT_Class__c>();
            response.ILTClasses.addAll(ILTClasses.values());
            List<Academy_Certification__c> AcademyCertificationList = New  List<Academy_Certification__c>();
            Map<String,List<Academy_Certification__c>> ContactIdWithListOfAcademy_CertificationMap = new Map<String,List<Academy_Certification__c>>();
            if(ILTClasses.size()>0){
                for(redwing__ILT_Class__c ILTClass : ILTClasses.values()){
                    if(ILTClass.redwing__ILT_Rosters__r!=NULL){
                        for(redwing__ILT_Roster__c Roaster :ILTClass.redwing__ILT_Rosters__r){
                            system.debug(Roaster.redwing__Status__c);
                            ContactIds.add(Roaster.redwing__User__r.ContactId);
                            ContactIdWithRoaster.put(Roaster.redwing__User__r.ContactId,Roaster);
                        }
                    }
                }
                if(ContactIds.size()>0){
                    AcademyCertificationList =[SELECT Id,Certification_Student__c,Certification_Program__r.Name,Earned_Date__c,Certification_Student__r.Contact__c , Expiration_Date__c, Status__c FROM Academy_Certification__c WHERE Certification_Student__r.Contact__c IN: ContactIds];                                       
                    List<Academy_Certification__c> TempAcademy_Certification = new List<Academy_Certification__c>();
                    for(Academy_Certification__c Academy_Certification: AcademyCertificationList){
                        if(ContactIdWithListOfAcademy_CertificationMap.containsKey(Academy_Certification.Certification_Student__r.Contact__c)){
                            TempAcademy_Certification = new List<Academy_Certification__c>();
                            TempAcademy_Certification = ContactIdWithListOfAcademy_CertificationMap.get(Academy_Certification.Certification_Student__r.Contact__c);
                            TempAcademy_Certification.add(Academy_Certification);
                            ContactIdWithListOfAcademy_CertificationMap.put(Academy_Certification.Certification_Student__r.Contact__c,TempAcademy_Certification);
                        }
                        else{
                            TempAcademy_Certification = new List<Academy_Certification__c>();
                            TempAcademy_Certification.add(Academy_Certification);
                            ContactIdWithListOfAcademy_CertificationMap.put(Academy_Certification.Certification_Student__r.Contact__c,TempAcademy_Certification);
                        }
                    }
                     response.ContactIdWithListOfAcademy_CertificationMap = New Map<String,List<Academy_Certification__c>>(ContactIdWithListOfAcademy_CertificationMap);
                }
                return response;
            }
        }
        Return NULL;
    }
    
    //Training Console
    @AuraEnabled
    public static Map<String,List<Playground__c>> getPlaygroundsListByUserIds(String UserIdsString){
        Map<String,List<Playground__c>> contactIdWithPlayground = new Map<String,List<Playground__c>>();
        List<Playground__c> Playgrounds = new List<Playground__c>([SELECT Id,Name, User__c, Status__c FROM Playground__c WHERE User__c IN: JSON_String_To_list_parse(UserIdsString)]);
        List<Playground__c> tempPlaygroundList = new List<Playground__c>();
        for(Playground__c playground : Playgrounds){
            tempPlaygroundList = new List<Playground__c>();
            if(contactIdWithPlayground.containsKey(playground.User__c)){
                tempPlaygroundList = contactIdWithPlayground.get(playground.User__c);
                tempPlaygroundList.add(playground);
                contactIdWithPlayground.put(playground.User__c,tempPlaygroundList);
            }
            else{
                tempPlaygroundList.add(playground);
                contactIdWithPlayground.put(playground.User__c,tempPlaygroundList);
            }
        }
        if(contactIdWithPlayground.size()>0){
            RETURN contactIdWithPlayground;
        }
        RETURN NULL;
    }
    
    public static List<String> JSON_String_To_list_parse(String json) {
		return (List<String>) System.JSON.deserialize(json, List<String>.class);
	}
    
    Public Class NewResponse{
        @AuraEnabled public List<Academy_Certification_Program__c> AcademyCertificationPrograms;
        @AuraEnabled Public list<redwing__ILT_Class__c> ILTClasses;
        @AuraEnabled Public Map<String,List<Academy_Certification__c>> ContactIdWithListOfAcademy_CertificationMap;
    }
    
    public class responseWrap{
        @AuraEnabled public String ILTEventId;
        @AuraEnabled public String ILTEventName;
        @AuraEnabled public String ILTEventLearningId;
        @AuraEnabled public String ILTEventLearningName;
        @AuraEnabled public String ILTEventClassId;
        @AuraEnabled public String ILTEventClassName;
        @AuraEnabled public String ILTEventClassLearningId;
        @AuraEnabled public String ILTEventClassLearningName;
        @AuraEnabled public List<CertificateUserDetails> CertificateUserDetailList;
    }
    
    public class CertificateUserDetails{
        @AuraEnabled public String UserId;
        @AuraEnabled public String UserName;
        @AuraEnabled public String ContactId;
        @AuraEnabled public List<Academy_Certification__c> Academy_Certifications;
    }
    
    public class responseResult{
        @AuraEnabled public List<Academy_Certification_Program__c> AcademyCertificationPrograms;
        @AuraEnabled public List<redwing__Prerequisite_Item__c> BadgesList;
        @AuraEnabled public List<responseWrap> response;
    }
    
    public class AchievementAssignmentWrap{
        @AuraEnabled public String UserId;
        @AuraEnabled public String UserName;
        @AuraEnabled public String PrerequisiteId;
        @AuraEnabled public String PrerequisiteName;
        @AuraEnabled public String PrerequisiteItemId;
        @AuraEnabled public String status;
    }
    
    public class PrerequisiteRequestResponse{
        @AuraEnabled public List<redwing__Prerequisite_Item__c> Prerequisite_Items;
        @AuraEnabled public List<AchievementAssignmentWrap> AchievementAssignmentList;
    }
    
}