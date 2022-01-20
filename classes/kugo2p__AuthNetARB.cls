/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AuthNetARB {
    global AuthNetARB() {

    }
    webService static kugo2p.AuthNetARB.CancelSubscriptionRequestResult cancelSubscriptionRequest(String connectionId, String refId, String subscriptionId) {
        return null;
    }
    webService static kugo2p.AuthNetARB.CreateSubscriptionRequestResult createSubscriptionRequest(String connectionId, String refId, String subscriptionXML) {
        return null;
    }
    webService static kugo2p.AuthNetARB.UpdateSubscriptionRequestResult updateSubscriptionRequest(String connectionId, String refId, String subscriptionId, String subscriptionXML) {
        return null;
    }
global class CancelSubscriptionRequestResult {
    @WebService
    webService List<String> messages;
    @WebService
    webService String refId;
    @WebService
    webService String resultCode;
    @WebService
    webService String xml;
}
global class CreateSubscriptionRequestResult {
    @WebService
    webService List<String> messages;
    @WebService
    webService String refId;
    @WebService
    webService String resultCode;
    @WebService
    webService String subscriptionId;
    @WebService
    webService String xml;
}
global class UpdateSubscriptionRequestResult {
    @WebService
    webService List<String> messages;
    @WebService
    webService String refId;
    @WebService
    webService String resultCode;
    @WebService
    webService String xml;
}
}
