public with sharing class ContractOrderExtension {
    public Order order {get;set;}
    public List<OrderItem> ois {get;set;}
    public List<OIWrapper> wois {get;set;}
    public List<CurrencyType> cts {get;set;}
    public Map<String, double> rates {get;set;} 
    public CHANNEL_ORDERS__Customer__c scust {get;set;}
    public CHANNEL_ORDERS__Service_Order__c so {get;set;}
    public List<CHANNEL_ORDERS__Service_Order_Detail__c> solis {get;set;}

    public class OIWrapper{
        public OrderItem wcli {get;set;}
        public double totalPrice {get;set;}
        public double convertedMonthlyAmount {get;set;}
        public OIWrapper(OrderItem c, double cma){
            this.wcli = c;
            this.convertedMonthlyAmount = cma;
            this.totalPrice = c.UnitPrice * c.Quantity;
        }
    }
    
    public ContractOrderExtension(ApexPages.StandardController stdController){
        order = (Order)stdController.getRecord();
    }
    
    public PageReference init(){
        wois = new List<OIWrapper>();
        rates = new Map<String, double>();
        solis = new List<CHANNEL_ORDERS__Service_Order_Detail__c>();
        so = new CHANNEL_ORDERS__Service_Order__c();
        System.debug('#### init');
        
        if(order.Custom_Salesforce_Org__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'You must add a Salesforce Org to the order before proceeding.'));
            return null;
        }
        
        try{            
            for(CurrencyType ct : getCurrencyRates()){
                rates.put(ct.IsoCode, ct.ConversionRate);
            }
            order = [SELECT Id, CurrencyIsoCode, Name, Custom_Salesforce_Org__c, Custom_Salesforce_Org__r.OrgId__c, AccountId, Account.Billing_Name__c, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry, OpportunityId, Opportunity.Name, EffectiveDate, EndDate from Order where Id=:order.Id limit 1];
            
            ois = [SELECT Id, CurrencyIsoCode, Quantity, UnitPrice,	SBQQ__UnproratedNetPrice__c, PricebookEntry.Product2.Name,
                    PricebookEntry.Product2.Partner_Product_Catalog__c, 
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Billing_Frequency__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Cancellation_Terms__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Contract_Auto_Renew__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Contract_Length__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Custom_Unit__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Fixed_Price__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Floor_Price__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__PNR__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Pricing_Type__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Product_ID__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Renewal_Terms__c,
                    PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Pricing_Unit__c
                    FROM OrderItem WHERE OrderId=:order.Id and PricebookEntry.Product2.Partner_Product_Catalog__c!=null];
    		
            List<CHANNEL_ORDERS__Customer__c> custs = [SELECT Id, CHANNEL_ORDERS__Customer_Org_ID__c, CHANNEL_ORDERS__Customer_Company_Name__c, CHANNEL_ORDERS__Customer_Street__c, CHANNEL_ORDERS__Customer_City__c, CHANNEL_ORDERS__Customer_State__c, CHANNEL_ORDERS__Customer_ZIP_Postal_Code__c, CHANNEL_ORDERS__Customer_Country__c  from CHANNEL_ORDERS__Customer__c where CHANNEL_ORDERS__Customer_Org_ID__c=:order.Custom_Salesforce_Org__r.OrgId__c.subString(0,15)];
            scust = new CHANNEL_ORDERS__Customer__c();
            if(custs.size()>0){
                scust = custs.get(0);
            }
            else{
                scust.CHANNEL_ORDERS__Customer_Company_Name__c = order.Account.Billing_Name__c;
                scust.CHANNEL_ORDERS__Customer_Org_ID__c = order.Custom_Salesforce_Org__r.OrgId__c.subString(0,15);
                scust.CHANNEL_ORDERS__Customer_Street__c = order.Account.BillingStreet;
                scust.CHANNEL_ORDERS__Customer_City__c = order.Account.BillingCity;
                scust.CHANNEL_ORDERS__Customer_State__c = order.Account.BillingState;
                scust.CHANNEL_ORDERS__Customer_ZIP_Postal_Code__c = order.Account.BillingPostalCode;
                scust.CHANNEL_ORDERS__Customer_Country__c = order.Account.BillingCountry;
                insert scust;
            }
            
            so.Order__c = order.Id;
            so.CHANNEL_ORDERS__Created_with_new_COA__c = true;
            so.CHANNEL_ORDERS__Customer_Org_ID__c = order.Custom_Salesforce_Org__r.OrgId__c.subString(0,15);
            so.CHANNEL_ORDERS__Customer__c = scust.Id;
            so.CHANNEL_ORDERS__Date_Partner_Received_Customer_Order__c = system.today();
            so.CHANNEL_ORDERS__I_certify__c = 'Yes';
            so.CHANNEL_ORDERS__Order_Type__c = 'Initial';
            so.CHANNEL_ORDERS__X62Org_To_Partner_Org_Email__c = 'sfdc_service_order@e-au107j40bklzxpq53bhqlwngucqhsgvrgw8f8jiu62hpfrt2c.b-yn5reaw.eu2.apex.salesforce.com';
            so.CHANNEL_ORDERS__Override_Level__c = 'Order';
            so.CHANNEL_ORDERS__Related_Opportunity__c = order.OpportunityId;
            so.CHANNEL_ORDERS__Service_Start_Date__c = (order.EffectiveDate>=system.today())?order.EffectiveDate:system.today().addMonths(1).toStartOfMonth();
	        so.CHANNEL_ORDERS__Partner_Contract_Rules__c = [select Id from CHANNEL_ORDERS__Partner_Contract_Terms__c limit 1].Id;
            System.debug('#######@'+ [select Id from CHANNEL_ORDERS__Partner_Contract_Terms__c limit 1]);
            
            for(OrderItem oi : ois){
                double cma = getConvertedAmount(oi.CurrencyIsoCode, double.valueOf(oi.SBQQ__UnproratedNetPrice__c));
                system.debug('### Contract line items '+cma );
                wois.add(new OIWrapper(oi, cma));
                solis.add(new CHANNEL_ORDERS__Service_Order_Detail__c(
					CurrencyIsoCode='EUR',
                    CHANNEL_ORDERS__pct_Currency__c='EUR',
                    CHANNEL_ORDERS__Application__c='Copado Deployer',
                    CHANNEL_ORDERS__Customer_Price_Per_Month__c=Decimal.valueOf(cma).setscale(2, System.RoundingMode.DOWN),
                    CHANNEL_ORDERS__Product_Name__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__c,
                    CHANNEL_ORDERS__Quantity__c=oi.Quantity,
                    CHANNEL_ORDERS__Product_Line_Description__c=order.Opportunity.Name,
                    CHANNEL_ORDERS__pc_Billing_Frequency__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Billing_Frequency__c,
                    CHANNEL_ORDERS__pc_Cancellation_Terms__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Cancellation_Terms__c,
                    CHANNEL_ORDERS__pc_Contract_Auto_Renew__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Contract_Auto_Renew__c,
                    CHANNEL_ORDERS__pc_Contract_Length__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Contract_Length__c,
                    CHANNEL_ORDERS__pc_Custom_Unit__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Custom_Unit__c,
                    CHANNEL_ORDERS__pc_Fixed_Price__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Fixed_Price__c,
                    CHANNEL_ORDERS__pc_Floor_Price__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Floor_Price__c,
                    CHANNEL_ORDERS__pc_Partner_Contract_Term__c=so.CHANNEL_ORDERS__Partner_Contract_Rules__c,
                    CHANNEL_ORDERS__pc_PNR__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__PNR__c,
                    CHANNEL_ORDERS__pc_Pricing_Type__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Pricing_Type__c,
                    CHANNEL_ORDERS__pc_Product_ID__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Product_ID__c,
                    CHANNEL_ORDERS__pc_Renewal_Terms__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Renewal_Terms__c,
                    CHANNEL_ORDERS__pc_Pricing_Unit__c=oi.PricebookEntry.Product2.Partner_Product_Catalog__r.CHANNEL_ORDERS__Pricing_Unit__c
                ));
            }
        }
        catch(Exception e){
            System.debug('#### Exception message: ' + e.getMessage()+' '+e.getLineNumber()+' '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()+' '+e.getLineNumber()+' '+e.getStackTraceString()));
        }
        return null;
    }
    public List<CurrencyType> getCurrencyRates(){
        if(Test.isRunningTest()){
            List<CurrencyType> cts = new List<CurrencyType>();
            cts.add(new CurrencyType(IsoCode='EUR', ConversionRate=1.00, DecimalPlaces=2, IsActive=true, IsCorporate=true));
            cts.add(new CurrencyType(IsoCode='GBP', ConversionRate=0.85, DecimalPlaces=2, IsActive=true, IsCorporate=false));
            return cts;
        }
        else{
            return [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate FROM CurrencyType];
        }
    }
    public Double getConvertedAmount(String curr, Double amount){
        if(rates==null || rates.isEmpty() || !rates.keySet().contains(curr))return amount;
        return amount / rates.get(curr);
    }
    public PageReference createOrder(){
        System.debug('#### Create Order');
        Savepoint sp = Database.setSavepoint();
        try{
            System.debug('aaaaa');
            insert so;
            System.debug('bbbbb');
            for(CHANNEL_ORDERS__Service_Order_Detail__c soli : solis){
                soli.CHANNEL_ORDERS__Partner_Order__c=so.Id;
            }
            insert solis;
            System.debug('ccccc');
	        return new PageReference('/'+so.Id);
        }
        catch(Exception e){
            Database.rollback(sp);
            System.debug('#### Exception message: '+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ''+e.getMessage()));
            return null;
        }
    }
}