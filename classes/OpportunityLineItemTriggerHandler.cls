public  with sharing  class OpportunityLineItemTriggerHandler implements ITrigger {
    
    public OpportunityLineItemTriggerHandler(){
    }
    public void bulkBefore(){
    }
    public void bulkAfter(){
        Set<string> setOfIds = New Set<String>();
        if(Trigger.isInsert && Trigger.isAfter){
            for(sObject sc : Trigger.New){
               OpportunityLineItem oppLine = (OpportunityLineItem)sc;
                setOfIds.add(oppLine.Id);
              
            }
            if(setOfIds.Size() > 0 ){
                OppLineItemService.deleteRecord(setOfIds);
            }
        }
        
    }
    
    public void beforeInsert(SObject so){
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
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
        
    }
    
}