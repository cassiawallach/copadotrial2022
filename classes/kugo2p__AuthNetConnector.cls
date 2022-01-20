/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AuthNetConnector extends kugo2p.AuthNetConnectorBase {
    global AuthNetConnector() {

    }
    webService static kugo2p.PaymentX.TransactionResultExt capturePayment(Decimal amount, String paymentXId) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResultExt chargeCreditCard(String description, Decimal amount, String paymentXId, String invoiceNum, String poNum, Boolean emailCustomer, kugo2p.AuthNetAimAPI.CustomerInfo customerInfo, kugo2p.AuthNetAimAPI.ShippingInfo shippingInfo, String ccNumber, String ccExp, String ccCVV, String authCode, Boolean taxExempt, String authenticationIndicator, String cardholderAuthValue, Boolean authOnly) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResultExt processECheck(String eCheckType, String description, Decimal amount, String paymentXId, String invoiceNum, String poNum, Boolean emailCustomer, kugo2p.AuthNetAimAPI.CustomerInfo customerInfo, kugo2p.AuthNetAimAPI.ShippingInfo shippingInfo, String bankCheckNumber, String abaCode, String accountNumber, String acctType, String bankName, String bankAcctName, kugo2p.AuthNetAimAPI.ECheckOptFields eCheckExtraInfo) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResultExt refundTransaction(Decimal amount, String ccNumber, String paymentXId, String reason) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResultExt voidTransaction(String paymentXId, String reason) {
        return null;
    }
}
