<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Release_Approval_Notification</fullName>
        <ccEmails>release@copado.com</ccEmails>
        <description>Release Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/Release_Approved</template>
    </alerts>
    <alerts>
        <fullName>Release_Approval_Notification_Reject</fullName>
        <ccEmails>release@copado.com</ccEmails>
        <description>Release Approval Notification Reject</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/Release_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Ready_for_Testing_status</fullName>
        <description>Set to ready for testing</description>
        <field>copado__Status__c</field>
        <literalValue>Ready for Testing</literalValue>
        <name>Ready for Testing status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release_Status_Update</fullName>
        <field>copado__Status__c</field>
        <literalValue>Approved by QA</literalValue>
        <name>Release Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release_Status_Update_Reject</fullName>
        <field>copado__Status__c</field>
        <literalValue>Rejected by QA</literalValue>
        <name>Release Status Update Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
