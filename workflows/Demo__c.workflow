<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MeetingReminderAfterEnd</fullName>
        <description>Do not forget to update the meeting status  and attach any information</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_to__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>help@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Meeting_reminder_the_end</template>
    </alerts>
    <alerts>
        <fullName>Notify_Meeting_Update_to_Sales_Rep</fullName>
        <description>Notify Meeting Update to Sales Rep</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Templates/Meeting_updated</template>
    </alerts>
    <rules>
        <fullName>Meeting Rep Update</fullName>
        <actions>
            <name>Notify_Meeting_Update_to_Sales_Rep</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This rule ill notify Sales Reps whenever there is an update in the meeting record.</description>
        <formula>ISCHANGED(Status__c)  ||  ISCHANGED(Demo_outcome__c) || ISCHANGED(Video_URL__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Meeting reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Demo__c.Status__c</field>
            <operation>equals</operation>
            <value>Scheduled</value>
        </criteriaItems>
        <description>Send a reminder three hours after the end of a meeting</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>MeetingReminderAfterEnd</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Demo__c.Date__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
