/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TransactionLineModel extends AVA_MAPPER.ErrorResult {
    global Long boundaryOverrideId {
        get;
        set;
    }
    global String businessIdentificationNo {
        get;
        set;
    }
    global String certificateId {
        get;
        set;
    }
    global String customerUsageType {
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
    global List<AVA_MAPPER.TransactionLineDetailModel> details {
        get;
        set;
    }
    global Decimal discountAmount {
        get;
        set;
    }
    global Long discountTypeId {
        get;
        set;
    }
    global String entityUseCode {
        get;
        set;
    }
    global Decimal exemptAmount {
        get;
        set;
    }
    global Long exemptCertId {
        get;
        set;
    }
    global String exemptNo {
        get;
        set;
    }
    global Long id {
        get;
        set;
    }
    global Boolean isItemTaxable {
        get;
        set;
    }
    global Boolean isSSTP {
        get;
        set;
    }
    global String itemCode {
        get;
        set;
    }
    global Decimal lineAmount {
        get;
        set;
    }
    global List<AVA_MAPPER.TransactionLineLocationTypeModel> lineLocationTypes {
        get;
        set;
    }
    global String lineNumber {
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
    global Decimal quantity {
        get;
        set;
    }
    global String ref1 {
        get;
        set;
    }
    global String ref2 {
        get;
        set;
    }
    global Datetime reportingDate {
        get;
        set;
    }
    global String revAccount {
        get;
        set;
    }
    global AVA_MAPPER.Sourcing sourcing {
        get;
        set;
    }
    global Decimal tax {
        get;
        set;
    }
    global Decimal taxableAmount {
        get;
        set;
    }
    global Decimal taxCalculated {
        get;
        set;
    }
    global String taxCode {
        get;
        set;
    }
    global Long taxCodeId {
        get;
        set;
    }
    global Datetime taxDate {
        get;
        set;
    }
    global String taxEngine {
        get;
        set;
    }
    global Boolean taxIncluded {
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
    global Long transactionId {
        get;
        set;
    }
    global TransactionLineModel() {

    }
}
