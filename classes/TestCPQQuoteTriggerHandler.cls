/**
 * Created by kheidt on 24/01/2018.
 */
@isTest
public with sharing class TestCPQQuoteTriggerHandler {
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
    private static SBQQ__Quote__c quote;
    private static List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();

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

    }

    public static testMethod void testProrationOnNewQuote(){
        setUp();
        quote = TestDataFactory.createCPQQuote(oppty,account,null,null,'Quote',oppty.CloseDate);
        quote.SBQQ__EndDate__c = oppty.CloseDate.addYears(1).addDays(-1);

        test.startTest();
        insert quote;
        test.stopTest();

        quote = [SELECT Id, Number_Of_Months__c FROM SBQQ__Quote__c WHERE Id = :quote.Id];

        System.assertEquals(12.0000,quote.Number_Of_Months__c);
    }
}