<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Activity_Type_to_Call</fullName>
        <field>Type</field>
        <literalValue>Call</literalValue>
        <name>Set Activity Type to Call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Activity_Type_to_Email</fullName>
        <field>Type</field>
        <literalValue>Email</literalValue>
        <name>Set Activity Type to Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Call Acitivities</fullName>
        <actions>
            <name>Set_Activity_Type_to_Call</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.CallDurationInSeconds</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Acitivities</fullName>
        <actions>
            <name>Set_Activity_Type_to_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>startsWith</operation>
            <value>→ Email:,← Email:,Email:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
