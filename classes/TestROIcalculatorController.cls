@isTest
public class TestROIcalculatorController {
    static testMethod void concatenationTest(){
        Id pricebookId = Test.getStandardPricebookId();

		Product2 p = new Product2(Name='Enterprise Edition (12 months)', isActive=true, Used_on_Website__c=true);
		insert p;
        Product2 p2 = new Product2(Name='Branch Management (12 months)', isActive=true, Used_on_Website__c=true);
		insert p2;
        Product2 p3 = new Product2(Name='Change Management (12 months)', isActive=true, Used_on_Website__c=true);
		insert p3;
        Product2 p4 = new Product2(Name='Professional Edition (12 months)', isActive=true, Used_on_Website__c=true);
		insert p4;
		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p.Id, UnitPrice=5, IsActive=true);
        insert standardPrice;
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p2.Id, UnitPrice=5, IsActive=true);
        insert standardPrice2;
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p3.Id, UnitPrice=5, IsActive=true);
        insert standardPrice3;
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p4.Id, UnitPrice=5, IsActive=true);
        insert standardPrice4;
        ROIcalculatorController con = new ROIcalculatorController();
        PageReference pr = con.init();
        system.assert(String.isNotBlank(con.eePrices));
        system.assert(String.isNotBlank(con.cbmPrices));
        system.assert(String.isNotBlank(con.pePrices));
        system.assert(String.isNotBlank(con.ccmPrices));
        
    }
}