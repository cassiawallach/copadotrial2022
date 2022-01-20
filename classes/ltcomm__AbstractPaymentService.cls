/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AbstractPaymentService {
    global List<Map<String,Object>> formSettings;
    global ltcomm.AbstractPaymentService.PAYMENT_TYPE paymentType;
    global AbstractPaymentService() {

    }
    global abstract String approvePayment(String param0, String param1);
    global static ltcomm.AbstractPaymentService createPaymentService(Map<String,String> paramSettings) {
        return null;
    }
    global abstract String createPayment(String param0, String param1, List<ltcomm.ShoppingCartItem> param2, String param3, String param4);
    global abstract String getAccessToken(String param0);
    global String getClassName() {
        return null;
    }
    global String getMerchantID() {
        return null;
    }
    global String getName() {
        return null;
    }
    global String getReturnUrl() {
        return null;
    }
    global String getSecurityKey() {
        return null;
    }
    global String getTargetUrl() {
        return null;
    }
    global abstract String refundTransaction(String param0);
global enum PAYMENT_TYPE {FORM, REDIRECT}
}
