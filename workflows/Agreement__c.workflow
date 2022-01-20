<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Agreement_Needs_Review</fullName>
        <description>Agreement Needs Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Contracts_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Conga_Email_Templates/Agreement_Needs_Review</template>
    </alerts>
    <alerts>
        <fullName>Review_Agreements</fullName>
        <ccEmails>ghiggins@copado.com</ccEmails>
        <description>Review Agreements</description>
        <protected>false</protected>
        <recipients>
            <recipient>sgidwani@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Conga_Email_Templates/Agreement_Needs_Review</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved_to_False</fullName>
        <field>Approved__c</field>
        <literalValue>0</literalValue>
        <name>Approved to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_to_True</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Approved to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_End_Date</fullName>
        <description>This will set the end date on the agreement with the start date and number of months from the agreement.</description>
        <field>End_Date__c</field>
        <formula>ADDMONTHS(Start_Date__c,Term__c)-1</formula>
        <name>Set End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Approval_Review</fullName>
        <field>Status__c</field>
        <literalValue>Approval Review</literalValue>
        <name>Status to Approval Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Copado_Review</fullName>
        <field>Status__c</field>
        <literalValue>Copado Review</literalValue>
        <name>Status to Copado Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Approved and goes back</fullName>
        <actions>
            <name>Approved_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Agreement__c.Approved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Agreement__c.Status__c</field>
            <operation>equals</operation>
            <value>Draft,Copado Review,Customer Review,Approval Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set End Date</fullName>
        <actions>
            <name>Set_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Agreement__c.Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Agreement__c.Term__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Agreement__c.End_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
