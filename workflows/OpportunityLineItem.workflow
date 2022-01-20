<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FU_Engagement_Type</fullName>
        <description>Perform field update on Opportunity Product &apos;Engagement Type&apos;</description>
        <field>Engagement_Type__c</field>
        <formula>TEXT(Product2.Engagement_Type__c)</formula>
        <name>FU: Engagement Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_Family</fullName>
        <field>Product_Family__c</field>
        <formula>TEXT(Product2.Family)</formula>
        <name>Set Product Family</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__UpdateOpportunityProductARR</fullName>
        <field>kuga_sub__ARR__c</field>
        <formula>IF(
  Product2.kuga_sub__Renewable__c = FALSE,
  0,
  IF(
    AND(
      TEXT(kuga_sub__UnitofTerm__c) = &quot;Week&quot;,
      kuga_sub__ServiceTerm__c &gt; 52
    ),
    (round(kuga_sub__NetAmount__c / kuga_sub__ServiceTerm__c, 2) * 52),
    IF(
      AND(
        TEXT(kuga_sub__UnitofTerm__c) = &quot;Month&quot;,
        kuga_sub__ServiceTerm__c &gt; 12
      ),
      (round(kuga_sub__NetAmount__c / kuga_sub__ServiceTerm__c, 2) * 12),
      IF(
        AND(
          TEXT(kuga_sub__UnitofTerm__c) = &quot;Quarter&quot;,
          kuga_sub__ServiceTerm__c &gt; 4
        ),
        (round(kuga_sub__NetAmount__c / kuga_sub__ServiceTerm__c, 2) * 4),
        IF(
          AND(
            TEXT(kuga_sub__UnitofTerm__c) = &quot;Year&quot;,
            kuga_sub__ServiceTerm__c &gt; 1
          ),
          round(kuga_sub__NetAmount__c / kuga_sub__ServiceTerm__c, 2),
          kuga_sub__NetAmount__c
        )
      )
    )
  )
)</formula>
        <name>Update Opportunity Product ARR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__UpdateOpportunityProduct_MRR</fullName>
        <field>kuga_sub__MRR__c</field>
        <formula>IF(
  AND(
    TEXT(kuga_sub__UnitofTerm__c) = &quot;Week&quot;,
    Product2.kuga_sub__Renewable__c = TRUE
  ),
  (round(kuga_sub__NetAmount__c / kuga_sub__ServiceTerm__c, 2) * 4),
  IF(
    AND(
      TEXT(kuga_sub__UnitofTerm__c) = &quot;Month&quot;,
      Product2.kuga_sub__Renewable__c = TRUE
    ),
    (round(kuga_sub__NetAmount__c / kuga_sub__ServiceTerm__c, 2)),
    IF(
      AND(
        TEXT(kuga_sub__UnitofTerm__c) = &quot;Quarter&quot;,
        Product2.kuga_sub__Renewable__c = TRUE
      ),
      (round(kuga_sub__NetAmount__c / kuga_sub__ServiceTerm__c / 3, 2)),
      IF(
        AND(
          TEXT(kuga_sub__UnitofTerm__c) = &quot;Year&quot;,
          Product2.kuga_sub__Renewable__c = TRUE
        ),
        (round(kuga_sub__NetAmount__c / kuga_sub__ServiceTerm__c / 12, 2)),
        0
      )
    )
  )
)</formula>
        <name>Update Opportunity Product MRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Edit of Oppty Product</fullName>
        <actions>
            <name>Set_Product_Family</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Product%3A Populate Engagement Type</fullName>
        <actions>
            <name>FU_Engagement_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populates the Engagement Type field based on the value on the Product field</description>
        <formula>Engagement_Type__c &lt;&gt; TEXT(Product2.Engagement_Type__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>kuga_sub__Kugamon Update Opportunity Product Details</fullName>
        <actions>
            <name>kuga_sub__UpdateOpportunityProductARR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>kuga_sub__UpdateOpportunityProduct_MRR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Kugamon - Do Not Deactivate.

Background:
- Support Opportunity Rollup Summary of Opportunity Product Calculations

Action: 
- Calculate Monthly Recurring Revenue and Annual Recurring Revenue, if a Service</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
