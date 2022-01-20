<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Most Recent Call Date</label>
    <protected>false</protected>
    <values>
        <field>rh2__Components_Included__c</field>
        <value xsi:type="xsd:string">Contact.rhuc_Most_Recent_Call_Date</value>
    </values>
    <values>
        <field>rh2__Description__c</field>
        <value xsi:type="xsd:string">Max on ActivityDate where Type = &apos;Call&apos;</value>
    </values>
    <values>
        <field>rh2__FieldType__c</field>
        <value xsi:type="xsd:string">Date</value>
    </values>
    <values>
        <field>rh2__Label__c</field>
        <value xsi:type="xsd:string">Most Recent Call Date</value>
    </values>
    <values>
        <field>rh2__Long_Description__c</field>
        <value xsi:type="xsd:string">The Most Recent Call Date use case calculates the latest ActivityDate of all children Tasks of type &quot;Call&quot; for each Contact record. This use case deploys one Rollup Helper setting and one field, &quot;rhuc_Most_Recent_Call_Date.&quot;</value>
    </values>
    <values>
        <field>rh2__Object__c</field>
        <value xsi:type="xsd:string">Contact</value>
    </values>
</CustomMetadata>
