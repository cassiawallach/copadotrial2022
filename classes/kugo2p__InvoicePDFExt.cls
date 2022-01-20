/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InvoicePDFExt extends kugo2p.PDFBase {
    global Boolean accHaveDescriptions {
        get;
    }
    global Boolean accHaveTax {
        get;
    }
    global Account account {
        get;
        set;
    }
    global String button1 {
        get;
        set;
    }
    global String button2 {
        get;
        set;
    }
    global Integer ChargeCreditLineCount {
        get;
    }
    global Boolean displayInvoiceOrderTermsAccepted {
        get;
    }
    global Boolean displayShipmentInfo {
        get;
        set;
    }
    global Boolean hasError {
        get;
    }
    global Boolean hasServiceLines {
        get;
    }
    global Boolean hasShipments {
        get;
    }
    global Boolean hasShipmentsWithCarrier {
        get;
    }
    global kugo2p__KugamonInvoice__c Invoice {
        get;
        set;
    }
    global Id invoiceIdValue {
        get;
        set;
    }
    global Integer InvoiceLineCount {
        get;
    }
    global List<kugo2p.InvoicePDFExt.PDFInvoiceLine> InvoiceLines {
        get;
    }
    global List<kugo2p.OrderPDFExt.OrderTermsAccepted> InvoiceOrderTermsAccepted {
        get;
    }
    global List<kugo2p__KugamonInvoice__c> invoices {
        get;
        set;
    }
    global List<kugo2p__Shipment__c> InvoiceShipments {
        get;
    }
    global List<kugo2p__Shipment__c> InvoiceShipmentsWithCarrier {
        get;
        set;
    }
    global Boolean linesHaveDescriptions {
        get;
        set;
    }
    global Boolean linesHaveTax {
        get;
        set;
    }
    global List<kugo2p__PaymentX__c> payments {
        get;
        set;
    }
    global InvoicePDFExt() {

    }
    global InvoicePDFExt(ApexPages.StandardController stdController) {

    }
    global InvoicePDFExt(ApexPages.StandardSetController setController) {

    }
    global String getAcceptAndPayOnline() {
        return null;
    }
    global String getCheckout() {
        return null;
    }
    global void initOnlineInvoice() {

    }
global class PDFInvoiceLine {
    global String hasTaxVAT {
        get;
        set;
    }
    global kugo2p__KugamonInvoiceLine__c InvoiceLine {
        get;
        set;
    }
    global kugo2p.OrderPDFExt.OrderTermsAccepted orderTermsAccepted {
        get;
        set;
    }
    global kugo2p__AdditionalProductDetail__c Product {
        get;
        set;
    }
    global kugo2p__SalesOrder__c SalesOrder {
        get;
        set;
    }
    global kugo2p__SalesOrderServiceLine__c tempServiceLine {
        get;
        set;
    }
    global PDFInvoiceLine(kugo2p__KugamonInvoiceLine__c invline) {

    }
}
}
