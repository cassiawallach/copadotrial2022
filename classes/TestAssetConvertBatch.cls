@isTest
public class TestAssetConvertBatch {

    private static List<Account> createTestData(){
        
        Date lastYearStart = Date.newInstance(Date.today().addYears(-1).Year(), 1, 1);
        Date lastYearEnd   = Date.newInstance(Date.today().addYears(-1).Year(), 12, 31);
        Date thisYearStart = Date.newInstance(Date.today().Year(), 1, 1);
        Date thisYearEnd   = Date.newInstance(date.today().Year(), 12, 31);
        
        Account aNo = new Account(Name='Account NO HISTORY', Type='Corporate Entity');
        insert aNO;
        Account aWITH = new Account(Name='Account WITH HISTORY', Type='Corporate Entity');
        insert aWITH;
        
        List<Account> accounts = new List<Account>();
        accounts.add(aNO);
        accounts.add(aWITH);
        
        Product2 p1 = new Product2(Name='Enterprise Edition'); insert p1;
        Product2 p2 = new Product2(Name='Change Management'); insert p2;
        Product2 p3 = new Product2(Name='Branch Management'); insert p3;
        Product2 p4 = new Product2(Name='Selenium User'); insert p4;
        Product2 pUnsupported = new Product2(Name='Unsupported%$'); insert pUnsupported;
        
        List<Asset> assets = new List<Asset>();
        //Assets for WITH HISTORY
        assets.add(new Asset(Name='Enterprise Edition', AccountId=aWITH.Id, Product2Id=p1.Id, Quantity=1, PurchaseDate=lastYearStart, UsageEndDate=lastYearEnd, Status='Active'));
        assets.add(new Asset(Name='Change Management', AccountId=aWITH.Id, Product2Id=p2.Id, Quantity=1, PurchaseDate=lastYearStart, UsageEndDate=lastYearEnd, Status='Active'));
        assets.add(new Asset(Name='Branch Management', AccountId=aWITH.Id, Product2Id=p3.Id, Quantity=1, PurchaseDate=lastYearStart, UsageEndDate=lastYearEnd, Status='Active'));
        assets.add(new Asset(Name='Enterprise Edition', AccountId=aWITH.Id, Product2Id=p1.Id, Quantity=1, PurchaseDate=thisYearStart, UsageEndDate=thisYearEnd, Status='Active'));
        assets.add(new Asset(Name='Change Management', AccountId=aWITH.Id, Product2Id=p2.Id, Quantity=1, PurchaseDate=thisYearStart, UsageEndDate=thisYearEnd, Status='Active'));
        
        //Assets for NO HISTORY
        assets.add(new Asset(Name='Enterprise Edition', AccountId=aNO.Id, Product2Id=p1.Id, Quantity=1, PurchaseDate=thisYearStart, UsageEndDate=thisYearEnd, Status='Active'));
        assets.add(new Asset(Name='Change Management', AccountId=aNO.Id, Product2Id=p2.Id, Quantity=1, PurchaseDate=thisYearStart, UsageEndDate=thisYearEnd, Status='Active'));
        assets.add(new Asset(Name='Selenium User', AccountId=aNO.Id, Product2Id=p4.Id, Quantity=1, PurchaseDate=thisYearStart, UsageEndDate=thisYearEnd, Status='Active'));
        assets.add(new Asset(Name='Unsupported%$', AccountId=aNO.Id, Product2Id=pUnsupported.Id, Quantity=1, PurchaseDate=thisYearStart, UsageEndDate=thisYearEnd, Status='Active'));
        insert assets; 
        
        return accounts;
    }
    private static Account getAccountByName(String n){
        return [select Id, Name, Active_Products__c from Account where Name=:n limit 1];
    }
    private static List<Asset> getAssetsByAccountName(String accName, String status){
        return [select Id, Product2.Name, Account.Name, PurchaseDate, UsageEndDate, Status from Asset where Account.Name=:accName and Status=:status];
    }
    
    static testMethod void noContractHistory(){
        List<Account> accounts = createTestData();
        
        Account testAccount = new Account(Name='NOTHING AT ALL', Active_Products__c='Change Management;Branch Management');
        insert testAccount;
        accounts.add(testAccount);
        
		Test.startTest();
        List<Account> batch_scope = new List<Account>();
        batch_scope.addAll(accounts);
        AssetConvertBatch batchApex = new AssetConvertBatch();   
        Database.BatchableContext dbc;
        batchApex.start(dbc);
        batchApex.execute(dbc, batch_scope);
        batchApex.finish(dbc);
        Test.stopTest();    
        
        String result1 = getAccountByName('NOTHING AT ALL').Active_Products__c;
        system.assertEquals(null, result1);        
        
        String result2 = getAccountByName('Account NO HISTORY').Active_Products__c;
        system.debug('### 2 '+result2);
        system.assert(result2.contains('Enterprise Edition'));
        system.assert(result2.contains('Change Management'));
        system.assert(result2.contains('Selenium Testing'));
        system.assert( !result2.contains('Branch Management'));
    
        String result3 = getAccountByName('Account WITH HISTORY').Active_Products__c;
        system.debug('### 3 '+result3);
        system.assert(result3.contains('Enterprise Edition'));
        system.assert(result3.contains('Change Management'));
        system.assert( !result3.contains('Branch Management'));
        
        List<Asset> assets = getAssetsByAccountName('Account WITH HISTORY', 'Expired');
        system.assertEquals(3, assets.size());
        assets = getAssetsByAccountName('Account WITH HISTORY', 'Active');
        system.debug('### Assets 2: '+assets);
        system.assertEquals(2, assets.size());
    }
    
}