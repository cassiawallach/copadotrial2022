<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Domain</fullName>
        <description>6 (copado) + 18 chars + 9 (timenow) = 33 chars</description>
        <field>Domain__c</field>
        <formula>&quot;copado&quot;+
LEFT(Domain__c, 18)+ 
TEXT(HOUR(TIMENOW()))+
TEXT(MINUTE(TIMENOW()))+
TEXT(SECOND(TIMENOW()))+
TEXT(MILLISECOND(TIMENOW()))</formula>
        <name>Set Domain</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TSO_Template_ID</fullName>
        <field>Template__c</field>
        <formula>TSO_Template_ID__c</formula>
        <name>Set TSO Template ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Set Domain</fullName>
        <actions>
            <name>Set_Domain</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Signup_Request__c.Domain__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Template field value</fullName>
        <actions>
            <name>Set_TSO_Template_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Signup_Request__c.TSO_Template_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
