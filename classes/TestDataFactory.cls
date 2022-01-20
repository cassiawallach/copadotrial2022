@isTest
public class TestDataFactory {
    
    public static User getAdminUser(){
        return [
            SELECT Id, Name, Email FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True LIMIT  1
        ];
    }
    
    public static User createRunningSalesUser(){
        //tbd get sales user profile & permission sets
        return null;
    }
    
    public static User createRunningDevUser(){
        //tbd get dev user profile & permission sets
        return null;
    }
    
    public static User createUser(){
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User u = new User();
        u.FirstName = 'Thomas';
        u.LastName = 'Test';
        u.Email = 'ttest@copadotest.test';
        
        u.Username = uniqueName + '@test' + orgId + '.org';//'user' + system.now().getTime() + '@test.com'; //u.Email;        
        
        u.ProfileId = [Select Id FROM Profile WHERE Profile.Name LIKE 'SALES%' LIMIT 1].Id;
        u.Alias = 'ttest';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        return u;
    }
    
    public static User setToAdmin(User u){
        u.ProfileId = [Select Id FROM Profile WHERE Profile.Name = 'System Administrator' LIMIT 1].Id;
        u.Username = u.Username + '.admin';
        return u;
    }
    
    public static RecordType getRecordType(){
        return[
            SELECT Id, Name FROM RecordType WHERE Name = 'Corporate Entity' LIMIT 1
        ];
    }
    
    public static Account createAccount(String postFix, String currencyCode){
        Account acct = new Account();
        acct.Name = 'TestAccount_' + postFix;
        acct.RecordTypeId = getRecordType().Id;
        acct.Type = 'Customer';
        acct.CurrencyIsoCode = currencyCode;
        acct.Industry = 'Agriculture';
        return acct;
    }
    public static Account createAccountNew(String name, String currencyCode){
        Account acct = new Account();
        acct.Name = name;
        acct.RecordTypeId = getRecordType().Id;
        acct.Type = 'Customer';
        acct.CurrencyIsoCode = currencyCode;
        acct.Industry = 'Agriculture';
        return acct;
    }
    public static List<Account> createAccounts(List<String> postFixes, List<String> currencyCodes){
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<postFixes.size(); i++){
            accounts.add(createAccount(postFixes[i],currencyCodes[i]));
        }
        return accounts;
    }
    public static Campaign createCampaign(String name,String currencyCode){
        Campaign campObj = New Campaign();
        campObj.Capacity__c = 2;
        campObj.Name = name;
        campObj.StartDate = system.today();
        campObj.CurrencyIsoCode = currencyCode;
        campObj.Fiscal_Year__c = '2022';
        campObj.Type = 'Inbound - INB';
        campObj.Sub_Type__c = 'Form Fill';
        campObj.Region__c = 'EMEA';
        campObj.Timeframe__c ='Q3';
        campObj.Vertical__c = 'Insurance';
        return campObj;
    }
   
    public static Contact createContact(Id acctID, String lastName){
        Contact ctc = new Contact();
        ctc.FirstName = 'Theo';
        ctc.LastName = lastName;
        ctc.Email = 'Theo' + '.' + lastName + '@copa.do.testclass';
        ctc.accountId = acctID;
        return ctc;
    }
    
    public static List<Contact> createContacts(List<Id> accountIds, List<String> lastNames){
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0; i<accountIds.size(); i++){
            contacts.add(createContact(accountIds[i],lastNames[i]));
        }
        return contacts;
    }
    
    public static Lead createLead(String lstName,String company){
        Lead led = new Lead();
        led.LastName = lstName;
        led.Status ='Open';
        led.Company = company;
        return led;
    }
    public static Contract createDraftContract(Id acct, String currencyCode){
        Contract ctrct = new Contract();
        ctrct.AccountId = acct;
        ctrct.CurrencyIsoCode = currencyCode;
        ctrct.Status = 'Draft';
        ctrct.StartDate = Date.today().addDays(7);
        ctrct.ContractTerm = 12;
        //ctrct.EndDate = Date.today().addDays(7).addMonths(12);
        return ctrct;
    }
    
    public static List<Contract> createDraftContracts(List<Id> accountIds, List<String> currencyCodes){
        List<Contract> contracts = new List<Contract>();
        for(Integer i = 0; i<accountIds.size();i++){
            contracts.add(createDraftContract(accountIds[i], currencyCodes[i]));
        }
        return contracts;
    }
    
    public static Opportunity createOpportunity(Account acct, String opptyNamePart, String type){
        Opportunity oppty = new Opportunity();
        oppty.Name = acct.Name  + ' - ' + opptyNamePart;
        oppty.Type = type;
        oppty.Amount =100;
        oppty.Value_Prop_ID__c = 'Test123';
        oppty.CloseDate = Date.today().addDays(2);
        oppty.StageName = 'Marketing Qualification';
        oppty.CurrencyIsoCode = acct.CurrencyIsoCode;
        oppty.Description = 'Test Opportunity';
        oppty.NextStep = 'Work with the test';
        oppty.Next_Contact__c = Date.today().addDays(1);
        oppty.Main_Problems__c='Problem';
        oppty.LeadSource='Advertisement';
        oppty.AccountId=acct.Id;
        return oppty;
    }
    
    public static List<Opportunity> createOpportunities(List<Account> accts){
        List<Opportunity> opptys = new List<Opportunity>();
        for(Integer i = 0; i<accts.size();i++){
            opptys.add(createOpportunity(
                accts[i],
                ' ' + String.valueOf(i),
                'New Customer'
            ));
        }
        return opptys;
    }
    public static DL_VC__VC_Value_Proposition__c createROICalculation(Id oppId){
        DL_VC__VC_Value_Proposition__c obj = new DL_VC__VC_Value_Proposition__c();
        obj.Name = 'Test';
        obj.DL_VC__VC_Opportunity__c = oppId;
        return obj;
    }
    public static SBQQ__Quote__c createCPQuote(Opportunity oppty){
        SBQQ__Quote__c qt = new SBQQ__Quote__c();
        qt.SBQQ__Account__c = oppty.AccountId;
        qt.SBQQ__Primary__c = true;
        qt.SBQQ__Opportunity2__c = oppty.Id;
        qt.CurrencyIsoCode = oppty.CurrencyIsoCode;
        qt.SBQQ__Status__c = 'Draft';
        qt.SBQQ__ExpirationDate__c = Date.today().addDays(14);
        String type = 'Quote';
        if(oppty.Type == 'Renewal') type = 'Renewal';
        if(oppty.Type == 'Add-on') type = 'Amendment';
        qt.SBQQ__Type__c = type;
        qt.Payment_Method__c = 'ACH';
        qt.SBQQ__PaymentTerms__c = 'Net 30';
        qt.SBQQ__BillingFrequency__c = 'Annual';
        qt.SBQQ__StartDate__c = oppty.CloseDate;
        qt.SBQQ__EndDate__c = oppty.CloseDate.addYears(1);
        qt.SBQQ__LineItemsPrinted__c = true;
        return qt;
    }
    
    
    public static List<SBQQ__Quote__c> createCPQuotes(List<Opportunity> opptys){
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
        for(Opportunity o : opptys){
            quotes.add(createCPQuote(o));
        }
        return quotes;
    }
    
    public static SBQQ__DiscountSchedule__c createDiscountSchedule(
        String namePostfix
    ){
        SBQQ__DiscountSchedule__c ds = new SBQQ__DiscountSchedule__c();
        ds.Name = 'Discount Schedule - ' + namePostfix;
        ds.SBQQ__Type__c = 'Range';
        ds.SBQQ__DiscountUnit__c = 'Percent';
        ds.SBQQ__AggregationScope__c = 'Group';
        ds.SBQQ__CrossOrders__c = true;
        ds.SBQQ__QuoteLineQuantityField__c = 'Quantity';
        ds.SBQQ__PriceScale__c = 2;
        return ds;
    }
    
    public static SBQQ__DiscountTier__c createDiscountTier(
        Id dsId,
        Integer lowerBound,
        Integer upperBound,
        Decimal disc
    ){
        SBQQ__DiscountTier__c dt = new SBQQ__DiscountTier__c();
        dt.SBQQ__Schedule__c = dsId;
        dt.SBQQ__LowerBound__c = lowerBound;
        dt.SBQQ__UpperBound__c = upperBound;
        dt.SBQQ__Discount__c = disc;
        dt.Name = String.valueOf(lowerBound) + '-' + String.valueOf(upperBound-1);
        return dt;
    }
    
    public static List<SBQQ__DiscountTier__c> createDiscountTiers(
        Id dsId,
        List<Integer> thresholds,
        List<Decimal> discounts
    ){
        List<SBQQ__DiscountTier__c> dtlist = new List<SBQQ__DiscountTier__c>();
        for(Integer i = 0; i<thresholds.size()-1; i++){
            dtlist.add(createDiscountTier(
                dsId,
                thresholds[i],thresholds[i+1],
                discounts[i]
            ));
        }
        return dtlist;
    }
    
    public static List<SBQQ__DiscountTier__c> createStandardTiersAll(Id dsId){
        List<Integer> tierList = new List<Integer>{1,5,11,21,31,61,81,91,101,100001};
            List<Decimal> discList = new List<Decimal>{0,10.0000, 15.0000, 20.0000, 25.0000, 30.0000, 40.0000,50.0000,55.0000};
                List<SBQQ__DiscountTier__c> dtList = createDiscountTiers(dsId,tierList, discList);
        return dtList;
    }
    
    public static Product2 createProduct(String prodName,String family,Id discountSchedule){
        Product2 prod = new Product2();
        prod.Name = prodName;
        prod.Family = family;
        prod.SBQQ__DiscountSchedule__c = discountSchedule;
        prod.SBQQ__PricingMethod__c = 'List';
        prod.IsActive = true;
        prod.SBQQ__QuantityEditable__c = true;
        prod.CurrencyIsoCode = 'EUR';
        return prod;
    }
    
    public static Product2 addStandardCPQItems(
        Product2 prod,
        String family,
        Id dsId
    ){
        prod.Family = family;
        prod.SBQQ__DiscountSchedule__c = dsId;
        prod.SBQQ__PricingMethod__c = 'List';
        prod.IsActive = true;
        prod.SBQQ__QuantityEditable__c = true;
        prod.CurrencyIsoCode = 'EUR';
        return prod;
    }
    
    public static Product2 createLicenseProduct(
        String prodName,
        Id discountSchedule
    ){
        Product2 prod = createProduct(prodName, 'Licenses', discountSchedule);
        prod.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        prod.SBQQ__SubscriptionTerm__c = 1;
        prod.SBQQ__SubscriptionType__c = 'Renewable';
        prod.SBQQ__SubscriptionCategory__c = 'Licenses';
        prod.SBQQ__BillingType__c = 'Advance';
        return prod;
    }
    
    public static Product2 addLicenseCPQItems(Product2 prod){
        prod.Family = 'Licenses'; //just in case a non-license product is provided
        prod.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        prod.SBQQ__SubscriptionTerm__c = 1;
        prod.SBQQ__SubscriptionType__c = 'Renewable';
        prod.SBQQ__SubscriptionCategory__c = 'Licenses';
        prod.SBQQ__BillingType__c = 'Advance';
        return prod;
    }
    
    public static Pricebook2 createPricebook(){
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Copado Subscriptions';
        pb.IsActive = true;
        return pb;
    }
    
    public static PricebookEntry createPricebookEntry(Id priceBook,Id product,String currencyCode,Decimal price){
        PricebookEntry one = new PricebookEntry();
        one.pricebook2Id = Test.getStandardPricebookId();
        one.product2id = product;
        one.unitprice = price;
        one.CurrencyIsoCode = currencyCode;
        one.isactive = true;
        upsert one;
        
        PricebookEntry ret = new PricebookEntry();
        ret.pricebook2Id = priceBook;
        ret.product2id = product;
        ret.unitprice = price;
        ret.CurrencyIsoCode = currencyCode;
        ret.UseStandardPrice = true;
        ret.isactive = true;
        insert ret;
        return ret;
    }
    
    public static List<PricebookEntry> createPricebookEntries(
        Pricebook2 pb,
        List<Product2> products,
        List<String> currencies,
        List<Decimal> prices
    ){
        List<PricebookEntry> entries = new List<PricebookEntry>();
        for(Integer i=0; i<products.size();i++){
            entries.add(createPricebookEntry(
                pb.Id,
                products[i].Id,
                currencies[i],
                prices[i]
            ));
        }
        return entries;
    }
    
    public static SBQQ__ContractedPrice__c createContractedPrice(
        Id acctId,
        Id prodId,
        Id asId,
        Date startDate,
        Date endDate
    ){
        SBQQ__ContractedPrice__c cp = new SBQQ__ContractedPrice__c();
        cp.SBQQ__Account__c = acctId;
        cp.SBQQ__DiscountSchedule__c = asId;
        cp.SBQQ__Product__c = prodId;
        cp.SBQQ__EffectiveDate__c = startDate;
        cp.SBQQ__ExpirationDate__c = endDate;
        return cp;
    }
    
    
    public static Order createOrder(
        Id accId,
        Contract cn,
        Pricebook2 pb,
        Date startDate,
        Date endDate
    ){
        Order o = new Order();
        o.AccountId = accId;
        o.EffectiveDate = startDate;
        o.EndDate = endDate;
        o.Status = 'Draft';
        o.ContractId = cn.Id;
        o.CurrencyIsoCode = cn.CurrencyIsoCode;
        o.Pricebook2Id = pb.Id;
        return o;
    }
    
    public static List<Order> createOrders(
        List<Contract>  contracts,
        Pricebook2 pb
    ){
        List<Order> orders = new List<Order>();
        for(Contract c:contracts){
            orders.add(createOrder(
                c.AccountId,
                c,
                pb,
                c.StartDate,
                c.EndDate
            ));
        }
        return orders;
    }
    
    public static OrderItem createOrderItem(
        PricebookEntry pbe,
        Id orderId,
        Decimal quantity,
        Decimal price
        //Decimal unitPrice
    ){
        OrderItem oi = new OrderItem();
        oi.Product2Id = pbe.Product2Id;
        oi.PricebookEntryId = pbe.Id;
        oi.OrderId = orderId;
        oi.Quantity = quantity;
        //oi.ListPrice = listPrice;
        oi.UnitPrice = price;
        return oi;
    }
    
    public static List<OrderItem> createOrderItems(
        Id orderId,
        List<PricebookEntry> pbes,
        List<Decimal> quantities,
        List<Decimal> prices
    ){
        List<OrderItem> oilist = new List<OrderItem>();
        for(Integer i = 0; i<pbes.size(); i++){
            oilist.add(createOrderItem(
                pbes[i],
                orderId,
                quantities[i],
                prices[i]
            ));
        }
        return oilist;
    }
    
    public static Asset createAsset(OrderItem oi){
        Asset ast = new Asset();
        ast.Name = oi.Product2.Name;
        ast.Product2Id = oi.Product2Id;
        ast.Quantity = oi.Quantity;
        ast.AccountId = oi.Order.AccountId;
        ast.PurchaseDate = oi.Order.EffectiveDate;
        ast.UsageEndDate = oi.Order.EndDate;
        ast.Status = 'Active';
        return ast;
    }
    
    public static List<Asset> createAssets(List<OrderItem> ois){
        List<Asset> asts = new List<Asset>();
        for(OrderItem oi : ois){
            asts.add(createAsset(oi));
        }
        return asts;
    }
    public static kugo2p__Warehouse__c createWareHouse(String name,Id kugamonSetting){
        kugo2p__Warehouse__c wareObj = new kugo2p__Warehouse__c();
        wareObj.Name = name;
        wareObj.kugo2p__KugamonSetting__c = kugamonSetting;
        
        
        return wareObj;
    }
    
    
    public static kugo2p__SalesOrder__c createKugamonOrder(Id account){
        kugo2p__SalesOrder__c orderObj = new kugo2p__SalesOrder__c();
        orderObj.kugo2p__Account__c = account;
        orderObj.kugo2p__RecordStatus__c ='Draft';
        //orderObj.kugo2p__IsPrimary__c = true;
        return orderObj;
    }
    public static SBQQ__QuoteLine__c createCPQQuoteLine(Id quote,Id product){
        SBQQ__QuoteLine__c lineObj = new SBQQ__QuoteLine__c();
        lineObj.SBQQ__Product__c = product;
        lineObj.SBQQ__Quote__c = quote;
        
        return lineObj;
    }
    public static SBQQ__Subscription__c createSubscription(OrderItem oi, PricebookEntry pe){
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Product__c = oi.Product2Id;
        sub.SBQQ__Account__c = oi.Order.AccountId;
        sub.SBQQ__Quantity__c = oi.Quantity;
        sub.SBQQ__Contract__c = oi.Order.ContractId;
        sub.SBQQ__SubscriptionStartDate__c = oi.Order.EffectiveDate;
        sub.SBQQ__SubscriptionEndDate__c = oi.Order.EndDate;
        sub.SBQQ__ProrateMultiplier__c = CPQMigrationHelper.calculateProRate(oi.Order.EffectiveDate, oi.Order.EndDate);
        sub.SBQQ__ListPrice__c = pe.UnitPrice * sub.SBQQ__ProrateMultiplier__c;
        sub.SBQQ__SpecialPrice__c = pe.UnitPrice;
        sub.SBQQ__NetPrice__c = sub.SBQQ__ListPrice__c;
        return sub;
    }
    
    public static List<SBQQ__Subscription__c> createSubscriptions(List<OrderItem> ois, List<PricebookEntry> pes){
        List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
        for(Integer i=0; i<ois.size(); i++){
            subs.add(createSubscription(
                ois[i],
                pes[i]
            ));
        }
        return subs;
    }
    
    public static SBQQ__Quote__c createCPQQuote(
        Opportunity o,
        Account a,
        Contact con,
        Contract addOnContract,
        String type,
        Date startDate
    ){
        Date endDate;
        
        //set end date to contract end date, if possible.
        //if no contract is provided, e.g. for new customers
        if(addOnContract != null ) {
            endDate = addOnContract.EndDate;
        } else {
            startDate.addYears(1);
        }
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.Id;
        q.SBQQ__Account__c = a.Id;
        q.SBQQ__PrimaryContact__c = con != null ? con.Id : null;
        q.CurrencyIsoCode = o.CurrencyIsoCode;
        q.SBQQ__MasterContract__c = addOnContract != null? addOnContract.Id : null;
        q.SBQQ__Type__c = type;
        q.SBQQ__Status__c = 'Presented';
        q.SBQQ__StartDate__c = startDate;
        q.SBQQ__EndDate__c =  endDate;
        q.SBQQ__Primary__c = true;
        q.Agreement_Sent_with_Quote__c = true;
        q.SBQQ__ExpirationDate__c = o.CloseDate.addDays(-5);
        return q;
    }
    public static Agreement__c createAgreement(Opportunity o,Account a,Contact con){
        Agreement__c agreObj = new Agreement__c();
        agreObj.Status__c = 'Executed';
        agreObj.Type__c = 'MSA';
        agreObj.Opportunity__c = o.id;
        agreObj.Account__c = a.id;
        agreObj.Legal_Contact__c = con.id;
        return agreObj;
    }
    public static Entitlement createEntitlementPremier(String acctID){
        Date today = Date.today();
        Date startDate = today.addYears(-1);
        Date endDate = today;
        
        SlaProcess sla = [SELECT Id, Name, IsActive FROM SlaProcess WHERE Name = 'Premier Support'  AND IsActive = true LIMIT 1];
        Entitlement ent = new Entitlement();
        ent.Name = 'Premier';
        ent.AccountId = acctID;
        ent.SlaProcessId = sla.Id;
        ent.StartDate = startDate;
        //ent.EndDate = today;
        return ent;
    }
    public static copado__Project__c createProject(String name){
        copado__Project__c project = new copado__Project__c();
        project.Name = name;
        insert project;
        return  project;
    }
    public static copado__Release__c createRelease(String name){
        copado__Release__c rel = new copado__Release__c();
        rel.Name = name;
        return rel;
    }
    public static copado__User_Story__c createUserStories(String title,String status){
        copado__User_Story__c userStoriesObj = new copado__User_Story__c();
        userStoriesObj.copado__User_Story_Title__c = title;
        userStoriesObj.copado__Status__c = status;
        return userStoriesObj;
    }
    public static copado__Test_Script__c createTestScript(Id userStoriesId){
        copado__Test_Script__c testScript = new copado__Test_Script__c();
        testScript.copado__User_Story__c = userStoriesId;
        return testScript;
    }
    public static copado__Test_Run__c createTestRun(Id userId,Id testScriptId,Id userStoriesId,String status,String type,String testPhase){
        copado__Test_Run__c testRun = new copado__Test_Run__c();
        testRun.copado__Status__c = status;
        testRun.copado__Type__c = type;
        testRun.copado__Test_Phase__c = testPhase;
        testRun.copado__Tester__c = userId;
        testRun.copado__Test_Script__c = testScriptId;
        testRun.copado__User_Story__c = userStoriesId;
        return testRun; 
    }
    public static amc__Project__c createMCProject(Account acct, Opportunity oppty, String prjName){
        amc__Project__c p = new amc__Project__c();
        
        p.amc__Account__c = acct.Id;
        p.amc__Opportunity__c = oppty.Id;
        p.Name = prjName;
        p.RecordTypeId = [SELECT Id FROM RecordType WHERE Name LIKE '%Guide%'].Id;
        p.amc__Category__c = 'Implementation';
        p.amc__Billing_Type__c = 'Fixed Price';
        p.Project_Type__c = 'Guide Me';
        p.amc__Hours_Per_Day__c = 8;
        p.amc__Project_Day_Rate__c = 'Standard';
        return p;
    }
    
    public static amc__Milestone__c createMCMilestone(amc__Project__c prj, String nr, amc__Role__c role){
        amc__Milestone__c ms = new amc__Milestone__c();
        
        ms.Name = 'Objective ' + nr;
        ms.amc__Status__c = 'In Progress';
        ms.amc__Project__c = prj.Id;
        ms.amc__Milestone_Owner__c = role.Id;
        
        return ms;
    }
    
    public static amc__Role__c createMCRole(User u){
        amc__Role__c role = new amc__Role__c();
        
        role.amc__Job_Title__c = 'Service Guy or Gal';
        role.CurrencyIsoCode = u.CurrencyIsoCode;
        role.amc__Hours_Per_Week__c = 40;
        role.amc__Billable_Target__c = 35;
        role.amc__Hourly_Rate__c = 200;
        
        return role;
    }
    
    public static amc__Action__c createMCAction(Account acct, amc__Milestone__c ms, amc__Role__c role, String nr){
        amc__Action__c an = new amc__Action__c();
        
        an.amc__Action_Name__c = 'TestAction ' + nr;
        an.amc__Action_Owner__c = role.Id;
        an.amc__Status__c = 'In Progress';
        an.amc__Milestone__c = ms.Id;
        an.amc__Start_Date__c = Date.today();
        an.amc__End_Date__c = Date.today().addDays(10);
        an.amc__Hours_Scheduled__c = 10*8;
        an.Account__c = acct.Id;
        
        return an;
    }
    
    public static amc__Time_Log__c createMCTimeLog(amc__Action__c action, Boolean isNonBillable, amc__Role__c role, Decimal hours ){
        amc__Time_Log__c tl = new amc__Time_Log__c();
        
        tl.amc__Action__c = action.Id;
        tl.amc__Project_Member__c = role.Id;
        tl.amc__Date__c = Date.today();
        tl.amc__Hours_Completed__c = hours;
        tl.amc__Non_Billable__c = isNonBillable == null? false : isNonBillable;
        
        return tl;
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
        return testKugamonSetting;
    }
    public static CHANNEL_ORDERS__Service_Order__c createChannelOrdersServiceOrder(){
        CHANNEL_ORDERS__Service_Order__c tempOrderService =  new CHANNEL_ORDERS__Service_Order__c();
        return TempOrderService;
    }
    public static CHANNEL_ORDERS__Service_Order_Detail__c createChannelOrdersServiceOrderDetail(){
        CHANNEL_ORDERS__Service_Order_Detail__c testServiceOrderDetail =  new CHANNEL_ORDERS__Service_Order_Detail__c();
        return TestServiceOrderDetail;
    }
    
    
    public static Payable_Invoice__c createPayableInvoice(Id accId, Id orderId, string status){
        Payable_Invoice__c testPayableInvoice =  new Payable_Invoice__c();
        testPayableInvoice.Invoice_Date__c = Date.newInstance(2015, 5, 1);
        testPayableInvoice.Invoice_Due_Date__c = Date.newInstance(2015, 5, 31);        
        testPayableInvoice.Status__c = status;
        testPayableInvoice.Account__c= accId;
        testPayableInvoice.Order__c = orderId;
        return testPayableInvoice ;
    }
    
    public static CHANNEL_ORDERS__Partner_Contract_Terms__c createPartnerContractTerms(String postfix){
        CHANNEL_ORDERS__Partner_Contract_Terms__c sfdcContract = new CHANNEL_ORDERS__Partner_Contract_Terms__c(
            Name='Copado '+postfix,
            CHANNEL_ORDERS__Allow_to_Sell_to_Existing_Org__c=true,
            CHANNEL_ORDERS__Default_Billing_Frequency__c=1,
            CHANNEL_ORDERS__Default_Cancellation_Terms__c=30,
            CHANNEL_ORDERS__Default_Contract_Auto_Renew__c='Yes',
            CHANNEL_ORDERS__Default_Contract_Currency__c='EUR',
            CHANNEL_ORDERS__Default_Contract_Length__c=1,
            CHANNEL_ORDERS__Default_Renewal_Length__c=1,
            CHANNEL_ORDERS__Override_Level__c='Order',
            CHANNEL_ORDERS__Partner_API_Key__c='cpdltd2',
            CHANNEL_ORDERS__Partner_Contract_Term_External_ID__c='Copado Ltd*_ISVForce_EUR2',
            CHANNEL_ORDERS__Type__c='ISVforce'
        );
        return sfdcContract;
    }
    
    public static CHANNEL_ORDERS__Partner_Product_Catalog__c createPartnerProductCatalog(String postfix,Id partnerContractTermId){
        CHANNEL_ORDERS__Partner_Product_Catalog__c soli1 = new CHANNEL_ORDERS__Partner_Product_Catalog__c(
            Name='Copado '+postfix,
            CHANNEL_ORDERS__Application__c='Copado Deployer',
            CHANNEL_ORDERS__Billing_Frequency__c=1,
            CHANNEL_ORDERS__Cancellation_Terms__c=30,
            CHANNEL_ORDERS__Contract_Auto_Renew__c='Yes',
            CHANNEL_ORDERS__Contract_Length__c=1,
            CHANNEL_ORDERS__Floor_Price__c=0,
            CHANNEL_ORDERS__PNR__c=15,
            //CHANNEL_ORDERS__Partner_Application_Name__c='Copado Deployer'
            CHANNEL_ORDERS__Partner_Contract_Terms__c=partnerContractTermId,
            CHANNEL_ORDERS__Pricing_Type__c='PNR',
            CHANNEL_ORDERS__Pricing_Unit__c='User',
            CHANNEL_ORDERS__Product_Description__c='some description',
            CHANNEL_ORDERS__Product_ID__c='CPDDP-EUR-ISVF-STD-USER-ENT2',
            CHANNEL_ORDERS__Renewal_Terms__c=1,
            CHANNEL_ORDERS__Special_Instructions__c='test',
            CHANNEL_ORDERS__Status__c='Active'
        );
        Return soli1;
    }
    
    public static OpportunityLineItem createOpportunityLineItem(Id opportunityId,Id pricebookEntryId){
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opportunityId, Quantity=2, UnitPrice=100, PricebookEntryId=pricebookEntryId, ServiceDate=Date.today());
        return oli;
    }
    
    
    
    
    public static copado__Release__c createCopadoRelease(String name){
        copado__Release__c rel = new copado__Release__c();
        rel.Name = name;      
        return rel;
    }
    
    public static copado__Environment__c createEnvironment(String name){
        copado__Environment__c env = new copado__Environment__c();
        env.Name = name;
        return env;
    }
    
    public static Salesforce_Org__c createSalesforceOrg(String name){
        Salesforce_Org__c sfdcOrg = new Salesforce_Org__c();
        sfdcOrg.Name = name;
        return sfdcOrg;
    }
    public static sfLma__Package__c craetePackage(String name){
        sfLma__Package__c pkge = new sfLma__Package__c();
        pkge.Name = name;
        return pkge;
    }
    public static sfLma__License__c createLicense(Id salesforceId,Integer seat){
        sfLma__License__c lic = new sfLma__License__c();
        lic.Salesforce_Org__c = salesforceId;
        lic.sfLma__Seats__c = seat;
        return lic;
    }
    public static sfFma__FeatureParameter__c createFeatureParameter(String fullName,String dataType,String nameSpace,String version,String dataFlow,Id packageId){
        sfFma__FeatureParameter__c featureParam = new sfFma__FeatureParameter__c();
        featureParam.sfFma__FullName__c = fullName;
        featureParam.sfFma__DataType__c = dataType;
        featureParam.sfFma__Namespace_Prefix__c = nameSpace;
        featureParam.sfFma__IntroducedInPackageVersion__c = version;
        featureParam.sfFma__DataFlowDirection__c = dataFlow;
        featureParam.sfFma__Package__c = packageId;
        return featureParam;
        
    }
    public static sfFma__FeatureParameterInteger__c createFeatureParameterInteger(String fullName,Id licenseId,Id featureParamId){
        sfFma__FeatureParameterInteger__c featureParamInt = new sfFma__FeatureParameterInteger__c();
        featureParamInt.sfFma__FullName__c = fullName;
        featureParamInt.sfFma__License__c = licenseId;
        featureParamInt.sfFma__FeatureParameter__c = featureParamId;
        return featureParamInt;
    }
    
    public static Copado_Settings__c createCopadoSetting(){
        Copado_Settings__c testCopadoSetting = new Copado_Settings__c();
        testCopadoSetting.Name = 'Default';
        return testCopadoSetting;
    }
    public static Knowledge__kav createKnowledgeArticle(String urlName,String title,String body){
        Knowledge__kav knv = New Knowledge__kav();
        knv.URLName = urlName;
        knv.Title = title;
        knv.Body__c = body;
        knv.IsVisibleInPkb = true;
        return knv;
    }
    
    public static redwing__Training_Track__c createTrainingTrack(String name,Id productId){
        redwing__Training_Track__c trainingTrack = new redwing__Training_Track__c();
        trainingTrack.Name = name;
        trainingTrack.redwing__Status__c ='Active';
        trainingTrack.ltcomm__Product__c = productId;
        trainingTrack.redwing__Enable_all_internal_users__c = TRUE;
        trainingTrack.redwing__Enable_all_external_accounts__c = TRUE;
        trainingTrack.redwing__Language__c ='en_US';
        RETURN trainingTrack;
    }
    Public static redwing__Training_Track_Level__c createTrainingTrackLevel(String name,String trainingTrackId){
        redwing__Training_Track_Level__c trainingTrackLevel = NEW redwing__Training_Track_Level__c();
        trainingTrackLevel.Name = name;
        trainingTrackLevel.redwing__Training_Track__c = trainingTrackId;
        RETURN trainingTrackLevel;
    }
    Public static redwing__Training_Plan__c createTrainingPlan(String name){
        redwing__Training_Plan__c trainingPlan = new redwing__Training_Plan__c();
        trainingPlan.Name = name;
        trainingPlan.redwing__Status__c = 'Active';
        trainingPlan.Is_Certification_Plan__c = TRUE;
        RETURN trainingPlan;
    }
    Public static redwing__Training_Track_Assignment__c createTrainingTrackAssignment(Id userId,Id contactId,Id trainingTrackId){
        redwing__Training_Track_Assignment__c trainingTrackAssignment = NEW redwing__Training_Track_Assignment__c();
        trainingTrackAssignment.redwing__User__c = userId;
        trainingTrackAssignment.redwing__Contact__c = contactId;
        trainingTrackAssignment.redwing__Status__c = 'In Progress';
        trainingTrackAssignment.redwing__Training_Track__c = trainingTrackId;
        RETURN trainingTrackAssignment;
    }
    public static redwing__Training_Plan_Assignment__c createTrainingPlanAssignment(Id userId,Id contactId,Id trainingPlanId){
        redwing__Training_Plan_Assignment__c trainingPlanAssignment = NEW redwing__Training_Plan_Assignment__c();
        trainingPlanAssignment.redwing__User__c = userId;
        trainingPlanAssignment.redwing__Contact__c = contactId;
        trainingPlanAssignment.redwing__Training_Plan__c = trainingPlanId;
        trainingPlanAssignment.redwing__Status__c = 'In Progress';
        trainingPlanAssignment.redwing__Progress_Percentage__c =  0.00;
        RETURN trainingPlanAssignment;
    }
    public static redwing__Training_Track_Level_Item__c createTrainingTrackLevelItem(Id trainingTrackLevelId,Id trainingPlanId){
        redwing__Training_Track_Level_Item__c trainingTrackLevelItem = NEW redwing__Training_Track_Level_Item__c();
        trainingTrackLevelItem.redwing__Training_Track_Level__c = trainingTrackLevelId;
        trainingTrackLevelItem.redwing__Training_Plan__c = trainingPlanId;
        RETURN trainingTrackLevelItem;
    }
    public static redwing__Learning__c createLearning(String name){
        redwing__Learning__c learning = new redwing__Learning__c();
        learning.Name   = name;
        learning.redwing__Published__c = true;
        RETURN learning;
    }
    public static redwing__ILT_Event__c createILTEvent(String name,Id iLTEventLearningId){
        redwing__ILT_Event__c iLTEvent = new redwing__ILT_Event__c();
        iLTEvent.redwing__Learning__c = iLTEventLearningId;
        iLTEvent.Name = name;
        RETURN iLTEvent;
    }
    public static redwing__ILT_Event_Class__c createILTEventClass(Id iLTEventId, Id iLTClassLearningId){
        redwing__ILT_Event_Class__c iLTEventClass = new redwing__ILT_Event_Class__c();
        iLTEventClass.redwing__ILT_Event__c = iLTEventId;
        iLTEventClass.redwing__Learning__c = iLTClassLearningId;
        RETURN iLTEventClass;
        
        
        
        
        
    }
    public static CollaborationGroup createCollaborationGroup(String name){
        CollaborationGroup cGroup = new CollaborationGroup();
        cGroup.Name=name;
        cGroup.CollaborationType= 'Public';
        RETURN cGroup;
    }
    
    
    
    public static redwing__ILT_Class__c createILTClass(String name,Id iLTClassLearningId){
        redwing__ILT_Class__c iLTClass = new redwing__ILT_Class__c();
        iLTClass.redwing__Learning__c = iLTClassLearningId;
        iLTClass.Name = name;
        iLTClass.redwing__Start_Date__c = system.today();
        iLTClass.redwing__End_Date__c = system.today().addDays(10);
        RETURN iLTClass;
    }
    public static redwing__Training_Plan_Section__c createTrainigPlanSection(String name,Id trainingPlanId){
        redwing__Training_Plan_Section__c trainingPlanSection = NEW redwing__Training_Plan_Section__c();
        trainingPlanSection.Name = 'Test';
        trainingPlanSection.redwing__Training_Plan__c =trainingPlanId;
        RETURN trainingPlanSection;
    }
    public static redwing__Training_Plan_Section_Item__c createTrainingPlanSectionItem(id learningId,Id trainingPlanSectionId){
        redwing__Training_Plan_Section_Item__c trainingPlanSectionItem = NEW redwing__Training_Plan_Section_Item__c();
        trainingPlanSectionItem.redwing__Learning__c = learningId;
        trainingPlanSectionItem.redwing__Training_Plan_Section__c = trainingPlanSectionId;
        RETURN trainingPlanSectionItem;
    }
    public static redwing__Training_Plan_Section_Assignment__c createTrainingPlanSectionAssignment(Id userId,Id trainingPlanSectionId,Id trainingPlanAssignmentId){
        redwing__Training_Plan_Section_Assignment__c trainingPlanSectionAssignment = NEW redwing__Training_Plan_Section_Assignment__c();
        trainingPlanSectionAssignment.redwing__User__c = userId;
        trainingPlanSectionAssignment.redwing__Status__c = 'In Progress';
        trainingPlanSectionAssignment.redwing__Training_Plan_Section__c = trainingPlanSectionId;
        trainingPlanSectionAssignment.redwing__Training_Plan_Assignment__c= trainingPlanAssignmentId;
        RETURN trainingPlanSectionAssignment;
    }
    public static redwing__Learning_Assignment__c createLearningAssignment(Id contactId,Id userId,Id trainingPlanId,Id learningId,Id trainingPlanSectionId,Id trainingPlanSectionAssignmentId,Id trainingPlanSectionItemId){
        redwing__Learning_Assignment__c learningAssignment = NEW redwing__Learning_Assignment__c();
        learningAssignment.redwing__Contact__c = contactId;
        learningAssignment.redwing__User__c = userId;
        learningAssignment.redwing__Progress__c = '';
        learningAssignment.redwing__Progress_Percentage__c = 0.00;
        learningAssignment.redwing__Evaluation_Times_Taken__c = 0;
        learningAssignment.redwing__Evaluation_Result__c = 'N/A';  
        learningAssignment.redwing__Progress__c = 'In Progress';
        learningAssignment.redwing__Training_Plan__c = trainingPlanId;
        learningAssignment.redwing__Learning__c = learningId;
        learningAssignment.redwing__Training_Plan_Section__c = trainingPlanSectionId;
        learningAssignment.redwing__Training_Plan_Section_Assignment__c =trainingPlanSectionAssignmentId;
        learningAssignment.redwing__Training_Plan_Section_Item__c = trainingPlanSectionItemId;
        learningAssignment.redwing__Times_Launched__c =1;
        learningAssignment.redwing__Evaluation_Score__c =1; 
        RETURN learningAssignment;
    }
    public static redwing__ILT_Roster__c createILTRoster(Id iLTClassId,Id userId,Id learningAssignmentId){
        redwing__ILT_Roster__c iLTRoster = new redwing__ILT_Roster__c();
        iLTRoster.redwing__ILT_Class__c = iLTClassId;
        iLTRoster.redwing__Attended__c = true;
        iLTRoster.redwing__Registered_Date__c = system.today();
        iLTRoster.redwing__User__c = userId;
        iLTRoster.redwing__Learning_Assignment__c = learningAssignmentId;
        RETURN iLTRoster;
    }
    
    public static Case createCase(string caseOrigin){
        Case cs = new Case();
        cs.Origin = caseOrigin;
        return cs;
    }
    
    public static Demo__c createDemo(){
        Demo__c meeting = new Demo__c();        
        return meeting;
    }
    
    
    
    
    
    
    
    public static Account_Email_Domain__c createAccountEmailDomain(string domain,Id accountId){
        Account_Email_Domain__c emailDomain = new Account_Email_Domain__c();
        emailDomain.Domain__c = domain;
        emailDomain.Account__c = accountId;
        return emailDomain;
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public static Academy_Certification_Program__c createCertificationProgram(){
        Academy_Certification_Program__c certificationProgram = new Academy_Certification_Program__c();
        certificationProgram.Name = 'TestCertificateProgram';
        certificationProgram.Copado_Version__c = 'V1';
        certificationProgram.Status__c = 'Valid';
        RETURN certificationProgram;
    }
    
    public static redwing__Achievement__c createAchievement(String achievementType, String certificationProgramId){
        redwing__Achievement__c achievement = new redwing__Achievement__c();
        achievement.Name = 'Test Achievement';
        achievement.redwing__Type__c = achievementType;
        achievement.Certification_Program__c = certificationProgramId;
        achievement.ReputationPoints__c =100;
        RETURN achievement;
    }
    
    public static redwing__Training_Plan_Achievement__c createTriningPlanAchievement(Id achievementId,Id trainingPlanId){
        redwing__Training_Plan_Achievement__c trainingPlanAchievement = new redwing__Training_Plan_Achievement__c();
        trainingPlanAchievement.redwing__Achievement__c = achievementId;
        trainingPlanAchievement.redwing__Training_Plan__c = trainingPlanId;
        RETURN trainingPlanAchievement;
    }
    
    public static redwing__Achievement_Assignment__c createAchievementAssignment(String contactId,String trainingPlanAchievementId,String achievementId){
        redwing__Achievement_Assignment__c achievementAssignment = new redwing__Achievement_Assignment__c();
        achievementAssignment.redwing__Contact__c =contactId;
        achievementAssignment.redwing__Training_Plan_Achievement__c =trainingPlanAchievementId;
        achievementAssignment.redwing__Achievement__c =achievementId;
        achievementAssignment.redwing__Acquisition_Date__c =System.today();
        achievementAssignment.redwing__Status__c ='achievementId';
        RETURN achievementAssignment;
    }
    
    public static Academy_Certification_Student__c createCertificationStudent(Contact con){
        Academy_Certification_Student__c certificationStudent = new Academy_Certification_Student__c();
        certificationStudent.Contact__c = con.Id;
        certificationStudent.Student_Email__c = con.Email;
        RETURN certificationStudent;
    }
    
    public static Academy_Certification_Examination__c createCertificationExam(String programId,String certificateId, String certificatoinStudentId){
        DateTime dt = System.now();
        Academy_Certification_Examination__c exam = new Academy_Certification_Examination__c();
        exam.Certification_Program__c= programId;
        exam.Certification_Student__c= certificatoinStudentId;
        exam.Academy_Certification2__c = certificateId;
        exam.Grade__c= 100;
        //exam.Date__c= dt.addYear(-1);
        exam.Status__c= 'Approved';
        RETURN exam;
    }
    
    public static Academy_Certification__c createCertification(String studentId, String programId){
        Academy_Certification__c certificate = new Academy_Certification__c();
        certificate.Certification_Student__c = studentId;
        certificate.Certification_Program__c = programId;
        certificate.Status__c = 'Expired';
        RETURN certificate;
    }
    
    public static Module__c createModule(String name){
        Module__c module = new Module__c();
        module.Name = name;
        insert module;
        return  module;
    }
    
    public static copado__Theme__c createTheme(String name){
        copado__Theme__c theme = new copado__Theme__c();
        theme.Name = name;
        insert theme;
        return  theme;
    }
    
    public static copado__Sprint__c createSprint(String name){
        copado__Sprint__c sprint = new copado__Sprint__c();
        sprint.Name = name;
        insert sprint;
        return  sprint;
    }
}