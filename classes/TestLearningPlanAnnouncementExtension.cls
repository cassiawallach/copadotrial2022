@IsTest
private with sharing class TestLearningPlanAnnouncementExtension {

    @TestSetup static void setupData() {

        Academy_Certification_Program__c acp = new Academy_Certification_Program__c();
        acp.Name = 'ADMINISTRATOR';
        acp.Status__c = 'Valid';
        acp.Copado_Version__c = 'v15';
        insert acp;

        redwing__Training_Plan__c maintenance = new redwing__Training_Plan__c();
        maintenance.Name = 'Admin Maintenance';
        maintenance.Is_Maintenance_Plan__c = true;
        maintenance.redwing__Start_Date__c = Date.today();
        maintenance.redwing__End_Date__c = Date.today().addMonths(6);
        maintenance.Maintenance_Expiration_Date__c = Date.today().addMonths(6);
        insert maintenance;

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

    }

    @IsTest static void testWithResultAttachment(){
        //added for coverage for now
        AcademyCertificationStudentHandler acsh = new AcademyCertificationStudentHandler();
        AcademyCertificationStudentHelper.tester();
        redwing__Training_Plan__c currentPlan = [SELECT Id FROM redwing__Training_Plan__c WHERE Name = 'Admin Maintenance'];

        //test with result attachment
        Attachment resultAttachment = new Attachment(Name = 'Maintenance Open Mail Results', Body = Blob.valueOf('test'), ParentId = currentPlan.Id);
        insert resultAttachment;
        //added to get coverage on empty methods
        acsh.beforeDelete((SObject) resultAttachment);
        acsh.afterDelete((SObject) resultAttachment);
        Test.setCurrentPage(Page.LearningPlanAnnouncement);
        LearningPlanAnnouncementExtension lpae = new LearningPlanAnnouncementExtension(new ApexPages.StandardController(currentPlan));

        System.assertEquals(true, ApexPages.hasMessages(), 'When there is attachment for result page has messages');
        System.assertEquals('Email already sent!', ApexPages.getMessages()[0].getDetail(), ' When there is result attachment email sent message is shown');
        System.assertEquals(true, lpae.emailSent, 'emailSent field is true');

    }

    @IsTest static void testWithStartDateNull(){
        redwing__Training_Plan__c currentPlan = [SELECT Id, redwing__Start_Date__c, redwing__End_Date__c FROM redwing__Training_Plan__c WHERE Name = 'Admin Maintenance'];
        currentPlan.redwing__Start_Date__c = null;
        currentPlan.redwing__End_Date__c = null;
        update currentPlan;

        Test.setCurrentPage(Page.LearningPlanAnnouncement);
        LearningPlanAnnouncementExtension lpae = new LearningPlanAnnouncementExtension(new ApexPages.StandardController(currentPlan));

        System.assertEquals(true, ApexPages.hasMessages(), 'When start date of learning plan is null, page has messages');
        System.assertEquals('Maintenance in the future or does not has a Start Date.', ApexPages.getMessages()[0].getDetail(), ' When  start date of learning plan is null message is shown');

    }

    @IsTest static void testWithNotMaintenancePlan(){
        redwing__Training_Plan__c currentPlan = [SELECT Id, redwing__Start_Date__c FROM redwing__Training_Plan__c WHERE Name = 'Admin Maintenance'];
        currentPlan.Is_Maintenance_Plan__c = false;
        update currentPlan;

        Test.setCurrentPage(Page.LearningPlanAnnouncement);
        LearningPlanAnnouncementExtension lpae = new LearningPlanAnnouncementExtension(new ApexPages.StandardController(currentPlan));

        System.assertEquals(true, ApexPages.hasMessages(), 'When learning plan is not maintenance, page has messages');
        System.assertEquals('This learning plan is not a maintenance plan.', ApexPages.getMessages()[0].getDetail(), ' When learning plan is not maintenance message is shown');

    }

    @IsTest static void testWithNoCertifiedPerson(){
        redwing__Training_Plan__c currentPlan = [SELECT Id, redwing__Start_Date__c FROM redwing__Training_Plan__c WHERE Name = 'Admin Maintenance'];

        Test.setCurrentPage(Page.LearningPlanAnnouncement);
        LearningPlanAnnouncementExtension lpae = new LearningPlanAnnouncementExtension(new ApexPages.StandardController(currentPlan));

        System.assertEquals(true, ApexPages.hasMessages(), 'When there is no one with that certification, page has messages');
        System.assertEquals('No one found for this maintenance program.', ApexPages.getMessages()[0].getDetail(), ' When there are no one with th related certification message is shown');

    }

    @IsTest static void testWithCertifiedPerson(){
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

        Test.setCurrentPage(Page.LearningPlanAnnouncement);
        LearningPlanAnnouncementExtension lpae = new LearningPlanAnnouncementExtension(new ApexPages.StandardController(currentPlan));

        Test.startTest();
        lpae.sendEmailToCertifiedUsers();
        Test.stopTest();
        System.assertEquals(true, lpae.emailSent, 'Email sent is true');

        Attachment resultAttachment = [SELECT Id, Body FROM Attachment WHERE Name = 'Maintenance Open Mail Results' AND ParentId = :currentPlan.Id];
        System.assertNotEquals(null, resultAttachment);
        System.assert(resultAttachment.Body.toString().contains('Total success: 20'));

    }

}