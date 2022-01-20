<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Low_CSAT_Received</fullName>
        <description>Notify Support Manager when a low CSAT is received.</description>
        <protected>false</protected>
        <recipients>
            <recipient>ar@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dfreeman@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mbarclay@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rreddy@copado.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sgillert@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/Customer_Disagrees</template>
    </alerts>
    <rules>
        <fullName>Low CSAT Received</fullName>
        <actions>
            <name>Low_CSAT_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GetFeedback_Aut__Answer__c.GetFeedback_Aut__QuestionTitle__c</field>
            <operation>contains</operation>
            <value>How would you rate your Copado Support experience</value>
        </criteriaItems>
        <criteriaItems>
            <field>GetFeedback_Aut__Answer__c.GetFeedback_Aut__Number__c</field>
            <operation>lessOrEqual</operation>
            <value>3</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
