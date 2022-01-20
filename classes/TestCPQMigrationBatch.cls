/**
 * Created by kheidt on 26/01/2018.
 */

@IsTest
private class TestCPQMigrationBatch {/*
    private static Account account;
    private static List<Account> accounts = new List<Account>();
    private static Opportunity oppty;
    private static List<Opportunity> opportunities = new List<Opportunity>();
    private static Contract contract;
    private static List<Contract> contracts = new List<Contract>();
    private static List<Product2> products = new List<Product2>();
    private static List<PricebookEntry> pbes = new List<PricebookEntry>();
    private static SBQQ__DiscountSchedule__c allProductSchedule;
    private static SBQQ__DiscountSchedule__c customerSchedule;
    private static List<SBQQ__DiscountTier__c> allProductTiers = new List<SBQQ__DiscountTier__c>();
    private static List<SBQQ__DiscountTier__c> customerProductTiers = new List<SBQQ__DiscountTier__c>();
    private static Order order;
    private static List<Order> orders = new List<Order>();
    private static List<OrderItem> orderItems = new List<OrderItem>();
    private static List<Asset> assets = new List<Asset>();
    private static List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();

    private static void setUp(){

        accounts = TestDataFactory.createAccounts(
                new List<String>{'UnitTest 1','Batch Test'},
                new List<String>{'EUR', 'USD'}
        );
        insert accounts;

        List<Id> accountIds = new List<Id>{accounts[0].Id, accounts[1].Id};
        List<String> currencies = new List<String>{accounts[0].CurrencyIsoCode, accounts[1].CurrencyIsoCode};

        contracts = TestDataFactory.createDraftContracts(accountIds, currencies);
        insert contracts;

        opportunities = TestDataFactory.createOpportunities(accounts);
        insert opportunities;

        //to activate the contract, only the status field might be modified
        Set<Id> contractIDs = new Set<Id>();
        for(Contract c:contracts){
            c.Status = 'Activated';
            contractIDs.add(c.Id);
        }
        update contracts;

        //to get the number field, it must be queried. Yeah.
        contracts = [
                SELECT Id, Name, ContractNumber, AccountId,CurrencyIsoCode, Status, StartDate, EndDate, ContractTerm, Account.Industry
                FROM Contract
                WHERE Id IN :contractIDs
        ];

        System.Debug('contracts = ' + contracts);

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
        Product2 prod1 = testMethodUtilities.createProduct('Enterprise', 100.00,'EE');
        prod1 = TestDataFactory.addStandardCPQItems(prod1,'Licenses',allProductSchedule.Id);
        prod1 = TestDataFactory.addLicenseCPQItems(prod1);
        update prod1;
        products.add(prod1);

        //create customer priced Product
        Product2 prod2 = testMethodUtilities.createProduct('Branch Management', 4000, 'CBM');
        prod2 = TestDataFactory.addStandardCPQItems(prod2,'Licenses',customerSchedule.Id);
        prod2 = TestDataFactory.addLicenseCPQItems(prod2);
        update prod2;
        products.add(prod2);

        //create premier support product
        Product2 prem1 = testMethodUtilities.createProduct('Premier Support', 100,'PSup');
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

        //link customer & discountSchedule & Product for one of the contracts
        SBQQ__ContractedPrice__c cp = TestDataFactory.createContractedPrice(accounts[1].Id,prod2.Id,customerSchedule.Id, contracts[1].StartDate, contracts[1].EndDate);
        insert cp;

        //that one inserts as part of the test data creation
        Pricebook2 pb = testMethodUtilities.createCustomPricebook('Subscriptions', true, 'EUR');

        //create euro pricebook entries
        pbes = TestDataFactory.createPricebookEntries(
                pb,
                products,
                new List<String>{'EUR','EUR','EUR'},
                new List<Decimal>{300,150,50}
        );
        //create dollar pricebook entries
        pbes.addAll(
                TestDataFactory.createPricebookEntries(
                        pb,
                        products,
                        new List<String>{'USD','USD','USD'},
                        new List<Decimal>{330,165,60}
                )
        );
        upsert pbes;

        orders = TestDataFactory.createOrders(contracts, pb);
        insert orders;

        for(Order o : orders){

            //get all pbe's applicable for this order. It's thought to be one order in USD and another in EUR
            List<PricebookEntry> orderEntries = new List<PricebookEntry>();
            List<Decimal> productPrices = new List<Decimal>();
            for(PricebookEntry pbe : pbes){
                if(pbe.CurrencyIsoCode == o.CurrencyIsoCode){
                    orderEntries.add(pbe);
                    productPrices.add(pbe.UnitPrice);
                }
            }
            orderItems.addAll(TestDataFactory.createOrderItems(
                    o.Id,
                    orderEntries,
                    new List<Decimal>{15,6,1},
                    productPrices
            ));
        }
        insert orderItems;

        //requery, due to sfdc data handling in test context
        orderItems = [
                SELECT Id, Product2.Name, Product2.SBQQ__PricingMethod__c, Product2.Family, Product2Id, Quantity, ListPrice, UnitPrice, Recurring_Monthly_Price__c, TotalPrice, Order.EffectiveDate, Order.EndDate, Order.AccountId, Order.ContractId
                FROM OrderItem
                ORDER BY OrderItemNumber ASC
        ];

        //update order status
        for (Order o : orders) {
            o.Status = 'Provisioned';
        }
        update orders;

        System.debug('os: ' + orders);
        System.debug('ois: ' + orderItems);

        assets = TestDataFactory.createAssets(orderItems);
        System.debug('assets: ' + assets);
        insert assets;

    }

    static testMethod void testBatchConvertToCPQ() {
        setUp();

        Test.startTest();
        CPQMigrationBatch cmb = new CPQMigrationBatch();
        Database.executeBatch(cmb);

        Test.stopTest();

        //query results for assertions
        List<SBQQ__Subscription__c> createdSubs = [SELECT Id, SBQQ__Account__r.Name, SBQQ__Contract__r.ContractNumber, SBQQ__Product__r.Name, CurrencyIsoCode, SBQQ__ProrateMultiplier__c, SBQQ__Quantity__c, SBQQ__ListPrice__c, SBQQ__SpecialPrice__c, SBQQ__RenewalPrice__c, SBQQ__NetPrice__c FROM SBQQ__Subscription__c];
        List<Asset> remainingAssets = [SELECT Id FROM Asset];

        //see all data is false, so only access to test data
        System.assertEquals(0, remainingAssets.size());

        //list of subscriptions = list of order items
        System.assertEquals(orderItems.size(), createdSubs.size());

        for(SBQQ__Subscription__c s : createdSubs){
            System.debug('created subscription: ' + s);
        }
    }

    static testMethod void testBatchConvertToCPQTest() {
        setUp();

        Test.startTest();
        CPQMigrationBatch cmb = new CPQMigrationBatch(true);
        Database.executeBatch(cmb);

        Test.stopTest();

        //query results for assertions
        List<SBQQ__Subscription__c> createdSubs = [SELECT Id, SBQQ__Account__r.Name, SBQQ__Contract__r.ContractNumber, SBQQ__Product__r.Name, CurrencyIsoCode, SBQQ__ProrateMultiplier__c, SBQQ__Quantity__c, SBQQ__ListPrice__c, SBQQ__SpecialPrice__c, SBQQ__RenewalPrice__c, SBQQ__NetPrice__c FROM SBQQ__Subscription__c];
        List<Asset> remainingAssets = [SELECT Id FROM Asset];

        //see all data is false, so only access to test data
        System.assertEquals(assets.size(), remainingAssets.size());

        //list of subscriptions = list of order items
        System.assertEquals(0, createdSubs.size());
    }
*/}