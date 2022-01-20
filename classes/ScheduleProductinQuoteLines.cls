//This scheduler class will map Renewal QuoteLines with Product and run in every 10 minutes.
global class ScheduleProductinQuoteLines implements Schedulable {
   
    global void execute(SchedulableContext sc) {       
       
        // process each batch of records default size is 200
        Map<string,SBQQ__QuoteLine__c> origQuoteLineIdAndQuoteLine = new Map<string,SBQQ__QuoteLine__c>();
        List<SBQQ__QuoteLine__c> updateQuoteLineList = new List<SBQQ__QuoteLine__c>();
        
        List<SBQQ__QuoteLine__c> qtLineList = [SELECT Id, SBQQ__AllowAssetRefund__c,SBQQ__Quote__c,OriginalQuoteLineId2__c FROM SBQQ__QuoteLine__c where SBQQ__Product__c = null AND  OriginalQuoteLineId2__c != null];
        IF(Test.isRunningTest()){
            qtLineList = [SELECT Id, SBQQ__AllowAssetRefund__c,SBQQ__Quote__c,OriginalQuoteLineId2__c FROM SBQQ__QuoteLine__c where OriginalQuoteLineId2__c != null];
        }
        for(SBQQ__QuoteLine__c quoteLine : qtLineList) {
            
            origQuoteLineIdAndQuoteLine.put(quoteLine.OriginalQuoteLineId2__c,quoteLine);  
            
        }   
       
        if(!origQuoteLineIdAndQuoteLine.isEmpty()) {
            for(SBQQ__QuoteLine__c originalQuoteLine : [Select Id, SBQQ__ProrateMultiplier__c,SBQQ__Product__c from SBQQ__QuoteLine__c where Id IN:origQuoteLineIdAndQuoteLine.keySet()]) {
                origQuoteLineIdAndQuoteLine.get(originalQuoteLine.Id).SBQQ__Product__c = originalQuoteLine.SBQQ__Product__c;
                origQuoteLineIdAndQuoteLine.get(originalQuoteLine.Id).SBQQ__ProrateMultiplier__c = originalQuoteLine.SBQQ__ProrateMultiplier__c;
                origQuoteLineIdAndQuoteLine.get(originalQuoteLine.Id).SBQQ__AllowAssetRefund__c = true;
                updateQuoteLineList.add(origQuoteLineIdAndQuoteLine.get(originalQuoteLine.Id));
            }
        }

        if(!updateQuoteLineList.isEmpty()) {               
            try {           
                update updateQuoteLineList;
            
            } catch(Exception e) {
                System.debug(e);
            }    
        }         
    }  
}