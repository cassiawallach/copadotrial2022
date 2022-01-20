/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class OrderPDFExt extends kugo2p.PDFBase {
    global String acceptedBy {
        get;
        set;
    }
    global Boolean acceptTerms {
        get;
        set;
    }
    global List<kugo2p__SalesOrderAdditionalChargeCredit__c> ACCLines {
        get;
    }
    global Account account {
        get;
        set;
    }
    global Boolean accsHaveDescriptions {
        get;
        set;
    }
    global Boolean accsHaveTax {
        get;
        set;
    }
    global String approvalWarning {
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
    global Boolean disableAcceptButton {
        get;
    }
    global Boolean hasError {
        get;
    }
    global Boolean hasOrderLineGroups {
        get;
        set;
    }
    global Boolean hasProductTextandTerms {
        get;
        set;
    }
    global String initialBy {
        get;
        set;
    }
    global String InitialedBy {
        get;
    }
    global Boolean isPdf {
        get;
    }
    global kugo2p__SalesOrder__c Order {
        get;
        set;
    }
    global Id orderIdValue {
        get;
        set;
    }
    global User owner {
        get;
    }
    global List<kugo2p__PaymentX__c> payments {
        get;
        set;
    }
    global Integer ProductLineCount {
        get;
    }
    global List<kugo2p.OrderPDFExt.OrderLine> ProductLines {
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
    global Integer ServiceLineCount {
        get;
    }
    global List<kugo2p.OrderPDFExt.OrderLine> ServiceLines {
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
    global Boolean showAcceptedByNameErrorBlock {
        get;
        set;
    }
    global Boolean showInitialByErrorBlock {
        get;
        set;
    }
    global Boolean showTermsErrorBlock {
        get;
        set;
    }
    global String SignatureUrl {
        get;
    }
    global kugo2p.OrderPDFExt.OrderTermsAccepted TermsAccepted {
        get;
        set;
    }
    global String TermsAcceptedBy {
        get;
    }
    global String TermsAcceptedDate {
        get;
    }
    global String TermsAcceptedFromIPAddress {
        get;
    }
    global Task TermsAcceptedTask {
        get;
        set;
    }
    global OrderPDFExt() {

    }
    global OrderPDFExt(ApexPages.StandardController stdController) {

    }
    global System.PageReference acceptAndPayOnline() {
        return null;
    }
    global System.PageReference checkout() {
        return null;
    }
    global Boolean checksAndTaskCreation() {
        return null;
    }
    global List<kugo2p.OrderPDFExt.OrderLineGroupWrapper> getOrderLineGroupWrapperList() {
        return null;
    }
    global void initOnlineOrder() {

    }
global class OrderLine implements System.Comparable {
    global Boolean IsPriceIncluded {
        get;
    }
    global kugo2p__AdditionalProductDetail__c Product {
        get;
        set;
    }
    global kugo2p__SalesOrderProductLine__c ProductLine {
        get;
        set;
    }
    global String ProductName {
        get;
        set;
    }
    global kugo2p__SalesOrderServiceLine__c ServiceLine {
        get;
        set;
    }
    global String UnitTermAbbr {
        get;
    }
    global OrderLine(kugo2p__SalesOrderProductLine__c line) {

    }
    global OrderLine(kugo2p__SalesOrderServiceLine__c line) {

    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class OrderLineGroupWrapper {
    global Boolean hasLineDescription {
        get;
    }
    global Boolean hasServiceLine {
        get;
    }
    global List<kugo2p.OrderPDFExt.OrderLine> lineGroupMembers {
        get;
        set;
    }
    global kugo2p__OrderLineGroup__c orderLineGroup {
        get;
        set;
    }
    global OrderLineGroupWrapper(kugo2p__OrderLineGroup__c pOrderLineGroup) {

    }
}
global class OrderTermsAccepted {
    global String InitialedBy {
        get;
    }
    global String orderName {
        get;
        set;
    }
    global String TermsAcceptedBy {
        get;
    }
    global String TermsAcceptedDate {
        get;
    }
    global String TermsAcceptedFromIPAddress {
        get;
    }
    global Task TermsAcceptedTask;
    global OrderTermsAccepted(Task t) {

    }
    global OrderTermsAccepted(Task t, String name) {

    }
}
}
