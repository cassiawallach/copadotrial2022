@isTest
public class ContactCertificationListControllerTest {
	@isTest
    public static void UnitTest(){
        //Insert Contact
        Contact conObj = new Contact();
        conObj.FirstName ='test';
        conObj.LastName ='contact';
        INSERT conObj;
        //Insert Academy Certifications Program
        Academy_Certification_Program__c Academy_Certification_Program = new Academy_Certification_Program__c();
        Academy_Certification_Program.Name ='Test Administrator';
        Academy_Certification_Program.Copado_Version__c = '10';
        Academy_Certification_Program.Status__c = 'Valid';
        Insert Academy_Certification_Program;
        
        //Insert Academy Certifications Student
        Academy_Certification_Student__c academyCertificationObj = New Academy_Certification_Student__c();
        academyCertificationObj.Contact__c = conObj.id;
        Insert academyCertificationObj;
        
        //Insert Academy Certifications
        Academy_Certification__c  Academy_Certification = new Academy_Certification__c();
        Academy_Certification.Certification_Program__c = Academy_Certification_Program.Id;
        Academy_Certification.Certification_Student__c = academyCertificationObj.Id;
        //Academy_Certification.Certification_Examination__c = Academy_Certification_Examination.Id;
        Academy_Certification.Status__c = 'Valid';
        
        Insert Academy_Certification;
        List<Academy_Certification__c> academyList = [Select Id,Certification_Program__r.Name,Expiration_Date__c, 
                                                         Status__c From Academy_Certification__c];
        System.assertEquals(1,academyList.Size());
        
        ContactCertificationListController.getContactRelatedCertification(conObj.Id);
        
        System.assertEquals('Valid',academyList[0].Status__c);
    }
}