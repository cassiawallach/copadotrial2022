public class CPQMigrationHelper {

    public Set<Id> productIDs = new Set<Id>();
    public Map<Id, Id> scheduleProductMap = new Map<Id, Id>();
    public Map<Id, PricebookEntry> productPricebookEntryMap = new Map<Id, PricebookEntry>();
    public Map<String, SBQQ__ContractedPrice__c> accountDiscounts = new Map<String, SBQQ__ContractedPrice__c>();
    public Map<String, Map<String,SBQQ__DiscountTier__c>> generalProductDiscounts = new Map<String, Map<String, SBQQ__DiscountTier__c>>();
    public Map<Id, Order> orderMap = new Map<Id, Order>();
    public Map<Id, List<OrderItem>> orderItemMap = new Map<Id, List<OrderItem>>();
    public Contract contract {get;set;}

    public void CPQMigrationHelper(){}

    public void getContract(String contractNumber){
        contract = [
                SELECT Id, AccountId, StartDate, EndDate, CurrencyIsoCode, Account.Industry
                FROM Contract where Status = 'Activated'
                AND ContractNumber=:contractNumber
                limit 1
        ];
        if(contract.CurrencyIsoCode == 'GBP') contract.CurrencyIsoCode = 'EUR';
    }

    public void createPricebookEntryMap(){
        List<PriceBookEntry> pbes = [
                SELECT Id, Name, Pricebook2Id, Product2Id, Product2.SBQQ__DiscountSchedule__c, CurrencyIsoCode, UnitPrice, UseStandardPrice
                FROM PricebookEntry
                where IsActive=true
                and (UseStandardPrice=true OR Name = 'Premier Support')
                and CurrencyIsoCode= :contract.CurrencyIsoCode
        ];

        for(PricebookEntry pbe : pbes){
            if(pbe.Product2.SBQQ__DiscountSchedule__c != null) {
                scheduleProductMap.put(pbe.Product2Id, pbe.Product2.SBQQ__DiscountSchedule__c);
            }
            productIDs.add(pbe.Product2Id);
            productPricebookEntryMap.put(pbe.Product2Id, pbe);
        }
    }

    public void createAccountDiscountsMap(){
        accountDiscounts = new Map<String, SBQQ__ContractedPrice__c>();
        List<SBQQ__ContractedPrice__c> cpList = [
                SELECT Id, Name, SBQQ__Account__c,SBQQ__Contract__c, SBQQ__EffectiveDate__c, SBQQ__ExpirationDate__c, SBQQ__Price__c, SBQQ__Product__c, SBQQ__DiscountSchedule__c
                FROM SBQQ__ContractedPrice__c
        ];

        for(SBQQ__ContractedPrice__c cp : cpList){
            accountDiscounts.put(cp.SBQQ__Account__c + '_' + cp.SBQQ__Product__c, cp);
        }
    }

    public void createProductDiscountsMap(){
        List<SBQQ__DiscountTier__c> productTiers = [
                SELECT Id,Name, SBQQ__Discount__c,SBQQ__LowerBound__c, SBQQ__UpperBound__c, SBQQ__Schedule__c
                FROM SBQQ__DiscountTier__c
        ];

        generalProductDiscounts = new Map<String, Map<String, SBQQ__DiscountTier__c>>();
        for(SBQQ__DiscountTier__c dt : productTiers){
            if(generalProductDiscounts.get(dt.SBQQ__Schedule__c)== null){
                generalProductDiscounts.put(dt.SBQQ__Schedule__c, new Map<String, SBQQ__DiscountTier__c>());
            }
            generalProductDiscounts.get(dt.SBQQ__Schedule__c).put(dt.Name, dt);
        }
    }

    public void createOrderMap(){
        List<Order> orders = [
                SELECT Id,Name, EndDate, EffectiveDate,Pricebook2Id, AccountId, ContractId
                FROM Order
                WHERE ContractId = : contract.Id
                ORDER BY EffectiveDate ASC
        ];

        orderMap = new Map<Id, Order>();
        for(Order o : orders){
            orderMap.put(o.Id, o);
        }
        System.debug('Order: ' + orderMap);
    }

    public void createOrderItemMap(){
        List<OrderItem> orderItems = [
                select
                        Id,Product2.Name, Product2Id, Product2.SBQQ__PricingMethod__c, Product2.Family,
                        Quantity, ListPrice, UnitPrice,Recurring_Monthly_Price__c, TotalPrice, Order.EffectiveDate,
                        Order.EndDate, Order.AccountId, Order.ContractId, CurrencyIsoCode
                from OrderItem
                where OrderId IN :orderMap.keySet() AND
                (Product2.Family != 'Services' AND Product2.Name != 'Agile Delivery')
                ORDER BY OrderItemNumber ASC
        ];

        orderItemMap = new Map<Id, List<OrderItem>>();
        for(OrderItem oi : orderItems){
            if(orderItemMap.get(oi.OrderId) == null){
                orderItemMap.put(oi.OrderId, new List<OrderItem>());
            }
            orderItemMap.get(oi.OrderId).add(oi);
        }
        System.debug('OrderItems: ' + orderItems);
    }

    public static SBQQ__Subscription__c setSubscriptionAmounts(SBQQ__Subscription__c sub){
        system.debug('Incoming sub >>> '+sub);

        Decimal prorate = calculateProRate(sub.SBQQ__SubscriptionStartDate__c, sub.SBQQ__SubscriptionEndDate__c);
        system.debug('prorate calculated >>> '+prorate+'  '+sub.SBQQ__SpecialPrice__c);
        Decimal proratedPriceNoDiscount = sub.SBQQ__SpecialPrice__c * prorate;
        Decimal proratedPriceWithDiscount = sub.SBQQ__RenewalPrice__c * prorate;

        System.debug('proratedPriceNoDiscount: ' + proratedPriceNoDiscount);
        System.debug('proratedPriceWithDiscount: ' + proratedPriceWithDiscount);

        //fill in fields
        sub.SBQQ__ProrateMultiplier__c = prorate;
        sub.SBQQ__ListPrice__c = proratedPriceNoDiscount;
        sub.SBQQ__CustomerPrice__c = proratedPriceWithDiscount;
        sub.SBQQ__RegularPrice__c = proratedPriceWithDiscount;
        sub.SBQQ__NetPrice__c = proratedPriceWithDiscount;
        return sub;
    }

    public Decimal getDiscount(Id dsId, Decimal quantity){
        Decimal discount = 0;
        Map<String, SBQQ__DiscountTier__c> tiersMap = this.generalProductDiscounts.get(dsID);
        for (String tn : tiersMap.keySet()) {
            SBQQ__DiscountTier__c dt = tiersMap.get(tn);
            if (quantity >= dt.SBQQ__LowerBound__c && quantity < dt.SBQQ__UpperBound__c) {
                discount = dt.SBQQ__Discount__c;
            }
        }
        return discount;
    }

    public Id getDiscountSchedule(Id acctId, Id prodId){
        Id disId;
        if (this.accountDiscounts.keySet().contains(acctId + '_' + prodId)) {
            disId = this.accountDiscounts.get(acctId + '_' + prodId).SBQQ__DiscountSchedule__c;
        }
        else {
            disId = this.scheduleProductMap.get(prodId);
        }
        return disId;
    }

    public SBQQ__Subscription__c setSubscriptionInfo(OrderItem oi){
        SBQQ__Subscription__c s = new SBQQ__Subscription__c();
        s.SBQQ__Account__c = this.contract.AccountId;
        s.SBQQ__Contract__c = this.contract.Id;
        s.SBQQ__Product__c = oi.Product2Id;
        s.CurrencyIsoCode = this.contract.CurrencyIsoCode;
        s.SBQQ__Quantity__c = oi.Quantity;
        s.SBQQ__RenewalQuantity__c = oi.Quantity;
        s.SBQQ__PricingMethod__c = oi.Product2.SBQQ__PricingMethod__c;
        s.SBQQ__SubscriptionStartDate__c = oi.Order.EffectiveDate;
        s.SBQQ__SubscriptionEndDate__c = oi.Order.EndDate;
        return s;
    }

    /**
     * TODO: expired assets are taken into account for add ons by cpq. this is a bug. we might need to change this query.
     */
    public List<Asset> getAssets(){
        return [ SELECT Id,AccountId,Quantity,ParentId,Product2Id,Product2.Name,Status,PurchaseDate,UsageEndDate
                FROM Asset
                WHERE AccountId = :this.contract.accountId
                AND PurchaseDate>=:this.contract.StartDate
                and UsageEndDate=:this.contract.EndDate
                AND Status = 'Active'
                AND Product2.Family != 'Services'
        ];
    }

    public static Decimal calculateProRate(Date startDate, Date endDate){
        system.debug('### Entering CPQMigrationHelper.calculateProRate: StartDate='+startDate+' EndDate='+endDate);
        Integer fullMonths = calculateFullMonths(startDate, endDate);
        Integer daysLeft = calculateRemainingDays(startDate.addMonths(fullMonths), endDate);
        Decimal remainder = calculcateRemainingDecimal(daysLeft);
        return fullMonths + remainder;
    }

    public static Integer calculateFullMonths(Date startDate, Date endDate){
        system.debug('### Entering CPQMigrationHelper.calculateFullMonths: StartDate='+startDate+' EndDate='+endDate);
        Decimal result = startDate.monthsBetween(endDate);
        system.debug('### MonthsBetween result: '+result);
        if(startDate.day()>endDate.day() && (startDate.day()-endDate.day())>1)result--;
        if(startDate.day()==1 && endDate.day()== Date.daysInMonth(endDate.year(), endDate.month()))result++;
        system.debug('FULL MONTHS: '+startDate+' - '+endDate+' == '+result);
        return Integer.valueOf(Math.floor(result));
    }

    public static Integer calculateRemainingDays(Date startDate, Date endDate){
        Integer result = startDate.daysBetween(endDate)+1;
        return result;
    }

    public static Decimal calculcateRemainingDecimal(Integer daysLeft){
        Decimal result = Decimal.valueOf(daysLeft);
        result = result.divide(30.416666666666666666666666666667, 4);
        return result;
    }
}