public class KugamonOrderTriggerHandler implements ITrigger {
    public KugamonOrderTriggerHandler(){ 
    }
    
    public void bulkBefore(){     
    }
    
    public void bulkAfter(){ 
         if(Trigger.isAfter && Trigger.isUpdate){
            KugamonOrderTriggerHelper.createQuoteLineOnRenewalOpportuntiy(Trigger.New);
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
        KugamonOrderTriggerHelper.createQuoteLineOnRenewal();
    }
}