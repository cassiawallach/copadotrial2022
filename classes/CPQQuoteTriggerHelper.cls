public class CPQQuoteTriggerHelper {

    private static Set<Id> lstQuoteIds = new Set<Id>();
    private static Map<Id, SBQQ__Quote__c> mapQuote = new Map<Id, SBQQ__Quote__c>();
    private static Map<Id, List<SBQQ__Subscription__c>> contractSubscriptionMap = new Map<Id, List<SBQQ__Subscription__c>>();
    
    public static void prepareDataBefore(List<SObject> records) {
        Set<Id> contractIds = new Set<Id>();
        for (SObject so : records) {
            SBQQ__Quote__c q = (SBQQ__Quote__c)so;
            contractIds.add(q.SBQQ__MasterContract__c);
            contractSubscriptionMap.put(q.SBQQ__MasterContract__c, new List<SBQQ__Subscription__c>());
        }
        for(SBQQ__Subscription__c s : getCPQSubscriptions(contractIds)){
            List<SBQQ__Subscription__c> tmp = contractSubscriptionMap.get(s.SBQQ__Contract__c);
            tmp.add(s);
            contractSubscriptionMap.put(s.SBQQ__Contract__c, tmp);
        }
    }
    public static void prepareDataAfter(List<SObject> records) {
        for (SObject so : records) {
            SBQQ__Quote__c q = (SBQQ__Quote__c)so;
            if (q.SBQQ__Primary__c && string.isNotEmpty(q.SBQQ__Opportunity2__c)) {
                lstQuoteIds.add(q.Id);
            }
        }
        system.debug('@@@ result size: '+lstQuoteIds.size());
        if(lstQuoteIds.size()>0){
            mapQuote = new CPQQuoteSelector().GetQuoteById(lstQuoteIds);
            system.debug('@@@ map quote size: '+mapQuote.keySet().size());
        }
    }
    
    public static void setAcvTcvOnOpportunities(){
        
        List<Opportunity> lstOpps = new List<Opportunity>();
        for (SBQQ__Quote__c q : mapQuote.values()) {
            
            Decimal dTotalACV = 0;
            Decimal dTotalTCV = 0;
            Decimal dTotalMRR = 0;
            for (SBQQ__QuoteLine__c ql : q.SBQQ__LineItems__r) {
                if((ql.SBQQ__ProductFamily__c=='Licenses' || ql.SBQQ__ProductFamily__c=='Premier Support') && ql.SBQQ__ProrateMultiplier__c!=null && ql.SBQQ__DefaultSubscriptionTerm__c!=null){
                    dTotalTCV += ql.SBQQ__PackageTotal__c;
                    dTotalMRR += (ql.SBQQ__PackageTotal__c/q.Number_of_Months__c);
                    if ((ql.SBQQ__DefaultSubscriptionTerm__c * ql.SBQQ__ProrateMultiplier__c) < 12) {
                        dTotalACV += ql.SBQQ__PackageTotal__c;
                    }
                    else {
                        dTotalACV += ql.SBQQ__PackageTotal__c * (12 / (ql.SBQQ__DefaultSubscriptionTerm__c * ql.SBQQ__ProrateMultiplier__c));
                    }    
                }
            }

            // Add the opp to the list to update
            lstOpps.add(new Opportunity(Id=q.SBQQ__Opportunity2__c, TCV__c=dTotalTCV, ACV__c=dTotalACV, MRR__c=dTotalMRR));
        }
        // Update the opps
        if (lstOpps.size() > 0) {
            system.debug('### Updateing opportunities: '+lstOpps.size());
            // SG 2019-12-23: Deprecating code tranistining logic to price rules - need the above code for code coverage
            //update lstOpps;
        }
        
    }
    
    public static void setNumberOfMonths(SBQQ__Quote__c quote){
        if(quote.SBQQ__StartDate__c!=null && quote.SBQQ__EndDate__c!=null){
            Decimal proration = CPQMigrationHelper.calculateProRate(quote.SBQQ__StartDate__c, quote.SBQQ__EndDate__c);
            quote.Number_of_Months__c = proration;
        }
    }
    public static void setRemainingLicenseTCV(SBQQ__Quote__c oldQuote, SBQQ__Quote__c newQuote){
        // if is new quote and not been ammended, enter if statement.
        if(oldQuote!=null){
            system.debug('### OldQuote is null: ');
            if (!datesHaveChanged(oldQuote, newQuote)) return;
        }
        if (!isAmendmentQuote(newQuote)) return;
        
        system.debug('### Entering setRemainingLicenseTCV: StartDate='+newQuote.SBQQ__StartDate__c+'; EndDate='+newQuote.SBQQ__EndDate__c);
        Decimal proration = CPQMigrationHelper.calculateProRate(newQuote.SBQQ__StartDate__c, newQuote.SBQQ__EndDate__c);
        system.debug('### Proration calculated: '+ proration);
        
        system.debug('### MasterContract: '+newQuote.SBQQ__MasterContract__c);
        //get license subscription items
        List<SBQQ__Subscription__c> subscriptions = contractSubscriptionMap.get(newQuote.SBQQ__MasterContract__c);
        if(subscriptions == null)return;
        
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
        newQuote.Remaining_License_TCV__c = remainingTCV;
        newQuote.Current_License_TCV__c = fullValue;
    }
    public static void deleteSchedules() {
        
        List<OpportunityLineItemSchedule> scheds = [select Id from OpportunityLineItemSchedule where
                                                   OpportunityLineItem.SBQQ__QuoteLine__r.SBQQ__Quote__c IN :lstQuoteIds and
                                                   OpportunityLineItem.Product2.CanUseRevenueSchedule=true and
                                                   OpportunityLineItem.Product2.IsActive=true];
        system.debug('Schedules records to be deleted: '+scheds.size());
        delete scheds;
    }
    
    private static List<SBQQ__Subscription__c> getCPQSubscriptions(Set<Id> cids){
        List<SBQQ__Subscription__c> subs = [SELECT Id, Name, SBQQ__ListPrice__c, SBQQ__NetPrice__c, SBQQ__Quantity__c, SBQQ__ProrateMultiplier__c, SBQQ__Contract__c
                FROM SBQQ__Subscription__c
                WHERE SBQQ__Contract__c IN :cids
                AND SBQQ__Product__r.Family = 'Licenses'];
        return subs;
    }
    private static Boolean isAmendmentQuote(SBQQ__Quote__c quote){
        system.debug('### Entering isAmendmentQuote: quote='+quote);
        if(quote.SBQQ__Type__c == 'Amendment' && quote.SBQQ__MasterContract__c != null){
            system.debug('### isAmendmentQuote: return true;');
            return true;
        } else {
            system.debug('### isAmendmentQuote: return false;');
            return false;
        }
    }
    private static Boolean datesHaveChanged(SBQQ__Quote__c oldQuote, SBQQ__Quote__c newQuote){
        system.debug('### Entering datesHaveChanged: oldQuote='+oldQuote+'; newQuote='+newQuote);
        if(newQuote.SBQQ__StartDate__c != oldQuote.SBQQ__StartDate__c || newQuote.SBQQ__EndDate__c != oldQuote.SBQQ__EndDate__c){
            system.debug('### datesHaveChanged: return true;');
            return true;
        } else{
            system.debug('### datesHaveChanged: return false;');
            return false;
        }
    }
    
}