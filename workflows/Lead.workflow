<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Welcome_Installation_email</fullName>
        <description>Welcome Installation email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>help@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Copado_Leads/Welcome_Installation_Enhanced</template>
    </alerts>
    <fieldUpdates>
        <fullName>AppExchange_valuesDM</fullName>
        <field>LeadSource</field>
        <literalValue>Watch Demo</literalValue>
        <name>AppExchange valuesDM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AppExchange_valuesIN</fullName>
        <field>LeadSource</field>
        <literalValue>AppExchange</literalValue>
        <name>AppExchange valuesIN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_0</fullName>
        <field>Status</field>
        <literalValue>SDR - Meeting Set</literalValue>
        <name>EBQ Rating 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_1</fullName>
        <field>Status</field>
        <literalValue>SDR - Rescheduling</literalValue>
        <name>EBQ Rating 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_10</fullName>
        <field>Status</field>
        <literalValue>Unqualified</literalValue>
        <name>EBQ Rating 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_2</fullName>
        <field>Status</field>
        <literalValue>Requested Info</literalValue>
        <name>EBQ Rating 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_3</fullName>
        <field>Status</field>
        <literalValue>MQL</literalValue>
        <name>EBQ Rating 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_5</fullName>
        <field>Status</field>
        <literalValue>SDR - Short Term Follow Up</literalValue>
        <name>EBQ Rating 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_6</fullName>
        <field>Status</field>
        <literalValue>SDR - Long Term Follow Up</literalValue>
        <name>EBQ Rating 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_7</fullName>
        <field>Status</field>
        <literalValue>SDR - Cold; No Contact Made</literalValue>
        <name>EBQ Rating 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_8</fullName>
        <field>Status</field>
        <literalValue>Unsubscribe</literalValue>
        <name>EBQ Rating 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_9_99</fullName>
        <field>Status</field>
        <literalValue>SDR - (Wrong contact)</literalValue>
        <name>EBQ Rating 9, 99</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBQ_Rating_Null</fullName>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>EBQ Rating Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Opt_Out</fullName>
        <description>If the description of the AppExchange Lead is &quot;This customer does NOT want to be contacted about other products or services that you offer.&quot; the Lead is opted out.</description>
        <field>HasOptedOutOfEmail</field>
        <literalValue>1</literalValue>
        <name>Lead Opt Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Outreach_Engagement_Score_Field_Update_o</fullName>
        <description>Rule: If “Email Opt Out” field equals True, then Engagement Score field should be set to “Do Not Contact”</description>
        <field>Engagement_Score__c</field>
        <literalValue>Do Not Contact</literalValue>
        <name>Outreach Engagement Score Field Update o</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>St_Unqualified</fullName>
        <field>Status</field>
        <literalValue>Unqualified</literalValue>
        <name>St.Unqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>AppExchange valuesDM</fullName>
        <actions>
            <name>AppExchange_valuesDM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>startsWith</operation>
            <value>SFDC-DM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>startsWith</operation>
            <value>SFDC-dup-DM</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AppExchange valuesIN</fullName>
        <actions>
            <name>AppExchange_valuesIN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>startsWith</operation>
            <value>SFDC-IN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>startsWith</operation>
            <value>SFDC-dup-IN</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EBQ</fullName>
        <actions>
            <name>EBQ_Rating_9_99</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.EBQ_Rating__c</field>
            <operation>equals</operation>
            <value>9,99</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EBQ Rating 0</fullName>
        <actions>
            <name>EBQ_Rating_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.EBQ_Rating__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EBQ Rating 1</fullName>
        <actions>
            <name>EBQ_Rating_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.EBQ_Rating__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EBQ Rating 10</fullName>
        <actions>
            <name>EBQ_Rating_10</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.EBQ_Rating__c</field>
            <operation>equals</operation>
            <value>10</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EBQ Rating 2</fullName>
        <actions>
            <name>EBQ_Rating_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.EBQ_Rating__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EBQ Rating 3</fullName>
        <actions>
            <name>EBQ_Rating_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.EBQ_Rating__c</field>
            <operation>equals</operation>
            <value>3</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EBQ Rating 5</fullName>
        <actions>
            <name>EBQ_Rating_5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.EBQ_Rating__c</field>
            <operation>equals</operation>
            <value>5</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EBQ Rating 6</fullName>
        <actions>
            <name>EBQ_Rating_6</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.EBQ_Rating__c</field>
            <operation>equals</operation>
            <value>6</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EBQ Rating 7</fullName>
        <actions>
            <name>EBQ_Rating_7</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.EBQ_Rating__c</field>
            <operation>equals</operation>
            <value>7</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EBQ Rating 8</fullName>
        <actions>
            <name>EBQ_Rating_8</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.EBQ_Rating__c</field>
            <operation>equals</operation>
            <value>8</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Outreach Engagement Score Field Update on Lead</fullName>
        <actions>
            <name>Outreach_Engagement_Score_Field_Update_o</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Rule: If “Email Opt Out” field equals True, then Engagement Score field should be set to “Do Not Contact”</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
