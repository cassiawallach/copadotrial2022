<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Last_Support_Email</fullName>
        <field>Last_Support_Communication__c</field>
        <formula>MessageDate</formula>
        <name>Last Support Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Case_Comment_For_Email</fullName>
        <description>Update the Last Case Comment when Email is sent.</description>
        <field>Last_Case_Comment_Time__c</field>
        <formula>MessageDate</formula>
        <name>Update Last Case Comment For Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_No_reply_hours_Temp</fullName>
        <description>Reset No Reply hours.</description>
        <field>No_Reply_Hours_Temp__c</field>
        <formula>0</formula>
        <name>Update No reply hours Temp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Noreplyage</fullName>
        <field>NoReplyAge__c</field>
        <formula>0</formula>
        <name>Update No reply age</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Last Support Email</fullName>
        <actions>
            <name>Last_Support_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Case_Comment_For_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Noreplyage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Incoming = FALSE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
