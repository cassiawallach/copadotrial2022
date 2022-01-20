trigger AcademyCertificationStudent on Academy_Certification_Student__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
   TriggerFactory.createHandler(Academy_Certification_Student__c.sObjectType);
}