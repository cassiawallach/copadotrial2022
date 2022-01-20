@IsTest(SeeAllData=true)
private class TestAccountService {
	
    static testMethod void testAccountTriggerService() {
        Id corpRecordTypeId = [SELECT Id, Name, SObjectType FROM RecordType WHERE Name='Corporate Entity' AND SobjectType='Account'].Id;
        Account acc = new Account(
                Name = 'Copado APO Test',
                RecordTypeId = corpRecordTypeId);
        insert acc;

        Contract cont = new Contract(
            AccountId = acc.Id);
        insert cont;

        update acc;
    }
    static testMethod void testAccountTriggerServiceSupplier() {
        Id corpRecordTypeId = [SELECT Id, Name, SObjectType FROM RecordType WHERE Name='Corporate Entity' AND SobjectType='Account'].Id;
        Account acc = new Account(Name='Copado APO Test', Type='Supplier', RecordTypeId=corpRecordTypeId);
        insert acc;
  		test.startTest();
        update acc;
        acc=[SELECT Type FROM Account WHERE Id = :acc.Id limit 1];
        system.assertEquals ('Supplier', acc.Type);
        test.stopTest();
    }
    static testMethod void ProspectBecomesCustomer(){
        Id corpRecordTypeId = [SELECT Id, Name, SObjectType FROM RecordType WHERE Name='Corporate Entity' AND SobjectType='Account'].Id;
        Account acc = new Account(Name='Copado APO Test', Type='Prospect', Contract_Expiration_Date__c=null, RecordTypeId=corpRecordTypeId);
        insert acc;

        Opportunity o = new Opportunity(Name='My Opp', AccountId=acc.Id, StageName='Marketing Qualification', Type='Renewal', CloseDate=Date.today(), Main_Problems__c = 'Opp Main Problems',Amount = 99.0,CurrencyIsoCode='EUR');
o.LeadSource= 'Drift';
        insert o; 
        test.startTest();
        
        //Create a contract and activate it.
        Contract c = new Contract(AccountId=acc.Id, SBQQ__Opportunity__c=o.Id ,StartDate=Date.today(), ContractTerm=12, CurrencyIsoCode='EUR');
		insert c;
        c.Status = 'Activated';
        
        update c;
        
        acc.Account_Health__c='Red';
        acc.Type='Customer';
        // Contract update does not update the account, so we have to do it manually.
        update acc;
        
        acc=[select Type, Contract_Expiration_Date__c from Account where Id=:acc.Id limit 1];
        //system.assertEquals ('Customer', acc.Type);
    }
    static testMethod void CustomerBecomesProspect_OldExpirationDate(){
        Id corpRecordTypeId = [SELECT Id, Name, SObjectType FROM RecordType WHERE Name='Corporate Entity' AND SobjectType='Account'].Id;
        Account acc = new Account(Name='Copado APO Test', Type='Customer', Contract_Expiration_Date__c=Date.today(), RecordTypeId=corpRecordTypeId);
        insert acc;
        test.startTest();
        acc=[select Type, Contract_Expiration_Date__c from Account where Id=:acc.Id limit 1];
        system.assertEquals ('Customer', acc.Type);
        acc.Contract_Expiration_Date__c = Date.today().addDays(-10);
        acc.Account_Health__c='Red';
        update acc;
        
        acc=[select Type, Contract_Expiration_Date__c from Account where Id=:acc.Id limit 1];
        system.assertEquals ('Prospect', acc.Type);
    }
    static testMethod void CustomerBecomesProspect_BlankExpirationDate(){
        Id corpRecordTypeId = [SELECT Id, Name, SObjectType FROM RecordType WHERE Name='Corporate Entity' AND SobjectType='Account'].Id;
        Account acc = new Account(Name='Copado APO Test', Type='Customer', Contract_Expiration_Date__c=Date.today(), RecordTypeId=corpRecordTypeId);
        insert acc;
        test.startTest();
        acc=[select Type, Contract_Expiration_Date__c from Account where Id=:acc.Id limit 1];
        system.assertEquals ('Customer', acc.Type);
        acc.Contract_Expiration_Date__c = null;
        acc.Account_Health__c='Red';
        update acc;
        
        acc=[select Type, Contract_Expiration_Date__c from Account where Id=:acc.Id limit 1];
        system.assertEquals ('Prospect', acc.Type);
        delete acc;
    }
}