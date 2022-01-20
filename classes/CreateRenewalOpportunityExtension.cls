public class CreateRenewalOpportunityExtension {
    public final Opportunity opportunity {get;set;}
    public Contract contract {get;set;}
    public ApexPages.StandardController controller {get;set;}
    
    public static final String[] OPPFIELDS = new String[] {'Name','AccountId','RecordTypeId','Amount','CurrencyIsoCode','Type','Amount','OwnerId'};

    public CreateRenewalOpportunityExtension(ApexPages.StandardController stdController){
        if(!Test.isRunningTest())stdController.addFields(OPPFIELDS);
        controller = stdController;
        this.opportunity = (Opportunity)controller.getRecord();
    }
    public PageReference createRenewal(){
        if(controller.getId()==null){
            Apexpages.addMessage(new apexpages.Message(ApexPages.Severity.FATAL, 'No Opportunity specified to created a renewal record.'));
        	return null;
        }
        
        try{
            contract = [select Id, EndDate from Contract where Id=:ApexPages.currentPage().getParameters().get('contractId') limit 1];
        }
        catch(Exception e){
            Apexpages.addMessage(new apexpages.Message(ApexPages.Severity.FATAL, 'No contract record was found.'));
        	return null;
        }
        
        SavePoint sp = Database.setSavepoint();
        try{
        	Opportunity renewal = opportunity.clone();
            renewal.CloseDate = contract.EndDate;
            renewal.Name = renewal.Name+' renewal '+contract.EndDate.Year();
            renewal.StageName = 'Perception Analysis';
            renewal.Type = 'Renewal';
            renewal.Description = 'PLEASE CHECK PREVIOUS OPPORTUNITY PRICE.\nTHE LIST PRICE HAS BEEN ADOPTED.';
            insert renewal;
            
            List<OpportunityLineItem> newOlis = new List<OpportunityLineItem>();
            for(OpportunityLineItem oli:[select Id, OpportunityId, SortOrder, PricebookEntryId, PricebookEntry.UnitPrice, Product2.RevenueScheduleType, Product2.NumberOfRevenueInstallments, Product2.RevenueInstallmentPeriod, Product2Id, CurrencyIsoCode, Quantity, UnitPrice, External_Id__c, HasRevenueSchedule, ServiceDate from OpportunityLineItem where OpportunityId=:opportunity.Id]){
                OpportunityLineItem tmp = oli.clone();
                tmp.UnitPrice = oli.PricebookEntry.UnitPrice; //CHANGE THIS ONCE ALL OPPS PRICINGS ARE GOOD. DISCOUNT MATRIX WILL BE USED MOVING FORWARD.
                tmp.OpportunityId = renewal.Id;
                tmp.ServiceDate = contract.EndDate.addDays(1);
                newOlis.add(tmp);
            }
            
            List<OpportunityContactRole> newOcrs = new List<OpportunityContactRole>();
            for(OpportunityContactRole ocr : [select ContactId, OpportunityId, Role, isPrimary from OpportunityContactRole where OpportunityId=:opportunity.Id]){
                newOcrs.add(new OpportunityContactRole(ContactId=ocr.contactId, OpportunityId=renewal.Id, Role=ocr.Role, isPrimary=ocr.IsPrimary));
            }
            
			insert newOlis;
        	
            List<OpportunityLineItemSchedule> newOliSchedules = new List<OpportunityLineItemSchedule>();
            for(OpportunityLineItem oli : newOlis){
                for(Integer i=0; i<oli.Product2.NumberOfRevenueInstallments; i++){
                	if(oli.Product2.RevenueInstallmentPeriod=='Monthly'){ 
                        OpportunityLineItemSchedule oliSchedule = new OpportunityLineItemSchedule(OpportunityLineItemId=oli.Id, Type='Revenue');
                        
                        oliSchedule.ScheduleDate = oli.ServiceDate.addMonths(i);
                        //oliSchedule.Quantity = oli.Quantity;
                        
                        if(oli.Product2.RevenueScheduleType=='Repeat')oliSchedule.Revenue = oli.PricebookEntry.UnitPrice * oli.Quantity;
                        if(oli.Product2.RevenueScheduleType=='Divide')oliSchedule.Revenue = renewal.Amount / oli.Product2.NumberOfRevenueInstallments / oli.Quantity;
                		newOliSchedules.add(oliSchedule);
                    }
                }
            }
            insert newOliSchedules;
            
            insert newOcrs;
            return new PageReference('/'+renewal.Id);
        }
        catch(Exception e){
            Apexpages.addMessage(new apexpages.Message(ApexPages.Severity.FATAL, e.getMessage()));
            Database.rollback(sp);
            return null;
        }
    }
}