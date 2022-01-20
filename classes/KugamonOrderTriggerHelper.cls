public class KugamonOrderTriggerHelper {
    public static List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
    public static List<SBQQ__QuoteLine__c> updateListOfRenewalQuote = new List<SBQQ__QuoteLine__c>();
    public static Map<Id,SBQQ__QuoteLine__c> quoteLineMap = new Map<Id,SBQQ__QuoteLine__c>();
    public static Map<Id,SBQQ__QuoteLine__c> quoteLineListMap = new Map<Id,SBQQ__QuoteLine__c>();
    //By using this method create new line and subscription for renewal opportunity
    public static void createQuoteLineOnRenewalOpportuntiy(List<kugo2p__SalesOrder__c> newOrderList){
        Set<String> oppIdSet = new Set<String>();         
        Map<String,SBQQ__Quote__c> opptyQuoteMap = new Map<String,SBQQ__Quote__c>();
        Map<String,String> contractRenewalOppMap = new Map<String,String>();
       
        Id expRecordTypeId = Schema.SObjectType.kugo2p__SalesOrder__c.getRecordTypeInfosByName().get('Expansion').getRecordTypeId();
       
        for(kugo2p__SalesOrder__c orderObj : newOrderList){
            if(orderObj.RecordTypeId == expRecordTypeId && orderObj.kugo2p__RecordStatus__c == 'Released'){
                oppIdSet.add(orderObj.kugo2p__Opportunity__c);
                oppIdSet.add(orderObj.kuga_sub__RenewalOpportunity__c);                
            }
        }        
        
        for(SBQQ__Quote__c quoteObj :[Select Id,SBQQ__Opportunity2__c,(SELECT SBQQ__Quote__c,SBQQ__Product__r.name,SBQQ__Product__c,SBQQ__Quantity__c,SBQQ__PricingMethod__c,
                                                                       PS_Is_Licence__c,SBQQ__Renewal__c,SBQQ__ProrateMultiplier__c,SBQQ__SegmentIndex__c,SBQQ__ListPrice__c,
                                                                       Net_Unit_Price__c,SBQQ__BlockPrice__c,SBQQ__ContractedPrice__c,SBQQ__CustomerPrice__c,SBQQ__Dimension__c,
                                                                       SBQQ__GenerateContractedPrice__c,SBQQ__MaximumPrice__c,SBQQ__MinimumPrice__c,SBQQ__NetPrice__c,
                                                                       SBQQ__OriginalPrice__c,SBQQ__PartnerPrice__c,SBQQ__PreviousSegmentPrice__c,SBQQ__PricebookEntryId__c,
                                                                       SBQQ__PriceEditable__c,SBQQ__ProratedListPrice__c,SBQQ__ProratedPrice__c,SBQQ__RegularPrice__c,
                                                                       SBQQ__SpecialPrice__c,SBQQ__SpecialPriceDescription__c,SBQQ__SpecialPriceType__c,SBQQ__SubscriptionTargetPrice__c,
                                                                       SBQQ__UnproratedNetPrice__c,AVA_SFCPQ__Sales_Tax_Details__c,AVA_SFCPQ__SalesTaxDetails__c,AVA_SFCPQ__TaxAmount__c,
                                                                       SBQQ__SubscriptionPricing__c,SBQQ__SubscriptionScope__c,SBQQ__DefaultSubscriptionTerm__c,SBQQ__RenewedSubscription__c,
                                                                       SBQQ__SubscriptionTerm__c,SBQQ__Discount__c,SBQQ__DiscountSchedule__c,SBQQ__DiscountTier__c,SBQQ__TermDiscountSchedule__c,
                                                                       SBQQ__TermDiscountTier__c,SBQQ__AllowAssetRefund__c,SBQQ__BillingFrequency__c,
                                                                       CurrencyIsoCode,SBQQ__EndDate__c,SBQQ__SubscriptionBase__c,SBQQ__SubscriptionCategory__c,
                                                                       SBQQ__ProductSubscriptionType__c,SBQQ__SegmentKey__c,SBQQ__SegmentLabel__c,
                                                                       SBQQ__SubscriptionType__c,SBQQ__Uplift__c ,SBQQ__StartDate__c,SBQQ__UpliftAmount__c FROM SBQQ__LineItems__r) From SBQQ__Quote__c
                                      Where SBQQ__Primary__c = true AND SBQQ__Opportunity2__c IN:oppIdSet ]){
                                          
                                          opptyQuoteMap.put(quoteObj.SBQQ__Opportunity2__c,quoteObj);                       
                                      }
        for(kugo2p__SalesOrder__c orderObj2 : newOrderList ){
            if(orderObj2.RecordTypeId == expRecordTypeId){
                List<SBQQ__QuoteLine__c> listOfExpansionQuote = new List<SBQQ__QuoteLine__c>();
                List<SBQQ__QuoteLine__c> listOfRenewalQuote = new List<SBQQ__QuoteLine__c>();
               
                if(opptyQuoteMap.containskey(orderObj2.kuga_sub__RenewalOpportunity__c)){
                    listOfRenewalQuote = opptyQuoteMap.get(orderObj2.kuga_sub__RenewalOpportunity__c).SBQQ__LineItems__r;                    
                }
                if(opptyQuoteMap.containskey(orderObj2.kugo2p__Opportunity__c)){
                    listOfExpansionQuote = opptyQuoteMap.get(orderObj2.kugo2p__Opportunity__c).SBQQ__LineItems__r;
                } 
                        
                if(listOfRenewalQuote.Size()>0 && listOfExpansionQuote.Size() >0){
                    for(SBQQ__QuoteLine__c lineObj :listOfExpansionQuote){
                        Boolean isMatch = false;
                        for(SBQQ__QuoteLine__c lineObj2 :listOfRenewalQuote){
                            if(lineObj.SBQQ__Product__c == lineObj2.SBQQ__Product__c){
                                lineObj2.SBQQ__Quantity__c = lineObj.SBQQ__Quantity__c;
                                isMatch = true;
                                updateListOfRenewalQuote.add(lineObj2);
                                quoteLineMap.putAll(updateListOfRenewalQuote);
                            }
                        }                       
                        if(!isMatch){
                            SBQQ__QuoteLine__c quoteLineObj = lineObj.Clone();    
                            quoteLineObj.SBQQ__Quote__c = opptyQuoteMap.get(orderObj2.kuga_sub__RenewalOpportunity__c).id;
                            quoteLineList.add(quoteLineObj);
                            //system.debug('#Step1'+ quoteLineList);
                            //quoteLineListMap.putAll(quoteLineList);
                        } 
                    }
                }
            }
        } 
        
            
    }

    public static void createQuoteLineOnRenewal(){
       System.debug('#####'+quoteLineList );
       if(!quoteLineList.isEmpty()){    
            if(!Test.isRunningtest()) {        
                Upsert quoteLineList;  
            }         
        }       
        if(!quoteLineMap.isEmpty()){   
            system.debug('@@@@@'+quoteLineMap );
            Update quoteLineMap.values();             
        }  
    }
}