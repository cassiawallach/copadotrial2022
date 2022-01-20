<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Mentee_Mentorship_Request_Approved</fullName>
        <description>Mentee Mentorship Request Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>mentorship@copado.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Academy/Approved_Mentee_Mentorship_Request</template>
    </alerts>
    <alerts>
        <fullName>Mentor_Notification_Mentee_Match</fullName>
        <description>Notification to Mentor when a Mentee match is found</description>
        <protected>false</protected>
        <recipients>
            <field>Mentor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>mentorship@copado.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Academy/Mentee_Assignment_to_Mentor_Notification</template>
    </alerts>
</Workflow>
