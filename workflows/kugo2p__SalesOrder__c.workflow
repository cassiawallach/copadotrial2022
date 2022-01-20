<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_PO_Number</fullName>
        <field>kugo2p__CustomerPONumber__c</field>
        <formula>kugo2p__Opportunity__r.PO_Number__c</formula>
        <name>Update PO Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Set ACV and TCV for Kugamon order</fullName>
        <active>false</active>
        <description>By Using this rule set ACV and TCV value on kugamon order</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Customer PO Number from Opportunity</fullName>
        <actions>
            <name>Update_PO_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(kugo2p__Opportunity__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
