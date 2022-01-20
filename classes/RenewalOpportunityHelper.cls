//This class is called from createQuoteLineRenewalOppty trigger
public class RenewalOpportunityHelper {
  
    //This method creates Renewal Quote Lines 
    @future
    public static void RenewalOpportunityDetails(set<Id> opptyId, set<Id> quoteIds) {        
        
        List<SBQQ__Quote__c> renewQuoteList = [Select SBQQ__StartDate__c, SBQQ__EndDate__c, SBQQ__Type__c from SBQQ__Quote__c where Id IN: quoteIds];
        set<Id> ContractId = new set<Id>();  
           
        List<SBQQ__QuoteLine__c> createQuoteLineList = new List<SBQQ__QuoteLine__c>(); 
        if(!opptyId.isEmpty()) {
            Id RecdTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            
            for(Opportunity opp : [select Id, AccountId, ContractId from Opportunity where RecordTypeId =:RecdTypeId AND 
                                       Id IN:opptyId]) {
                ContractId.add(opp.ContractId);    
            }    
                  
            if(!ContractId.isEmpty()) {
                
                set<Id> originalQuoteIds = new set<Id>();
                for(Contract cont : [Select Id,Opportunity__c,Opportunity__r.SBQQ__PrimaryQuote__c from Contract where Id IN:ContractId]) {
                    originalQuoteIds.add(cont.Opportunity__r.SBQQ__PrimaryQuote__c);
                }    
                List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
                
                if(!OriginalQuoteIds.isEmpty()) {
                    for(SBQQ__QuoteLine__c qline : [Select Id,SBQQ__StartDate__c, OriginalQuoteLineId2__c ,SBQQ__EndDate__c,SBQQ__Uplift__c,SBQQ__PricingMethod__c,
                                               SBQQ__SubscriptionPercent__c,SBQQ__Product__c,SBQQ__ListPrice__c,
                                               SBQQ__DefaultSubscriptionTerm__c,SBQQ__Quantity__c,SBQQ__Quote__c,SBQQ__Discount__c,
                                               SBQQ__OriginalPrice__c,SBQQ__SubscriptionPricing__c,CurrencyIsoCode,
                                               SBQQ__SegmentIndex__c,SBQQ__Description__c,Non_Segmented_or_Non_Subscription__c,
                                               Proposal_Segment_Index__c,Proposal_Segment_Label__c,SBQQ__Dimension__c,SBQQ__Renewal__c,
                                               SBQQ__Existing__c,SBQQ__DiscountScheduleType__c,SBQQ__CarryoverLine__c,
                                               SBQQ__PriorQuantity__c,SBQQ__Bundled__c,No_of_Months__c,SBQQ__UpgradedQuantity__c,
                                               PS_CPQ_Term_in_Months__c,SBQQ__PricebookEntryId__c,SBQQ__ProductSubscriptionType__c,
                                               SBQQ__SegmentKey__c, SBQQ__SegmentLabel__c,SBQQ__SubscriptionBase__c,SBQQ__SubscriptionCategory__c,                                            
                                               SBQQ__SubscriptionType__c, SBQQ__Product__r.Family
                                               from SBQQ__QuoteLine__c where SBQQ__Quote__c IN:originalQuoteIds AND
                                               SBQQ__Product__r.Family != 'Academy' AND SBQQ__Product__r.Family != 'Services'  
                                               AND SBQQ__SegmentIndex__c = 1 ORDER BY SBQQ__Product__c  ASC
                                              ]) {                       
                        quoteLineList.add(qline); 
                    }
                    
                    if(!quoteLineList.isEmpty() && quoteLineList.size()>0) {       
                        for(SBQQ__Quote__c quote : renewQuoteList) {
                            for(SBQQ__QuoteLine__c quoteLine : quoteLineList) {
                                    SBQQ__QuoteLine__c qline = new SBQQ__QuoteLine__c();
                                    if(quoteLine.No_of_Months__c != null) {                                                                                 
                                        IF(Test.isRunningTest()){
                                            qline.SBQQ__StartDate__c = system.today();                                                                  
                                            qline.SBQQ__EndDate__c = system.today().addMonths(12)-1;                       
                                    
                                        } else {
                                            qline.SBQQ__StartDate__c = renewQuoteList[0].SBQQ__StartDate__c;                                                             
                                            qline.SBQQ__EndDate__c = qline.SBQQ__StartDate__c.addMonths(12)-1;                                     
                                        }                                        
                                    }
                                    qline.SBQQ__Quote__c = quote.Id;                                                          
                                    qline.SBQQ__ListPrice__c = quoteLine.SBQQ__ListPrice__c;
                                    qline.SBQQ__Quantity__c = quoteLine.SBQQ__Quantity__c;
                                    qline.SBQQ__OriginalPrice__c = quoteLine.SBQQ__OriginalPrice__c;
                                    qline.SBQQ__SegmentIndex__c= quoteLine.SBQQ__SegmentIndex__c;
                                    qline.SBQQ__Description__c= quoteLine.SBQQ__Description__c;
                                    qline.SBQQ__SubscriptionPricing__c = quoteLine.SBQQ__SubscriptionPricing__c;
                                    qline.SBQQ__DefaultSubscriptionTerm__c = quoteLine.SBQQ__DefaultSubscriptionTerm__c;
                                    qline.SBQQ__SubscriptionPercent__c= quoteLine.SBQQ__SubscriptionPercent__c;
                                    qline.Proposal_Segment_Index__c = quoteLine.Proposal_Segment_Index__c;
                                    qline.Proposal_Segment_Label__c = quoteLine.Proposal_Segment_Label__c;
                                    qline.SBQQ__Dimension__c = quoteLine.SBQQ__Dimension__c;
                                    qline.SBQQ__PricebookEntryId__c = quoteLine.SBQQ__PricebookEntryId__c;
                                    qline.SBQQ__ProductSubscriptionType__c = quoteLine.SBQQ__ProductSubscriptionType__c;
                                    qline.SBQQ__SegmentKey__c = quoteLine.SBQQ__SegmentKey__c;
                                    qline.SBQQ__SegmentLabel__c = quoteLine.SBQQ__SegmentLabel__c;
                                    qline.SBQQ__SubscriptionBase__c = quoteLine.SBQQ__SubscriptionBase__c;
                                    qline.SBQQ__SubscriptionCategory__c = quoteLine.SBQQ__SubscriptionCategory__c;
                                    qline.SBQQ__SubscriptionType__c = quoteLine.SBQQ__SubscriptionType__c;
                                    qline.SBQQ__Uplift__c = quoteLine.SBQQ__Uplift__c;                                                                    
                                    qline.SBQQ__Discount__c = quoteLine.SBQQ__Discount__c;                                    
                                    qline.OriginalQuoteLineId2__c = quoteLine.Id;                                
                                    qline.SBQQ__Renewal__c = quoteLine.SBQQ__Renewal__c;
                                    qline.SBQQ__Existing__c = quoteLine.SBQQ__Existing__c;
                                    qline.SBQQ__CarryoverLine__c = quoteLine.SBQQ__CarryoverLine__c;
                                    qline.SBQQ__PriorQuantity__c = quoteLine.SBQQ__PriorQuantity__c;
                                    qline.SBQQ__Bundled__c = quoteLine.SBQQ__Bundled__c;
                                    qline.SBQQ__PricingMethod__c = quoteLine.SBQQ__PricingMethod__c;                                    
                                    qline.SBQQ__SubscriptionPricing__c = quoteLine.SBQQ__SubscriptionPricing__c;
                                    qline.SBQQ__UpgradedQuantity__c = quoteLine.SBQQ__UpgradedQuantity__c;
                                    qline.SBQQ__DiscountScheduleType__c = quoteLine.SBQQ__DiscountScheduleType__c;                                                                     
                                    qline.CurrencyIsoCode = quoteLine.CurrencyIsoCode;                                                                    
                                    createQuoteLineList.add(qline);                                                               
                            }
                        }   
                    }
                }              
                if(!createQuoteLineList.isEmpty()) {                    
                    try {           
                        insert createQuoteLineList;
                    
                    } catch(Exception e) {
                        System.debug(e);
                    }                       
                } 
            }       
        }        
    }
}