<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Check_Is_Licence</fullName>
        <field>PS_Is_Licence__c</field>
        <literalValue>1</literalValue>
        <name>Check Is Licence</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Net_Unit_Price</fullName>
        <field>Net_Unit_Price__c</field>
        <formula>SBQQ__NetPrice__c/ SBQQ__ProrateMultiplier__c</formula>
        <name>Update Net Unit Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uplift_from_Opportunity</fullName>
        <field>PS_Uplift__c</field>
        <formula>SBQQ__Quote__r.SBQQ__Opportunity2__r.PS_Uplift__c</formula>
        <name>Uplift from Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Calcalute Net Unit Price</fullName>
        <actions>
            <name>Update_Net_Unit_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check Product Family</fullName>
        <actions>
            <name>Check_Is_Licence</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>SBQQ__QuoteLine__c.SBQQ__ProductFamily__c</field>
            <operation>equals</operation>
            <value>Licenses</value>
        </criteriaItems>
        <criteriaItems>
            <field>SBQQ__QuoteLine__c.SBQQ__ProductFamily__c</field>
            <operation>equals</operation>
            <value>Premier Support</value>
        </criteriaItems>
        <description>When Family = Licenses,Premier Support Checkbox Is Licence is checked.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Uplift from Opportunity</fullName>
        <actions>
            <name>Uplift_from_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.SBQQ__Type__c</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>SBQQ__QuoteLine__c.SBQQ__SubscriptionPricing__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>SBQQ__QuoteLine__c.PS_Uplift__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
