<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Notification</fullName>
        <description>Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Quote_Approved</template>
    </alerts>
    <alerts>
        <fullName>Approval_Request_Approved</fullName>
        <description>Approval Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Quote_Approved</template>
    </alerts>
    <alerts>
        <fullName>Approval_Request_Rejected</fullName>
        <description>Approval Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Quote_Rejected</template>
    </alerts>
    <alerts>
        <fullName>General_Discount_Approvals</fullName>
        <description>General Discount Approvals</description>
        <protected>false</protected>
        <recipients>
            <field>Approval_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPQ_Quote_Approvals/General_Discount_Approvals</template>
    </alerts>
    <alerts>
        <fullName>General_Discount_Approvals_For_Deal_Desk</fullName>
        <ccEmails>Dealdesk@copado.com</ccEmails>
        <description>General Discount Approvals For Deal Desk</description>
        <protected>false</protected>
        <recipients>
            <recipient>rmilem@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vloumiet@copado.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPQ_Quote_Approvals/General_Discount_Approvals</template>
    </alerts>
    <alerts>
        <fullName>Quote_Approval_Rejection</fullName>
        <description>Quote Approval Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Quote_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_Rejection</fullName>
        <description>Quote Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Quote_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Request_Approved</fullName>
        <description>Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Quote_Approved</template>
    </alerts>
    <alerts>
        <fullName>Request_Rejected</fullName>
        <description>Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Quote_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_In_Review</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Approval Status In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Approved</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status to  Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Draft</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Approval Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Back_to_Draft</fullName>
        <description>Status of Quote back to Draft upon Recall</description>
        <field>SBQQ__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Back to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Back_to_Draft2</fullName>
        <description>Status set back to Draft upon Recall.</description>
        <field>SBQQ__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Back to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Billing_Frequency</fullName>
        <description>Prefill the billing frequency with &quot;Annual&quot;</description>
        <field>SBQQ__BillingFrequency__c</field>
        <literalValue>Annual</literalValue>
        <name>Default Billing Frequency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disable_Quote_Groups</fullName>
        <description>Uncheck the box &quot;SBQQ__LineItemsGrouped__c&quot; on quotes, as we want to disable groupings in the line item editor</description>
        <field>SBQQ__LineItemsGrouped__c</field>
        <literalValue>0</literalValue>
        <name>Disable Quote Groups</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_Blank_T_C_S</fullName>
        <field>T_C_S_is_Blank__c</field>
        <formula>IF( ISBLANK(T_Cs__c) = True, &quot;True&quot;, &quot;False&quot;)</formula>
        <name>Is Blank T&amp;C&apos;S</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Back_to_Draft</fullName>
        <description>Status field back to draft</description>
        <field>SBQQ__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Status Back to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Status Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_In_Review</fullName>
        <description>It changes Approval status for value: In Reviev</description>
        <field>SBQQ__Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Status In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Approved</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Draft</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_In_Review</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Status to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Rejected</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submitted_Date</fullName>
        <field>SubmittedDate__c</field>
        <formula>TODAY()</formula>
        <name>Update Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Is Blank T%26C%27S</fullName>
        <actions>
            <name>Is_Blank_T_C_S</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Using for conga template</description>
        <formula>(ISNEW()&amp;&amp; NOT(ISBLANK(T_Cs__c))) || ISCHANGED( T_Cs__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>On Quote Create</fullName>
        <actions>
            <name>Default_Billing_Frequency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Fire this rule on all quote creations</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>On all create and edit</fullName>
        <actions>
            <name>Disable_Quote_Groups</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
