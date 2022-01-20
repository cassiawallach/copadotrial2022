public class testMethodUtilities {
    public static void setupEntitlements(){
        if([SELECT Id FROM Entitlement WHERE Name ='Basic Support'].size()>0)return;
        Account bs = TestDataFactory.createAccount('My Account', 'EUR');
        insert bs;
        Id bhid = null;
        List<BusinessHours> bhs = [SELECT Id FROM BusinessHours WHERE Name ='Working hours - UTC+1' LIMIT 1];
        if(bhs.size()>0){
            bhid = bhs.get(0).Id;
        }
        Entitlement basic = new Entitlement(Name = 'Basic Support',AccountId = bs.Id, Access_Code__c=1, BusinessHoursId = bhid);
        insert basic;
        System.debug('########### basic support entitlement created: ' + basic);
    }
    public static Account createAccount(String name, String orgId){
        Account a = new Account();
        a.Name = name;
        insert a;
        return a;
    }
    public static Contact createContact(Id accountId, String firstName, String lastName, String email, String userId){
        Contact c = new Contact();
        c.AccountId = accountId;
        c.FirstName = firstName;
        c.LastName = lastName;
        c.Email = email;
        c.UserId__c = userId;
        insert c;
        return c;
    }
    public static Opportunity createOpportunity(Id accountId, String name, String StageName, String verificationKey, Double amount, String mainProblems){
        Opportunity o = new Opportunity();
        o.AccountId = accountId;
        o.CloseDate = System.today();
        o.Name = name;
        o.StageName = StageName;
        o.Amount = amount;
        o.Main_Problems__c = mainProblems;
        o.LeadSource='Advertisement';
        insert o;
        return o;
    }
    public static Boolean hasMessage(String s){
        Boolean b = false;
        for(ApexPages.Message msg : ApexPages.getMessages()){
            if(msg.getDetail().contains(s)) b = true;
        }
        return b;
    }
    public static Product2 createProduct(String name, Decimal creds, String code){
        Product2 p = new Product2();
        p.Name = name;
        p.Credits_to_be_assigned__c = creds;
        p.ProductCode = code;
        p.CurrencyIsoCode = 'EUR';
        p.IsActive = true;
        insert p;
        return p;
    }
    /*public static Pricebook2 createStandardPricebook(Id pbId){
        Pricebook2 stdPb = [select Id, isActive, isStandard from Pricebook2 where Id=:pbId limit 1];
        if (stdPb!=null && !stdPb.isActive){
            stdPb.isActive = true;
            update stdPb;
        }
        return stdPb;
    }*/
    public static Pricebook2 createCustomPricebook(String name, Boolean isActive, String curr){
        Pricebook2 pb = new Pricebook2();
        pb.Name = name;
        pb.IsActive = isActive;
        pb.CurrencyIsoCode = curr;
        insert pb;
        return pb;
    }
    public static PricebookEntry createPBE(Pricebook2 standard, Pricebook2 newPB, Product2 prod){
        PricebookEntry one = new PricebookEntry();
        one.Pricebook2Id = standard.Id;
        one.Product2Id = prod.Id;
        one.UnitPrice = 1249.0;
        one.IsActive = true;
        insert one;
        PricebookEntry ret = new PricebookEntry();
        ret.Pricebook2Id = newPB.Id;
        ret.Product2Id = prod.Id;
        ret.UnitPrice = 1250.0;
        ret.IsActive = true;
        insert ret;
        return ret;
    }
    public static Copado_Settings__c createCopadoSettings(String n, String pw, String un, Date d, Integer maxc){
        Copado_Settings__c s = new Copado_Settings__c();
        s.Name = n;
        s.Admin_Password__c = pw;
        s.Admin_Username__c = un;
        s.Last_Data_Export__c = d;
        s.Max_top_up_value__c = maxc;
        s.Server_URL__c = 'https://copado.herokuapp.com';
        insert s;
        return s;
    }
    public static kugo2p__KugamonSetting__c createKugamonSetting(String pricebookname){
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
        testKugamonSetting.kugo2p__OnlinePaymentButton__c = 'Accept & Approve';
        testKugamonSetting.kugo2p__OnlineConfirmationTextandTerms__c = 'Test';
        testKugamonSetting.kugo2p__PaymentMethod__c = 'Check';
        testKugamonSetting.kugo2p__PaymentTerms__c = 'Due Upon Receipt';
        testKugamonSetting.kugo2p__PriceBookName__c = pricebookname;
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
        insert testKugamonSetting;
        return testKugamonSetting;
    }
    
    // START TESTS
    @IsTest
    static void runTestCode(){
        testHttpCalloutMock request1 = new testHttpCalloutMock(200, 'Complete', '{"status":"ok"}');
        Map<String, HttpCalloutMock> calloutMap = new Map<String, HttpCalloutMock>();
        calloutMap.put('https://testMethod.com/admin/syncFeatures?sid=someSessionId', request1);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(calloutMap);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);   
        
        Test.startTest();
        Account testAccount = createAccount('Salesforce.comTest123', 'orgId123');
        Contact testContact = createContact(testAccount.Id,'Mark','Benioff','ceo@salesforce.com', 'userId123');
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org');
        insert org;
        Opportunity testOpportunity = createOpportunity(testAccount.Id, 'Opp Name', 'Marketing Qualification', 'testKey123',100,'Opp Main Problems');
        Id stdPricebookId = Test.getStandardPricebookId();
        Pricebook2 customPricebook = createCustomPricebook('^%New Pricebook', true, 'EUR');
        Product2 testProduct = createProduct('%$£TestProduct&^%', 10.0, '$£"Test(*)');
        PricebookEntry testEntry = createPBE(new Pricebook2(Id=Test.getStandardPricebookId()), customPricebook, testProduct);
        Copado_Settings__c cs = createCopadoSettings('testDefault', 'password', 'username', System.today(), 50);
        kugo2p__KugamonSetting__c testKugamonSetting=  createKugamonSetting(customPricebook.name);
        setupEntitlements();
        Test.stopTest();
        // MAKE ASSERTIONS
        Account[] a = [SELECT Id, Name FROM Account WHERE Name = 'Salesforce.comTest123'];
        System.assert(a.size() > 0);
        Contact[] c = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE FirstName = 'Mark' AND LastName = 'Benioff' AND Email = 'ceo@salesforce.com'];
        System.assert(c.size() > 0);
        Opportunity[] o = [SELECT Id, AccountId, Name FROM Opportunity WHERE AccountId = :testAccount.Id];
        System.assert(o.size() > 0);
        Product2[] p2 = [SELECT Id, Name FROM Product2 WHERE Name =:'%$£TestProduct&^%'];
        System.assert(p2.size() > 0);
        Pricebook2[] pbs = [SELECT Id, Name FROM Pricebook2 WHERE Name =:'^%New Pricebook'];
        System.assert(pbs.size() > 0);
        PricebookEntry[] pbes = [SELECT Id, Name FROM PricebookEntry WHERE Pricebook2Id=:pbs[0].Id AND Product2Id=:p2[0].Id];
        System.assert(pbes.size() > 0);
        Copado_Settings__c[] css = [SELECT Id, Name FROM Copado_Settings__c WHERE Name =:'testDefault'];
        System.assert(css.size() > 0);
        
        
        ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'test'));
        System.assert(hasMessage('test'));
    }
}