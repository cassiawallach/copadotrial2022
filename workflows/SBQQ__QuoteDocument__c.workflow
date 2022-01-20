<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Latest_Quote_Document_Field</fullName>
        <field>Latest_Quote_Document__c</field>
        <formula>SBQQ__DocumentId__c</formula>
        <name>Update Latest Quote Document Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>SBQQ__Quote__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>On Quote Document Create</fullName>
        <actions>
            <name>Update_Latest_Quote_Document_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__QuoteDocument__c.SBQQ__DocumentId__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
