<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FU_Project_Send_CSH_Notification</fullName>
        <description>Field Update to populate the Project &apos;Send CSH Milestone Notification&apos; field</description>
        <field>Send_CSH_Milestone_Notification__c</field>
        <literalValue>1</literalValue>
        <name>FU: Project Send CSH Notification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>amc__Project__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Milestone%3A Send Customer Success Handover Notification</fullName>
        <actions>
            <name>FU_Project_Send_CSH_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Performs a Field Update on the Project when a Milestone is marked as Complete if it has a Milestone Type value of &apos;Customer Success Handover&apos;</description>
        <formula>AND(ISPICKVAL(amc__Milestone_Type__c, &quot;Customer Success Handover&quot;), ISPICKVAL(amc__Status__c, &quot;Complete&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
