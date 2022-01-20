public with sharing class AccountHandler implements ITrigger {
    
    public AccountHandler(){
    }
    public void bulkBefore(){
        if(Trigger.isUpdate)AccountService.prepareAccountContractData(Trigger.new);
        
    }
    
    public void bulkAfter(){
        if(Trigger.IsUpdate && Trigger.IsAfter){
            AccountService.prepareData(Trigger.OldMap,Trigger.newMap);
        }
    }
    
    public void beforeInsert(SObject so){
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Account newa = (Account)so;
        AccountService.setContractExpirationDate(newa);
        AccountService.setAccountType(newa);
    }
    public void beforeDelete(SObject so){
    }
    
    public void afterInsert(SObject so){
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        Account NewAccountValue = (Account) so;
        Account OldAccountValue =  (Account) oldSo;
       
    }
    
    public void afterDelete(SObject so){
    }
    public void andFinally(){
    }
}