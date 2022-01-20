public class OrderTriggerHelper {
    
    public static Map<String, double> rates = new Map<String, double>();
    public static Map<Id, Decimal> accountValueMap = new Map<Id, Decimal>();
    public static Map<Id, Contract> contractMap = new Map<Id, Contract>();
    public static Map<Id, Product2> productMap = new Map<Id, Product2>();
    public static Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();
    public static Map<Id, List<OrderItem>> orderItemMap = new Map<Id, List<OrderItem>>();
    public static Map<Id, List<OrderItem>> contractItemsMap = new Map<Id, List<OrderItem>>();
    public static Map<Id, PricebookEntry> pricebookEntryMap = new Map<Id, PricebookEntry>();
    //public static Map<Id, Id> account2matrix = new Map<Id, Id>();
    
    public static List<Order> renewalOppsToCreate = new List<Order>();
    public static List<Order> renewalOppsToUpdate = new List<Order>();
    public static Map<Id,Contract> contractsToUpdate = new Map<Id,Contract>();
    
    public static Set<Id> renewalOppIds = new Set<Id>();
    
    public static boolean inTrigger = false;
    
    public static void prepareData(List<SObject> records){
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> contractIdSet = new Set<Id>();
        contractsToUpdate = new Map<Id,Contract>();
        for(SObject so : records){
            Order o = (Order)so;
            orderItemMap.put(o.Id, new List<OrderItem>());
            orderIdSet.add(o.Id);
            contractIdSet.add(o.ContractId);
            contractItemsMap.put(o.ContractId, new List<OrderItem>());
        }
        for(CurrencyType ct : getCurrencyRates()){
            rates.put(ct.IsoCode, ct.ConversionRate);
        }
        
        contractMap = new Map<Id, Contract>([select Id, AccountId, Account.Name, EndDate, Renewal_Opportunity__c, ContractTerm from Contract where Id IN :contractIdSet]);
        productMap = new Map<Id, Product2>([select Id, RevenueScheduleType, RevenueInstallmentPeriod from Product2 where IsActive=true]);
        
        for(OrderItem oi : [select Id, PricebookEntryId, OrderId, Quantity, CurrencyIsoCode, UnitPrice, Order.AccountId, Order.Contract.Renewal_Opportunity__c from OrderItem where OrderId IN:orderIdSet]){
            opportunityMap.put(oi.Order.Contract.Renewal_Opportunity__c, new Opportunity());
            accountValueMap.put(oi.Order.AccountId,0.0);
            List<OrderItem> ois = orderItemMap.get(oi.OrderId);
            ois.add(oi);
            orderItemMap.put(oi.OrderId, ois);
        }
        system.debug('@@@@ '+orderItemMap);
        
        opportunityMap = new Map<Id, Opportunity>([select Id, Amount, CurrencyIsoCode, Type from Opportunity where Id IN :opportunityMap.keySet()]);
        
        for(OrderItem oi : [select Id, PricebookEntryId, PricebookEntry.UnitPrice, PricebookEntry.Product2Id, OrderId, Order.ContractId, Quantity, CurrencyIsoCode, UnitPrice from OrderItem where Order.ContractId IN:contractIdSet]){
            pricebookEntryMap.put(oi.PricebookEntryId, new PricebookEntry(UnitPrice=oi.PricebookEntry.UnitPrice, Product2Id=oi.PricebookEntry.Product2Id));
            List<OrderItem> ois = contractItemsMap.get(oi.Order.ContractId);
            ois.add(oi);
            contractItemsMap.put(oi.Order.ContractId, ois);
        }
    }
    private static List<CurrencyType> getCurrencyRates(){
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
    private static Decimal getConvertedAmount(String curr, Decimal amount){
        if(rates==null || rates.isEmpty() || !rates.keySet().contains(curr))return amount;
        return amount / rates.get(curr);
    }
    
    private static void calculateAccountOrderValue(){
        List<Order> orders = [select Id, AccountId, CurrencyIsoCode, TotalAmount from Order where Status='Provisioned' and AccountId IN :accountValueMap.keySet()];
        for(Order o : orders){
            accountValueMap.put(o.AccountId, 0.0);
        }
        for(Order o : orders){
            Decimal amount = accountValueMap.get(o.AccountId);
            System.debug('current account value: ' + o.Id + ' ' + amount);
            amount = amount + getConvertedAmount(o.CurrencyIsoCode, o.TotalAmount);
            System.debug('new account value: ' + o.AccountId + ' ' + amount);
            accountValueMap.put(o.AccountId, amount);
        }
    }
    public static void updateAccountsWithOrderValue(){
        calculateAccountOrderValue();
        List<Account> accounts = new List<Account>();
        if(accountValueMap!=null){
            for(Id i : accountValueMap.keySet()){
                accounts.add(new Account(Id=i, Total_Account_Value_EUR__c=accountValueMap.get(i)));
            }
        }
        update accounts;
    }
}