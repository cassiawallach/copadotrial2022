@isTest
public class TestCPQMigrationHelper {

    static testMethod void testProRateMultiplier(){
        system.assertEquals(7, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 12, 31), Date.newInstance(2018, 7, 30)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 10, 16), Date.newInstance(2018, 10, 15)));
        system.assertEquals(13, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 12, 1), Date.newInstance(2018, 12, 31)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 12, 29), Date.newInstance(2018, 12, 28)));
        system.assertEquals(1, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 1, 1), Date.newInstance(2018, 1, 31)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 1, 1), Date.newInstance(2018, 12, 31)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 1, 15), Date.newInstance(2019, 1, 14)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 1, 2), Date.newInstance(2019, 1, 1)));
        system.assertEquals(9.3288, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 1, 22), Date.newInstance(2018, 10, 31)));
        system.assertEquals(10, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 2, 1), Date.newInstance(2018, 11, 30)));
        system.assertEquals(11, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 2, 1), Date.newInstance(2018, 12, 31)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 2, 1), Date.newInstance(2019, 1, 31)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 2, 5), Date.newInstance(2019, 2, 4)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 3, 1), Date.newInstance(2019, 2, 28)));
        system.assertEquals(33.9534, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 3, 1), Date.newInstance(2020, 12, 29)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 4, 1), Date.newInstance(2019, 3, 31)));
        system.assertEquals(1.2301, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 12, 25), Date.newInstance(2018, 1, 31)));
        system.assertEquals(12.0329, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 12, 30), Date.newInstance(2018, 12, 30)));
        system.assertEquals(11, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 2, 1), Date.newInstance(2018, 12, 31)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 10, 16), Date.newInstance(2018, 10, 15)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 12, 1), Date.newInstance(2018, 11, 30)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 12, 29), Date.newInstance(2018, 12, 28)));
        system.assertEquals(24, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 2, 1), Date.newInstance(2019, 1, 31)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 1, 1), Date.newInstance(2018, 12, 31)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 1, 15), Date.newInstance(2019, 1, 14)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 1, 2), Date.newInstance(2019, 1, 1)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 2, 1), Date.newInstance(2019, 1, 31)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 2, 16), Date.newInstance(2019, 2, 15)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 2, 23), Date.newInstance(2019, 2, 22)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 2, 5), Date.newInstance(2019, 2, 4)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 3, 1), Date.newInstance(2019, 2, 28)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2019, 1, 1), Date.newInstance(2019, 12, 31)));
        system.assertEquals(12, CPQMigrationHelper.calculateProRate(Date.newInstance(2019, 2, 1), Date.newInstance(2020, 1, 31)));
        system.assertEquals(24, CPQMigrationHelper.calculateProRate(Date.newInstance(2018, 1, 20), Date.newInstance(2020, 1, 19)));
        system.assertEquals(5.0329, CPQMigrationHelper.calculateProRate(Date.newInstance(2017, 12, 14), Date.newInstance(2018, 5, 14)));
    }
    static testMethod void testCalculateFullMonths_roundNumbers(){
        system.assertEquals(0, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 1, 1)));
        system.assertEquals(1, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 2, 1)));
        system.assertEquals(2, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 3, 1)));
        system.assertEquals(3, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 4, 1)));
        system.assertEquals(4, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 5, 1)));
        system.assertEquals(5, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 6, 1)));
        system.assertEquals(6, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 7, 1)));
        system.assertEquals(7, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 8, 1)));
        system.assertEquals(8, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 9, 1)));
        system.assertEquals(9, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 10, 1)));
        system.assertEquals(10, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 11, 1)));
        system.assertEquals(11, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 12, 1)));
        system.assertEquals(12, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2018, 1, 1)));
        system.assertEquals(2, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 2, 28)));
    }
    static testMethod void testCalculateFullMonths_withRemainder(){
        system.assertEquals(1, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 2, 2)));
        system.assertEquals(2, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 3, 3)));
        system.assertEquals(3, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 4, 4)));
        system.assertEquals(4, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 5, 5)));
        system.assertEquals(5, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 6, 6)));
        system.assertEquals(6, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 7, 7)));
        system.assertEquals(7, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 8, 8)));
        system.assertEquals(8, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 9, 9)));
        system.assertEquals(9, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 10, 10)));
        system.assertEquals(0, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 31), Date.newInstance(2017, 2, 1)));
        system.assertEquals(0, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 1, 31), Date.newInstance(2017, 2, 28)));
        system.assertEquals(0, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 2, 20), Date.newInstance(2017, 3, 18)));
        system.assertEquals(0, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 2, 20), Date.newInstance(2017, 3, 17)));
        system.assertEquals(0, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 2, 20), Date.newInstance(2017, 3, 1)));
        system.assertEquals(2, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 2, 20), Date.newInstance(2017, 4, 21)));
        system.assertEquals(3, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 2, 20), Date.newInstance(2017, 5, 20)));
        system.assertEquals(4, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 2, 20), Date.newInstance(2017, 6, 19)));
        system.assertEquals(4, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 2, 20), Date.newInstance(2017, 7, 18)));
        system.assertEquals(4, CPQMigrationHelper.calculateFullMonths(Date.newInstance(2017, 2, 20), Date.newInstance(2017, 7, 17)));
    }
    static testMethod void testCalculateRemainingDays(){
        system.assertEquals(31, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 1, 31)));
        system.assertEquals(28, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 2, 1), Date.newInstance(2017, 2, 28)));
        system.assertEquals(31, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 3, 1), Date.newInstance(2017, 3, 31)));
        system.assertEquals(30, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 4, 1), Date.newInstance(2017, 4, 30)));
        system.assertEquals(31, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 5, 1), Date.newInstance(2017, 5, 31)));
        system.assertEquals(30, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 6, 1), Date.newInstance(2017, 6, 30)));
        system.assertEquals(31, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 7, 1), Date.newInstance(2017, 7, 31)));
        system.assertEquals(31, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 8, 1), Date.newInstance(2017, 8, 31)));
        system.assertEquals(30, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 9, 1), Date.newInstance(2017, 9, 30)));
        system.assertEquals(31, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 10, 1), Date.newInstance(2017, 10, 31)));
        system.assertEquals(30, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 11, 1), Date.newInstance(2017, 11, 30)));
        system.assertEquals(31, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 12, 1), Date.newInstance(2017, 12, 31)));
        system.assertEquals(1, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 1, 1), Date.newInstance(2017, 1, 1)));
        system.assertEquals(2, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 2, 28), Date.newInstance(2017, 3, 1)));
        system.assertEquals(2, CPQMigrationHelper.calculateRemainingDays(Date.newInstance(2017, 12, 31), Date.newInstance(2018, 1, 1)));
    }
    static testMethod void testCalculcateRemainingDecimal(){
        system.assertEquals(0.0329, CPQMigrationHelper.calculcateRemainingDecimal(1));
        system.assertEquals(0.0658, CPQMigrationHelper.calculcateRemainingDecimal(2));
        system.assertEquals(0.0986, CPQMigrationHelper.calculcateRemainingDecimal(3));
        system.assertEquals(0.1315, CPQMigrationHelper.calculcateRemainingDecimal(4));
        system.assertEquals(0.1644, CPQMigrationHelper.calculcateRemainingDecimal(5));
        system.assertEquals(0.1973, CPQMigrationHelper.calculcateRemainingDecimal(6));
        system.assertEquals(0.2301, CPQMigrationHelper.calculcateRemainingDecimal(7));
        system.assertEquals(0.263, CPQMigrationHelper.calculcateRemainingDecimal(8));
        system.assertEquals(0.2959, CPQMigrationHelper.calculcateRemainingDecimal(9));
        system.assertEquals(0.3288, CPQMigrationHelper.calculcateRemainingDecimal(10));
        system.assertEquals(0.3616, CPQMigrationHelper.calculcateRemainingDecimal(11));
        system.assertEquals(0.3945, CPQMigrationHelper.calculcateRemainingDecimal(12));
        system.assertEquals(0.4274, CPQMigrationHelper.calculcateRemainingDecimal(13));
        system.assertEquals(0.4603, CPQMigrationHelper.calculcateRemainingDecimal(14));
        system.assertEquals(0.4932, CPQMigrationHelper.calculcateRemainingDecimal(15));
        system.assertEquals(0.526, CPQMigrationHelper.calculcateRemainingDecimal(16));
        system.assertEquals(0.5589, CPQMigrationHelper.calculcateRemainingDecimal(17));
        system.assertEquals(0.5918, CPQMigrationHelper.calculcateRemainingDecimal(18));
        system.assertEquals(0.6247, CPQMigrationHelper.calculcateRemainingDecimal(19));
        system.assertEquals(0.6575, CPQMigrationHelper.calculcateRemainingDecimal(20));
        system.assertEquals(0.6904, CPQMigrationHelper.calculcateRemainingDecimal(21));
        system.assertEquals(0.7233, CPQMigrationHelper.calculcateRemainingDecimal(22));
        system.assertEquals(0.7562, CPQMigrationHelper.calculcateRemainingDecimal(23));
        system.assertEquals(0.789, CPQMigrationHelper.calculcateRemainingDecimal(24));
        system.assertEquals(0.8219, CPQMigrationHelper.calculcateRemainingDecimal(25));
        system.assertEquals(0.8548, CPQMigrationHelper.calculcateRemainingDecimal(26));
        system.assertEquals(0.8877, CPQMigrationHelper.calculcateRemainingDecimal(27));
        system.assertEquals(0.9205, CPQMigrationHelper.calculcateRemainingDecimal(28));
        system.assertEquals(0.9534, CPQMigrationHelper.calculcateRemainingDecimal(29));
    }

    static testMethod void testRandomDates(){
        System.assertEquals(0.3288, CPQMigrationHelper.calculateProRate(Date.newInstance(2017,2,9),Date.newInstance(2017,2,18)));
        System.assertEquals(12.3288, CPQMigrationHelper.calculateProRate(Date.newInstance(2017,2,9),Date.newInstance(2018,2,18)));
        System.assertEquals(0.4274, CPQMigrationHelper.calculateProRate(Date.newInstance(2017,2,18),Date.newInstance(2017,3,2)));
        System.assertEquals(13.5260, CPQMigrationHelper.calculateProRate(Date.newInstance(2017,2,18),Date.newInstance(2018,4,2)));
        System.assertEquals(0.0658, CPQMigrationHelper.calculateProRate(Date.newInstance(2017,2,18),Date.newInstance(2017,2,19)));
        System.assertEquals(12.0658, CPQMigrationHelper.calculateProRate(Date.newInstance(2017,2,18),Date.newInstance(2018,2,19)));
        System.assertEquals(12.0329, CPQMigrationHelper.calculateProRate(Date.newInstance(2017,2,18),Date.newInstance(2018,2,18)));
        System.assertEquals(0.8548, CPQMigrationHelper.calculateProRate(Date.newInstance(2018,12,18),Date.newInstance(2019,1,12)));
        System.assertEquals(2.7562, CPQMigrationHelper.calculateProRate(Date.newInstance(2018,12,18),Date.newInstance(2019,3,12)));
        System.assertEquals(1.3616, CPQMigrationHelper.calculateProRate(Date.newInstance(2018,12,2),Date.newInstance(2019,1,12)));
        System.assertEquals(12.0000, CPQMigrationHelper.calculateProRate(Date.newInstance(2018,1,1),Date.newInstance(2018,12,31)));
    }

    private static Account account;
    private static Opportunity oppty;
    private static Contract contract;
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
        insert prod1;
        prod1 = TestDataFactory.addStandardCPQItems(prod1,'Licenses',allProductSchedule.Id);
        prod1 = TestDataFactory.addLicenseCPQItems(prod1);
        update prod1;
        products.add(prod1);

        //create customer priced Product
        Product2 prod2 = TestDataFactory.createProduct('Branch Management', 'Licenses',null);
        insert prod2;
        prod2 = TestDataFactory.addStandardCPQItems(prod2,'Licenses',customerSchedule.Id);
        prod2 = TestDataFactory.addLicenseCPQItems(prod2);
        update prod2;
        products.add(prod2);

        //create premier support product
        Product2 prem1 = TestDataFactory.createProduct('Premier Support', 'Licenses',null);
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

    }

    public static testMethod void testGetContract(){
        setUp();

        Test.startTest();
        CPQMigrationHelper cmh = new CPQMigrationHelper();
        cmh.getContract(contract.ContractNumber);
        Contract testContract = cmh.contract;
        Test.stopTest();

        System.assertEquals(contract.Id, testContract.Id);
    }

    public static testMethod void testCreatePricebookEntryMap(){
        setUp();

        CPQMigrationHelper cmh = new CPQMigrationHelper();
        cmh.getContract(contract.ContractNumber);
        Test.startTest();
        cmh.createPricebookEntryMap();
        Test.stopTest();

        Integer p = 0;

        //map is prodId - pbe
        for(Id i : cmh.productPricebookEntryMap.keySet()){
            System.assertEquals(products[p].Id, i);
            System.assertEquals(pbes[p].Id, cmh.productPricebookEntryMap.get(i).Id);
            p++;
        }
    }

    public static testMethod void testCreateProductDiscountsMap(){
        setUp();

        CPQMigrationHelper cmh = new CPQMigrationHelper();
        cmh.getContract(contract.ContractNumber);
        Test.startTest();
        cmh.createProductDiscountsMap();
        Test.stopTest();

        System.assertEquals(true, cmh.generalProductDiscounts.get(allProductSchedule.Id)!= null);

        Map<String, SBQQ__DiscountTier__c> testTiers = cmh.generalProductDiscounts.get(allProductSchedule.Id);
        for(SBQQ__DiscountTier__c dti : allProductTiers){
            System.assertEquals(true,testTiers.get(dti.Name) != null);
            System.assertEquals(dti.SBQQ__UpperBound__c,testTiers.get(dti.Name).SBQQ__UpperBound__c);
            System.assertEquals(dti.SBQQ__LowerBound__c,testTiers.get(dti.Name).SBQQ__LowerBound__c);
            System.assertEquals(dti.SBQQ__Discount__c,testTiers.get(dti.Name).SBQQ__Discount__c);
        }
    }

    public static testMethod void testCreateOrderMap(){
        setUp();
        CPQMigrationHelper cmh = new CPQMigrationHelper();
        cmh.getContract(contract.ContractNumber);
        Test.startTest();
        cmh.createOrderMap();
        Test.stopTest();

        for(Order o : orders){
            System.assertEquals(true, cmh.orderMap.get(o.Id) != null );
            System.assertEquals(o.Pricebook2Id, cmh.orderMap.get(o.Id).Pricebook2Id);
            System.assertEquals(o.Id, cmh.orderMap.get(o.Id).Id);
            System.assertEquals(o.EffectiveDate, cmh.orderMap.get(o.Id).EffectiveDate);
            System.assertEquals(o.EndDate, cmh.orderMap.get(o.Id).EndDate);
            System.assertEquals(o.AccountId, cmh.orderMap.get(o.Id).AccountId);
            System.assertEquals(o.ContractId, cmh.orderMap.get(o.Id).ContractId);
        }
    }

    public static testMethod void testCreateOrderItemMap(){
        setUp();

        CPQMigrationHelper cmh = new CPQMigrationHelper();
        cmh.getContract(contract.ContractNumber);
        Test.startTest();
        cmh.getContract(contract.ContractNumber);
        cmh.createOrderMap();
        cmh.createOrderItemMap();
        System.debug('ois: ' + [SELECT Id, Product2.Name, Product2.SBQQ__PricingMethod__c, Product2.Family, Product2Id, Quantity, ListPrice, UnitPrice, Recurring_Monthly_Price__c, TotalPrice, Order.EffectiveDate, Order.EndDate, Order.AccountId, Order.ContractId FROM OrderItem ORDER BY OrderItemNumber ASC NULLS FIRST]);
        Test.stopTest();

        System.debug('ois: ' + [SELECT Id, Product2.Name, Product2.SBQQ__PricingMethod__c, Product2.Family, Product2Id, Quantity, ListPrice, UnitPrice, Recurring_Monthly_Price__c, TotalPrice, Order.EffectiveDate, Order.EndDate, Order.AccountId, Order.ContractId FROM OrderItem ORDER BY OrderItemNumber ASC NULLS FIRST]);
        System.debug('oim: ' + cmh.orderItemMap);

        System.assertEquals(true, cmh.orderItemMap.get(order.Id) != null);
        for(Integer i = 0; i< cmh.orderItemMap.get(order.Id).size(); i++){
            System.assertEquals(orderItems[i].Id, cmh.orderItemMap.get(order.Id)[i].Id);
            System.assertEquals(orderItems[i].Product2Id, cmh.orderItemMap.get(order.Id)[i].Product2Id);
            System.assertEquals(orderItems[i].Quantity, cmh.orderItemMap.get(order.Id)[i].Quantity);
            System.assertEquals(orderItems[i].ListPrice, cmh.orderItemMap.get(order.Id)[i].ListPrice);
            System.assertEquals(orderItems[i].UnitPrice, cmh.orderItemMap.get(order.Id)[i].UnitPrice);
        }
    }

    public static testMethod void testGetAssets(){
        setUp();

        CPQMigrationHelper cmh = new CPQMigrationHelper();

        Test.startTest();
        cmh.getContract(contract.ContractNumber);
        List<Asset> testAssets = cmh.getAssets();
        Test.stopTest();

        for(Integer i=0; i<assets.size();i++){
            System.assertEquals(assets[i].Id, testAssets[i].Id);
            System.assertEquals(assets[i].Product2Id, testAssets[i].Product2Id);
            System.assertEquals(assets[i].Quantity, testAssets[i].Quantity);
            System.assertEquals(assets[i].AccountId, testAssets[i].AccountId);
        }
    }

    public static testMethod void testSetSubscriptionInfo(){
        setUp();

        CPQMigrationHelper cmh = new CPQMigrationHelper();
        Test.startTest();
        cmh.getContract(contract.ContractNumber);
        SBQQ__Subscription__c sub = cmh.setSubscriptionInfo(orderItems[0]);
        Test.stopTest();

        System.assertEquals(orderItems[0].Product2Id, sub.SBQQ__Product__c);
        System.assertEquals(orderItems[0].Quantity, sub.SBQQ__Quantity__c);
        System.assertEquals(orderItems[0].Order.AccountId, sub.SBQQ__Account__c);
        System.assertEquals(orderItems[0].Order.ContractId, sub.SBQQ__Contract__c);
    }

    public static testMethod void testSetSubscriptionAmounts(){
        setUp();

        CPQMigrationHelper cmh = new CPQMigrationHelper();
        cmh.getContract(contract.ContractNumber);
        cmh.createPricebookEntryMap();

        Test.startTest();
        SBQQ__Subscription__c sub = cmh.setSubscriptionInfo(orderItems[0]);
        System.debug('map: ' + cmh.productPricebookEntryMap);
        System.debug('orderItems: ' + orderItems);

        sub.SBQQ__SpecialPrice__c = cmh.productPricebookEntryMap.get(orderItems[0].Product2Id).UnitPrice;
        sub.SBQQ__RenewalPrice__c = orderItems[0].ListPrice;
        sub.SBQQ__SubscriptionEndDate__c = system.today().addMonths(12);
                
        sub = CPQMigrationHelper.setSubscriptionAmounts(sub);
        Test.stopTest();

        Decimal prorate = CPQMigrationHelper.calculateProRate(sub.SBQQ__SubscriptionStartDate__c, sub.SBQQ__SubscriptionEndDate__c);

        System.assertEquals((cmh.productPricebookEntryMap.get(orderItems[0].Product2Id).UnitPrice)*prorate, sub.SBQQ__ListPrice__c);
        System.assertEquals(orderItems[0].ListPrice * prorate, sub.SBQQ__NetPrice__c);
    }

    public static testMethod void testCreateAccountDiscountsMap(){
        setUp();

        CPQMigrationHelper cmh = new CPQMigrationHelper();
        cmh.getContract(contract.ContractNumber);

        Test.startTest();
        cmh.createAccountDiscountsMap();
        Test.stopTest();

        SBQQ__ContractedPrice__c cp = [SELECT Id, SBQQ__Account__c, SBQQ__Product__c FROM SBQQ__ContractedPrice__c WHERE SBQQ__Account__c =: account.Id];

        for(String s : cmh.accountDiscounts.keySet()){
            System.assertEquals(true, cmh.accountDiscounts.get(cp.SBQQ__Account__c +  '_'  + cp.SBQQ__Product__c)!= null);
        }
    }

    public static testMethod void testGetDiscountSchedule(){
        setUp();

        CPQMigrationHelper cmh = new CPQMigrationHelper();
        cmh.getContract(contract.ContractNumber);
        cmh.createPricebookEntryMap();
        cmh.createAccountDiscountsMap();

        Test.startTest();
        System.assertEquals(allProductSchedule.Id, cmh.getDiscountSchedule(account.Id, products[0].Id));
        System.assertEquals(customerSchedule.Id, cmh.getDiscountSchedule(account.Id, products[1].Id));
        Test.stopTest();
    }

    public static testMethod void testGetDiscount(){
        setUp();

        CPQMigrationHelper cmh = new CPQMigrationHelper();
        cmh.getContract(contract.ContractNumber);
        cmh.createPricebookEntryMap();
        cmh.createAccountDiscountsMap();
        cmh.createProductDiscountsMap();

        //this should now exclude professional services

        Test.startTest();
        for(OrderItem oi : orderItems){
            Id dsId = cmh.getDiscountSchedule(account.Id, oi.Product2Id);

            //premier support does not have a discount schedule
            if(oi.Product2.Name != 'Premier Support'){
                Decimal discount = cmh.getDiscount(dsId, oi.Quantity);

                //customer product has a discount of 80% discount for >5 quantities
                if(dsId == customerSchedule.Id) System.assertEquals(80, discount);

                //generic product has a discount of 15% between 10 and 20 quantities
                if(dsId == allProductSchedule.Id) System.assertEquals(15, discount);
            }
        }
        Test.stopTest();
    }

    private class ProductLoadContext {
        public Id pricebookId;
        public String currencyCode;
    }

    public static testMethod void testLoadProduct(){

        setUp();
        contract.Has_Premier_Support__c = true;
        update contract;

        ProductLoadContext context = new ProductLoadContext();
        context.currencyCode = pbes[0].CurrencyIsoCode;
        context.pricebookId = pbes[0].Id;

        String pJson = SBQQ.ServiceRouter.load('ProductAPI.ProductLoader',pbes[0].Product2Id,JSON.serialize(context));
        TinyProductModel tpm = (TinyProductModel)JSON.deserialize(pJson, TinyProductModel.class);
        System.debug('returned product model' + tpm);
    }

    private class TinyProductModel {
        public Product2 record;
        public String currencyCode;
        public TinyOptionModel[] options;
        public TinyFeatureModel[] features;
        public TinyConfigurationModel configuration;
        public TinyConfigAttributeModel[] configurationAttributes;
        public TinyConfigAttributeModel[] inheritedConfigurationAttributes;
        public TinyConstraintModel[] constraints;
    }

    private class TinyConstraintModel {
        public SBQQ__OptionConstraint__c record;
        public Boolean priorOptionExists;
    }

    private class TinyOptionModel {
        public SBQQ__ProductOption__c record;
        public Map<String,String> externalConfigurationData;
        public Boolean configurable;
        public Boolean configurationRequired;
        public Boolean quantityEditable;
        public Boolean priceEditable;
        public Decimal productQuantityScale;
        public Boolean priorOptionExists;
        public Set<Id> dependentIds;
        public Map<String,Set<Id>> controllingGroups;
        public Map<String,Set<Id>> exclusionGroups;
        public String reconfigureDimensionWarning;
        public Boolean hasDimension;
        public Boolean isUpgrade;
        public String dynamicOptionKey;
    }

    private class TinyConfigAttributeModel {
        public String name;
        public String targetFieldName; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__TargetField__c
        public Decimal displayOrder; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__DisplayOrder__c
        public String columnOrder; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__ColumnOrder__c
        public Boolean required; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__Required__c
        public Id featureId; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__Feature__c
        public String position; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__Position__c
        public Boolean appliedImmediately; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__AppliedImmediately__c
        public Boolean applyToProductOptions; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__ApplyToProductOptions__c
        public Boolean autoSelect; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__AutoSelect__c
        public String[] shownValues; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__ShownValues__c
        public String[] hiddenValues; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__HiddenValues__c
        public Boolean hidden; // Corresponds directly to SBQQ__ConfigurationAttribute__c.SBQQ__Hidden__c
        public String noSuchFieldName; // If no field with the target name exists, the target name is stored here.
        public Id myId; // Corresponds directly to SBQQ__ConfigurationAttribute__c.Id
    }

    private class TinyFeatureModel {
        public SBQQ__ProductFeature__c record;
        public String instructionsText;
        public Boolean containsUpgrades;
    }

    private class TinyConfigurationModel {
        public Id configuredProductId;
        public Id optionId;
        public SBQQ__ProductOption__c optionData; // Editable data about the option in question, such as quantity or discount
        public SBQQ__ProductOption__c configurationData;
        public SBQQ__ProductOption__c inheritedConfigurationData;
        public TinyConfigurationModel[] optionConfigurations;
        public Boolean configured;
        public Boolean changedByProductActions;
        public Boolean isDynamicOption;
        public Boolean isUpgrade;
        public Set<Id> disabledOptionIds;
        public Set<Id> hiddenOptionIds;
        public Decimal listPrice;
        public Boolean priceEditable;
        public String[] validationMessages;
        public String dynamicOptionKey;
    }

    private class TinyQuoteModel {
        public SBQQ__Quote__c record;
        public TinyQuoteLineModel[] lineItems;
        public TinyQuoteLineGroupModel[] lineItemGroups;

        public Integer nextKey;
        public Boolean applyAdditionalDiscountLast;
        public Boolean applyPartnerDiscountFirst;
        public Boolean channelDiscountsOffList;
        public Decimal customerTotal;
        public Decimal netTotal;
        public Decimal netNonSegmentTotal;
    }

    private class TinyQuoteLineModel {
        public SBQQ__QuoteLine__c record;

        public Decimal renewalPrice;
        public Boolean amountDiscountProrated;
        public Integer parentGroupKey;
        public Integer parentItemKey;
        public Integer key;
        public Boolean upliftable;
        public String configurationType;
        public String configurationEvent;
        public Boolean reconfigurationDisabled;
        public Boolean descriptionLocked;
        public Boolean productQuantityEditable;
        public Decimal productQuantityScale;
        public String dimensionType;
        public Boolean productHasDimensions;
        public Decimal targetCustomerAmount;
        public Decimal targetCustomerTotal;
    }

    private class TinyQuoteLineGroupModel {
        public SBQQ__QuoteLineGroup__c record;

        public Decimal netNonSegmentTotal;
        public Integer key;
    }
}