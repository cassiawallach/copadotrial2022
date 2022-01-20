/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FullcastErrorHandler implements System.Queueable {
    global String className;
    global String commaSepParams;
    global String dmlFieldName;
    global String dmlMessage;
    global String dmlType;
    global String errorMessage;
    global String errorType;
    global Integer lineNumber;
    global String methodName;
    global String stackTrace;
    global String transactionId;
    global FullcastErrorHandler() {

    }
    global FullcastErrorHandler(Exception e, String commaSepParams) {

    }
    global String AWSLambdaException(Exception e, String errCode) {
        return null;
    }
    global String DMLException(System.DmlException e, String errCode) {
        return null;
    }
    global String GenericException(Exception e) {
        return null;
    }
    global String JSONException(System.JSONException e, String errCode) {
        return null;
    }
    global String ListException(System.ListException e, String errCode) {
        return null;
    }
    global void LogException() {

    }
    global String NotifyException(String errCode, String errMsg) {
        return null;
    }
    global String NullPointerException(System.NullPointerException e, String errCode) {
        return null;
    }
    global String SObjectException(System.SObjectException e, String errCode) {
        return null;
    }
    global String TypeException(System.TypeException e, String errCode) {
        return null;
    }
    global void execute(System.QueueableContext context) {

    }
    global String policyException(Exception e, String errCode) {
        return null;
    }
}
