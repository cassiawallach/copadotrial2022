public class MeetingTriggerHandler implements ITrigger {

    public MeetingTriggerHandler(){
        //if(Trigger.new!=null)MeetingTriggerHelper.prepareData(Trigger.new, Trigger.isBefore && Trigger.isInsert);
    }
    
    public void bulkBefore(){}
    
    public void bulkAfter(){
        MeetingTriggerHelper.prepareMeetingToMap();
    }
        
    public void beforeInsert(SObject so){}
    
    public void beforeUpdate(SObject oldSo, SObject so){}
    
    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){
       // MeetingTriggerHelper.createProfessionalServiceConsumption((Demo__c)oldSo,(Demo__c)so);
        
    }
    
    public void afterDelete(SObject so){}
    
    public void andFinally(){
       MeetingTriggerHelper.insertProfessionalServicesConsumptions();
    }
}