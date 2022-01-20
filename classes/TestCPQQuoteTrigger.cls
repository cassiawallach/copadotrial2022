@isTest
private class TestCPQQuoteTrigger {
    

     static testMethod void testdeleteSchedules(){
        CPQQuoteTriggerHelper.deleteSchedules();
    } 
    static testMethod void testACVTCV() {
        SBQQ__Quote__c quote = [SELECT Id, Name, SBQQ__Opportunity2__c, SBQQ__Opportunity2__r.Id, Number_of_Months__c, (SELECT Id, SBQQ__ProductFamily__c, SBQQ__ProrateMultiplier__c, SBQQ__ListPrice__c, SBQQ__ListTotal__c from SBQQ__LineItems__r ) from SBQQ__Quote__c limit 1];

        test.startTest();
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();

        System.debug('Products');
        System.debug([SELECT Id, Name, Family FROM Product2]);
        for(Product2 p : [SELECT Id, Name, Family FROM Product2 WHERE Family != 'Services']) {
            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quote.Id, SBQQ__Product__c = p.Id, SBQQ__Quantity__c = 1.0 );
            if (p.Family == 'Premier Support') {
                ql.SBQQ__DefaultSubscriptionTerm__c = 12;
                ql.SBQQ__ProrateMultiplier__c = 2;
            }
            else {
                ql.SBQQ__DefaultSubscriptionTerm__c = 1;
                ql.SBQQ__ProrateMultiplier__c = 24;                
            }
            quoteLines.add(ql);
        }
        insert quoteLines;

        Opportunity currentOpportunity = [SELECT Id, Main_Problems__c FROM Opportunity WHERE Id = :quote.SBQQ__Opportunity2__r.Id ];
        currentOpportunity.Main_Problems__c = 'The problem is Houston';
        update currentOpportunity;

        quote.SBQQ__Primary__c = true;
        update quote;

        Test.stopTest();
        System.debug('quote');
        Decimal dTotalTCV = 0;
        Decimal dTotalACV = 0;
        for(SBQQ__Quote__c qtCheck : [SELECT Id, Name, SBQQ__Opportunity2__c, Number_of_Months__c, (SELECT Id, SBQQ__ProductFamily__c, SBQQ__ListTotal__c, SBQQ__PackageTotal__c, SBQQ__DefaultSubscriptionTerm__c, SBQQ__ProrateMultiplier__c FROM SBQQ__LineItems__r ) FROM SBQQ__Quote__c])
        {
            for(SBQQ__QuoteLine__c ql : qtCheck.SBQQ__LineItems__r) {
                dTotalTCV += ql.SBQQ__PackageTotal__c;
                if ((ql.SBQQ__DefaultSubscriptionTerm__c * ql.SBQQ__ProrateMultiplier__c) < 12) {
                    dTotalACV += ql.SBQQ__PackageTotal__c;
                }
                else {
                    dTotalACV += ql.SBQQ__PackageTotal__c * (12 / (ql.SBQQ__DefaultSubscriptionTerm__c * ql.SBQQ__ProrateMultiplier__c));
                }
            }
        }
        //update quote;
        Opportunity opp = [SELECT Id, Name, TCV__c, ACV__c FROM Opportunity WHERE Id = :quote.SBQQ__Opportunity2__c];
        System.debug(opp);
        System.assertNotEquals(1, opp.TCV__c);
        System.assertNotEquals(1, opp.ACV__c);

        delete quote;
        undelete quote;
    }
    static testMethod void testACVTCV12Months() {
        SBQQ__Quote__c quote = [SELECT Id, Name, SBQQ__Opportunity2__c, SBQQ__Opportunity2__r.CloseDate, Number_of_Months__c, (SELECT Id, SBQQ__ProductFamily__c, SBQQ__ProrateMultiplier__c, SBQQ__ListPrice__c, SBQQ__ListTotal__c, SBQQ__CustomerPrice__c from SBQQ__LineItems__r ) from SBQQ__Quote__c limit 1];

        Test.startTest();

        quote.SBQQ__EndDate__c = quote.SBQQ__Opportunity2__r.CloseDate.addMonths(2);
        update quote;

        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        
        for(Product2 p : [SELECT Id, Name, Family FROM Product2 WHERE Family != 'Services']) {
            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quote.Id, SBQQ__Product__c = p.Id, SBQQ__Quantity__c = 1.0 );
            if (p.Family == 'Premier Support') {
                ql.SBQQ__DefaultSubscriptionTerm__c = 12;
                ql.SBQQ__ProrateMultiplier__c = 2;
                ql.SBQQ__CustomerPrice__c = 10;
            }
            else {
                ql.SBQQ__DefaultSubscriptionTerm__c = 1;
                ql.SBQQ__ProrateMultiplier__c = 24;
                ql.SBQQ__CustomerPrice__c = 10;            
            }
            quoteLines.add(ql);
        }
        insert quoteLines;

        quote.SBQQ__Primary__c = true;
        update quote;

        Test.stopTest();
        System.debug('quote');
        Decimal dTotalTCV = 0;
        Decimal dTotalACV = 0;
        Decimal dTotalMRR = 0;
        for (SBQQ__Quote__c qtCheck : [SELECT Id, Name, SBQQ__Opportunity2__c, Number_of_Months__c, (SELECT Id, SBQQ__ProductFamily__c, SBQQ__ListTotal__c, SBQQ__PackageTotal__c, SBQQ__DefaultSubscriptionTerm__c, SBQQ__ProrateMultiplier__c, SBQQ__CustomerPrice__c FROM SBQQ__LineItems__r ) FROM SBQQ__Quote__c])
        {
            for (SBQQ__QuoteLine__c ql : qtCheck.SBQQ__LineItems__r) {
                dTotalTCV += ql.SBQQ__PackageTotal__c;
                dTotalMRR += (ql.SBQQ__CustomerPrice__c/qtCheck.Number_of_Months__c);
                if ((ql.SBQQ__DefaultSubscriptionTerm__c * ql.SBQQ__ProrateMultiplier__c) < 12) {
                    dTotalACV += ql.SBQQ__PackageTotal__c;
                }
                else {
                    dTotalACV += ql.SBQQ__PackageTotal__c * (12 / (ql.SBQQ__DefaultSubscriptionTerm__c * ql.SBQQ__ProrateMultiplier__c));
                }
            }
        }
        
        //update quote;
        Opportunity opp = [SELECT Id, Name, TCV__c, ACV__c, MRR__c FROM Opportunity WHERE Id = :quote.SBQQ__Opportunity2__c];
        System.debug(opp);
        System.assertNotEquals(1, opp.TCV__c);
        System.assertNotEquals(1, opp.ACV__c);
        System.assertNotEquals(1, opp.MRR__c);

        delete quote;
        undelete quote;
    }
    
    @testSetup static void setup() {
        Account account;
        Opportunity oppty;
        Contract contract;
        List<Product2> products = new List<Product2>();
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        SBQQ__DiscountSchedule__c allProductSchedule;
        SBQQ__DiscountSchedule__c customerSchedule;
        List<SBQQ__DiscountTier__c> allProductTiers = new List<SBQQ__DiscountTier__c>();
        List<SBQQ__DiscountTier__c> customerProductTiers = new List<SBQQ__DiscountTier__c>();
        Order order;
        List<Order> orders = new List<Order>();
        List<OrderItem> orderItems = new List<OrderItem>();
        List<Asset> assets = new List<Asset>();
        List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
        SBQQ__Quote__c quote;
        
        account = TestDataFactory.createAccount('UnitTest', 'EUR');
        insert account;

        Contact ctc = TestDataFactory.createContact(account.Id, 'OfTest');
        insert ctc;

        oppty = TestDataFactory.createOpportunity(account, ' 1EE', 'New Customer');
        insert oppty;
        
        Pricebook2 pb = TestDataFactory.createPricebook(); 
        pb.CurrencyIsoCode = 'EUR';
        insert pb;     
        
        kugo2p__KugamonSetting__c testKugamonSetting = TestDataFactory.createKugamonSetting(pb.name);
        insert testKugamonSetting ;
        contract = TestDataFactory.createDraftContract(account.Id, account.CurrencyIsoCode);
        insert contract;
        //to activate the contract, only the status field might be modified
        contract.Status = 'Activated';
        update contract;
        //to get the number field, it must be queried. Yeah.
        contract = [
                SELECT Id, Name, ContractNumber, AccountId,CurrencyIsoCode, Status, StartDate, EndDate, ContractTerm, Account.Industry
                FROM Contract
                WHERE Id = :contract.Id
        ];

        allProductSchedule = TestDataFactory.createDiscountSchedule('allProducts');
        insert allProductSchedule;

        allProductTiers = TestDataFactory.createStandardTiersAll(allProductSchedule.Id);
        insert allProductTiers;

        //add customer discount schedule
        customerSchedule = TestDataFactory.createDiscountSchedule('TestAccount');
        insert customerSchedule;

        //add custom tiers to schedule
        customerProductTiers = TestDataFactory.createDiscountTiers(
                customerSchedule.Id,
                new List<Integer>{1,2,3,4,5,10000},
                new List<Decimal>{0,10,20,50,80}
        );
        insert customerProductTiers;

        //create regular priced product
        Product2 prod1 = TestDataFactory.createProduct('Enterprise', 'Licenses',null);
        prod1.Credits_to_be_assigned__c = 100.00;
        prod1.ProductCode = 'EE';
        insert prod1;      
        prod1 = TestDataFactory.addStandardCPQItems(prod1,'Licenses',allProductSchedule.Id);
        prod1 = TestDataFactory.addLicenseCPQItems(prod1);
        update prod1;
        products.add(prod1);

        //create customer priced Product       
        Product2 prod2 = TestDataFactory.createProduct('Branch Management', 'Licenses',null);
        prod2.Credits_to_be_assigned__c = 4000;
        prod2.ProductCode = 'CBM';
        insert prod2;
        prod2 = TestDataFactory.addStandardCPQItems(prod2,'Licenses',customerSchedule.Id);
        prod2 = TestDataFactory.addLicenseCPQItems(prod2);
        update prod2;
        products.add(prod2);

        //create premier support product     
        Product2 prem1 = TestDataFactory.createProduct('Premier Support', 'Licenses',null);
        prem1.Credits_to_be_assigned__c = 100;
        prem1.ProductCode = 'PSup';
        insert prem1;
        prem1 = TestDataFactory.addStandardCPQItems(prem1,'Premier Support', null);
        prem1.SBQQ__NonDiscountable__c = true;
        prem1.SBQQ__PricingMethod__c = 'Percent Of Total';
        prem1.SBQQ__PriceEditable__c = true;
        prem1.SBQQ__ExcludeFromMaintenance__c = true;
        prem1 = TestDataFactory.addLicenseCPQItems(prem1);
        prem1.Family = 'Premier Support';
        prem1.SBQQ__SubscriptionPricing__c = 'Percent Of Total';
        prem1.SBQQ__SubscriptionTerm__c = 1;
        prem1.SBQQ__SubscriptionBase__c = 'Net';
        prem1.SBQQ__SubscriptionPercent__c = 15.0000;
        prem1.SBQQ__SubscriptionCategory__c = 'Licenses';
        update prem1;
        products.add(prem1);

        //link customer & discountSchedule & Product
        SBQQ__ContractedPrice__c cp = TestDataFactory.createContractedPrice(account.Id,prod2.Id,customerSchedule.Id, contract.StartDate, contract.EndDate);
        insert cp;

        //Pricebook2 pb = testMethodUtilities.createCustomPricebook('Subscriptions', true, 'EUR');

        //cannot use existing PBE method, as it need the whole standard pricebook to get the Id
        // instead of Test.getStandardPricebookId(), and my test run without @seeAllData
        PricebookEntry pbe1 = TestDataFactory.createPricebookEntry(pb.Id,products[0].Id, pb.CurrencyIsoCode, 300);
        PricebookEntry pbe2 = TestDataFactory.createPricebookEntry(pb.Id,products[1].Id, pb.CurrencyIsoCode, 300);
        PricebookEntry pbe3 = TestDataFactory.createPricebookEntry(pb.Id,products[2].Id, pb.CurrencyIsoCode, 1);
        pbes.add(pbe1);
        pbes.add(pbe2);
        pbes.add(pbe3);

        order = TestDataFactory.createOrder(account.Id, contract,pb, contract.StartDate, contract.EndDate );
        order.Status = 'Draft';
        insert order;

        orderItems = TestDataFactory.createOrderItems(order.Id, pbes, new List<Decimal>{15,6,1}, new List<Decimal>{300,150,1500});
        insert orderItems;

        //requery, due to sfdc data handling in test context
        orderItems = [
                SELECT Id, Product2.Name, Product2.SBQQ__PricingMethod__c, Product2.Family, Product2Id, Quantity, ListPrice, UnitPrice, Recurring_Monthly_Price__c, TotalPrice, Order.EffectiveDate, Order.EndDate, Order.AccountId, Order.ContractId
                FROM OrderItem
                ORDER BY OrderItemNumber ASC
        ];

        order.Status = 'Provisioned';
        update order;
        orders.add(order);

        System.debug('ois: ' + orderItems);

        assets = TestDataFactory.createAssets(orderItems);
        System.debug('assets: ' + assets);
        insert assets;

        oppty.Pricebook2Id = pb.Id;
        update oppty;

        quote = TestDataFactory.createCPQQuote(oppty,account,null,null,'Quote',oppty.CloseDate);
        quote.SBQQ__EndDate__c = oppty.CloseDate.addYears(2);
        quote.SBQQ__PricebookId__c = pb.Id;
        insert quote;
    }    
}