public with sharing class OpportunityTriggerHandler implements ITrigger {
    
    public OpportunityTriggerHandler(){ 
    }
    
    public void bulkBefore(){
        //if(checkRecursive.runOnce()) {
            if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
                OpportunityTriggerHelper.prepareData(Trigger.New);
            }
        //}
    }
    
    public void bulkAfter(){ 
       
    }
    
    public void beforeInsert(SObject so){
        Opportunity newOpp = (Opportunity)so;
        if(Trigger.new != null){
            OpportunityTriggerHelper.setOpportunityRegion(newOpp); 
            OpportunityTriggerHelper.setOpportunityCreationRole(newOpp);
            OpportunityTriggerHelper.updateRenewalOpportunityDueDate(newOpp);
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Opportunity newOpp = (Opportunity)so;
        Opportunity oldOpp = (Opportunity)oldSo;
        OpportunityTriggerHelper.setOpportunityRegion(newOpp);
        OpportunityTriggerHelper.updateNextStepDate(oldOpp,newOpp);
        OpportunityTriggerHelper.updateMRR(oldOpp,newOpp);
       
    }
    
    public void beforeDelete(SObject so){
    }
    
    public void afterInsert(SObject so){ 
        Opportunity newOpp = (Opportunity)so;
        OpportunityTriggerHelper.createRoiCalculation(newOpp);
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        Opportunity newOpp = (Opportunity)so;
        Opportunity oldOpp = (Opportunity)oldSo;
       
    }
    
    public void afterDelete(SObject so){
    }
    
    public void andFinally(){
        OpportunityTriggerHelper.finish();
    }
}