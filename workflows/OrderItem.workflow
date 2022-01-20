<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_full_term_price</fullName>
        <description>temporarily whilst old quotes are still used.</description>
        <field>SBQQ__UnproratedNetPrice__c</field>
        <formula>Recurring_Monthly_Price__c</formula>
        <name>Set full term price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>TEMPORARY FIX TO calculate pricing</fullName>
        <actions>
            <name>Set_full_term_price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OrderItem.Recurring_Monthly_Price__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OrderItem.SBQQ__UnproratedNetPrice__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Temporary whilst normal quotes are still being used.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
