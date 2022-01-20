trigger AcademyCertificationDelivery on Academy_Certification_Delivery__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
        TriggerFactory.createHandler(Academy_Certification_Delivery__c.sObjectType);
}