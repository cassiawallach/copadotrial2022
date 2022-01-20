/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CEHandler {
    global CEHandler() {

    }
    global static Map<String,Object> addCTA(JBCXM.CEHandler.DataWrapper dataWrapObj, Integer version) {
        return null;
    }
    global static Map<String,Object> addCustomerFeatures(JBCXM.CEHandler.DataWrapper dataWrapObj, Integer version) {
        return null;
    }
    global static Map<String,Object> addCustomers(JBCXM.CEHandler.DataWrapper dataWrapObj, Integer version) {
        return null;
    }
    global static Map<String,Object> addMilestone(JBCXM.CEHandler.DataWrapper dataWrapObj, Integer version) {
        return null;
    }
    global static Map<String,Object> addNPSResponse(JBCXM.CEHandler.DataWrapper dataWrapObj, Integer version) {
        return null;
    }
    global static Map<String,Object> addParticipants(JBCXM.CEHandler.SendSurveyData details, Integer version) {
        return null;
    }
    global static Map<String,Object> addUsageData(JBCXM.CEHandler.DataWrapper dataWrapObj, Integer version) {
        return null;
    }
    @RemoteAction
    global static Object customerHandler(Map<String,Object> reqObj) {
        return null;
    }
    global static Map<String,Object> handleCall(Map<String,Object> reqObj) {
        return null;
    }
    global static Map<String,Object> loadSetUpData() {
        return null;
    }
    global static Map<String,Object> sendSurvey(JBCXM.CEHandler.SendSurveyData details, Integer version) {
        return null;
    }
    global static Map<String,Object> setCustomerScores(List<JBCXM.CEHandler.ScorecardData> measures, Integer version) {
        return null;
    }
    global static Map<String,Object> setMeasureScores(List<JBCXM.CEHandler.ScorecardData> measures, Integer version) {
        return null;
    }
global class CTAData {
    global String account;
    global String assignee;
    global String comment;
    global Date createdDate;
    global Date dueDate;
    global String name;
    global Integer numOfDays;
    global SObject obj;
    global String playbook;
    global String postFrequency;
    global String priority;
    global String reason;
    global String source;
    global String stage;
    global String type;
    global CTAData() {

    }
}
global class CustomerData {
    global String account;
    global Double asv;
    global Double mrr;
    global Date nextRenewalDate;
    global SObject obj;
    global Date orgContractDate;
    global Double otr;
    global String stage;
    global String status;
    global Integer users;
    global CustomerData() {

    }
}
global class CustomerFeature {
    global String account;
    global String comment;
    global Boolean enabled;
    global String feature;
    global Boolean licenced;
    global SObject obj;
    global CustomerFeature() {

    }
}
global class DataWrapper {
    global List<JBCXM.CEHandler.CTAData> ctas;
    global List<JBCXM.CEHandler.CustomerFeature> customerFeatures;
    global List<JBCXM.CEHandler.CustomerData> customers;
    global JBCXM.CEHandler.SendSurveyData distributionData;
    global Boolean honorOrgTimeZone;
    global List<JBCXM.CEHandler.MilestoneData> milestones;
    global List<JBCXM.CEHandler.NPSResponse> npsResponses;
    global List<JBCXM.CEHandler.ScorecardData> scores;
    global List<JBCXM.CEHandler.UsageData> usage;
    global String usageLevel;
    global DataWrapper() {

    }
}
global class MilestoneData {
    global String account;
    global String comment;
    global String milestone;
    global Datetime milestoneDate;
    global SObject obj;
    global MilestoneData() {

    }
}
global class NPSResponse {
    global String account;
    global String npscomment;
    global Integer npsscore;
    global Datetime respondeddate;
    global String surveycode;
    global String surveyid;
    global String useremail;
    global String username;
    global String userrole;
    global NPSResponse() {

    }
}
global class ScorecardData {
    global String account;
    global String comment;
    global String goals;
    global String metric;
    global Double prevscorevalue;
    global Boolean resetscore;
    global Double scorevalue;
    global ScorecardData() {

    }
}
global class SendSurveyData {
    global List<String> contactIds;
    global String emailService;
    global String fromAddress;
    global List<JBCXM__SurveyParticipant__c> participants;
    global Boolean resend;
    global String surveyCode;
    global String templateId;
    global SendSurveyData() {

    }
}
global class URI {
    global String area;
    global String errorMsg;
    global String operation;
    global Boolean valid;
    global String version;
    global URI() {

    }
}
global class UsageData {
    global String account;
    global String instanceId;
    global String instanceName;
    global SObject obj;
    global Date usageDate;
    global String usageLevel;
    global String user;
    global UsageData() {

    }
}
}
