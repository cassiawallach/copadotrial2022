/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class QuotePDFExt extends kugo2p.PDFBase {
    global Boolean accHaveDescriptions {
        get;
    }
    global Boolean accHaveTax {
        get;
    }
    global Integer ChargeCreditLineCount {
        get;
    }
    global Boolean hasProductTextandTerms {
        get;
        set;
    }
    global Boolean hasQuoteLineGroups {
        get;
        set;
    }
    global List<kugo2p.QuotePDFExt.QuoteLine> OptionalLines {
        get;
    }
    global String optionalProductTitle {
        get;
        set;
    }
    global Boolean optionalsHaveDescriptions {
        get;
        set;
    }
    global Boolean optionalsHaveProduct {
        get;
        set;
    }
    global Boolean optionalsHaveService {
        get;
        set;
    }
    global User owner {
        get;
    }
    global Integer ProductLineCount {
        get;
    }
    global List<kugo2p.QuotePDFExt.QuoteLine> ProductLines {
        get;
    }
    global List<kugo2p__AdditionalProductDetail__c> Products {
        get;
        set;
    }
    global Boolean productsHaveDescriptions {
        get;
        set;
    }
    global Boolean productsHaveTax {
        get;
        set;
    }
    global kugo2p__SalesQuote__c Quote {
        get;
        set;
    }
    global Id quoteIdValue {
        get;
        set;
    }
    global Integer ServiceLineCount {
        get;
    }
    global List<kugo2p.QuotePDFExt.QuoteLine> ServiceLines {
        get;
    }
    global Boolean servicesHaveDescriptions {
        get;
        set;
    }
    global Boolean servicesHaveTax {
        get;
        set;
    }
    global QuotePDFExt() {

    }
    global QuotePDFExt(ApexPages.StandardController stdController) {

    }
    global List<kugo2p.QuotePDFExt.QuoteLineGroupWrapper> getQuoteLineGroupWrapperList() {
        return null;
    }
global class QuoteLine implements System.Comparable {
    global Boolean IsPriceIncluded {
        get;
    }
    global kugo2p__SalesQuoteOptionalLine__c OptionalLine {
        get;
        set;
    }
    global kugo2p__AdditionalProductDetail__c Product {
        get;
        set;
    }
    global kugo2p__SalesQuoteProductLine__c ProductLine {
        get;
        set;
    }
    global String ProductName {
        get;
        set;
    }
    global kugo2p__SalesQuoteServiceLine__c ServiceLine {
        get;
        set;
    }
    global String UnitTermAbbr {
        get;
    }
    global QuoteLine(kugo2p__SalesQuoteOptionalLine__c line) {

    }
    global QuoteLine(kugo2p__SalesQuoteProductLine__c line) {

    }
    global QuoteLine(kugo2p__SalesQuoteServiceLine__c line) {

    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class QuoteLineGroupWrapper {
    global Boolean hasLineDescription {
        get;
    }
    global Boolean hasServiceLine {
        get;
    }
    global List<kugo2p.QuotePDFExt.QuoteLine> lineGroupMembers {
        get;
        set;
    }
    global kugo2p__QuoteLineGroup__c quoteLineGroup {
        get;
        set;
    }
    global QuoteLineGroupWrapper(kugo2p__QuoteLineGroup__c pQuoteLineGroup) {

    }
}
}
