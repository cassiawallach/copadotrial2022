/**
 * Created by kheidt on 26/01/2018.
 */

global class CPQMigrationBatch implements Database.Batchable<sObject>{

    private String query = '';
    private Boolean isTest = false;

    global CPQMigrationBatch(){
        this(false);
    }

    global CPQMigrationBatch(Boolean testStatus){
        isTest = testStatus;
        constructQuery();
    }

    private String constructQuery(){
        query += 'SELECT Id, Name, ContractNumber ';
        query += ' FROM Contract ';
        query += ' WHERE Status = \'Activated\'';
        System.debug('query: ' + query);
        return query;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('query: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){

        CPQMigrationService cms = new CPQMigrationService(isTest);
        List<Contract> contracts = (List<Contract>)scope;
        System.debug('Contracts to be processed: ' + contracts);

        for(Contract c : contracts){
            cms.convertClientToCPQ(c.ContractNumber);
        }
    }

    global void finish(Database.BatchableContext BC){
    }
}