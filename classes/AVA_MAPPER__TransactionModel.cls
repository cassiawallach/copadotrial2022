/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TransactionModel extends AVA_MAPPER.ErrorResult {
    global List<AVA_MAPPER.TransactionAddressModel> addresses {
        get;
        set;
    }
    global String adjustmentDescription {
        get;
        set;
    }
    global AVA_MAPPER.AdjustmentReason adjustmentReason {
        get;
        set;
    }
    global String batchCode {
        get;
        set;
    }
    global String businessIdentificationNo {
        get;
        set;
    }
    global String code {
        get;
        set;
    }
    global Long companyId {
        get;
        set;
    }
    global String country {
        get;
        set;
    }
    global String currencyCode {
        get;
        set;
    }
    global String customerUsageType {
        get;
        set;
    }
    global String customerVendorCode {
        get;
        set;
    }
    global String description {
        get;
        set;
    }
    global Long destinationAddressId {
        get;
        set;
    }
    global String email {
        get;
        set;
    }
    global String entityUseCode {
        get;
        set;
    }
    global Decimal exchangeRate {
        get;
        set;
    }
    global Datetime exchangeRateEffectiveDate {
        get;
        set;
    }
    global String exemptNo {
        get;
        set;
    }
    global List<AVA_MAPPER.TransactionModel> history {
        get;
        set;
    }
    global Long id {
        get;
        set;
    }
    global List<AVA_MAPPER.InvoiceMessage> invoiceMessages {
        get;
        set;
    }
    global Boolean isSellerImporterOfRecord {
        get;
        set;
    }
    global Long latencyTime {
        get;
        set;
    }
    global List<AVA_MAPPER.TransactionLineModel> lines {
        get;
        set;
    }
    global String locationCode {
        get;
        set;
    }
    global List<AVA_MAPPER.TransactionLocationTypeModel> locationTypes {
        get;
        set;
    }
    global Boolean locked {
        get;
        set;
    }
    global List<AVA_MAPPER.AvaTaxMessage> messages {
        get;
        set;
    }
    global Datetime modifiedDate {
        get;
        set;
    }
    global Long modifiedUserId {
        get;
        set;
    }
    global Long originAddressId {
        get;
        set;
    }
    global Map<String,String> parameters {
        get;
        set;
    }
    global Datetime paymentDate {
        get;
        set;
    }
    global String purchaseOrderNo {
        get;
        set;
    }
    global Boolean reconciled {
        get;
        set;
    }
    global String referenceCode {
        get;
        set;
    }
    global String region {
        get;
        set;
    }
    global String reportingLocationCode {
        get;
        set;
    }
    global String salespersonCode {
        get;
        set;
    }
    global String softwareVersion {
        get;
        set;
    }
    global AVA_MAPPER.DocumentStatus status {
        get;
        set;
    }
    global List<AVA_MAPPER.TransactionSummary> summary {
        get;
        set;
    }
    global Datetime taxDate {
        get;
        set;
    }
    global Decimal taxOverrideAmount {
        get;
        set;
    }
    global String taxOverrideReason {
        get;
        set;
    }
    global AVA_MAPPER.TaxOverrideTypeId taxOverrideType {
        get;
        set;
    }
    global Decimal totalAmount {
        get;
        set;
    }
    global Decimal totalExempt {
        get;
        set;
    }
    global Decimal totalTax {
        get;
        set;
    }
    global Decimal totalTaxable {
        get;
        set;
    }
    global Decimal totalTaxCalculated {
        get;
        set;
    }
    global Datetime transactionDate {
        get;
        set;
    }
    global AVA_MAPPER.DocumentType type {
        get;
        set;
    }
    global Long version {
        get;
        set;
    }
    global TransactionModel() {

    }
}
