public class OppLineItemService{
    public static void deleteRecord(Set<string> ids){
        List<OpportunityLineItemSchedule> oppLineItemList = [SELECT Id, OpportunityLineItemId FROM OpportunityLineItemSchedule 
                                                             Where OpportunityLineItemId=:ids];
        If(oppLineItemList.Size()> 0){
            Delete oppLineItemList;
        }      
       
    }
}