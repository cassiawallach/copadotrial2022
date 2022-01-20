/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class JBaraAPI {
    global JBaraAPI() {

    }
    webService static String addAdoptionInformation(JBCXM.JBaraAPI.WebAdoptionInformation adoptionItem) {
        return null;
    }
    webService static String addNPSResponse(JBCXM.JBaraAPI.WebNPSResponse responseItem) {
        return null;
    }
    webService static String addUsageInformation(JBCXM.JBaraAPI.WebUsageInformation usageTrackerItem) {
        return null;
    }
    @ReadOnly
    webService static String getReport(JBCXM.JBaraAPI.RequestInformation requestInfo) {
        return null;
    }
global class RequestInformation {
    webService String actionType {
        get;
        set;
    }
    webService String params {
        get;
        set;
    }
    webService String reportId {
        get;
        set;
    }
    global RequestInformation() {

    }
}
global class WebAdoptionInformation {
    webService String accountReferenceValue {
        get;
        set;
    }
    webService String adoptionDate {
        get;
        set;
    }
    webService String measureSystemName {
        get;
        set;
    }
    webService Integer measureValue {
        get;
        set;
    }
    global WebAdoptionInformation() {

    }
}
global class WebNPSResponse {
    webService String accountReferenceValue {
        get;
        set;
    }
    webService String asociatedRecordValue {
        get;
        set;
    }
    webService String responseComment {
        get;
        set;
    }
    webService String responseDate {
        get;
        set;
    }
    webService Integer responseScore {
        get;
        set;
    }
    webService String responseSurveyCode {
        get;
        set;
    }
    webService String responseUserEmail {
        get;
        set;
    }
    webService String responseUserName {
        get;
        set;
    }
    webService String responseUserRole {
        get;
        set;
    }
    global WebNPSResponse() {

    }
}
global class WebUsageInformation {
    webService String accountReferenceValue {
        get;
        set;
    }
    webService String actionTime {
        get;
        set;
    }
    webService String browserName {
        get;
        set;
    }
    webService String browserResolution {
        get;
        set;
    }
    webService String comments {
        get;
        set;
    }
    webService String deviceName {
        get;
        set;
    }
    webService String ipAddress {
        get;
        set;
    }
    webService String measureSystemName {
        get;
        set;
    }
    webService String moduleName {
        get;
        set;
    }
    webService String usageUserName {
        get;
        set;
    }
    global WebUsageInformation() {

    }
}
}
