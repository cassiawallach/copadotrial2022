global with sharing class BatchAcademyEmail implements Database.Batchable<Id>, Database.Stateful {

    public List<Id> targetObjectIds;
    public String templateId;
    public String orgWideEmailId;
    public String emailWhatId;
    public String attachmentResultBody;
    public Integer totalError = 0;
    public Integer totalSuccess = 0;
    public String typeOfEmail;
    global Iterable<Id> start(Database.BatchableContext bc) {
        List<Attachment> resultAttachments = [SELECT Id FROM Attachment WHERE Name = 'Maintenance Open Mail Results' AND ParentId = :emailWhatId];
        if(resultAttachments.size() > 0 && typeOfEmail != 'Reminder'){
            targetObjectIds.clear();
        }
        attachmentResultBody = 'targetObjectIds: ' + targetObjectIds + '\n';
        attachmentResultBody += 'templateId: ' + templateId + '\n';
        attachmentResultBody += 'orgWideEmailId: ' + orgWideEmailId + '\n';
        attachmentResultBody += 'emailWhatId: ' + emailWhatId + '\n';
        return targetObjectIds;
    }

    global void execute(Database.BatchableContext bc, List<Id> targetObjIds) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Id toid : targetObjIds) {
            emails.add(prepareEmailMessage(toid));
        }
        //commented out in the initial deployment to do a test
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails, false);
        for(Messaging.SendEmailResult rslt : results) {
            if(!rslt.isSuccess()) {
                totalError += 1;
                attachmentResultBody += 'Target object id: ' + rslt.errors[0].targetObjectId + ' ' + rslt.errors[0].message + '\n';
            } else {
                totalSuccess += 1;
            }
        }


    }
    global void finish(Database.BatchableContext bc) {
        String attBody = '\nEmail sending for maintenance done: ' + emailWhatId;
        attBody += '\nTotal success: ' + totalSuccess;
        attBody += '\n ' + attachmentResultBody;
        String attName = typeOfEmail == 'Reminder' ? 'Reminder for ' + Date.today() : 'Maintenance Open Mail Results';
        Attachment resultAttachment = new Attachment(Name = attName, Body = Blob.valueOf(attBody), ParentId = emailWhatId);
        insert resultAttachment;
    }

    public Messaging.SingleEmailMessage prepareEmailMessage(String targetObjectId) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTargetObjectId(targetObjectId);
        email.setReplyTo('academy@copado.com');
        if(String.isNotBlank(orgWideEmailId)) {
            email.setOrgWideEmailAddressId(orgWideEmailId);
        }
        if(String.isNotBlank(emailWhatId)) {
            email.setWhatId(emailWhatId);
        }
        email.setSaveAsActivity(true);
        email.setTemplateId(templateId);
        return email;
    }
}