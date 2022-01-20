/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AccountContactAddressBatcher implements Database.Batchable<SObject> {
    global Set<Id> contactIds;
    global Map<Id,Account> oldMap;
    global String query;
    global Account theAccount;
    global AccountContactAddressBatcher(kugadd.AccountContactAddressBatcher.BatcherTransactionType transType) {

    }
    global AccountContactAddressBatcher(String q, kugadd.AccountContactAddressBatcher.BatcherTransactionType transType) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
global enum BatcherTransactionType {accountTrans, contactAddressPhoneTrans, contactPhoneTrans, contactTrans}
}
