/**
 * Created by gaviriajesus on 22/05/2018.
 */

public with sharing class AcademyCertificationDeliveryHandler implements ITrigger{

    public AcademyCertificationDeliveryHandler(){
    }

    public void bulkBefore(){

    }

    public void bulkAfter(){
        system.debug('[AcademyCertificationProgramHandler]bulkBefore'+ Trigger.new);
        if(Trigger.new != null){
            AcademyCertificationDeliveryHelper.prepareData((List<Academy_Certification_Delivery__c>)Trigger.new);
        }
    }

    public void beforeInsert(SObject so){

    }

    public void beforeUpdate(SObject oldSo, SObject so){

    }

    public void beforeDelete(SObject so){
    }

    public void afterInsert(SObject so){
        AcademyCertificationDeliveryHelper.SubscribeUserToCourse((Academy_Certification_Delivery__c)so);
    }

    public void afterUpdate(SObject oldSo, SObject so){
    }

    public void afterDelete(SObject so){
    }

    public void andFinally(){
    }
}