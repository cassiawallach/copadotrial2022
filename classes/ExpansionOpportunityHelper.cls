//This class is called in trgforExpansionOpty trigger
public class ExpansionOpportunityHelper {   
    
    //This method map the Lead Source and Detail from Original Opportunity to Expansion Opportunity.
    public static void beforeInsert(List<Opportunity> opptyList) {
        Set<Id> contractId = new Set<Id>();
        for(Opportunity opp : opptyList) {
            
            if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Expansion').getRecordTypeId() && opp.ContractId != null) {
                system.debug('contractId---'+opp.RecordTypeId +opp.ContractId);
                contractId.add(opp.ContractId);    
            }
        }
        Map<Id,Contract> mapContractIdAndContract = new Map<Id,Contract>([Select Id,Opportunity__c,Opportunity__r.LeadSource, Opportunity__r.Lead_Source_Detail__c
                                        from Contract where Id IN:contractId]);
      
        for(Opportunity opp : opptyList) {
            if(!mapContractIdAndContract.isEmpty() && mapContractIdAndContract.size() > 0 && 
                mapContractIdAndContract.containsKey(opp.ContractId)){
                    Contract contr = mapContractIdAndContract.get(opp.ContractId);
                    opp.LeadSource = contr.Opportunity__r.LeadSource;
                    opp.Lead_Source_Detail__c = contr.Opportunity__r.Lead_Source_Detail__c ;
                    //opp.SBQQ__AmendedContract__c = contr.Id;                       
            }                
        } 
    }
    //This method creates the Quote, QuoteLines and OpportunityLineItem when an Expansion Opp gets created.
    public static void afterInsert(List<Opportunity> opptyList) {
        Map<Id,Opportunity> mapContIdAndOpportunity = new Map<Id,Opportunity>(); 
        for(Opportunity opp : opptyList) {
            if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Expansion').getRecordTypeId() && opp.ContractId != null) {
                mapContIdAndOpportunity.put(opp.ContractId,opp);                  
            }
        }
        Map<Id,Contract> mapContIdAndContract = new Map<Id,Contract>();
        Set<Id> quoteIds = new set<Id>();
        set<Id> opptyIds = new set<Id>();
        Map<Id,List<SBQQ__QuoteLine__c>> mapQuoteIdAndquoteLineList = new Map<Id,List<SBQQ__QuoteLine__c>>();
        Map<Id,List<OpportunityLineItem>> mapOppIdAndOppProductList = new Map<Id,List<OpportunityLineItem>>();
        
        if(!mapContIdAndOpportunity.isEmpty() && mapContIdAndOpportunity.size()>0) {
            for(Contract cont : [Select Id,Opportunity__c,kuga_sub__ContactBuying__c,StartDate,EndDate,Opportunity__r.OwnerId,
                        Opportunity__r.SBQQ__PrimaryQuote__c,Opportunity__r.SBQQ__PrimaryQuote__r.SBQQ__CustomerDiscount__c
                        from Contract where Id IN:mapContIdAndOpportunity.keyset()]) {            
                mapContIdAndContract.put(cont.id, cont);
                quoteIds.add(cont.Opportunity__r.SBQQ__PrimaryQuote__c);
                opptyIds.add(cont.Opportunity__c);
            }           
        }
        
        if(!quoteIds.isEmpty() && quoteIds.size()>0) {
            for(SBQQ__QuoteLine__c qline : [Select Id,SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__Uplift__c,SBQQ__PricingMethod__c,
                                               SBQQ__SubscriptionPercent__c,SBQQ__Product__c,SBQQ__ListPrice__c,SBQQ__NetPrice__c,
                                               SBQQ__DefaultSubscriptionTerm__c,SBQQ__Quantity__c,SBQQ__Quote__c,SBQQ__Discount__c,
                                               SBQQ__OriginalPrice__c,SBQQ__ProrateMultiplier__c,SBQQ__SubscriptionPricing__c,
                                               SBQQ__SegmentIndex__c,SBQQ__Description__c,Non_Segmented_or_Non_Subscription__c,
                                               Proposal_Segment_Index__c,Proposal_Segment_Label__c,SBQQ__Dimension__c,SBQQ__UpgradedQuantity__c,
                                               SBQQ__Renewal__c, SBQQ__Existing__c,SBQQ__DiscountScheduleType__c,SBQQ__CarryoverLine__c,
                                               SBQQ__PriorQuantity__c,SBQQ__Bundled__c,SBQQ__AllowAssetRefund__c,SBQQ__ProratedListPrice__c,
                                               SBQQ__PricebookEntryId__c,SBQQ__ProductSubscriptionType__c,SBQQ__SegmentKey__c,
                                               SBQQ__SegmentLabel__c,SBQQ__SubscriptionBase__c,SBQQ__SubscriptionCategory__c,
                                               SBQQ__SubscriptionType__c, SBQQ__Product__r.Family
                                               from SBQQ__QuoteLine__c where SBQQ__Quote__c IN:quoteIds AND
                                               SBQQ__Product__r.Family != 'Academy' AND SBQQ__Product__r.Family != 'Services']) {
                                               
                if(mapQuoteIdAndquoteLineList.get(qline.SBQQ__Quote__c) == null){
                    mapQuoteIdAndquoteLineList.put(qline.SBQQ__Quote__c, new List<SBQQ__QuoteLine__c>());
                }
                mapQuoteIdAndquoteLineList.get(qline.SBQQ__Quote__c).add(qline);
            }
        }
      
        set<Id> prodId = new set<Id>();
        if(!opptyIds.isEmpty() && opptyIds.size()>0) {
            for(OpportunityLineItem oprod : [Select Id,OpportunityId,Product2Id,kuga_sub__ARR__c,Quantity,UnitPrice,Opportunity.Pricebook2Id,Opportunity.CurrencyIsoCode
                                               from OpportunityLineItem
                                               where OpportunityId IN:opptyIds]) {
                 
                if(mapOppIdAndOppProductList.get(oprod.OpportunityId) == null){
                    mapOppIdAndOppProductList.put(oprod.OpportunityId, new List<OpportunityLineItem>());
                }
                mapOppIdAndOppProductList.get(oprod.OpportunityId).add(oprod);
                
                prodId.add(oprod.Product2Id);
            }
        }
        Map<id,List<PriceBookEntry>> mapProductIdAndPbeList = new Map<Id,List<PriceBookEntry>>();
        Map<Id,Id> mapPriceBookIdAndPbeId = new Map<Id,Id>();
        for(PriceBookEntry prBookEntry : [SELECT Id, Pricebook2Id ,Product2Id, Product2.Id, Product2.Name,CurrencyIsoCode FROM PriceBookEntry 
                                 WHERE Product2Id IN:prodId AND IsActive=true]) {
            mapPriceBookIdAndPbeId.put(prBookEntry.Pricebook2Id ,prBookEntry.Id );
           
            if(mapProductIdAndPbeList.get(prBookEntry.Product2Id) == null){
                mapProductIdAndPbeList.put(prBookEntry.Product2Id, new List<PriceBookEntry>());
            }
            mapProductIdAndPbeList.get(prBookEntry.Product2Id).add(prBookEntry);                       
        }        
    
        List<SBQQ__Quote__c> createQuoteList = new List<SBQQ__Quote__c>();
        
        if(!mapContIdAndContract.isEmpty() && mapContIdAndContract.size()>0) {
            for(Id conId : mapContIdAndContract.keySet()) {            
                    SBQQ__Quote__c quote = new SBQQ__Quote__c();
                    quote.SBQQ__Opportunity2__c = mapContIdAndOpportunity.get(conId).Id;
                    quote.SBQQ__Primary__c = true;
                    quote.SBQQ__Account__c = mapContIdAndOpportunity.get(conId).AccountId;
                    quote.SBQQ__SalesRep__c = mapContIdAndContract.get(conId).Opportunity__r.OwnerId;
                    //quote.SBQQ__StartDate__c = mapContIdAndContract.get(conId).StartDate;
                    quote.SBQQ__StartDate__c = system.today();
                    quote.SBQQ__EndDate__c = mapContIdAndContract.get(conId).EndDate;
                    quote.SBQQ__PrimaryContact__c = mapContIdAndContract.get(conId).kuga_sub__ContactBuying__c;
                    quote.SBQQ__CustomerDiscount__c = mapContIdAndContract.get(conId).Opportunity__r.SBQQ__PrimaryQuote__r.SBQQ__CustomerDiscount__c;
                    quote.SBQQ__Type__c = 'Amendment';
                    createQuoteList.add(quote);   
            }
        }     
        if(!createQuoteList.isEmpty()) {
            insert createQuoteList ;
        }
   
        Map<Id,Id> mapContIdAndQuoteId = new Map<Id,Id>();
        
        for(SBQQ__Quote__c quote : [Select Id, SBQQ__Opportunity2__r.ContractId from SBQQ__Quote__c where Id IN :createQuoteList]) {
         
            mapContIdAndQuoteId.put(quote.SBQQ__Opportunity2__r.ContractId,quote.Id);
        }  
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>(); 
        List<OpportunityLineItem> createOpptyProduct = new List<OpportunityLineItem>();
        if(!mapContIdAndContract.isEmpty() && mapContIdAndContract.size()>0) {
            for(Id conId : mapContIdAndContract.keyset()) {
    
                if(!mapQuoteIdAndquoteLineList.isEmpty() && mapQuoteIdAndquoteLineList.size()>0) {
                    for(SBQQ__QuoteLine__c quoteLine : mapQuoteIdAndquoteLineList.get(mapContIdAndContract.get(conId).Opportunity__r.SBQQ__PrimaryQuote__c)) {
                        SBQQ__QuoteLine__c qline = new SBQQ__QuoteLine__c();
                        qline.SBQQ__Quote__c = mapContIdAndQuoteId.get(conId);
                        qline.SBQQ__StartDate__c = quoteLine.SBQQ__StartDate__c;
                        qline.SBQQ__EndDate__c = quoteLine.SBQQ__EndDate__c;
                        qline.SBQQ__Product__c = quoteLine.SBQQ__Product__c;                         
                        qline.SBQQ__ListPrice__c = quoteLine.SBQQ__ListPrice__c;
                        qline.SBQQ__Quantity__c = quoteLine.SBQQ__Quantity__c;
                        qline.SBQQ__OriginalPrice__c = quoteLine.SBQQ__OriginalPrice__c;
                        qline.SBQQ__ProrateMultiplier__c= quoteLine.SBQQ__ProrateMultiplier__c;
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
                        qline.SBQQ__PricingMethod__c = quoteLine.SBQQ__PricingMethod__c;
                        qline.SBQQ__NetPrice__c = quoteLine.SBQQ__NetPrice__c;
                        qline.SBQQ__Discount__c = quoteLine.SBQQ__Discount__c;
                        qline.SBQQ__Renewal__c = quoteLine.SBQQ__Renewal__c;
                        qline.SBQQ__Existing__c = quoteLine.SBQQ__Existing__c;
                        qline.SBQQ__CarryoverLine__c = quoteLine.SBQQ__CarryoverLine__c;
                        qline.SBQQ__PriorQuantity__c = quoteLine.SBQQ__PriorQuantity__c;
                        qline.SBQQ__Bundled__c = quoteLine.SBQQ__Bundled__c;
                        qline.SBQQ__ProratedListPrice__c = quoteLine.SBQQ__ProratedListPrice__c;
                        qline.SBQQ__SubscriptionPricing__c = quoteLine.SBQQ__SubscriptionPricing__c;
                        qline.SBQQ__UpgradedQuantity__c = quoteLine.SBQQ__UpgradedQuantity__c;
                        qline.SBQQ__DiscountScheduleType__c = quoteLine.SBQQ__DiscountScheduleType__c;
                        qline.SBQQ__AllowAssetRefund__c = quoteLine.SBQQ__AllowAssetRefund__c;
                        quoteLineList.add(qline);
                    }
                }
                if(!mapOppIdAndOppProductList.isEmpty() && mapOppIdAndOppProductList.size()>0) {
                    for(OpportunityLineItem opptyLine : mapOppIdAndOppProductList.get(mapContIdAndContract.get(conId).Opportunity__c)) {
                        OpportunityLineItem oppline = new OpportunityLineItem();
                        if(!mapContIdAndOpportunity.isEmpty() && mapContIdAndOpportunity.size()>0) {
                            oppline.OpportunityId = mapContIdAndOpportunity.get(conId).Id;
                        }
                        oppline.Product2Id = opptyLine.Product2Id;
                        oppline.UnitPrice = opptyLine.UnitPrice;                         
                        oppline.Quantity = opptyLine.Quantity;
                        oppline.kuga_sub__ARR__c = opptyLine.kuga_sub__ARR__c;  
                       
                        if(!mapProductIdAndPbeList.isEmpty() && mapProductIdAndPbeList.size()>0 && mapProductIdAndPbeList.containskey(opptyLine.Product2Id)) {
                
                            List<PricebookEntry> pbeList = mapProductIdAndPbeList.get(opptyLine.Product2Id);
            
                            for(PriceBookEntry pbe : pbeList) {
                             
                                if(opptyLine.Opportunity.Pricebook2Id == pbe.Pricebook2Id  && pbe.Product2.Id == oppline.Product2Id && pbe.CurrencyIsoCode == opptyLine.Opportunity.CurrencyIsoCode) {
                                     
                                     oppline.PricebookEntryId = pbe.Id; 
                                } 
                            }
                        }                
                        createOpptyProduct.add(oppline);                
                    } 
                }
            } 
        }
        //system.debug('createOpptyProduct-------------'+createOpptyProduct.size()+createOpptyProduct);
        if(!quoteLineList.isEmpty()) {
            try {           
                insert quoteLineList;                    
            } catch(Exception e) {
                    System.debug(e);
            } 
        } 
        if(!createOpptyProduct.isEmpty()) {
            try {           
                insert createOpptyProduct;                    
            } catch(Exception e) {
                System.debug(e);
            } 
        }      
    }
}