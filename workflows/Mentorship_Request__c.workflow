<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Mentee_Mentorship_Request_Approved_but_without_a_Mentor</fullName>
        <description>Mentee Mentorship Request Approved but without a Mentor</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>mentorship@copado.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Academy/Approved_Mentee_without_mentor_Mentorship_Request</template>
    </alerts>
    <alerts>
        <fullName>Mentor_Mentorship_Request_Approved</fullName>
        <description>Mentor Mentorship Request Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>mentorship@copado.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Academy/Approved_Mentor_Mentorship_Request</template>
    </alerts>
    <alerts>
        <fullName>Mentor_Mentorship_Request_Waitlisted</fullName>
        <description>Mentor Mentorship Request Waitlisted</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>mentorship@copado.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Academy/Mentorship_Request_Waitlisted_Template</template>
    </alerts>
    <alerts>
        <fullName>Mentorship_Request_Rejected</fullName>
        <description>Mentorship Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>mentorship@copado.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Academy/Rejected_Mentorship_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
