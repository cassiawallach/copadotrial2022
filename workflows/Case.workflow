<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Internal_APO_Request_Notification</fullName>
        <description>Case Internal APO Request Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>APO_Regulators</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Case_Internal_Request_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Internal_Approval_Notification</fullName>
        <description>Case Internal Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Case_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Internal_IT_Request_Notification</fullName>
        <description>Case Internal IT Request Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>IT_Operations</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Case_Internal_Request_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Internal_Legal_Request_Notification</fullName>
        <description>Case Internal Legal Request Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Legal_Regulators</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Case_Internal_Request_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Internal_Marketing_Request_Notification</fullName>
        <description>Case Internal Marketing Request Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Marketing_Regulators</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Case_Internal_Request_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Internal_Rejection_Notification</fullName>
        <description>Case Internal Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Case_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Internal_Resource_Request_Notification</fullName>
        <description>Case Internal Resource Request Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Resource_Regulators</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Case_Internal_Request_Notification</template>
    </alerts>
    <alerts>
        <fullName>Closed_Case_Email</fullName>
        <description>Closed Case Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSAT_Templates/CSAT_Support_v1</template>
    </alerts>
    <alerts>
        <fullName>Customer_Disagrees</fullName>
        <description>Customer Disagrees</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>ag@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ar@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pfernandez@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vmurillo@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>help@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/Customer_Disagrees</template>
    </alerts>
    <alerts>
        <fullName>Notify_contact_case_comment</fullName>
        <description>Send email to contact in case notifying about new case comment.</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/CaseNewCommentNotification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Alert_to_Security_Team</fullName>
        <ccEmails>security@copado.com</ccEmails>
        <description>Send Email Alert to Security Team</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Case_Internal_Request_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_CST</fullName>
        <description>Send Email to CST</description>
        <protected>false</protected>
        <recipients>
            <recipient>mbarclay@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>help@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/New_case_notification_internal_users</template>
    </alerts>
    <alerts>
        <fullName>Spiff_Complete</fullName>
        <description>Spiff Complete</description>
        <protected>false</protected>
        <recipients>
            <recipient>rhermann@copado.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Spiff_Complete</template>
    </alerts>
    <alerts>
        <fullName>Test_Case_Notification</fullName>
        <description>Test Case Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>nlarrabee@copado.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Case_Internal_Request_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>Product_Team_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner Product Team</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Owner_to_CST</fullName>
        <description>Change the case owner to Copado Support team</description>
        <field>OwnerId</field>
        <lookupValue>mbarclay@copa.do</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Owner to CST</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Owner_to_Sales</fullName>
        <field>OwnerId</field>
        <lookupValue>Sales_Cases</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner to Sales</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Origin_to_Community</fullName>
        <field>Origin</field>
        <literalValue>Community</literalValue>
        <name>Set Case Origin to Community</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_In_progress</fullName>
        <field>Status</field>
        <literalValue>In progress</literalValue>
        <name>Set Status to In progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Escalated_field</fullName>
        <description>Uncheck the Escalated field on cases.</description>
        <field>IsEscalated</field>
        <literalValue>0</literalValue>
        <name>Uncheck Escalated field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Type_Question</fullName>
        <description>Update the case Type field to Question.</description>
        <field>Type</field>
        <literalValue>Question</literalValue>
        <name>Update Case Type Question</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Type_Sales</fullName>
        <description>Update the case Type field to Sales.</description>
        <field>Type</field>
        <literalValue>Sales</literalValue>
        <name>Update Case Type Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Case_Comment_Field</fullName>
        <description>Update with Last Modified</description>
        <field>Last_Case_Comment_Time__c</field>
        <formula>LastModifiedDate</formula>
        <name>Update Last Case Comment Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Case Escalation</fullName>
        <actions>
            <name>Change_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_In_progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a case is escalated, using the &quot;Escalated&quot; checkbox</description>
        <formula>AND(ISCHANGED(IsEscalated),(IsEscalated = True), NOT(ISCHANGED(AccountId)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Owner to Sales queue</fullName>
        <actions>
            <name>Change_Owner_to_Sales</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Escalated_field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Type_Sales</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the Case Record Type changes to Sales Case, the case owner changes to &quot;Sales Cases&quot; queue and the Type changes to &quot;Sales&quot;.</description>
        <formula>AND(RecordType.Name = &quot;Sales Case&quot;, ISCHANGED(RecordTypeId),NOT(ISCHANGED(AccountId)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Owner to Support Team</fullName>
        <actions>
            <name>Change_Owner_to_CST</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Type_Question</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When the Case Record Type changes to Support Case, the case owner changes to &quot;Copado Team Support&quot; and the Type changes to &quot;Question&quot;.</description>
        <formula>AND(RecordType.Name = &quot;Support Case&quot;, ISCHANGED(RecordTypeId),NOT(ISCHANGED(AccountId)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Closed Case</fullName>
        <actions>
            <name>Closed_Case_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed - Bug fix submitted,Closed - Resolved,Closed - Feature Request,Closed - Routed to internal helpdesk,Closed - No response from customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Outbound Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support Case</value>
        </criteriaItems>
        <description>When closing a Case we notify the customer and ask for feedback.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Community Case Change Owner to Support Team</fullName>
        <actions>
            <name>Send_Email_to_CST</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Change_Owner_to_CST</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Case_Origin_to_Community</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Type_Question</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>Community</value>
        </criteriaItems>
        <description>Change owner of the support cases created from the Community to Copado Support Team.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Customer Disagrees</fullName>
        <actions>
            <name>Customer_Disagrees</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Customer_Feedback__c</field>
            <operation>equals</operation>
            <value>Not satisfied</value>
        </criteriaItems>
        <description>Whenever a customer is not happy with Support given, we&apos;ll do a follow up.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification to APO Regulators</fullName>
        <actions>
            <name>Case_Internal_APO_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Case_APO_Request_Has_Been_Created</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>APO Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification to IT Operations</fullName>
        <actions>
            <name>Case_Internal_IT_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Test_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Case_IT_Request_Has_Been_Created</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification to Legal Regulators</fullName>
        <actions>
            <name>Case_Internal_Legal_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Test_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Case_Legal_Request_Has_Been_Created</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Legal Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification to Marketing Regulators</fullName>
        <actions>
            <name>Case_Internal_Marketing_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Case_Marketing_Request_Has_Been_Created</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification to Resource Regulators</fullName>
        <actions>
            <name>Case_Internal_Resource_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Test_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Case_Resource_Request_Has_Been_Created</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Resource Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification to Security Team</fullName>
        <actions>
            <name>Send_Email_Alert_to_Security_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Security Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Spiff Complete</fullName>
        <actions>
            <name>Spiff_Complete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Case Study</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Spiff Complete</value>
        </criteriaItems>
        <description>Email alert is sent when a case study is set to Complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Last Case Comment by Status Change</fullName>
        <actions>
            <name>Update_Last_Case_Comment_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change the last case comment time when status changes to Awaiting Customer Feedback</description>
        <formula>ISCHANGED(Status) &amp;&amp; ISPICKVAL(Status, &quot;Awaiting customer feedback&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update contact with case comment</fullName>
        <actions>
            <name>Notify_contact_case_comment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email alert to the contact in the case when a new case comment is added.</description>
        <formula>ISCHANGED( Last_comment__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>New_Case_APO_Request_Has_Been_Created</fullName>
        <assignedToType>creator</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>New Case APO Request Has Been Created</subject>
    </tasks>
    <tasks>
        <fullName>New_Case_IT_Request_Has_Been_Created</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>New Case IT Request Has Been Created</subject>
    </tasks>
    <tasks>
        <fullName>New_Case_Legal_Request_Has_Been_Created</fullName>
        <assignedToType>owner</assignedToType>
        <description>Legal has been notified of your request.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>New Case Legal Request Has Been Created</subject>
    </tasks>
    <tasks>
        <fullName>New_Case_Marketing_Request_Has_Been_Created</fullName>
        <assignedToType>creator</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>New Case Marketing Request Has Been Created</subject>
    </tasks>
    <tasks>
        <fullName>New_Case_Request_Has_Been_Approved</fullName>
        <assignedToType>owner</assignedToType>
        <description>The request has been approved.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>New Case Request Has Been Approved</subject>
    </tasks>
    <tasks>
        <fullName>New_Case_Resource_Request_Has_Been_Created</fullName>
        <assignedToType>owner</assignedToType>
        <description>Resource Management has been notified of your request.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>New Case Resource Request Has Been Created</subject>
    </tasks>
    <tasks>
        <fullName>URGENT_Case_Violation_at_Risk</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please review this case and ensure that Milestones are not violated.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>URGENT: Case Violation at Risk</subject>
    </tasks>
</Workflow>
