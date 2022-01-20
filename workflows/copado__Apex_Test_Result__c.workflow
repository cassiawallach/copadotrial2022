<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Apex_Test_failures</fullName>
        <description>Apex Test failures</description>
        <protected>false</protected>
        <recipients>
            <recipient>fl@copado.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Apex_Test_Failures_Found</template>
    </alerts>
    <rules>
        <fullName>Apex Test Failure</fullName>
        <actions>
            <name>Apex_Test_failures</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>copado__Apex_Test_Result__c.copado__Status__c</field>
            <operation>equals</operation>
            <value>Errors</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
