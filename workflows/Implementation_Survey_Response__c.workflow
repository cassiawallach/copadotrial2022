<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Implementation_Survey</fullName>
        <ccEmails>rcanfield@copado.com, jimperato@copado.com, dnameth@copado.com</ccEmails>
        <description>New Implementation Survey</description>
        <protected>false</protected>
        <recipients>
            <recipient>dfreeman@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/New_Implementation_Survey</template>
    </alerts>
    <alerts>
        <fullName>Send_Completed_ISR_Notification</fullName>
        <description>Send Completed ISR Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Opportunity_ISR_Status</template>
    </alerts>
    <rules>
        <fullName>New Implementation Survey Notification</fullName>
        <actions>
            <name>New_Implementation_Survey</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification to Opportunity Owner</fullName>
        <actions>
            <name>Send_Completed_ISR_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Survey_Response__c.Opportunity_Owner__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Implementation_Survey_Response__c.Status__c</field>
            <operation>equals</operation>
            <value>Scoping Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
