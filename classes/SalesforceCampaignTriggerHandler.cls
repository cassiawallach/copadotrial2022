public with sharing class SalesforceCampaignTriggerHandler implements ITrigger {
   
    public SalesforceCampaignTriggerHandler(){ 
    }
    
    public void bulkBefore(){
     
    }
    
    public void bulkAfter(){ 
       
    }
    
    public void beforeInsert(SObject so){
         Campaign newCamp = (Campaign)so;
         if(Trigger.new != null){
            SalesforceCampaignTriggerHelper.updateCampaignName(newCamp);     
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Campaign newCamp = (Campaign)so;
        Campaign oldCamp = (Campaign)oldSo;
		SalesforceCampaignTriggerHelper.setCampaignName(oldCamp,newCamp);           
    }
    
    public void beforeDelete(SObject so){
    }
    
    public void afterInsert(SObject so){ 
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        
    }
    
    public void afterDelete(SObject so){
    }
    
    public void andFinally(){
        OpportunityTriggerHelper.finish();
    }
}