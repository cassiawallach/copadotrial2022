@RestResource(urlMapping='/AcademyStudent')
global without sharing class AcademyStudents  {

    public class Error {
        public string errorMessage;
    }
    public static AcademyCertification.Error err = New AcademyCertification.Error();
    @HttpGet
    global static void show() {
        RestResponse res = new RestResponse();
        res = RestContext.response;

        if (([Select ID FROM Academy_API_Settings__c WHERE trusted_IP_Address__c = :RestContext.request.headers.get('Idtoken')].size() > 0 
            && RestContext.request.params.get('student_Name') != null))
        {
            String studentName = RestContext.request.params.get('student_Name');

            List<Academy_Certification_Student__c> students = New  List<Academy_Certification_Student__c>();
            try{
                students = [SELECT Student_Id__c, Contact__r.Name, Contact__r.MailingCity, Contact__r.MailingState, Contact__r.MailingCountry  FROM Academy_Certification_Student__c 
                                    WHERE Academy_Certification_Student__c.Contact__r.Name =: studentName];

                if (students.size()>0)
                {
                    res.responseBody = Blob.valueOf(JSON.serialize(students));
                    res.statusCode = 200;
                }   
                else 
                {
                    res.responseBody = Blob.valueOf('{"errorMessage":"No student registered for '+studentName+'"}');
                    res.statusCode = 200;
                }

            } catch (exception e) {
                System.debug(e.getMessage());
                return;
            }
        } 
        else {
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('{"errorMessage":"Forbidden"}');            
        }        
    }

}