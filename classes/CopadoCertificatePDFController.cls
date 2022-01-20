/**
* This Apex class is responsible for rendering Pdf called from Invocable controller method from Process builder
* which will be fired when a Academy_Certification__c is created with status as VALID
* Created by dineshdk on 16/08/2018.
* Modified by David Pinett on 08/05/2019. To Hotfix Null Object DeReference 
*/
public without sharing class CopadoCertificatePDFController {
    public String htmlDisplay { get; set; }
    
    public CopadoCertificatePDFController() {
        String AcademyCertificateProgramId ='',certName= '',candName='',issuedDate='',certId='';
        if(APEXPages.currentPage().getParameters().get('download')!=null){
            if(APEXPages.currentPage().getParameters().get('CertificateId')!=null){
                AcademyCertificateProgramId = APEXPages.currentPage().getParameters().get('CertificateId');
                AcademyCertificateProgramId = AcademyCertificateProgramId.substring(9,AcademyCertificateProgramId.length()-9);
                User LoggedInUser = [SELECT Id, ContactId FROM User WHERE ID=: UserInfo.getUserId()];   
                List<Academy_Certification__c> Academy_Certification = new List<Academy_Certification__c >([SELECT Id,Earned_Date__c, Certification_Student__c,Certification_Student__r.contact__c, Student_Name__c, Status__c, Certification_Program__c,Certification_Program__r.Name,Certification_Id__c FROM Academy_Certification__c WHERE Certification_Student__r.Contact__c =: LoggedInUser.contactId  AND Certification_Program__c=:AcademyCertificateProgramId AND Status__c = 'Valid']);
                if(Academy_Certification.size()>0){
                    certName = Academy_Certification.get(0).Certification_Program__r.Name!=null?Academy_Certification.get(0).Certification_Program__r.Name:'';
                    candName = Academy_Certification.get(0).Student_Name__c!=null?Academy_Certification.get(0).Student_Name__c:'';
                    datetime tempDateTime = Academy_Certification.get(0).Earned_Date__c;
                    issuedDate = tempDateTime.day() + '-' + tempDateTime.month() + '-' + tempDateTime.year();
                    certId = Academy_Certification.get(0).Certification_Id__c!=null?Academy_Certification.get(0).Certification_Id__c:'';
                }
            }
        }
        else{
            certName = Apexpages.currentPage().getParameters().get('ProgramName');
            candName = Apexpages.currentPage().getParameters().get('StudentName');
            issuedDate = Apexpages.currentPage().getParameters().get('CertificateIssueDate');
            certId = Apexpages.currentPage().getParameters().get('CertificateId');
        }
        if(certName!='' || candName!='' || issuedDate!='' || certId!=''){
            EmailTemplate emailTemplate = [SELECT Id, HtmlValue FROM EmailTemplate WHERE Name = : System.Label.ET_Academy_CERT_PDF_BLOB LIMIT 1];
            String strHTML = emailTemplate.HtmlValue.replaceAll('(\\r|\\n)+', '');
            htmlDisplay = strHTML.replace('certName', certName).replace('candName', candName).replace('issuedDate', issuedDate).replace('certId', certId);
        }
    }
}