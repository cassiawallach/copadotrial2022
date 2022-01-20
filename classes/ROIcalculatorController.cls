public class ROIcalculatorController {
    public String eePrices {get;set;}
    public String pePrices {get;set;}
    public String ccmPrices {get;set;}
    public String cbmPrices {get;set;}
    
    public PageReference init(){
        pePrices = '';
        eePrices = '';
        ccmPrices = '';
        cbmPrices = '';
    	List<PricebookEntry> pbes = [SELECT Id, Name, CurrencyIsoCode, Product2.Name, Product2.ProductCode, IsActive, UnitPrice FROM PricebookEntry 
                                     where IsActive=true and Product2.Used_on_Website__c=true and UseStandardPrice=false];
        for(PricebookEntry pe : pbes){
            if(pe.Product2.Name.contains('Branch Management'))cbmPrices = cbmPrices + pe.CurrencyIsoCode+':'+pe.UnitPrice+';';
            if(pe.Product2.Name.contains('Enterprise Edition'))eePrices = eePrices + pe.CurrencyIsoCode+':'+pe.UnitPrice+';';
        	if(pe.Product2.Name.contains('Professional Edition'))pePrices = pePrices + pe.CurrencyIsoCode+':'+pe.UnitPrice+';';
            if(pe.Product2.Name.contains('Change Management'))ccmPrices = ccmPrices + pe.CurrencyIsoCode+':'+pe.UnitPrice+';';
        }
        return null;
    }
}