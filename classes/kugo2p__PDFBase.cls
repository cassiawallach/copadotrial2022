/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class PDFBase {
    global static Boolean AddCheckoutToInvoice {
        get;
    }
    global static Boolean AddOnlinePaymentDetailsinPDF {
        get;
    }
    global System.PageReference AuthorizeNetCheckout {
        get;
    }
    global String AuthorizeNetCheckoutUrl {
        get;
    }
    global String CompanyCity {
        get;
    }
    global String CompanyCountry {
        get;
    }
    global String CompanyFax {
        get;
    }
    global String CompanyName {
        get;
    }
    global String CompanyPhone {
        get;
    }
    global String CompanyPostalCode {
        get;
    }
    global String CompanyState {
        get;
    }
    global String CompanyStreet {
        get;
    }
    global String DefaultPaymentProcessorName {
        get;
        set;
    }
    global Boolean displayShipToInfo {
        get;
        set;
    }
    global User documentOwner {
        get;
    }
    global String downloadPDFURL {
        get;
    }
    global System.PageReference eWayCheckout {
        get;
    }
    global String eWayCheckoutUrl {
        get;
    }
    global String GoogleCheckoutUrl {
        get;
    }
    global Boolean hasError {
        get;
    }
    global Boolean isMultiCurrencyEnabled {
        get;
    }
    global String ISOCurrencyCode {
        get;
    }
    global String LogoUrl {
        get;
    }
    global Organization OrgInfo {
        get;
    }
    global String PaymentURL {
        get;
    }
    global String PaypalCheckoutUrl {
        get;
    }
    global Set<Id> PDFIds {
        get;
        set;
    }
    global String renderAs {
        get;
    }
    global Boolean renderPaymentButton {
        get;
    }
    global kugo2p__KugamonSetting__c settings {
        get;
    }
    global Integer totalPDFsToPrint {
        get;
        set;
    }
    global System.PageReference WorldPayCheckout {
        get;
    }
    global String WorldPayCheckoutUrl {
        get;
    }
    global PDFBase() {

    }
    global System.PageReference defaultCheckout() {
        return null;
    }
}
