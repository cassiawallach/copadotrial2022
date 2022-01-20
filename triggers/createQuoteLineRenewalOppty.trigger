trigger createQuoteLineRenewalOppty on SBQQ__Quote__c (after insert) {

    set<Id> opptyId = new set<Id>();
    
    for(SBQQ__Quote__c quote : trigger.new) {
        if(quote.SBQQ__Opportunity2__c != null ) {            
            opptyId.add(quote.SBQQ__Opportunity2__c);
        }
    }  
    RenewalOpportunityHelper.RenewalOpportunityDetails(opptyId,trigger.newMap.keyset());       
}