trigger SetContractToExpiredReplacement on Contract (after insert) {
    
    Set<Contract> toBeActivated = new Set<Contract>();
    Set<Contract> toBeExpired = new Set<Contract>();
    Set<Id> accId = new Set<Id>();
     
   for(Contract c: trigger.new){
       if(c.AccountId != null){
            accId.add(c.AccountId);
       }
    }
     
    For(Contract contract: [Select id, EndDate from Contract where AccountId=:accId ORDER BY EndDate DESC LIMIT 1]){
        toBeActivated.add(contract);
    }
    
    System.debug('To be activated');
    
     For(Contract contract: [Select id, EndDate from Contract where AccountId=:accId and Status != 'Expired']){
        toBeExpired.add(contract);
    }
    
    if(toBeExpired.size() > 1){
        toBeExpired.removeAll(toBeActivated);
        for(Contract c: toBeExpired){
            c.Status = 'Expired - Replacement';
        }
        
        List<Contract> listToUpdate = new List<Contract>(toBeExpired);
        update (listToUpdate);
        System.debug('Updated');
    }
    
    
}