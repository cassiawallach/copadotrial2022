/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/FullcastPolicyHandler/*')
global class FullcastPolicyHandler {
    global FullcastPolicyHandler() {

    }
    @HttpDelete
    global static String doDelete() {
        return null;
    }
    @HttpGet
    global static String doGet() {
        return null;
    }
    @HttpPost
    global static String doPost(fcio1.FullcastPolicyHandler.RequestHeader header, String body) {
        return null;
    }
    @HttpPut
    global static String doPut() {
        return null;
    }
    @InvocableMethod(label='Policy Handler' description='To handle various policies')
    global static void policyHandlerMethod(List<fcio1.FullcastPolicyHandler.PolicyHandlerParams> params) {

    }
global class PolicyHandlerParams {
    @InvocableVariable( required=false)
    global String inputVal1;
    @InvocableVariable( required=false)
    global String inputVal2;
    @InvocableVariable( required=false)
    global String inputVal3;
    @InvocableVariable( required=false)
    global String inputVal4;
    @InvocableVariable( required=false)
    global String inputVal5;
    @InvocableVariable( required=true)
    global String policyType;
    @InvocableVariable( required=true)
    global Id recordId;
    global PolicyHandlerParams() {

    }
}
global class PostResponseWrapper {
    global PostResponseWrapper() {

    }
}
global class RequestHeader {
    global String Crud {
        get;
        set;
    }
    global String GTMType {
        get;
        set;
    }
    global String NodeId {
        get;
        set;
    }
    global String PolicyId {
        get;
        set;
    }
    global String PolicyName {
        get;
        set;
    }
    global String Status {
        get;
        set;
    }
    global String Type {
        get;
        set;
    }
}
}
