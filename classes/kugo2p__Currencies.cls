/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Currencies {
    global static Map<String,kugo2p.Currencies.KugCurrencyType> ActiveCurrencies {
        get;
    }
    global static Map<String,kugo2p.Currencies.KugCurrencyType> AllCurrencies {
        get;
    }
    global static String DefaultOrgCurrencyCode {
        get;
    }
    global static String DefaultUserCurrencyCode {
        get;
    }
    global static Boolean isMultiCurrencyEnabled {
        get;
    }
    global Currencies() {

    }
    global static void assignCurrencyIsoCode(SObject obj_to, SObject obj_from) {

    }
    global static void assignCurrencyIsoCode(SObject obj_to, String isoCode) {

    }
    global static Decimal convertCurrency(Decimal amount, String fromCurrency, String toCurrency) {
        return null;
    }
    global static String getRecordCurrencyCode(SObject obj) {
        return null;
    }
    global static Boolean isCurrencyActive(String isoCode) {
        return null;
    }
    global static Boolean isCurrencyExisting(String isoCode) {
        return null;
    }
    global static String soqlConvertCurrencyWrapper(String fieldName) {
        return null;
    }
}
