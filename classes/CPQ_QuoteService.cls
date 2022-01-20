/**
 * Created by kheidt on 24/01/2018.
 */

public with sharing class CPQ_QuoteService {

    public Decimal proration;
    public Boolean isAmendment;
    List<SBQQ__Subscription__c> subscriptions = new List<SBQQ__Subscription__c>();

    //standard constructor
    public CPQ_QuoteService(){}

    //custom constructor for more efficient code
    public CPQ_QuoteService(SBQQ__Quote__c quote){
        initializeService(quote);
    }

    private void initializeService(SBQQ__Quote__c quote){
        proration = CPQMigrationHelper.calculateProRate(quote.SBQQ__StartDate__c, quote.SBQQ__EndDate__c);
    }

    public SBQQ__Quote__c setRemainingLicenseTCV(SBQQ__Quote__c quote){

        //get license subscription items
        subscriptions = this.getCPQSubscriptions(quote.SBQQ__MasterContract__c);

        //Calculate proration if it is null
        if(proration == null){
            this.initializeService(quote);
        }

        //calculate license value per month for subscriptions
        Decimal monthlyValue = 0;
        Decimal fullValue = 0;
        for(SBQQ__Subscription__c sub : subscriptions){
            fullValue += sub.SBQQ__NetPrice__c * sub.SBQQ__Quantity__c;
            monthlyValue += (sub.SBQQ__NetPrice__c * sub.SBQQ__Quantity__c)/sub.SBQQ__ProrateMultiplier__c;
        }

        //calculate remaining TCV
        System.debug('actual TCV - proration: ' + proration + ' ; licenseValue: ' + monthlyValue);

        Decimal remainingTCV = monthlyValue * proration;
        quote.Remaining_License_TCV__c = remainingTCV;
        quote.Current_License_TCV__c = fullValue;

        return quote;
    }

    public SBQQ__Quote__c setNumberOfMonths(SBQQ__Quote__c quote){

        //Calculate proration if it is null
        if(proration == null){
            this.initializeService(quote);
        }
        quote.Number_of_Months__c = this.proration;

        return quote;
    }
    

    public List<SBQQ__Subscription__c> getCPQSubscriptions(String cid){
        List<SBQQ__Subscription__c> subs;

        subs = [
                SELECT Id, Name, SBQQ__ListPrice__c, SBQQ__NetPrice__c, SBQQ__Quantity__c, SBQQ__ProrateMultiplier__c
                FROM SBQQ__Subscription__c
                WHERE SBQQ__Contract__c =:cid
                AND SBQQ__Product__r.Family = 'Licenses'
        ];

        return subs;
    }

    public Boolean isAmendmentQuote(SBQQ__Quote__c quote){
        if(quote.SBQQ__Type__c == 'Amendment' && quote.SBQQ__MasterContract__c != null){
            isAmendment = true;
        } else {
            isAmendment = false;
        }

        return isAmendment;
    }

    public Boolean datesHaveChanged(SBQQ__Quote__c newQuote, SBQQ__Quote__c oldQuote){
        if(newQuote.SBQQ__StartDate__c != oldQuote.SBQQ__StartDate__c || newQuote.SBQQ__EndDate__c != oldQuote.SBQQ__EndDate__c){
            return true;
        } else{
            return false;
        }
    }

}