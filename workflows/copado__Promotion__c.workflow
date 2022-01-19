<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Merge_Conflict_Checkbox</fullName>
        <field>Conflict__c</field>
        <literalValue>1</literalValue>
        <name>Update &quot;Merge Conflict&quot; Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Track If Promotion Contains Merge Conflict</fullName>
        <actions>
            <name>Update_Merge_Conflict_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>copado__Promotion__c.copado__Status__c</field>
            <operation>equals</operation>
            <value>Merge Conflict</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
