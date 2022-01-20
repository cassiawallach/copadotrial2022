@RestResource(UrlMapping='/AcademyCertifications')
global without sharing class AcademyCertification {

    public class Error {
        public String errorMessage;
    }

    public static AcademyCertification.Error err = new AcademyCertification.Error();

    @HttpGet
    global static void show() {
        RestResponse res = new RestResponse();
        res = RestContext.response;
        Boolean isFromTrustedIPAddress = [SELECT Id FROM Academy_API_Settings__c WHERE trusted_IP_Address__c = :RestContext.request.headers.get('Idtoken')].size() > 0;
        String studentId = RestContext.request.params.get('student_Id');

        System.debug(RestContext.request.headers);
        System.debug(RestContext.request.headers.get('Idtoken'));
        System.debug(RestContext.request.remoteAddress);

        if(!(isFromTrustedIPAddress && String.isNotBlank(studentId))) {
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('{"errorMessage":"Forbidden"}');
            return;
        }

        try {
            List<Academy_Certification__c> student_Certifications = new List<Academy_Certification__c>();
            Student_Certifications = [
                    SELECT Certification_Program__r.Name, Certification_Program__r.Image__c,
                            Expiration_Date__c, Student_Name__c, Status__c
                    FROM Academy_Certification__c
                    WHERE Certification_Student__c = :studentId
            ];

            if(Student_Certifications.isEmpty()) {
                res.responseBody = Blob.valueOf('{"errorMessage":"No certification available for ' + studentId + '"}');
            } else {
                res.responseBody = Blob.valueOf(JSON.serialize(Student_Certifications));
            }

        } catch(Exception excp) {
            System.debug(excp.getMessage());
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('{"errorMessage":"No certification available for ' + studentId + '"}');
            return;
        }
    }
}