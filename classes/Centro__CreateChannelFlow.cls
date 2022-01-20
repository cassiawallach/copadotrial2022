/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CreateChannelFlow {
    global CreateChannelFlow() {

    }
    @InvocableMethod(label='Centro: Create Slack conversation and invite users')
    global static List<Centro.CreateChannelFlow.CreateChannelResult> CreateChannel(List<Centro.CreateChannelFlow.CreateChannelFlowSetting> settings) {
        return null;
    }
global class CreateChannelFlowSetting {
    @InvocableVariable(label='Channel Name' required=true)
    global String channelName;
    @InvocableVariable(label='Platform Event GUID (Slack Channel ID can be retrieved from Centro Action by pausing for this GUID)' required=false)
    global String InterviewGuid;
    @InvocableVariable(label='Invite collection of Emails via Slack Connect' required=false)
    global List<String> inviteEmails;
    @InvocableVariable(label='Invite collection of Salesforce User IDs or Slack Member IDs (default current User)' required=false)
    global List<Id> inviteUserIds;
    @InvocableVariable(label='Make Private' required=false)
    global Boolean isPrivate;
    global CreateChannelFlowSetting() {

    }
}
global class CreateChannelResult {
    @InvocableVariable(label='Channel ID' required=false)
    global String channelId;
    @InvocableVariable(label='Error Message' required=false)
    global String error;
    global CreateChannelResult() {

    }
}
}
