<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Zero_Licenses</fullName>
        <field>sfFma__Value__c</field>
        <formula>0</formula>
        <name>Zero Licenses</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Expire Feature</fullName>
        <active>true</active>
        <criteriaItems>
            <field>sfFma__FeatureParameterInteger__c.Expiration_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Zero_Licenses</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>sfFma__FeatureParameterInteger__c.Expiration_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
