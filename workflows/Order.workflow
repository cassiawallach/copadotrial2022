<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AVA_SFCPQ__AvaTaxMessage</fullName>
        <field>AVA_SFCPQ__AvaTaxMessage__c</field>
        <formula>&quot;Tax Amount is Outdated&quot;</formula>
        <name>AvaTaxMessage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AVA_SFCPQ__Update</fullName>
        <field>AVA_SFCPQ__AvaTaxMessage__c</field>
        <formula>&quot;Sales Tax Not Current&quot;</formula>
        <name>Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ACV</fullName>
        <field>ACV__c</field>
        <formula>Opp_ACV__c</formula>
        <name>Set ACV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TCV</fullName>
        <field>TCV__c</field>
        <formula>Opp_TCV__c</formula>
        <name>Set TCV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>AVA_SFCPQ__AvaTax Order Status</fullName>
        <actions>
            <name>AVA_SFCPQ__Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(TotalAmount ) || ISCHANGED( BillingCity ) || ISCHANGED( BillingCountry ) || ISCHANGED( BillingState ) || ISCHANGED( BillingStreet ) || ISCHANGED( BillingPostalCode ) || ISCHANGED( ShippingCity ) || ISCHANGED( ShippingCountry ) || ISCHANGED( ShippingState ) || ISCHANGED( ShippingStreet ) || ISCHANGED( ShippingPostalCode ) || ISCHANGED( AccountId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AVA_SFCPQ__Order Status Change</fullName>
        <actions>
            <name>AVA_SFCPQ__AvaTaxMessage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( TotalAmount ) || ISCHANGED(  BillingAddress ) || ISCHANGED(  ShippingAddress )|| ISCHANGED(   AccountId )|| ISCHANGED(   AVA_SFCPQ__Entity_Use_Code__c )|| ISCHANGED(    AVA_SFCPQ__Is_Seller_Importer_Of_Record__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set ACV and TCV</fullName>
        <actions>
            <name>Set_ACV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_TCV</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This populates the currency fields from the formula field so that we can use it in a Roll-up summary field.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
