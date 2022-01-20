/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PaymentX {
    global PaymentX() {

    }
    webService static String isAlive() {
        return null;
    }
    webService static kugo2p.PaymentX.TaxLookupResponse stateProvinceTaxLookup(String country, String state) {
        return null;
    }
    webService static kugo2p.PaymentX.APIPostResult testAPICall(String notification, String origin) {
        return null;
    }
    webService static String testNotificationHandler(String connectionId) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResult triggerTaxCalculation(String paymentXId, String taxMethod) {
        return null;
    }
global class APIPostResult {
    @WebService
    webService String message;
    @WebService
    webService Boolean success;
    global APIPostResult() {

    }
}
global class CustomerInfo {
    @WebService
    webService String address;
    @WebService
    webService String city;
    @WebService
    webService String company;
    @WebService
    webService String country;
    @WebService
    webService String custId;
    @WebService
    webService String customerIP;
    @WebService
    webService String email;
    @WebService
    webService String fax;
    @WebService
    webService String firstname;
    @WebService
    webService String lastname;
    @WebService
    webService String phone;
    @WebService
    webService String postalCode;
    @WebService
    webService String state;
    global CustomerInfo() {

    }
}
global class ShippingInfo {
    @WebService
    webService String address;
    @WebService
    webService String city;
    @WebService
    webService String company;
    @WebService
    webService String country;
    @WebService
    webService String firstname;
    @WebService
    webService String lastname;
    @WebService
    webService String phone;
    @WebService
    webService String postalCode;
    @WebService
    webService String state;
    global ShippingInfo() {

    }
}
global class TaxLookupResponse {
    @WebService
    webService Integer errorCode;
    @WebService
    webService String message;
    @WebService
    webService Boolean success;
    @WebService
    webService Decimal value;
}
global class TransactionResult {
    @WebService
    webService Integer errorCode;
    @WebService
    webService String id;
    @WebService
    webService String message;
    @WebService
    webService Boolean success;
}
global class TransactionResultExt {
    @WebService
    webService Integer pxErrorCode;
    @WebService
    webService String pxId;
    @WebService
    webService String pxMessage;
    @WebService
    webService Boolean pxSuccess;
    @WebService
    webService String transErrorCode;
    @WebService
    webService String transMessage;
    @WebService
    webService String transResult;
}
}
