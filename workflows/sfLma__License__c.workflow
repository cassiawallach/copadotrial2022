<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>License_Suspension_Notification</fullName>
        <description>License Suspension Notification</description>
        <protected>false</protected>
        <recipients>
            <field>sfLma__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>help@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/License_suspension_notification_Enhanced</template>
    </alerts>
    <fieldUpdates>
        <fullName>License_Force_Active_TRUE</fullName>
        <field>Force_to_remain_Active__c</field>
        <literalValue>1</literalValue>
        <name>License Force Active = TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Suspend_license</fullName>
        <field>sfLma__Status__c</field>
        <literalValue>Suspended</literalValue>
        <name>Suspend license</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Block Competitor license activation</fullName>
        <actions>
            <name>Suspend_license</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>sfLma__License__c.Is_Blocked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email BlockList</fullName>
        <actions>
            <name>Suspend_license</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(   NOT( Force_to_remain_Active__c),   OR(     CONTAINS(sfLma__Lead__r.Email  , &quot;vlaxmanmadival@deloitte.com&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;vlaxmanmadival@deloitte.com&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@autorabit&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@autorabit&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@red-gate&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@red-gate&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;gearset&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;gearset&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@gmail&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@gmail&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@ymail&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@ymail&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@outlook&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@outlook&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@hotmail&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@hotmail&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@aol&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@aol&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@gmx&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@gmx&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@yahoo&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@yahoo&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@icloud&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@icloud&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@me.com&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@me.com&quot;),     CONTAINS(sfLma__Lead__r.Email  , &quot;@mac.com&quot;),     CONTAINS(Salesforce_User__r.Email__c, &quot;@mac.com&quot;),     CONTAINS(sfLma__Lead__r.Email , &quot;@yopmail&quot;),      CONTAINS(Salesforce_User__r.Email__c, &quot;@yopmail&quot;),     CONTAINS(sfLma__Lead__r.Email , &quot;@live.&quot;),      CONTAINS(Salesforce_User__r.Email__c, &quot;@live.&quot;),     CONTAINS(sfLma__Lead__r.Email , &quot;@inbox.&quot;),      CONTAINS(Salesforce_User__r.Email__c, &quot;@inbox.&quot;),     CONTAINS(sfLma__Lead__r.Email , &quot;@163.&quot;),      CONTAINS(Salesforce_User__r.Email__c, &quot;@163.&quot;),      CONTAINS(Salesforce_User__r.Email__c, &quot;@skarklasers.&quot;),     CONTAINS(sfLma__Lead__r.Email , &quot;@skarklasers.&quot;),      CONTAINS(Salesforce_User__r.Email__c, &quot;@guerillamail.&quot;),     CONTAINS(sfLma__Lead__r.Email , &quot;@guerillamail.&quot;),      CONTAINS(Salesforce_User__r.Email__c, &quot;@grr.la&quot;),     CONTAINS(sfLma__Lead__r.Email , &quot;@grr.la&quot;),      CONTAINS(Salesforce_User__r.Email__c, &quot;@pokemail.&quot;),     CONTAINS(sfLma__Lead__r.Email , &quot;@pokemail.&quot;),      CONTAINS(Salesforce_User__r.Email__c, &quot;.onmicrosoft.com&quot;),     CONTAINS(sfLma__Lead__r.Email , &quot;.onmicrosoft.com&quot;)        ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Salesforce Employee License</fullName>
        <actions>
            <name>License_Force_Active_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>We do not want to deactivate Salesforce employee licenses.</description>
        <formula>CONTAINS(sfLma__Lead__r.Email, &quot;@salesforce.com&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set License Suspension after 30 days</fullName>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>sfLma__License__c.sfLma__Licensed_Seats__c</field>
            <operation>equals</operation>
            <value>Site License</value>
        </criteriaItems>
        <criteriaItems>
            <field>sfLma__License__c.sfLma__Org_Type__c</field>
            <operation>equals</operation>
            <value>Developer Edition</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Suspend_license</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
