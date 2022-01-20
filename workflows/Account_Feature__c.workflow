<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Feature_Unique_Id_Concat</fullName>
        <description>This rule creates the unique Id for the junction object.</description>
        <field>Account_Feature_Unique_Id__c</field>
        <formula>Account__r.Id +  Feature__r.Id</formula>
        <name>Account Feature Unique Id Concat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Account Feature Unique Id Creation</fullName>
        <actions>
            <name>Account_Feature_Unique_Id_Concat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>copado__Application_Feature__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
