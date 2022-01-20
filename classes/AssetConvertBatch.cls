global class AssetConvertBatch implements Database.Batchable<sObject>{
    
    global AssetConvertBatch(){}
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select Id, Active_Products__c from Account where RecordType.Name='Corporate Entity']);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id, Set<String>> activeProductsMapSet = new Map<Id, Set<String>>();
        
        for(sObject o : scope){
            Account a = (Account)o;
            accountIdSet.add(a.Id);
            activeProductsMapSet.put(a.Id, new Set<String>());
        }
        
        List<Asset> assets = [select Id, Product2.Name, AccountId, PurchaseDate, UsageEndDate from Asset where AccountId IN :accountIdSet];
        Set<String> allowedProducts = new Set<String>{'Professional Edition', 'Enterprise Edition', 'Unlimited Edition', 'Change Management', 'Branch Management', 'Selenium User'};
        
        for(Asset ass : assets){
            if(Date.today() > ass.UsageEndDate){
                ass.Status = 'Expired';
            }
            else{
                if(allowedProducts.contains(ass.Product2.Name)){
                    String productName = (ass.Product2.Name=='Selenium User')?'Selenium Testing':ass.Product2.Name;
                    ass.Status = 'Active';
                    Set<String> aps = activeProductsMapSet.get(ass.AccountId);
                    aps.add(productName);
                    activeProductsMapSet.put(ass.AccountId, aps);
                }   
            }              
        }
        
        List<Account> updates = new List<Account>();
        for(Id i : activeProductsMapSet.KeySet()){
            Account acc = new Account(Id=i);
            
            List<String> s = new List<String>();
            s.addAll(activeProductsMapSet.get(i));
            acc.Active_Products__c = String.join(s, ';');
            updates.add(acc);
        }
        update assets;
        update updates;
    }
    global void finish(Database.BatchableContext BC){}
}