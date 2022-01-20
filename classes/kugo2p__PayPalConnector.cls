/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PayPalConnector extends kugo2p.PayPalConnectorBase {
    global PayPalConnector() {

    }
    webService static kugo2p.PaymentX.TransactionResultExt capturePayment(Boolean complete, Double amount, String paymentXId, String invoiceNum, String note) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResultExt chargeCreditCard(String description, Decimal amount, String paymentXId, String invoiceNum, kugo2p.PayPalAPI.CustomerInfo customerInfo, kugo2p.PayPalAPI.ShippingInfo shippingInfo, String ccNumber, String ccType, String ccExp, String ccCVV, kugo2p.PayPalAPI.LineItemInfo lineItems, Decimal itemAmt, Decimal shippingAmt, Decimal handlingAmt, Decimal taxAmt, Boolean authOnly) {
        return null;
    }
    webService static kugo2p.PayPalConnector.CreateRecurringPaymentsProfileResult createRecurringPaymentsProfile(String connectionId, String requestParms) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResultExt getRecurringPaymentsProfileDetails(String profileId, String processorConnection, String format) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResultExt getTransactionDetails(String transactionId) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResultExt manageRecurringPaymentsProfileStatus(String profileId, String processorConnection, String action, String note) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResultExt refundTransaction(Boolean fullRefund, Double amount, String paymentXId, String note) {
        return null;
    }
    webService static kugo2p.PaymentX.TransactionResultExt voidAuthorization(String authorizationId, String paymentXId, String note) {
        return null;
    }
global class CreateRecurringPaymentsProfileResult {
    @WebService
    webService List<String> messages;
    @WebService
    webService String profileId;
    @WebService
    webService String response;
    @WebService
    webService String resultCode;
    @WebService
    webService String status;
}
}
