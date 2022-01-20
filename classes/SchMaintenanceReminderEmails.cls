public without sharing class SchMaintenanceReminderEmails implements Schedulable {

    public static String academyEmailId;
    public static String templateId;

    public void execute(SchedulableContext sc) {
        List<redwing__Training_Plan__c> plans = [
                SELECT Id, Name, redwing__Start_Date__c, Schedule_Days_for_Reminder__c, Maintenance_Expiration_Date__c, redwing__End_Date__c
                FROM redwing__Training_Plan__c
                WHERE Is_Maintenance_Plan__c = TRUE
                AND redwing__Start_Date__c < :Date.today()
                AND Maintenance_Expiration_Date__c >= :Date.today()
                AND Schedule_Days_for_Reminder__c != NULL
        ];

        if(plans.isEmpty()) {
            return;
        }

        List<redwing__Training_Plan__c> reminderPlansForTomorrow = new List<redwing__Training_Plan__c>();
        List<redwing__Training_Plan__c> reminderPlans = new List<redwing__Training_Plan__c>();
        Set<Id> trainingPlanIds = new Set<Id>();

        for(redwing__Training_Plan__c tp : plans) {
            List<String> scheduleDays = tp.Schedule_Days_for_Reminder__c.split(';');
            for(String day : scheduleDays) {
                Integer untilReminderDay = -1 * Integer.valueOf(day);
                Date reminderDate = tp.Maintenance_Expiration_Date__c.addDays(untilReminderDay);
                if(reminderDate == Date.today()) {
                    System.debug('We will need to send reminder for ' + tp.Name);
                    reminderPlans.add(tp);
                    trainingPlanIds.add(tp.Id);
                } else if(reminderDate == Date.today().addDays(1)) {
                    reminderPlansForTomorrow.add(tp);
                }
            }
        }

        if(reminderPlans.isEmpty() && reminderPlansForTomorrow.isEmpty()) {
            System.debug('We wont send reminders for today');
            return;
        } else if(!reminderPlansForTomorrow.isEmpty()) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{
                    'academy@copado.com'
            });
            email.setSubject('Tomorrow Reminder for Certification Maintenance');
            email.setPlainTextBody('Hello Academy Team, Here is the list of maintenance Ids that will be reminded to students: ' + reminderPlansForTomorrow);
            email.setSaveAsActivity(true);
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>{
                    email
            };
            Messaging.sendEmail(emails, false);
            return;
        } else if(reminderPlans.isEmpty()) {
            return;
        }

        templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Academy_Maintenance_Reminder'].Id;
        academyEmailId = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'academy@copado.com'].Id;

        Map<Id, Set<Id>> mapTrainingWithContactToSend = SchMaintenanceReminderEmails.prepareData(trainingPlanIds);
        Set<Id> contactsWithoutMaintenanceTotal = new Set<Id>();
        for(Integer i = 0; i < reminderPlans.size(); i++) {
            Set<Id> contactsWithoutMaintenance = new Set<Id>();
            if (mapTrainingWithContactToSend.containsKey(reminderPlans[i].Id)) {
                contactsWithoutMaintenance = mapTrainingWithContactToSend.get(reminderPlans[i].Id);
            }
            
            if(contactsWithoutMaintenance.isEmpty()) {
                continue;
            }
            if(!contactsWithoutMaintenanceTotal.isEmpty()){
                for(Id cid : contactsWithoutMaintenance){
                    if(contactsWithoutMaintenanceTotal.contains(cid)) contactsWithoutMaintenance.remove(cid);
                }
            } 
            SchMaintenanceReminderEmails.sendEmailToMaintenanceUsers(reminderPlans[i].Id, contactsWithoutMaintenance);   
            contactsWithoutMaintenanceTotal.addAll(contactsWithoutMaintenance);
        }

    }

    public static Map<Id, Set<Id>> prepareData(Set<Id> trainingPlanIds) {
        Map<Id, Date> certificationWithStartDate = new Map<Id, Date>();
        Map<Id, Set<Id>> mapCompletedAssignmentContactIds = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> mapExpiredCertWithContact = new Map<Id, Set<Id>>();
        Map<Id, Id> mapCertificationWithTrainingPlan = new Map<Id, Id>();
        Map<Id, Set<Id>> mapCertificationWithContact = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> mapTrainingWithContactToSend = new Map<Id, Set<Id>>();
        Map<Id, Id> trainingPlanWithAchivementId = new Map<Id, Id>();

        for (redwing__Training_Plan_Section_Item__c planSec : [SELECT Id, redwing__Learning__r.Academy_Certification_Program__c,
                        redwing__Training_Plan_Section__r.redwing__Training_Plan__c, redwing__Training_Plan_Section__r.redwing__Training_Plan__r.redwing__Start_Date__c
                        FROM redwing__Training_Plan_Section_Item__c
                        WHERE redwing__Training_Plan_Section__r.redwing__Training_Plan__c IN :trainingPlanIds
                        AND redwing__Learning__r.Academy_Certification_Program__c != NULL]) {
            mapCertificationWithTrainingPlan.put(planSec.redwing__Learning__r.Academy_Certification_Program__c, planSec.redwing__Training_Plan_Section__r.redwing__Training_Plan__c);
            certificationWithStartDate.put(planSec.redwing__Learning__r.Academy_Certification_Program__c, planSec.redwing__Training_Plan_Section__r.redwing__Training_Plan__r.redwing__Start_Date__c);
        }

        for (redwing__Training_Plan_Achievement__c tpa : [Select Id, redwing__Achievement__c From redwing__Training_Plan_Achievement__c
                    Where redwing__Achievement__r.Certification_Program__c IN :mapCertificationWithTrainingPlan.keySet() ]) {
            trainingPlanWithAchivementId.put(tpa.Id, tpa.redwing__Achievement__c);
        }

        for (redwing__Training_Plan_Assignment__c planAssignment : [SELECT Id, redwing__Contact__c, redwing__Training_Plan__c
                FROM redwing__Training_Plan_Assignment__c
                WHERE redwing__Training_Plan__c IN :trainingPlanIds
                AND redwing__Status__c = 'Completed']) {
            if (!mapCompletedAssignmentContactIds.containsKey(planAssignment.redwing__Training_Plan__c)) {
                mapCompletedAssignmentContactIds.put(planAssignment.redwing__Training_Plan__c, new Set<Id>());
            }
            mapCompletedAssignmentContactIds.get(planAssignment.redwing__Training_Plan__c).add(planAssignment.redwing__Contact__c);
        }

        for (redwing__Achievement_Assignment__c aas : [SELECT Id, redwing__Achievement__r.Certification_Program__c, redwing__Contact__c, redwing__Training_Plan_Achievement__c
                        FROM redwing__Achievement_Assignment__c
                        WHERE redwing__Achievement__c IN :trainingPlanWithAchivementId.values() 
                        AND redwing__Training_Plan_Achievement__c IN :trainingPlanWithAchivementId.keySet()
                        AND redwing__Contact__c != NULL AND redwing__Status__c = 'Expired']) {
            if (!mapExpiredCertWithContact.containsKey(aas.redwing__Achievement__r.Certification_Program__c)) {
                mapExpiredCertWithContact.put(aas.redwing__Achievement__r.Certification_Program__c, new Set<Id>());
            }
            mapExpiredCertWithContact.get(aas.redwing__Achievement__r.Certification_Program__c).add(aas.redwing__Contact__c);
        }
        for (Academy_Certification__c ac : [SELECT Id, Certification_Student__r.Contact__c, Earned_Date__c, Certification_Student__r.Contact__r.Name, Certification_Student__r.Contact__r.Email, Certification_Program__c
                        FROM Academy_Certification__c
                        WHERE Certification_Program__c IN :certificationWithStartDate.keySet()
                        AND Certification_Student__r.Contact__c != NULL]) {
            if (!mapCertificationWithContact.containsKey(ac.Certification_Program__c)) {
                mapCertificationWithContact.put(ac.Certification_Program__c, new Set<Id>());
            }
            if (ac.Earned_Date__c < certificationWithStartDate.get(ac.Certification_Program__c)) {
                mapCertificationWithContact.get(ac.Certification_Program__c).add(ac.Certification_Student__r.Contact__c);
            }
        }

        for (Id certId : mapCertificationWithContact.keySet()) {
            Set<Id> conIdsToBeUpdate = mapCertificationWithContact.get(certId);
            Id tPlanId = mapCertificationWithTrainingPlan.containsKey(certId) ? mapCertificationWithTrainingPlan.get(certId) : null;

            if (mapExpiredCertWithContact.containsKey(certId)) {
                for (Id conId : mapExpiredCertWithContact.get(certId)) {
                    if (conIdsToBeUpdate.contains(conId)) {
                        conIdsToBeUpdate.remove(conId);
                    }
                }
            }

            if (tPlanId != null && mapCompletedAssignmentContactIds.containsKey(tPlanId)) {
                for (Id conId : mapCompletedAssignmentContactIds.get(tPlanId)) {
                    if (conIdsToBeUpdate.contains(conId)) {
                        conIdsToBeUpdate.remove(conId);
                    }
                }
            }

            mapTrainingWithContactToSend.put(tPlanId, conIdsToBeUpdate);
        }

        return mapTrainingWithContactToSend;
    }

    public static void sendEmailToMaintenanceUsers(String planId, Set<Id> contactIds) {
        List<Id> contactIdList = new List<Id>();
        contactIdList.addAll(contactIds);
        BatchAcademyEmail bae = new BatchAcademyEmail();
        bae.emailWhatId = planId;
        bae.targetObjectIds = contactIdList;
        bae.orgWideEmailId = academyEmailId;
        bae.templateId = templateId;
        bae.typeOfEmail = 'Reminder';
        Database.executeBatch(bae, 20);
    }
}