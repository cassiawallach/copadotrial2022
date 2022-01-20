<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>lnt__Updat_Environment</fullName>
        <field>lnt__Loop_Tie_Environment__c</field>
        <formula>IF(lnt__Team__c =&apos;sandbox&apos;, &apos;sandbox&apos;,&apos;production&apos;)</formula>
        <name>Update Environment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>lnt__Update_Organization</fullName>
        <description>Update Loop &amp; Tie Organization field</description>
        <field>lnt__Loop_Tie_Organization__c</field>
        <formula>lnt__Team__c</formula>
        <name>Update Organization</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>lnt__Update_RecordTypes</fullName>
        <field>RecordTypeId</field>
        <lookupValue>lnt__Canceled_Gifts</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RecordTypes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>lnt__Canceled Gift</fullName>
        <actions>
            <name>lnt__Update_RecordTypes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When stage reach redeemed and cancel change pagelayout</description>
        <formula>OR( ISPICKVAL(lnt__Stage__c, &quot;Canceled&quot;), ISPICKVAL(lnt__Stage__c , &quot;Redeemed&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>lnt__Loop %26 Tie Organization</fullName>
        <actions>
            <name>lnt__Updat_Environment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>lnt__Update_Organization</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>lnt__Gift__c.lnt__Team__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
