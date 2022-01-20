/**
 * Created by dineshdk on 19/08/2018.
 */
@isTest
public with sharing class TestAcademyCertificationPDFMailer {
    @isTest
    private static void TestAcademyCertificationPDFMailer() {

        testHttpCalloutMock requestCreateUser = new testHttpCalloutMock(200, 'Complete', '<?xml version="1.0" encoding="ISO-8859-1"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:WSUser.CreateUserResponse xmlns:ns1="urn:WSService"><return xsi:type="xsd:int">115</return></ns1:WSUser.CreateUserResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>');
        testHttpCalloutMock requestIP = new testHttpCalloutMock(200, 'Complete', '192.168.0.0');
        Map<String, HttpCalloutMock> calloutMap = new Map<String, HttpCalloutMock>();
        calloutMap.put('https://academy.copa.do/main/webservices/soap.php', requestCreateUser);
        calloutMap.put('https://academy.copa.do/main/webservices/testip.php', requestIP);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(calloutMap);

        Contact con = new Contact(firstname = 'Dineshkumar', lastname = 'rajamani', email = 'din2262@gmail.com');
        insert con;
        Academy_Certification_Student__c acs = new Academy_Certification_Student__c(Student_Id__c = '2312', Contact__c = con.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        insert acs;
        Test.stopTest();
        Academy_Certification_Program__c acp = new Academy_Certification_Program__c(Name = 'Release Manager', Copado_Version__c = 'v1.1', Status__c = 'Valid');
        insert acp;
        List<Academy_Certification__c> listAcademy_certifications = new List<Academy_Certification__c>();
        Academy_Certification__c ac = new Academy_Certification__c(Certification_Program__c = acp.Id, Certification_Student__c = acs.Id, Status__c = 'Valid');
        listAcademy_certifications.add(ac);
        insert listAcademy_certifications;
        Academy_Certification_Examination__c ace = new Academy_Certification_Examination__c(Date__c = datetime.newInstance(2018, 9, 15, 12, 30, 0), Certification_Student__c = acs.Id, Certification_Program__c = acp.Id, Status__c = 'Approved', Academy_Certification2__c = listAcademy_certifications[0].Id);
        insert ace;

        listAcademy_certifications[0].Certification_Examination__c = ace.Id;
        update listAcademy_certifications;
        User thisUser = [SELECT Id FROM USER WHERE Id = :UserInfo.getUserId()];
        EmailTemplate validEmailTemplate = new EmailTemplate();
        System.runAs(thisUser) {
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'Copado certificate Email Content';
            validEmailTemplate.DeveloperName = 'Copado_certificate_Email_Content';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = UserInfo.getUserId();

            insert validEmailTemplate;
        }

        Academy_Certification_Program__c academy_certification_program = [SELECT Id,Name FROM Academy_Certification_Program__c WHERE Id=:acp.Id ];
        EmailTemplate emailTemplate = [SELECT Id, DeveloperName FROM EmailTemplate WHERE Id = :validEmailTemplate.Id];
        System.assertEquals('Release Manager',academy_certification_program.name);
        System.assertEquals('Copado_certificate_Email_Content',emailTemplate.DeveloperName);
        System.debug('listAcademy_certifications...' + listAcademy_certifications);
        Map<Id, Academy_Certification__c> academy_certificationMap = new Map<Id, Academy_Certification__c>(listAcademy_certifications);
        AcademyCertificationPDFMailer.sendEmailMethood(new List<Id>(academy_certificationMap.keySet()));

    }
}