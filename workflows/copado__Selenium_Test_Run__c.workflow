<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Regression_Test_Run_Failed</fullName>
        <ccEmails>developers@copa.do</ccEmails>
        <description>Regression Test Run Failed</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/Regression_Test_failed_html</template>
    </alerts>
    <rules>
        <fullName>Check failing test runs</fullName>
        <actions>
            <name>Regression_Test_Run_Failed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>copado__Selenium_Test_Run__c.copado__Last_Status__c</field>
            <operation>equals</operation>
            <value>Completed with errors,Provider Failure</value>
        </criteriaItems>
        <criteriaItems>
            <field>copado__Selenium_Test_Run__c.Name</field>
            <operation>startsWith</operation>
            <value>Regression</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
