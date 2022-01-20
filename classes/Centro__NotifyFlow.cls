/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class NotifyFlow {
    global NotifyFlow() {

    }
    @InvocableMethod(label='Centro: Send notification message to Slack' description='Centro will post record details using Compact Layout as well as an additional message to specified Slack channel.')
    global static void NotifyRecord(List<Centro.NotifyFlow.NotifyFlowSetting> settings) {

    }
global class NotifyFlowSetting {
    @InvocableVariable( required=false)
    global String buttons;
    @InvocableVariable( required=false)
    global String channelId;
    @InvocableVariable( required=false)
    global String channelName;
    @InvocableVariable( required=false)
    global String contentVersionId;
    @InvocableVariable( required=false)
    global String ephemeralUser;
    @InvocableVariable( required=false)
    global String InterviewGuid;
    @InvocableVariable( required=false)
    global String linkRecordId;
    @InvocableVariable( required=false)
    global String message;
    @InvocableVariable( required=false)
    global String pinMessage;
    @InvocableVariable( required=false)
    global String postEphemeral;
    @InvocableVariable( required=false)
    global String postReply;
    @InvocableVariable( required=false)
    global String recordId;
    @InvocableVariable( required=false)
    global String replyMessageTs;
    @InvocableVariable( required=false)
    global String reportFilterParam;
    @InvocableVariable( required=false)
    global String reportFilterValue;
    @InvocableVariable( required=false)
    global String reportFormat;
    @InvocableVariable( required=false)
    global String reportId;
    @InvocableVariable( required=false)
    global String shouldAttachFile;
    @InvocableVariable( required=false)
    global String shouldAttachReport;
    @InvocableVariable( required=false)
    global String shouldLinkMessage;
    @InvocableVariable( required=false)
    global String shouldLinkRecord;
    @InvocableVariable( required=false)
    global String showCompactLayout;
    @InvocableVariable( required=false)
    global String TeamId;
    @InvocableVariable( required=false)
    global String threadName;
    global NotifyFlowSetting() {

    }
}
}
