/*
 * Craeted By : Rahul Ranjan
 * Created date: 3rd August 2020
   Description:- This controller used in ContactCertificationRelatedList component to show certification 
			     details on contact Detail Page. 
*/
public class ContactCertificationListController {
    //Get Academy Certication List
    @AuraEnabled
    public static List<Academy_Certification__c> getContactRelatedCertification(String contactId){
        List<Academy_Certification__c> certificateObj = [SELECT Id, Name, Earned_Date__c, 
                                                         Certification_Program__r.Name,Expiration_Date__c, 
                                                         Status__c, Student_Name__c FROM Academy_Certification__c 
                                                         where Certification_Student__c!= Null AND
                                                         Certification_Student__r.Contact__c =:contactId];
        
        return certificateObj;
    }
    
}