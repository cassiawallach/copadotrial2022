public with sharing class LearningPlanAnnouncementExtension {

    public redwing__Training_Plan__c currentPlan { get; set; }
    private Id certificationProgramId;
    private Set<Id> contactIds;
    public transient List<Academy_Certification__c> certifications { get; set; }
    public transient List<Academy_Certification__c> certificationsToShow { get; set; }
    public Boolean emailSent { get; set; }
    public Integer totalSuccess { get; set; }
    public Integer totalError { get; set; }
    public String errorMessages { get; set; }
    public String academyEmailId;
    public String templateId;

    public LearningPlanAnnouncementExtension(ApexPages.StandardController stdController) {
        List<Attachment> attachments = [SELECT Id FROM Attachment WHERE Name = 'Maintenance Open Mail Results' AND ParentId = :stdController.getId()];
        currentPlan = new redwing__Training_Plan__c();
        if(attachments.size() > 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email already sent!'));
            emailSent = true;
            return;
        }
        emailSent = false;
        currentPlan = [
                SELECT Id, Is_Maintenance_Plan__c, Is_Certification_Plan__c, Name, redwing__Start_Date__c
                FROM redwing__Training_Plan__c
                WHERE Id = :stdController.getId()
        ];

        if(currentPlan.redwing__Start_Date__c == NULL || currentPlan.redwing__Start_Date__c > Date.today()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Maintenance in the future or does not has a Start Date.'));
            emailSent = true;

            return;
        }

        if(!currentPlan.Is_Maintenance_Plan__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This learning plan is not a maintenance plan.'));
            emailSent = true;
            return;
        }


        List<redwing__Training_Plan_Section_Item__c> sectionItems = [SELECT Id, redwing__Learning__r.Academy_Certification_Program__c FROM redwing__Training_Plan_Section_Item__c WHERE redwing__Training_Plan_Section__r.redwing__Training_Plan__c = :currentPlan.Id AND redwing__Learning__r.Academy_Certification_Program__c != NULL LIMIT 1];

        if(sectionItems.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not find responding Certification Program. Please check the data.'));
            emailSent = true;
            return;
        }

        templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Maintenance_Exam_Window_Open2'].Id;
        academyEmailId = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'academy@copa.do'].Id;

        certificationProgramId = sectionItems[0].redwing__Learning__r.Academy_Certification_Program__c;
        certifications = new List<Academy_Certification__c>();
        totalSuccess = 0;
        totalError = 0;
        errorMessages = '';
        findUsersToNotify();
    }

    public void findUsersToNotify() {
        certifications = [
                SELECT Id, Certification_Student__r.Contact__c, Certification_Student__r.Contact__r.Name, Certification_Student__r.Contact__r.Email, Certification_Program__c
                FROM Academy_Certification__c
                WHERE Earned_Date__c < :currentPlan.redwing__Start_Date__c
                AND Expiration_Date__c >= :Date.today()
                AND Certification_Program__c = :certificationProgramId
                AND Certification_Student__r.Contact__c != NULL
        ];

        if(certifications.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No one found for this maintenance program.'));
            return;
        }

        contactIds = new Set<Id>();
        Integer counter = 0;
        certificationsToShow = new List<Academy_Certification__c>();
        for(Academy_Certification__c ac : certifications) {
            contactIds.add(ac.Certification_Student__r.Contact__c);
            if(counter > 999) {
                continue;
            }
            counter++;
            certificationsToShow.add(ac);
        }


    }

    public PageReference sendEmailToCertifiedUsers() {

        if(emailSent) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Email already sent!'));
            return null;
        }

        List<Id> contactIdList = new List<Id>();
        contactIdList.addAll(contactIds);
        BatchAcademyEmail bae = new BatchAcademyEmail();
        bae.emailWhatId = currentPlan.Id;
        bae.targetObjectIds = contactIdList;
        bae.orgWideEmailId = academyEmailId;
        bae.templateId = templateId;
        Database.executeBatch(bae, 20);
        emailSent = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Email sending operation started!'));

        return null;
    }

}