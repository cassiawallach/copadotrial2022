/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InviteMembersFlow {
    global InviteMembersFlow() {

    }
    @InvocableMethod(label='Centro: Invite Users to existing Slack conversation')
    global static List<Centro.InviteMembersFlow.InviteMembersResult> InviteMembers(List<Centro.InviteMembersFlow.InviteMembersFlowSetting> settings) {
        return null;
    }
global class InviteMembersFlowSetting {
    @InvocableVariable(label='Channel Id' required=true)
    global String channelId;
    @InvocableVariable(label='Invite collection of Salesforce User IDs or Slack Member IDs (default current User)' required=false)
    global List<String> inviteUserIds;
    global InviteMembersFlowSetting() {

    }
}
global class InviteMembersResult {
    global InviteMembersResult() {

    }
}
}
