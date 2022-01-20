/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GlobalAPI {
    global GlobalAPI() {

    }
    @Future(callout=true)
    global static void asyncCallMDA(String url, String method, String requestBody, Map<String,String> additionalHeaders) {

    }
    global static void createSurveyCountsUpdateSchedule() {

    }
    global List<Id> deleteOpenTransactions(List<Id> transactionHeaderIds, Boolean deleteAllOrNone, Boolean updateCustomerInfo) {
        return null;
    }
    global List<JBCXM.GlobalAPI.GSTransaction> getTransactionsForOpportunites(String accountId, List<JBCXM.GlobalAPI.OpportunitySet> opportunitySets) {
        return null;
    }
    global List<Id> saveTransactions(List<JBCXM.GlobalAPI.GSTransaction> gsTransactions, Boolean saveAllOrNone, Boolean updateCustomerInfo) {
        return null;
    }
    global void setSettings(JBCXM.GlobalAPI.MappingSettings newSettings) {

    }
    global static void startGSDailyScheduleJob() {

    }
global class GSTransaction {
    global String bookingType;
    global List<String> childTransactions;
    global JBCXM__TransHeader__c header;
    global List<JBCXM__TransLines__c> lines;
    global List<String> parentTransactions;
    global String refId;
    global GSTransaction() {

    }
}
global class MappingSettings {
    global String churnToThisIfItIsNotLast;
    global Boolean completeDebookNotRenewable;
    global Boolean completeDownsellNotRenewable;
    global Boolean coTermIsDefault;
    global String defaultChurnReason;
    global Boolean loggingEnabled;
    global List<String> parentPreferenceOrder;
    global Boolean skipIfFirstIsNotNewBusiness;
    global Integer tolerableDaysDifference;
    global MappingSettings() {

    }
}
global class OpportunitySet {
    global String bookingType;
    global String opportunityId;
    global OpportunitySet() {

    }
}
}
