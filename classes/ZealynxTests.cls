@isTest
private class ZealynxTests {

  @TestSetup
  static void makeData(){
    Id pricebookId = Test.getStandardPricebookId();

    Pricebook2 testPricebook = new Pricebook2();
    testPricebook.Name = 'Test';
    testPricebook.CurrencyIsoCode = 'EUR';
    testPricebook.IsActive = true;
    insert testPricebook;

    SBQQ__DiscountSchedule__c  allProductSchedule = TestDataFactory.createDiscountSchedule('allProducts');
    insert allProductSchedule;

    List<SBQQ__DiscountTier__c> allProductTiers = TestDataFactory.createStandardTiersAll(
      allProductSchedule.Id
    );
    insert allProductTiers;

    SBQQ__DiscountSchedule__c customerSchedule = TestDataFactory.createDiscountSchedule(
      'TestAccount'
    );
    insert customerSchedule;

    List<SBQQ__DiscountTier__c> customerProductTiers = TestDataFactory.createDiscountTiers(
      customerSchedule.Id,
      new List<Integer>{1,2,3,4,5,10000},
      new List<Decimal>{0,10,20,50,80}
    );
    insert customerProductTiers;

    Product2 testProduct = testMethodUtilities.createProduct('Enterprise', 100.00,'EE');

    SBQQ__ProductFeature__c testProductFeature = new SBQQ__ProductFeature__c();
    testProductFeature.SBQQ__ConfiguredSKU__c = testProduct.Id;
    testProductFeature.SBQQ__Number__c = 1;
    insert testProductFeature;

    SBQQ__ProductOption__c testProductOption = new SBQQ__ProductOption__c();
    testProductOption.SBQQ__ConfiguredSKU__c = testProduct.Id;
    testProductOption.SBQQ__Number__c = 1;
    insert testProductOption;

    PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=testProduct.Id, UnitPrice=5, IsActive=true);
    insert standardPrice;
        
    PricebookEntry customPrice = new PriceBookEntry(Pricebook2Id=testPricebook.Id, Product2Id=testProduct.Id, UnitPrice=5, IsActive=true);
        insert customPrice;

    Account testAccount = TestDataFactory.createAccount('Test','USD');
    insert testAccount;

    Contact testContact = TestDataFactory.createContact(testAccount.Id, 'Tester');
    insert testContact;

    kugo2p__Warehouse__c testWarehouse = new kugo2p__Warehouse__c();
    testWarehouse.Name = 'Test';
    insert testWarehouse;

    kugo2p__InvoiceSchedule__c testInvoiceSchedule = new kugo2p__InvoiceSchedule__c();
    testInvoiceSchedule.Name = 'One-Time Invoicing';
    testInvoiceSchedule.kugo2p__Description__c = 'One-Time Invoicing';
    insert testInvoiceSchedule;

    kugo2p__KugamonSetting__c testKugamonSetting = new kugo2p__KugamonSetting__c();
    testKugamonSetting.Name = 'Kugamon Configuration';
    testKugamonSetting.kugo2p__Admin_User__c = UserInfo.getUserId();
    testKugamonSetting.kugo2p__AllowOverrideServiceDateUpdate__c = true;
    testKugamonSetting.kugo2p__BillingMethod__c = 'Email';
    testKugamonSetting.kugo2p__CompanyTextandTerms__c = 'Test';
    testKugamonSetting.kugo2p__CreditTerms__c = 'No Credit Check Required';
    testKugamonSetting.kugo2p__DateAvailabletoPromiseBasis__c = 'Date Required';
    testKugamonSetting.kugo2p__DaysTillPaymentDue__c = 0;
    testKugamonSetting.kugo2p__DeliveryTerms__c = 'FOB Origin';
    testKugamonSetting.kugo2p__InvoiceTextandTerms__c = 'test';
    testKugamonSetting.kugo2p__FirstInvoiceDateBasis__c = 'Order Date Required';
    testKugamonSetting.kugo2p__DayofRevenueRecognition__c = '31';
    testKugamonSetting.kugo2p__DefaultInvoiceSchedule__c = testInvoiceSchedule.Id;
    testKugamonSetting.kugo2p__OnlinePaymentButton__c = 'Accept & Approve';
    testKugamonSetting.kugo2p__OnlineConfirmationTextandTerms__c = 'Test';
    testKugamonSetting.kugo2p__PaymentMethod__c = 'Check';
    testKugamonSetting.kugo2p__PaymentTerms__c = 'Due Upon Receipt';
    testKugamonSetting.kugo2p__PriceBookName__c = testPricebook.Name;
    testKugamonSetting.kugo2p__RemitToCity__c = 'MyCity';
    testKugamonSetting.kugo2p__RemitToCountry__c = 'USA';
    testKugamonSetting.kugo2p__RemitToName__c = 'Test';
    testKugamonSetting.kugo2p__RemitToStateProvince__c = 'CA';
    testKugamonSetting.kugo2p__RemitToStreet__c = '123 My Street';
    testKugamonSetting.kugo2p__RemitToZipPostalCode__c = '91405';
    testKugamonSetting.kugo2p__ResetQuoteOrderTermsConditions__c = 'Update Matched Terms';
    testKugamonSetting.kugo2p__RestrictedBannerText__c = 'Test';
    testKugamonSetting.kugo2p__SalesQuoteValidOfferInDays__c = 10;
    testKugamonSetting.kugo2p__UnitofMeasure__c = 'Each';
    testKugamonSetting.kugo2p__UnitofTerm__c = 'Year';
    testKugamonSetting.kugo2p__UpdateOpportunityAmountBasis__c = 'Net AMount';
    testKugamonSetting.kugo2p__Warehouse__c = testWarehouse.Id;
    insert testKugamonSetting;

    testWarehouse.kugo2p__KugamonSetting__c = testKugamonSetting.Id;
    update testWarehouse;

    testInvoiceSchedule.kugo2p__KugamonSetting__c = testKugamonSetting.Id;
    update testInvoiceSchedule;

    kugo2p__AdditionalAccountDetail__c additionalAccountDetail = new kugo2p__AdditionalAccountDetail__c();
    additionalAccountDetail.kugo2p__Account__c = testAccount.Id;
    additionalAccountDetail.kugo2p__ContactBilling__c = testContact.Id;
    additionalAccountDetail.kugo2p__ContactBuying__c = testContact.Id;
    additionalAccountDetail.kugo2p__ContactShipping__c = testContact.Id;
    additionalAccountDetail.kugo2p__Warehouse__c = testWarehouse.Id;
    additionalAccountDetail.kuga_sub__RenewalPriceUpliftPercent__c = 0;
    insert additionalAccountDetail;

    Opportunity testOpportunity = TestDataFactory.createOpportunity(testAccount, 'Test', 'Marketing Qualification');
    testOpportunity.StageName = 'Marketing Qualification';
    testOpportunity.LeadSource = 'Website';
    insert testOpportunity;

    SBQQ__Quote__c testQuote = TestDataFactory.createCPQuote(testOpportunity);
    testQuote.SBQQ__Primary__c = true;
    testQuote.SBQQ__Account__c = testAccount.Id;
    insert testQuote;

    SBQQ__QuoteLineGroup__c testQuotelineGroup = new SBQQ__QuoteLineGroup__c();
    testQuotelineGroup.SBQQ__Quote__c = testQuote.Id;
    testQuotelineGroup.SBQQ__Account__c = testAccount.Id;
    testQuotelineGroup.SBQQ__Number__c = 1;
    insert testQuotelineGroup;

    SBQQ__QuoteLine__c testQuoteline = new SBQQ__QuoteLine__c();
    testQuoteline.SBQQ__Product__c = testProduct.Id;
    testQuoteline.SBQQ__Quote__c = testQuote.Id;
    testQuoteline.SBQQ__PricebookEntryId__c = customPrice.Id;
    testQuoteline.SBQQ__Group__c = testQuotelineGroup.Id;
    testQuoteline.SBQQ__DefaultSubscriptionTerm__c = 12;
    testQuoteline.SBQQ__Quantity__c = 1;
    insert testQuoteline;
  }

  static testMethod void ZealynxController(){
    List<SBQQ__Quote__c> testQuotes = [
      SELECT Id, Name, SBQQ__Account__c, SBQQ__Opportunity2__r.RecordType.Name
      FROM SBQQ__Quote__c
      LIMIT 1
    ];
    kugo2p__SalesOrder__c testSalesOrder = new kugo2p__SalesOrder__c();
    testSalesOrder.kugo2p__Account__c = testQuotes[0].SBQQ__Account__c;
    ZealynxController.Result res = new ZealynxController.Result(testQuotes[0]);
    res.orderRecord = testSalesOrder;
    res.orderRecord.Id = null;
    res.errors = '';

    test.startTest();
      Set<Id> accountIds = new Set<Id>{testQuotes[0].SBQQ__Account__c};
      Map<Id,kugo2p__AdditionalAccountDetail__c> accountDetailMap = ZealynxController.queryAccountDetails(accountIds);

      Pagereference pr = Page.QuoteToOrder;
      pr.getParameters().put('id',testQuotes[0].Id);
      Test.setCurrentPage(pr);
      ApexPages.StandardController standardController = new ApexPages.StandardController(testQuotes[0]);
      ZealynxController con = new ZealynxController(standardController);
      con.syncQuotes();

      con.results = new List<ZealynxController.Result>{res};
      con.redirectToOrder();

      ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(testQuotes);
      con = new ZealynxController(standardSetController);

      List<Map<String,Object>> results = new List<Map<String,Object>>();

      ZealynxController.populateOrderFromAccountDetail(testSalesOrder, accountDetailMap);
      ZealynxController.populateOrderRecordType(testQuotes[0], testSalesOrder);
    test.stopTest();
  }

  static testMethod void SBQQDiscountTierTrigger(){
    List<SBQQ__DiscountTier__c> allProductTiers = [SELECT Id FROM SBQQ__DiscountTier__c LIMIT 1];
    test.startTest();
      update allProductTiers;
      delete allProductTiers;
      undelete allProductTiers;
    test.stopTest();
  }

  static testMethod void Product2Trigger(){
    List<Product2> allProducts = [SELECT Id FROM Product2 LIMIT 1];
    test.startTest();
      update allProducts;
      delete allProducts;
      undelete allProducts;
    test.stopTest();
  }

  static testMethod void SBQQProductOptionTrigger(){
    List<SBQQ__ProductOption__c> allProductOptions = [SELECT Id FROM SBQQ__ProductOption__c LIMIT 1];
    test.startTest();
      update allProductOptions;
      delete allProductOptions;
      undelete allProductOptions;
    test.stopTest();
  }

  static testMethod void SBQQProductFeatureTrigger(){
    List<SBQQ__ProductFeature__c> allProductFeatures = [SELECT Id FROM SBQQ__ProductFeature__c LIMIT 1];
    test.startTest();
      update allProductFeatures;
      delete allProductFeatures;
      undelete allProductFeatures;
    test.stopTest();
  }

  static testMethod void SBQQDiscountScheduleTrigger(){
    List<SBQQ__DiscountSchedule__c> allProductSchedules = [SELECT Id FROM SBQQ__DiscountSchedule__c LIMIT 1];
    test.startTest();
      update allProductSchedules;
      delete allProductSchedules;
      undelete allProductSchedules;
    test.stopTest();
  }

  static testMethod void Kugo2pAdditionalProductDetailTrigger(){
    List<Product2> allProducts = [SELECT Id FROM Product2 LIMIT 1];
    test.startTest();
      kugo2p__AdditionalProductDetail__c testProductDetail = new kugo2p__AdditionalProductDetail__c();
      testProductDetail.kugo2p__ReferenceProduct__c = allProducts[0].Id;
      insert testProductDetail;
    test.stopTest();
  }

}