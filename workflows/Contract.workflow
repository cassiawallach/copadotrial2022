<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Create_Renewal_Opportunity</fullName>
        <field>SBQQ__RenewalQuoted__c</field>
        <literalValue>1</literalValue>
        <name>Create Renewal Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Status_to_Expired</fullName>
        <field>Status</field>
        <literalValue>Expired</literalValue>
        <name>Set Contract Status to Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Renewal_Quote</fullName>
        <description>If the DaysSinceEnd Date is greater than 120, then RenewalQuoted</description>
        <field>SBQQ__RenewalQuoted__c</field>
        <literalValue>1</literalValue>
        <name>Update Renewal Quote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>Status</field>
        <literalValue>Expired - Replacement</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__UpdateContractEndDate</fullName>
        <field>EndDate</field>
        <formula>kuga_sub__SubscriptionEndDate__c</formula>
        <name>Update Contract End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__UpdateContractName</fullName>
        <field>Name</field>
        <formula>LEFT(Account.Name, 71) + &apos;-&apos; + ContractNumber</formula>
        <name>Update Contract Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__UpdateContractStartDate</fullName>
        <field>StartDate</field>
        <formula>kuga_sub__SubscriptionStartDate__c</formula>
        <name>Update Contract Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>AutomaticRenewal</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contract.Days_Since_End_Date__c</field>
            <operation>greaterThan</operation>
            <value>120</value>
        </criteriaItems>
        <description>The aim of this workflow is to set the value of Renewal Quoted to TRUE under specific condition.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Renewal_Quote</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contract.ActivatedDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Contract Expiration Status update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Contract_Status_to_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contract.EndDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>kuga_sub__Kugamon Update Contract End Date</fullName>
        <actions>
            <name>kuga_sub__UpdateContractEndDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Kugamon - Do Not Deactivate

Action:
- Update Contract End Date with latest Subscription End Date</description>
        <formula>AND( NOT ISBLANK(kuga_sub__SubscriptionEndDate__c), ISCHANGED(kuga_sub__SubscriptionEndDate__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>kuga_sub__Kugamon Update Contract Name</fullName>
        <actions>
            <name>kuga_sub__UpdateContractName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Kugamon -  Okay to Edit - Update Contract Record fields upon creation.

Action:
- Update Contract Name with combination of Account Name and Contract Number</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>kuga_sub__Kugamon Update Contract Start Date</fullName>
        <actions>
            <name>kuga_sub__UpdateContractStartDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Kugamon - Do Not Deactivate

Action:
- Update Contract End Date with Subscription Start Date</description>
        <formula>AND( NOT ISBLANK(kuga_sub__SubscriptionStartDate__c), OR (ISCHANGED(StartDate), ISCHANGED(kuga_sub__SubscriptionStartDate__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
