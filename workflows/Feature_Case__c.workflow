<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Feature_Case_Unique_Id_Concat</fullName>
        <description>This rule creates the unique Id for the junction object.</description>
        <field>Feature_with_Case_Unique_Id__c</field>
        <formula>Case__r.Id +  Feature__r.Id</formula>
        <name>Feature Case Unique Id Concat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Feature with Case Unique Id Creation</fullName>
        <actions>
            <name>Feature_Case_Unique_Id_Concat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>copado__Application_Feature__c.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CaseNumber</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
