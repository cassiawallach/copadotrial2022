/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GoogleConnector {
    global GoogleConnector() {

    }
    webService static String authorizeOrder(String orderNumber) {
        return null;
    }
    webService static String cancelOrder(String orderNumber, String reason, String comment) {
        return null;
    }
    webService static String chargeOrder(String orderNumber, String amount, String currencyCode) {
        return null;
    }
    webService static String encodedGoogleCheckoutURL(String cartXML) {
        return null;
    }
    webService static kugo2p.GoogleConnector.PostCartResult postCartXML(String cartXML, String processorConnectionId, Boolean diagnose) {
        return null;
    }
    webService static String refundOrder(String orderNumber, String amount, String currencyCode, String reason, String comment) {
        return null;
    }
global class PostCartResult {
    @WebService
    webService Integer errorCode;
    @WebService
    webService String message;
    @WebService
    webService String redirectURL;
    @WebService
    webService Boolean success;
    @WebService
    webService String xml;
}
}
