public class OrderItemImporterExtension {
    
    public Order theOrder {get;set;}
    
    public static final String[] FIELDS = new String[] {'Id','Name','OpportunityId','Id','CurrencyIsoCode'};
        
	public OrderItemImporterExtension(ApexPages.StandardController stdController) {
        if(!Test.isRunningTest())stdController.addFields(FIELDS);
        theOrder = [select Id, OpportunityId from Order where Id=:stdController.getId()];
    }
    public PageReference doImport(){
        try{
            if(theOrder.OpportunityId==null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Opportunity needs to be defined Order'));
                return null;
            }
            Map<Id, Double> revenueMap = new Map<Id, Double>();
            Id oppPricebook2Id = null;
            for(OpportunityLineItemSchedule r : [select Id, Revenue, OpportunityLineItemId, OpportunityLineItem.Opportunity.Pricebook2Id from OpportunityLineItemSchedule where OpportunityLineItem.OpportunityId=:theOrder.OpportunityId]){
                revenueMap.put(r.OpportunityLineItemId, r.Revenue);
                oppPricebook2Id = r.OpportunityLineItem.Opportunity.Pricebook2Id;
            }
            List<OrderItem> oitems = new List<OrderItem>();
            for(OpportunityLineItem oli : [select Id, Product2Id, PricebookEntryId, Quantity, UnitPrice, TotalPrice from OpportunityLineItem where OpportunityId=:theOrder.OpportunityId]){
                OrderItem i = new OrderItem(PricebookEntryId=oli.PricebookEntryId, Quantity=oli.Quantity, UnitPrice=oli.UnitPrice, OrderId=theOrder.Id);
                i.Recurring_Monthly_Price__c = (revenueMap.containsKey(oli.Id))?(revenueMap.get(oli.Id)/oli.Quantity):null;
                oitems.add(i);
            }
            theOrder.Pricebook2Id = oppPricebook2Id;
            update theOrder;
            
            insert oitems;
            return new PageReference('/'+theOrder.Id);
        }
        catch(Exception e){
            system.debug('### Exception: '+e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ''+e.getMessage()+'   '+e.getStackTraceString()));
            return null;
        }
    }
}