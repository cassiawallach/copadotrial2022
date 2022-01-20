/**
 * This Apex class has Invocable method which will be fired through Process builder when a Academy_Certification__c is created
 * with status as VALID and will send an email with certification pdf attached to the related contact email.
 * Created by dineshdk on 16/08/2018.
 */

public without sharing class AcademyCertificationPDFMailer {

    @InvocableMethod
    public static void sendEmailMethood(List<Id> certIds) {
        String certificateName ;
        String candidateName ;
        String certificateId ;
        String candEmail;
        String issuedDate;
        String contactID;
        Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{
        };

        Map<Id, Academy_Certification_Student__c> academy_certification_studentMap = new Map<Id, Academy_Certification_Student__c>([SELECT Id, Name, Contact__r.EMAIL FROM Academy_Certification_Student__c WHERE Id IN (SELECT Certification_Student__c FROM Academy_Certification__c WHERE Id IN :certIds)]);
        Map<Id, Academy_Certification__c> academy_certificationMap = new Map<Id, Academy_Certification__c>([SELECT Id,Certification_Program__r.Name,Certification_Student__c, Certification_Examination__r.Date__c, Student_Name__c, Certification_Id__c FROM Academy_Certification__c WHERE Id IN :certIds]);
        OrgWideEmailAddress[] owa = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address = 'academy@copa.do' LIMIT 1];
        EmailTemplate templateId = [SELECT Id, HtmlValue FROM EmailTemplate WHERE Name = :System.Label.ET_Academy_CERT_PDF LIMIT 1];
        system.debug('academy_certification_studentMap...' + academy_certification_studentMap);

        for(ID cId : certIds) {
            if(academy_certificationMap.containsKey(cId)) {
                candidateName = academy_certificationMap.get(cId).Student_Name__c != null ? academy_certificationMap.get(cId).Student_Name__c : '' ;
                certificateName = academy_certificationMap.get(cId).Certification_Program__r.name != null ? academy_certificationMap.get(cId).Certification_Program__r.name : '';
                DateTime dT = academy_certificationMap.get(cId).Certification_Examination__r.Date__c ;
                issuedDate = dT.day() + '-' + dT.month() + '-' + dT.year();
                Id academy_certification_studentId = academy_certificationMap.get(cId).Certification_Student__c != null ? academy_certificationMap.get(cId).Certification_Student__c : '';
                certificateId = academy_certificationMap.get(cId).Certification_Id__c != null ? academy_certificationMap.get(cId).Certification_Id__c : '';
                if(academy_certification_studentMap.containsKey(academy_certification_studentId)) {
                    candEmail = academy_certification_studentMap.get(academy_certification_studentId).Contact__r.email != null ? academy_certification_studentMap.get(academy_certification_studentId).Contact__r.email : '';
                    contactID = academy_certification_studentMap.get(academy_certification_studentId).Contact__r.Id != null ? academy_certification_studentMap.get(academy_certification_studentId).Contact__r.Id : '';
                }
                //Visualforce that will contain the structure of the PDF.
                PageReference pagePdfContent =
                        new PageReference('/apex/CopadoCertificatePDFRenderer?ProgramName=' + certificateName + '&StudentName=' + candidateName + '&CertificateId=' + certificateId + '&CertificateIssueDate=' + issuedDate);
                //Obtain the page content as PDF blob in a variable.
                Blob b;
                if(!Test.isRunningTest()) b = pagePdfContent.getContentAsPDF();
// Create the email attachment
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Copado Certified ' + certificateName + '.pdf');
                efa.setContentType('application/pdf');
                efa.setBody(b);
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateID(templateId.Id);
                mail.setSaveAsActivity(true);
                String[] toAddresses = new String[]{
                        candEmail
                };
                mail.setToAddresses(toAddresses);
                if(owa.size() != 0)mail.setOrgWideEmailAddressId(owa[0].id);
                mail.setTargetObjectId(contactID);
                mail.setWhatId(cId);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{
                        efa
                });
                emails.add(mail);
            }
        }
        Messaging.SendEmailResult[] er = Messaging.sendEmail(emails, false);
        system.debug('result ...' + er);

    }
}