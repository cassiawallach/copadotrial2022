<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>kuga_sub__UpdateSubscriptionARR</fullName>
        <field>kuga_sub__ARR__c</field>
        <formula>IF(
  kuga_sub__Service__r.kuga_sub__Renewable__c = FALSE,
  0,
  IF(
    AND(
      CONTAINS(kuga_sub__UnitofTerm__c, &quot;Week&quot;),
      kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c &gt; 52
    ),
    (round(kuga_sub__OrderServiceLine__r.kugo2p__TotalAmount__c / kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c, 2) * 52),
    IF(
      AND(
        CONTAINS(kuga_sub__UnitofTerm__c, &quot;Month&quot;),
        kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c &gt; 12
      ),
      (round(kuga_sub__OrderServiceLine__r.kugo2p__TotalAmount__c / kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c, 2) * 12),
      IF(
        AND(
          CONTAINS(kuga_sub__UnitofTerm__c, &quot;Quarter&quot;),
          kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c &gt; 4
        ),
        (round(kuga_sub__OrderServiceLine__r.kugo2p__TotalAmount__c / kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c, 2) * 4),
        IF(
          AND(
            CONTAINS(kuga_sub__UnitofTerm__c, &quot;Year&quot;),
            kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c &gt; 1
          ),
          round(kuga_sub__OrderServiceLine__r.kugo2p__TotalAmount__c / kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c, 2),
          kuga_sub__OrderServiceLine__r.kugo2p__TotalAmount__c
        )
      )
    )
  )
)</formula>
        <name>Update Subscription ARR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__UpdateSubscriptionMRR</fullName>
        <field>kuga_sub__MRR__c</field>
        <formula>IF(
  AND(
    CONTAINS(kuga_sub__UnitofTerm__c, &quot;Week&quot;),
    kuga_sub__Service__r.kuga_sub__Renewable__c = TRUE
  ),
  (round(kuga_sub__OrderServiceLine__r.kugo2p__TotalAmount__c / kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c, 2) * 4),
  IF(
    AND(
      CONTAINS(kuga_sub__UnitofTerm__c, &quot;Month&quot;),
      kuga_sub__Service__r.kuga_sub__Renewable__c = TRUE
    ),
    (round(kuga_sub__OrderServiceLine__r.kugo2p__TotalAmount__c / kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c, 2)),
    IF(
      AND(
        CONTAINS(kuga_sub__UnitofTerm__c, &quot;Quarter&quot;),
        kuga_sub__Service__r.kuga_sub__Renewable__c = TRUE
      ),
      (round(kuga_sub__OrderServiceLine__r.kugo2p__TotalAmount__c / kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c / 3, 2)),
      IF(
        AND(
          CONTAINS(kuga_sub__UnitofTerm__c, &quot;Year&quot;),
          kuga_sub__Service__r.kuga_sub__Renewable__c = TRUE
        ),
        (round(kuga_sub__OrderServiceLine__r.kugo2p__TotalAmount__c / kuga_sub__OrderServiceLine__r.kugo2p__ServiceTerm__c / 12, 2)),
        0
      )
    )
  )
)</formula>
        <name>Update Subscription MRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__UpdateSubscriptionNetAmount</fullName>
        <field>kuga_sub__NetAmount__c</field>
        <formula>kuga_sub__OrderServiceLine__r.kugo2p__NetAmount__c</formula>
        <name>Update Subscription Net Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__Update_IsActive_Check</fullName>
        <field>kuga_sub__IsActive__c</field>
        <literalValue>1</literalValue>
        <name>Update IsActive - Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__Update_Subscription_Total_Amount</fullName>
        <field>kuga_sub__TotalAmount__c</field>
        <formula>kuga_sub__OrderServiceLine__r.kugo2p__TotalAmount__c</formula>
        <name>Update Subscription Total Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>kuga_sub__Kugamon Update IsActive - Check</fullName>
        <actions>
            <name>kuga_sub__Update_IsActive_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>kuga_sub__Subscription__c.kuga_sub__Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Kugamon - Do Not Deactivate.

Background:
- Support Contract Rollup Summary of Subscription Calculations 

Action:
- Update Subscription Active to True</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>kuga_sub__Kugamon Update Subscription Details</fullName>
        <actions>
            <name>kuga_sub__UpdateSubscriptionARR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>kuga_sub__UpdateSubscriptionMRR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>kuga_sub__UpdateSubscriptionNetAmount</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>kuga_sub__Update_Subscription_Total_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Kugamon - Do Not Deactivate.

Background: 
- Support Contract Rollup Summary Calculations 

Action: 
- Calculate Monthly Recurring Revenue, Annual Recurring Revenue, Total Amount and Net Amount</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
