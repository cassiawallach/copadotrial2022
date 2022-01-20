<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CCH_Platform_Module_Notification</fullName>
        <description>CCH &amp; Platform Module Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>dbrooks@copa.do.apo</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/Module_notification</template>
    </alerts>
    <alerts>
        <fullName>CST_Infra_Module_Notification</fullName>
        <description>CST Infra Module Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>nr@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/Module_notification</template>
    </alerts>
    <alerts>
        <fullName>DX_Module_Notification</fullName>
        <description>DX Module Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>my@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/Module_notification</template>
    </alerts>
    <alerts>
        <fullName>New_APO_US_Aert</fullName>
        <description>New APO US Aert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Invoice_Email</template>
    </alerts>
    <alerts>
        <fullName>Q_C_Module_Notification</fullName>
        <description>Q&amp;C Module Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>jgaviria@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/Module_notification</template>
    </alerts>
    <alerts>
        <fullName>Release_Module_Notification</fullName>
        <description>Release Module Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>dr@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/Module_notification</template>
    </alerts>
    <alerts>
        <fullName>Story_assigned</fullName>
        <description>Story assigned</description>
        <protected>false</protected>
        <recipients>
            <field>copado__Developer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Story_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Support_Investigation_Completed_No_Owners</fullName>
        <description>Support Investigation Completed No Owners</description>
        <protected>false</protected>
        <recipients>
            <recipient>ar@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Support_Investigation_Completed</template>
    </alerts>
    <alerts>
        <fullName>Support_Investigation_Completed_Owners</fullName>
        <description>Support Investigation Completed Owners</description>
        <protected>false</protected>
        <recipients>
            <recipient>Customer_Support_Agent</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Support_Investigation_Completed</template>
    </alerts>
    <alerts>
        <fullName>Test_Script_Owner_Assignee</fullName>
        <description>Test Script Owner Assignee</description>
        <protected>false</protected>
        <recipients>
            <field>copado__Test_Script_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/APO_Tech_Script_Owner_Assignment</template>
    </alerts>
    <alerts>
        <fullName>User_Story_Approved_Alert</fullName>
        <description>User Story Approved Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/User_Story_Approval</template>
    </alerts>
    <alerts>
        <fullName>User_Story_Approved_Alert_Releaser</fullName>
        <ccEmails>release@copado.com</ccEmails>
        <description>User Story Approved Alert Releaser</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/User_Story_Approval</template>
    </alerts>
    <alerts>
        <fullName>User_Story_Due_In_2_Days_Alert</fullName>
        <description>User Story Due In 2 Days Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/User_Story_Due_In_2_Days</template>
    </alerts>
    <alerts>
        <fullName>User_Story_Due_Today_Alert</fullName>
        <description>User Story Due Today Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/User_Story_Due_Today</template>
    </alerts>
    <alerts>
        <fullName>User_Story_Environment_Changed_Alert</fullName>
        <description>User Story Environment Changed Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/User_Story_Environment_Changed</template>
    </alerts>
    <alerts>
        <fullName>User_Story_Rejected_Alert</fullName>
        <description>User Story Rejected Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/User_Story_Rejection</template>
    </alerts>
    <alerts>
        <fullName>User_Story_Rejected_Alert_Releaser</fullName>
        <ccEmails>release@copado.com</ccEmails>
        <description>User Story Rejected Alert Releaser</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/User_Story_Rejection</template>
    </alerts>
    <alerts>
        <fullName>User_Story_Status_Updated_Not_By_Owner_Alert</fullName>
        <description>User Story Status Updated Not By Owner Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Change_Management/User_Story_Status_Updated</template>
    </alerts>
    <alerts>
        <fullName>Work_Item_assigned</fullName>
        <description>Work Item assigned</description>
        <protected>false</protected>
        <recipients>
            <field>copado__Developer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Work_Item_Assigned</template>
    </alerts>
    <fieldUpdates>
        <fullName>Blank_First_Ready_to_Promote_Time</fullName>
        <field>copadometrics__First_Ready_to_Promote_Time__c</field>
        <name>Blank First Ready to Promote Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Ready_to_Promote</fullName>
        <field>copado__Promote_Change__c</field>
        <literalValue>1</literalValue>
        <name>Check Ready to Promote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IT_Ops_Priority_Transpose</fullName>
        <description>Copy the IT Ops Priority Value to the normal Priority Field</description>
        <field>copado__Priority__c</field>
        <formula>VALUE(Text(IT_Ops_Priority__c))</formula>
        <name>IT Ops Priority Transpose</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Progress_to_100</fullName>
        <field>copado__Progress__c</field>
        <formula>1</formula>
        <name>Progress to 100</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Promote_Change_FALSE</fullName>
        <field>copado__Promote_Change__c</field>
        <literalValue>0</literalValue>
        <name>Promote Change FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Promote_Change_TRUE</fullName>
        <field>copado__Promote_Change__c</field>
        <literalValue>1</literalValue>
        <name>Promote Change TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Promote_and_Deploy_to_FALSE</fullName>
        <field>copado__Promote_and_Deploy__c</field>
        <literalValue>0</literalValue>
        <name>Set Promote and Deploy to FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Promote_and_Deploy_to_TRUE</fullName>
        <field>copado__Promote_and_Deploy__c</field>
        <literalValue>1</literalValue>
        <name>Set Promote and Deploy to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Ready_to_Promote</fullName>
        <field>copado__Promote_Change__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Ready to Promote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved</fullName>
        <field>copado__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_QA_DEV_Completed</fullName>
        <field>copado__Status__c</field>
        <literalValue>QA DEV Testing Completed</literalValue>
        <name>Update Status to QA DEV Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Rejected</fullName>
        <field>copado__Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Released</fullName>
        <field>copado__Status__c</field>
        <literalValue>Released</literalValue>
        <name>Update Status to Released</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Story_Indexing_Metadata</fullName>
        <field>copado__Stop_Indexing_Metadata__c</field>
        <literalValue>1</literalValue>
        <name>User Story Indexing Metadata</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>APO US UAT Alert</fullName>
        <actions>
            <name>New_APO_US_Aert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email to User that their story is ready for testing</description>
        <formula>AND( ISCHANGED( copado__Environment__c ), AND( 
copado__Environment__r.Name = &apos;UAT&apos;), NOT( ISBLANK( copado__Environment__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IT Ops Priority Update</fullName>
        <actions>
            <name>IT_Ops_Priority_Transpose</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the IT Ops Priority Value to the Priority Field, when updated</description>
        <formula>AND (
     RecordType.Name = &apos;IT Operations&apos;,
     OR (
         ISNEW(), 
         ISCHANGED(  IT_Ops_Priority__c )
        )
     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Story Assigned</fullName>
        <actions>
            <name>Story_assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify the Story Assignee through email</description>
        <formula>AND( IsChanged( copado__Developer__c ),  RecordType.DeveloperName &lt;&gt; &apos;IT_Operations&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Support Investigation Completed No Owners</fullName>
        <actions>
            <name>Support_Investigation_Completed_No_Owners</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email to Customer Support team when the US status changed  to completed,ready for testing, cancelled, inprogress-blocked, waiting for customer or in code review. This US was not created by Customer Support, but they want to be notified anyway.</description>
        <formula>AND(RecordType.Name == &quot;Investigation&quot;, CONTAINS( copado__Theme__r.Name, &quot;Bugs&quot;), OR(TEXT(copado__Status__c)==&quot;Ready for Manual Testing&quot;,TEXT(copado__Status__c)==&quot;Ready for Tech. Review&quot;,TEXT(copado__Status__c)==&quot;Completed&quot;,TEXT(copado__Status__c)==&quot;Cancelled&quot;,TEXT(copado__Status__c)==&quot;Development Blocked&quot;, TEXT(copado__Status__c)==&quot;Waiting for customer&quot;),  CreatedBy.UserRole.Name != &quot;Customer Support&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Investigation Completed Owners</fullName>
        <actions>
            <name>Support_Investigation_Completed_Owners</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email to Customer Support team when the US have changed the status to completed,ready for testing or in code review. The US is no created by Customer Support</description>
        <formula>AND(RecordType.Name == &quot;Investigation&quot;, CONTAINS( copado__Theme__r.Name, &quot;Bugs&quot;), OR(TEXT(copado__Status__c)==&quot;Ready for Manual Testing&quot;,TEXT(copado__Status__c)==&quot;Ready for Tech. Review&quot;,TEXT(copado__Status__c)==&quot;Completed&quot;,TEXT(copado__Status__c)==&quot;Cancelled&quot;,TEXT(copado__Status__c)==&quot;Development Blocked&quot;, TEXT(copado__Status__c)==&quot;Waiting for customer&quot;),  CreatedBy.UserRole.Name == &quot;Customer Support&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Progress when User Story is Released2</fullName>
        <actions>
            <name>Progress_to_100</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>User_Story_Indexing_Metadata</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>copado__User_Story__c.copado__Status__c</field>
            <operation>equals</operation>
            <value>Released</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status when Environment is APO</fullName>
        <actions>
            <name>Update_Status_to_Released</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the user story status to Released when the environment is APO Production</description>
        <formula>copado__Environment__r.Name == &apos;APO Production&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>User Story Close Date Is In 2 Days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>copado__User_Story__c.copado__Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Notify case owner that the close date is in 2 days.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>User_Story_Due_In_2_Days_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>copado__User_Story__c.copado__Close_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>User Story Close Date Is Today</fullName>
        <active>true</active>
        <criteriaItems>
            <field>copado__User_Story__c.copado__Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Notify case owner that the close date is today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>User_Story_Due_Today_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>copado__User_Story__c.copado__Close_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>User Story Environment Changed</fullName>
        <actions>
            <name>User_Story_Environment_Changed_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify the user story owner when the user story environment changes the value from non-empty to another non-empty value.</description>
        <formula>AND( ISCHANGED( copado__Environment__c ), NOT( ISBLANK( PRIORVALUE( copado__Environment__c ))), NOT( ISBLANK( copado__Environment__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Story Status Updated Not By Owner</fullName>
        <actions>
            <name>User_Story_Status_Updated_Not_By_Owner_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When the user story status changes and the change is done not by the owner.</description>
        <formula>AND(ISCHANGED( copado__Status__c ),OwnerId &lt;&gt; LastModifiedById)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Work Item Assigned</fullName>
        <actions>
            <name>Work_Item_assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify the Copado Work Item Assignee through email (US-0021619)</description>
        <formula>AND( NOT(ISBLANK( copado__Developer__c )),  RecordType.DeveloperName = &apos;IT_Operations&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>APO_User_Story_Testing</fullName>
        <assignedToType>owner</assignedToType>
        <description>Your user story is ready to test. If you only need to verify then please check and select completed in user story testing date.</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>APO User Story Testing</subject>
    </tasks>
</Workflow>
