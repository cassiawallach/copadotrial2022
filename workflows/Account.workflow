<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Health_Red</fullName>
        <description>Account Health Red</description>
        <protected>false</protected>
        <recipients>
            <recipient>sgidwani@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sgillert@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales@copado.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Account_Health_Red</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Type_to_Prospect</fullName>
        <field>Type</field>
        <literalValue>Prospect</literalValue>
        <name>Account Type to Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
