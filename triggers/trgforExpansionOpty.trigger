trigger trgforExpansionOpty on Opportunity (before insert,after insert) {

    
    if(trigger.isBefore) {
        ExpansionOpportunityHelper.beforeInsert(trigger.New);
    }
    
    if(trigger.isAfter) {       
        ExpansionOpportunityHelper.afterInsert(trigger.New);       
    }    
}