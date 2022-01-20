@IsTest
private with sharing class TestAcademyMaintenanceReminder {

    @TestSetup static void setupData() {

        Academy_Certification_Program__c acp = new Academy_Certification_Program__c();
        acp.Name = 'ADMINISTRATOR';
        acp.Status__c = 'Valid';
        acp.Copado_Version__c = 'v15';
        insert acp;
        
        redwing__Achievement__c achievement = TestDataFactory.createAchievement('Certifications',acp.Id);
        insert achievement;

        List<redwing__Training_Plan__c> trainingPlan = new List<redwing__Training_Plan__c>();
        redwing__Training_Plan__c maintenance = new redwing__Training_Plan__c();
        maintenance.Name = 'Admin Maintenance';
        maintenance.Is_Maintenance_Plan__c = true;
        maintenance.redwing__Start_Date__c = Date.today().addDays(-10);
        maintenance.redwing__End_Date__c = Date.today().addDays(1);
        maintenance.Maintenance_Expiration_Date__c = Date.today().addDays(1);
        maintenance.Schedule_Days_for_Reminder__c = '1';
        trainingPlan.add(maintenance);
        
        redwing__Training_Plan__c certTPlan = TestDataFactory.createTrainingPlan('ADMINISTRATOR T Plan');
        trainingPlan.add(certTPlan);
        insert trainingPlan;
        
        redwing__Training_Plan_Achievement__c trainingPlanAchievement = TestDataFactory.createTriningPlanAchievement(achievement.Id,trainingPlan[1].Id);
        INSERT trainingPlanAchievement;

        redwing__Learning__c learning = new redwing__Learning__c();
        learning.Name = 'Admin Maintenance';
        learning.Academy_Certification_Program__c = acp.Id;
        learning.redwing__Published__c = true;
        insert learning;

        redwing__Training_Plan_Section__c tps = new redwing__Training_Plan_Section__c();
        tps.Name = 'Admin Certification Maintenance';
        tps.redwing__Training_Plan__c = maintenance.Id;
        insert tps;

        redwing__Training_Plan_Section_Item__c tpsc = new redwing__Training_Plan_Section_Item__c();
        tpsc.redwing__Training_Plan_Section__c = tps.Id;
        tpsc.redwing__Learning__c = learning.Id;
        insert tpsc;

        List<Contact> academyContacts = new List<Contact>();

        for(Integer i = 1; i <= 20; i++){
            Contact academyContact = new Contact();
            academyContact.FirstName = 'Academy ' + i;
            academyContact.LastName = 'Test';
            academyContact.Email = 'academy' + i + '@copado.com';
            academyContacts.add(academyContact);
        }
        insert academyContacts;
        
        List<redwing__Achievement_Assignment__c> achivementAssignmentAssignments = new List<redwing__Achievement_Assignment__c>();
        List<redwing__Training_Plan_Assignment__c> trainingPlanAssignments = new List<redwing__Training_Plan_Assignment__c>();
        for(Integer i = 0; i < 20; i++){
            redwing__Achievement_Assignment__c achievementAssignment = new redwing__Achievement_Assignment__c();
            achievementAssignment.redwing__Contact__c = academyContacts[i].Id;
            achievementAssignment.redwing__Training_Plan_Achievement__c =trainingPlanAchievement.Id;
            achievementAssignment.redwing__Achievement__c =achievement.Id;
            achievementAssignment.redwing__Acquisition_Date__c =System.today();
            achievementAssignment.redwing__Status__c = (i > 2) ? 'Acquired' : 'Expired';
            achivementAssignmentAssignments.add(achievementAssignment);

            redwing__Training_Plan_Assignment__c trainingPlanAssignment = TestDataFactory.createTrainingPlanAssignment(userinfo.getUserId(),academyContacts[i].Id, trainingPlan[0].Id);
            trainingPlanAssignment.redwing__Status__c = (i >= 2 && i < 4) ? 'Completed' : achievementAssignment.redwing__Status__c;
            trainingPlanAssignments.add(trainingPlanAssignment);
        }

        insert achivementAssignmentAssignments;
        insert trainingPlanAssignments;

    }

    @IsTest static void testReminderPositive(){
        redwing__Training_Plan__c currentPlan = [SELECT Id, redwing__Start_Date__c FROM redwing__Training_Plan__c WHERE Name = 'Admin Maintenance'];
        Academy_Certification_Program__c acp = [SELECT Id FROM Academy_Certification_Program__c WHERE Name = 'ADMINISTRATOR'];
        List<Contact> academyContacts = [SELECT Id FROM Contact WHERE LastName = 'Test'];

        List<Academy_Certification_Student__c> academyStudents = new List<Academy_Certification_Student__c>();
        for(Integer i = 0; i < 20; i++){
            Academy_Certification_Student__c academyStudent = new Academy_Certification_Student__c();
            academyStudent.Contact__c = academyContacts[i].Id;
            academyStudent.Student_Email__c = 'academy' + (i + 1) + '@copado.com';
            academyStudents.add(academyStudent);
        }

        insert academyStudents;

        List<Academy_Certification__c> academyCertifications = new List<Academy_Certification__c>();
        for(Academy_Certification_Student__c acs : academyStudents){
            Academy_Certification__c ac = new Academy_Certification__c();
            ac.Certification_Program__c = acp.Id;
            ac.Certification_Student__c = acs.Id;
            ac.Status__c = 'Valid';
            academyCertifications.add(ac);
        }

        insert academyCertifications;

        List<Academy_Certification_Examination__c> academyExaminations = new List<Academy_Certification_Examination__c>();
        Map<Id, Academy_Certification__c> academyCertificationMap = new Map<Id, Academy_Certification__c>();
        for(Academy_Certification__c ac :  academyCertifications){
            Academy_Certification_Examination__c ace = new Academy_Certification_Examination__c();
            ace.Academy_Certification2__c = ac.Id;
            ace.Certification_Student__c = ac.Certification_Student__c;
            ace.Certification_Program__c = acp.Id;
            ace.Status__c = 'Approved';
            ace.Date__c = Date.today().addMonths(-1);
            academyExaminations.add(ace);
            academyCertificationMap.put(ac.Id, ac);
        }

        insert academyExaminations;

        for(Academy_Certification_Examination__c ace : academyExaminations){
            academyCertificationMap.get(ace.Academy_Certification2__c).Certification_Examination__c = ace.Id;
        }

        update academyCertificationMap.values();

        Test.startTest();
        SchMaintenanceReminderEmails mre = new SchMaintenanceReminderEmails();
        String cronExpr = '0 0 20 * * ?';
        System.schedule('Test Academy Maintenance Reminder', cronExpr, mre);
        Test.stopTest();

        AcademyMaintenanceReminderTableCtr amrt = new AcademyMaintenanceReminderTableCtr();
        amrt.contactIdApex = academyStudents[0].Contact__c;
        List<AcademyMaintenanceReminderTableCtr.AcademyCertificationMaintenanceStatus> statusList = amrt.getContactCertifications();
        System.assertEquals(1, statusList.size(), 'We have 1 maintenance status');

    }

    @IsTest static void testReminderPositiveTomorrow(){
        redwing__Training_Plan__c currentPlan = [SELECT Id, redwing__Start_Date__c, Maintenance_Expiration_Date__c FROM redwing__Training_Plan__c WHERE Name = 'Admin Maintenance'];
        currentPlan.Maintenance_Expiration_Date__c = Date.today().addDays(2);
        update currentPlan;
        Academy_Certification_Program__c acp = [SELECT Id FROM Academy_Certification_Program__c WHERE Name = 'ADMINISTRATOR'];
        List<Contact> academyContacts = [SELECT Id FROM Contact WHERE LastName = 'Test'];

        List<Academy_Certification_Student__c> academyStudents = new List<Academy_Certification_Student__c>();
        for(Integer i = 0; i < 5; i++){
            Academy_Certification_Student__c academyStudent = new Academy_Certification_Student__c();
            academyStudent.Contact__c = academyContacts[i].Id;
            academyStudent.Student_Email__c = 'academy' + (i + 1) + '@copado.com';
            academyStudents.add(academyStudent);
        }

        insert academyStudents;

        List<Academy_Certification__c> academyCertifications = new List<Academy_Certification__c>();
        for(Academy_Certification_Student__c acs : academyStudents){
            Academy_Certification__c ac = new Academy_Certification__c();
            ac.Certification_Program__c = acp.Id;
            ac.Certification_Student__c = acs.Id;
            ac.Status__c = 'Valid';
            academyCertifications.add(ac);
        }

        insert academyCertifications;

        List<Academy_Certification_Examination__c> academyExaminations = new List<Academy_Certification_Examination__c>();
        Map<Id, Academy_Certification__c> academyCertificationMap = new Map<Id, Academy_Certification__c>();
        for(Academy_Certification__c ac :  academyCertifications){
            Academy_Certification_Examination__c ace = new Academy_Certification_Examination__c();
            ace.Academy_Certification2__c = ac.Id;
            ace.Certification_Student__c = ac.Certification_Student__c;
            ace.Certification_Program__c = acp.Id;
            ace.Status__c = 'Approved';
            ace.Date__c = Date.today().addMonths(-1);
            academyExaminations.add(ace);
            academyCertificationMap.put(ac.Id, ac);
        }

        insert academyExaminations;

        for(Academy_Certification_Examination__c ace : academyExaminations){
            academyCertificationMap.get(ace.Academy_Certification2__c).Certification_Examination__c = ace.Id;
        }

        update academyCertificationMap.values();

        Test.startTest();
        SchMaintenanceReminderEmails mre = new SchMaintenanceReminderEmails();
        String cronExpr = '0 0 20 * * ?';
        System.schedule('Test Academy Maintenance Reminder', cronExpr, mre);
        Test.stopTest();


    }

}