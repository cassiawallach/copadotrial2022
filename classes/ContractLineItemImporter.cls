public class ContractLineItemImporter {
	public Contract contract {get;set;}
	public List<QuoteLineItem> qlis {get;set;}
    
    public ContractLineItemImporter(ApexPages.StandardController stdController) {
        qlis = new List<QuoteLineItem>();
        contract = [select Id, Name, CurrencyIsoCode, Opportunity__c from Contract where Id = :stdController.getId()];
    }
    public PageReference doImport(){
        try{
            if(contract.Opportunity__c==null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Opportunity needs to be defined to get quote'));
                return null;
            }
            List<Quote> quotes = [SELECT Id, Name, CurrencyIsoCode, IsSyncing, OpportunityId FROM Quote where IsSyncing=true and OpportunityId=:contract.Opportunity__c];
            if(quotes.size()==0){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'No quotes found that are sync\'ed against opportunity'));
                return null;                
            }
            if(contract.CurrencyIsoCode != quotes[0].CurrencyIsoCode){
                contract.CurrencyIsoCode = quotes[0].CurrencyIsoCode;
                update contract;
            }
            qlis = new List<QuoteLineItem>();
            qlis = [SELECT Id, CurrencyIsoCode, QuoteId, LineNumber FROM QuoteLineItem where QuoteId=:quotes[0].Id];
            List<Contract_Line_Item__c> clis = new List<Contract_Line_Item__c>();
            for(QuoteLineItem qli : qlis){
                clis.add(new Contract_Line_Item__c(Contract__c=contract.Id, Quote_Line_Item__c=qli.Id));
            }
            insert clis;
            system.debug('### inserting clis '+clis);
            return new PageReference('/'+contract.Id);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ''+e.getMessage()+'   '+e.getStackTraceString()));
            return null;
        }
    }
}