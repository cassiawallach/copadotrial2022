global class CertificationExpirationBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, redwing__Achievement__c,redwing__Achievement__r.Certification_Program__r.Name, redwing__Status__c, redwing__Expiration_Date__c, redwing__Contact__c FROM redwing__Achievement_Assignment__c WHERE redwing__Contact__c!=NULL AND redwing__Training_Plan_Achievement__r.redwing__Training_Plan__r.Is_Certification_Plan__c = TRUE]);
    }
    
    global void execute(Database.BatchableContext bc, List<redwing__Achievement_Assignment__c> scope){
        Set<String> contactIds = new Set<String>();
        for(redwing__Achievement_Assignment__c achievementObj : scope){
            contactIds.add(achievementObj.redwing__Contact__c);
        }
        Map<String,Academy_Certification_Student__c> certificationStudentMap = new Map<String,Academy_Certification_Student__c>([SELECT Id,Contact__c FROM Academy_Certification_Student__c WHERE Contact__c IN:contactIds ]);
        Map<String,Academy_Certification__c> expiredCertificationMap = new Map<String,Academy_Certification__c>([SELECT Id,Certification_Student__r.Contact__c,Certification_Program__c,Expiration_Date__c,Status__c FROM Academy_Certification__c WHERE Certification_Student__c IN:certificationStudentMap.keySet() AND Status__c = 'Expired' ]);
        Set<String> expiredCertificateContactIds = new Set<String>();
        Set<String> expiredCertificateProgramIds = new Set<String>();

        // Map to store the expired certificates, by using key as combination of Contact and Certification Program Id
        // and value as expired certificate record.
        Map<String,Academy_Certification__c> certificationWithContactIdMap = new Map<String,Academy_Certification__c>();
        for(String recordId : expiredCertificationMap.keySet()){
            certificationWithContactIdMap.put(String.valueof(expiredCertificationMap.get(recordId).Certification_Student__r.Contact__c) + String.valueof(expiredCertificationMap.get(recordId).Certification_Program__c),expiredCertificationMap.get(recordId));
            expiredCertificateContactIds.add(expiredCertificationMap.get(recordId).Certification_Student__r.Contact__c);
            expiredCertificateProgramIds.add(expiredCertificationMap.get(recordId).Certification_Program__c);
        }

        // List to store the valid certificates records of same certification program which have expired certificates
        // and same Contacts of expired certificates
        List<Academy_Certification__c> validCertificationList = new List<Academy_Certification__c>([SELECT Id,Certification_Student__r.Contact__c, Certification_Program__c FROM Academy_Certification__c WHERE Certification_Student__c IN :certificationStudentMap.keySet() AND Status__c = 'Valid' AND Certification_Student__r.Contact__c IN :expiredCertificateContactIds AND Certification_Program__c IN :expiredCertificateProgramIds]);

        // Map to store the valid certificates, by using key as combination of Contact and Certification Program Id
        // and value as expired certificate record.
        Map<String,Academy_Certification__c> contactCertificationProgramKeyWithValidCertificateMap = new Map<String,Academy_Certification__c>();
        for(Academy_Certification__c validCertificate : validCertificationList) {
            contactCertificationProgramKeyWithValidCertificateMap.put(String.valueof(validCertificate.Certification_Student__r.Contact__c) + String.valueof(validCertificate.Certification_Program__c), validCertificate);
        }

        map<String,redwing__Achievement_Assignment__c> updateAchievementAssignment = new map<String,redwing__Achievement_Assignment__c>();
        Map<String,redwing__Achievement_Assignment__c> expiredAchievementAssignmentMap= new map<String,redwing__Achievement_Assignment__c>([SELECT Id, redwing__Achievement__c,redwing__Achievement__r.Certification_Program__c, redwing__Status__c, redwing__Expiration_Date__c, redwing__Contact__c FROM redwing__Achievement_Assignment__c WHERE redwing__Contact__c IN: expiredCertificateContactIds AND redwing__Achievement__r.Certification_Program__c IN:expiredCertificateProgramIds  AND redwing__Training_Plan_Achievement__r.redwing__Training_Plan__r.Is_Certification_Plan__c = TRUE]);
        for(String recordId : expiredAchievementAssignmentMap.keySet()){
            String mapKey = String.valueof(expiredAchievementAssignmentMap.get(recordId).redwing__Contact__c) + String.valueof(expiredAchievementAssignmentMap.get(recordId).redwing__Achievement__r.Certification_Program__c);

            // Condition to update the status of Achievement Assignment to expired,
            // if no valid certificate for corresponding certification program is found.
            if(certificationWithContactIdMap.containsKey(mapKey) && !contactCertificationProgramKeyWithValidCertificateMap.containsKey(mapKey) 
               && expiredAchievementAssignmentMap.get(recordId).redwing__Status__c != 'Expired'){
                  redwing__Achievement_Assignment__c achievement = new redwing__Achievement_Assignment__c();
                  achievement.Id = recordId;
                  achievement.redwing__Status__c = 'Expired';
                  updateAchievementAssignment.put(recordId,achievement);
              }
            // Condition to update the status of Achievement Assignment to acquired,
            // if valid certificate for corresponding certification program is found.
            if(certificationWithContactIdMap.containsKey(mapKey) && contactCertificationProgramKeyWithValidCertificateMap.containsKey(mapKey) 
               && expiredAchievementAssignmentMap.get(recordId).redwing__Status__c == 'Expired'){
                  redwing__Achievement_Assignment__c achievement = new redwing__Achievement_Assignment__c();
                  achievement.Id = recordId;
                  achievement.redwing__Status__c = 'Acquired';
                  updateAchievementAssignment.put(recordId,achievement);
              }
        }
        if(updateAchievementAssignment.size()>0){
            UPDATE updateAchievementAssignment.values();
        }
    }
    
    global void finish(Database.BatchableContext bc){
    }
}