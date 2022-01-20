public class CPQQuoteTriggerHandler implements ITrigger {

    public CPQQuoteTriggerHandler(){}
    
    public void bulkBefore(){
        if(!Trigger.isDelete && !Trigger.isUndelete)CPQQuoteTriggerHelper.prepareDataBefore(Trigger.new);
    }
    
    public void bulkAfter(){
        if(!Trigger.isDelete && !Trigger.isUndelete)CPQQuoteTriggerHelper.prepareDataAfter(Trigger.new);
    }
        
    public void beforeInsert(SObject so){
        SBQQ__Quote__c quote = (SBQQ__Quote__c) so;
        CPQQuoteTriggerHelper.setNumberOfMonths(quote);
        CPQQuoteTriggerHelper.setRemainingLicenseTCV(null, quote);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        SBQQ__Quote__c oldQuote = (SBQQ__Quote__c) oldSo;
        SBQQ__Quote__c newQuote = (SBQQ__Quote__c) so;
        CPQQuoteTriggerHelper.setNumberOfMonths(newQuote);
        CPQQuoteTriggerHelper.setRemainingLicenseTCV(oldQuote, newQuote);
    }
    
    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){}
    
    public void afterDelete(SObject so){}
    
    public void andFinally(){
        if(!Trigger.isDelete && !Trigger.isUndelete)CPQQuoteTriggerHelper.setAcvTcvOnOpportunities();
    }
}