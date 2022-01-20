/**
 * Created by kheidt on 24/01/2018.
 */

public with sharing class CPQ_QuoteTriggerHandler implements ITrigger{
    public CPQ_QuoteTriggerHandler() {
    }
    public void bulkBefore() {
    }

    public void bulkAfter() {
    }

    public void beforeInsert(SObject so){
        System.debug('a cpq quote will be created');
        SBQQ__Quote__c quote = (SBQQ__Quote__c) so;

        System.debug('current Quote: ' + quote);

        //initialize service
        CPQ_QuoteService cqs = new CPQ_QuoteService(quote);

        //set number of months
        quote = cqs.setNumberOfMonths(quote);

        //set remaining license TCV if required
        if(cqs.isAmendmentQuote(quote)){
            quote = cqs.setRemainingLicenseTCV(quote);
        }
    }

    public void beforeUpdate(SObject oldSo, SObject so){
        System.debug('a cpq quote will be updated');

        SBQQ__Quote__c oldQuote = (SBQQ__Quote__c) oldSo;
        SBQQ__Quote__c newQuote = (SBQQ__Quote__c) so;

        //initialize service
        CPQ_QuoteService cqs = new CPQ_QuoteService(newQuote);

        Boolean datesHaveChanged = cqs.datesHaveChanged(newQuote, oldQuote);

        if(datesHaveChanged){
            newQuote = cqs.setNumberOfMonths(newQuote);
        }

        if(cqs.isAmendmentQuote(newQuote) && datesHaveChanged){
            newQuote = cqs.setRemainingLicenseTCV(newQuote);
        }

    }
    public void beforeDelete(SObject so) {
    }

    public void afterInsert(SObject so)
    {
        System.debug('a cpq quote was created');
    }

    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('a cpq quote was updated');
    }

    public void afterDelete(SObject so)
    {
    }
    public void andFinally()
    {
    }

}