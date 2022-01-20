/**
 * Created by kheidt on 26/01/2018.
 */

public with sharing class CPQMigrationService {

    //two constructors to enable a test-mode where results are debugged instead of created/deleted
    //default is false
    Boolean isTest = false;

    public CPQMigrationService(){
        this(false);
    }

    public CPQMigrationService(Boolean testStatus){
        isTest = testStatus;
    }

    public void convertClientToCPQ(String contractNumber) {
        CPQMigrationHelper cpqHelper = new CPQMigrationHelper();
        cpqHelper.getContract(contractNumber);
        cpqHelper.createPricebookEntryMap();

        //create order Map
        cpqHelper.createOrderMap();

        //Get Order Items
        cpqHelper.createOrderItemMap();

        //get customer specific discount schedules for products
        cpqHelper.createAccountDiscountsMap();

        //get tiers for products
        cpqHelper.createProductDiscountsMap();
        /**
        * Now, as we do have a list of products and their related schedule,
        * as well as a list of accounts and their related issue
        * When looping through order Items, we can check for product and account, and get the discount to be applied,
        * where account specifics override the general product ones
        */

        Map<String, Decimal> productCounter = new Map<String, Decimal>();
        List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();


        for (Id orderId : cpqHelper.orderItemMap.keySet()) {

            for (OrderItem oi : cpqHelper.orderItemMap.get(orderId)) {

                //apex OR expressions are short-cutting and we kind of hack our way arount PremSup for now
                if (oi.Product2.Name == 'Premier Support') {

                    System.debug('current product: ' + oi.Product2.Name + ' ; #: ' + oi.Quantity);

                    //construct subscription items with header information
                    SBQQ__Subscription__c s = cpqHelper.setSubscriptionInfo(oi);

                    //for Premiere Support the unit price is 1.
                    //it is 15% of licenses, therefore past prices are irrelevant for renewals

                    //get proration to calculate prices correctly
                    Decimal proration = CPQMigrationHelper.calculateProRate(oi.Order.EffectiveDate, oi.Order.EndDate);

                    //the pricebook price is 1. we get the order item price instead
                    // As the unit price is the total for the period, devide it by the proration to have the monthly value
                    Decimal standardPrice = oi.UnitPrice / proration;

                    //for PremSup discountedPrice = standard price
                    Decimal itemDiscountedPrice = standardPrice;
                    System.debug('unit price: ' + standardPrice + ' ; proration: ' + proration + '; original price: ' + oi.UnitPrice);

                    //parts of it are slightly redundant, but the equation will work anyway
                    s.SBQQ__SpecialPrice__c = standardPrice;
                    s.SBQQ__RenewalPrice__c = itemDiscountedPrice;
                    s = CPQMigrationHelper.setSubscriptionAmounts(s);

                    subs.add(s);
                } else if (oi.Product2.Name != 'Agile Delivery') {

                    //counter to get the right tiers later on
                    Decimal oldCount = productCounter.get(oi.Product2Id) == null ? 0 : productCounter.get(oi.Product2Id);
                    productCounter.put(oi.Product2Id, oldCount + oi.Quantity);
                    Decimal totalQuantity = productCounter.get(oi.Product2Id);

                    System.debug('current product: ' + oi.Product2.Name + ' ; #: ' + oi.Quantity + ' ; Total #: ' + totalQuantity + ' ; ' + oi.Product2Id);

                    //determine the correct discount schedule for the current order item
                    Id dsId = cpqHelper.getDiscountSchedule(oi.Order.AccountId, oi.Product2Id);

                    //determine the discount tier & Discount for the current order item
                    //agile delivery prices are fix/year for x <= 10;
                    Decimal itemDiscount = cpqHelper.getDiscount(dsId, totalQuantity);

                    //construct subscription items with header information
                    SBQQ__Subscription__c s = cpqHelper.setSubscriptionInfo(oi);

                    //get original price
                    Decimal standardPrice = cpqHelper.productPricebookEntryMap.get(oi.Product2Id).UnitPrice;
                    //Apply term discount
                    Decimal itemDiscountedPrice = standardPrice * (1 - (itemDiscount / 100));
                    System.debug('unit price: ' + standardPrice + ' ; discount ; ' + itemDiscount + ' | discounted unit price: ' + itemDiscountedPrice);

                    s.SBQQ__SpecialPrice__c = standardPrice;
                    s.SBQQ__RenewalPrice__c = itemDiscountedPrice;
                    s = CPQMigrationHelper.setSubscriptionAmounts(s);

                    subs.add(s);
                }
            }
        }

        //get assets to be deleted:
        List<Asset> assets = cpqHelper.getAssets();

        //print some intel before continuations
        system.debug('Assets found: ' + assets.size());
        system.debug('Subscriptions created: ' + subs.size());
        System.debug('print subs: ' + subs);
        System.debug('print assets: ' + assets);

        if (!isTest) {
            upsert subs;
            delete assets;
        }

    }

}