/**
 * Created by gaviriajesus on 22/05/2018.
 */

public with sharing class AcademyCertificationDeliveryHelper {


    public static Map<Id, Academy_Certification_Delivery__c> deliverMap = new Map<Id, Academy_Certification_Delivery__c>();

    public static void prepareData(List<Academy_Certification_Delivery__c> deliveries){
        Set<Id> ids = new Set<Id>();
        for(Academy_Certification_Delivery__c s : deliveries){
            if(s.Academy_Certification_Student__c != null && s.Certification_Program__c != null){
                ids.add(s.Id);
            }
        }
        if(ids.size()>0){
            deliverMap = new Map<Id, Academy_Certification_Delivery__c>([select Id, Academy_Certification_Student__r.Chamilo_Id__c, Certification_Program__r.Chamilo_Id__c from Academy_Certification_Delivery__c where Id IN:ids]);
        }
        system.debug(deliverMap);
    }

    public static void SubscribeUserToCourse(Academy_Certification_Delivery__c delivery){
        system.debug(delivery);
        if(deliverMap.containsKey(delivery.Id) &&  delivery.Type__c == 'Online'){
            List<AcademyAPI.Part> parts = AcademyAPI.getPartsForSubscribeUserToCourse(deliverMap.get(delivery.Id).Academy_Certification_Student__r.Chamilo_Id__c, deliverMap.get(delivery.Id).Certification_Program__r.Chamilo_Id__c);
            AcademyAPI.sendSOAPrequest(JSON.serialize(parts), 'SubscribeUserToCourse','urn:WSService', 'WSCourse', null);
        }

    }
}