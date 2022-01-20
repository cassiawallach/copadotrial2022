<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_Opp_Owner_POC_Guide_has_been_viewed</fullName>
        <description>Alert Opp Owner: POC Guide has been viewed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Alert_Opp_Owner_POC_viewed</template>
    </alerts>
    <alerts>
        <fullName>New_Sign_Contract_received</fullName>
        <description>New Sign Contract received</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales_Leader</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Sales_Ops</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>VP_Customer_Success</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>sales@copado.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Signed_Contract_rec</template>
    </alerts>
    <alerts>
        <fullName>New_Won_Opp_Alert</fullName>
        <description>New Won Opp Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales_Leader</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Sales_Ops</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>aleigh@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bbenz@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cameron@copado.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dfreeman@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sgidwani@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sgillert@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ted@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vrossi@copado.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Sales_Engineer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sales@copado.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>System_Emails/Opportunity_Won_Alert</template>
    </alerts>
    <alerts>
        <fullName>X1_Week_prior_to_net_billing</fullName>
        <ccEmails>accountsreceivable@copado.com</ccEmails>
        <description>1 Week prior to net billing.</description>
        <protected>false</protected>
        <recipients>
            <recipient>rmilem@copa.do</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rwong@copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Marketing/Multi_Year_Opty</template>
    </alerts>
    <fieldUpdates>
        <fullName>Increment_Push_Counter_Field</fullName>
        <description>Increment the Push Counter by 1</description>
        <field>Push_Counter__c</field>
        <formula>IF( 
ISNULL( Push_Counter__c ), 
1, 
Push_Counter__c + 1 
)</formula>
        <name>Increment Push Counter Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Name</fullName>
        <field>Name</field>
        <formula>Account.Name +  &quot; Renewal- &quot; + Text(YEAR( CloseDate ))</formula>
        <name>Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ordered</fullName>
        <description>Update the ordered field on the opportunity when closed won</description>
        <field>SBQQ__Ordered__c</field>
        <literalValue>1</literalValue>
        <name>Ordered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contracted_Checkbox_to_TRUE</fullName>
        <field>SBQQ__Contracted__c</field>
        <literalValue>1</literalValue>
        <name>Set Contracted Checkbox to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Price_Book_to_Pathfinder</fullName>
        <description>Sets the Quote Price Book to Pathfinder.</description>
        <field>SBQQ__QuotePricebookId__c</field>
        <formula>&quot;01s1j000000XnSi&quot;</formula>
        <name>Set Price Book to Pathfinder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Price_Book_to_default</fullName>
        <description>Sets the Quote Price Book to the default price book - Copado Subscriptions 2019.</description>
        <field>SBQQ__QuotePricebookId__c</field>
        <formula>&quot;01sb0000002aM52&quot;</formula>
        <name>Set Price Book to default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Renewal_Opportunity_Name</fullName>
        <description>Set the renewal Opportunity name to:
Renewal: Old opportunity name</description>
        <field>Name</field>
        <formula>IF(
  NOT(ISBLANK(SBQQ__RenewedContract__r.Account.Name)),
  SBQQ__RenewedContract__r.Account.Name &amp; &apos; - Renewal &apos; &amp;  TEXT(
    YEAR(SBQQ__RenewedContract__r.EndDate)
  ),
  Account.Name  &amp; &apos; - Renewal &apos; &amp;  TEXT(YEAR(TODAY()) + 1)
)</formula>
        <name>Set Renewal Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_to_renewal</fullName>
        <field>Type</field>
        <literalValue>Renewal</literalValue>
        <name>Type to renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateContracted</fullName>
        <description>This action is updating the SBQQ__Contracted__c to TRUE</description>
        <field>SBQQ__Contracted__c</field>
        <literalValue>1</literalValue>
        <name>UpdateContracted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contracted_checkbox</fullName>
        <description>Workflow to check the Contracted checkbox on Oppty when Closed/Won.</description>
        <field>SBQQ__Contracted__c</field>
        <literalValue>1</literalValue>
        <name>Update Contracted checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uplift_to_7</fullName>
        <field>PS_Uplift__c</field>
        <formula>0.07</formula>
        <name>Uplift to 7 %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__UpdateAutoEmailRenewalOrderUnchecked</fullName>
        <description>If Renewal Opportunity Status is Closed/lost then do field update to “Auto Email Renewal Order” = FALSE</description>
        <field>kuga_sub__AutoEmailRenewalOrder__c</field>
        <literalValue>0</literalValue>
        <name>Update AutoEmailRenewalOrder - Unchecked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kuga_sub__UpdateRenewalOrderAutoCreationDate</fullName>
        <description>If Renewal Opportunity Status is Closed/lost then do field update to “Auto Email Renewal Order” = FALSE &amp; “Renewal Order Auto Creation Date” = BLANK</description>
        <field>kuga_sub__RenewalOrderAutoCreationDate__c</field>
        <name>Update RenewalOrderAutoCreationDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>AutomaticContract</fullName>
        <actions>
            <name>UpdateContracted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>The rule evaluates if Opportunity Stage = &quot;Closed Won&quot; then marks it as TRUE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Automation to check the Contraced checkbox</fullName>
        <actions>
            <name>Update_Contracted_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>Workflow/automation to check the Contracted checkbox on Oppty when Closed/Won.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Multi year Opty Close Dates</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
            <value>Multi-year</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Negotiation/Review,Negotiation</value>
        </criteriaItems>
        <description>Notify 1 week prior to the net billing for multi year Opty</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X1_Week_prior_to_net_billing</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Name of Renewal Opportunites</fullName>
        <actions>
            <name>Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SBQQ__Renewal__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sets name of Renewal Opportunity to &quot;Account Name Renewal - Year&quot;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Signed Contract Received</fullName>
        <actions>
            <name>New_Sign_Contract_received</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Signed Contract Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Expansion,New,Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>notEqual</operation>
            <value>License Swap</value>
        </criteriaItems>
        <description>Email alert to Sales Ops and SVP Sales when an opportunity stage is changed to &quot;Sign Contract Received&quot;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Closed Won Alert</fullName>
        <actions>
            <name>New_Won_Opp_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>notEqual</operation>
            <value>Multi-year</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>notEqual</operation>
            <value>License Swap</value>
        </criteriaItems>
        <description>Email alert for opportunities moved to type &quot;Closed Won&quot;. Currently excludes Renewal type opportunities.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity type to renewal</fullName>
        <actions>
            <name>Type_to_renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.SBQQ__Renewal__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <description>Sets Opportunity Type for &quot;Renewal&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Push Counter</fullName>
        <actions>
            <name>Increment_Push_Counter_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Increment the Push Counter field by 1</description>
        <formula>IF(  CloseDate &gt; PRIORVALUE( CloseDate ),  IF (MONTH(CloseDate) &lt;&gt; MONTH(PRIORVALUE( CloseDate )) ,  TRUE,  FALSE),  FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Opportunity Price Book to Pathfinder</fullName>
        <actions>
            <name>Set_Price_Book_to_Pathfinder</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.PS_CPQ_Pricing_Group__c</field>
            <operation>equals</operation>
            <value>Pathfinder</value>
        </criteriaItems>
        <description>Sets the Opportunity Price Book to the Pathfinder price book, which is then used by all Quotes created from that Opportunity, based on Price Group picklist field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Opportunity Price Book to Standard</fullName>
        <actions>
            <name>Set_Price_Book_to_default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.PS_CPQ_Pricing_Group__c</field>
            <operation>equals</operation>
            <value>Standard</value>
        </criteriaItems>
        <description>Sets the Opportunity Price Book to the default price book, which is then used by all Quotes created from that Opportunity, based on Price Group picklist field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set to Contracted</fullName>
        <actions>
            <name>Set_Contracted_Checkbox_to_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kuga_sub__Kugamon Update Renewal Opportunity Stage - Closed%2FLost</fullName>
        <actions>
            <name>kuga_sub__UpdateAutoEmailRenewalOrderUnchecked</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>kuga_sub__UpdateRenewalOrderAutoCreationDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <description>Kugamon - Okay to Edit - Disable Renewal Order Automation for Closed/Lost Opportunities

Condition:
- Renewal Opportunity Stage is Closed/Lost

Action:
- Update Auto Email Renewal Order to FALSE 
- Update Renewal Order Auto Generation Date to BLANK</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kuga_sub__Kugamon Update Renewal Primary Order</fullName>
        <actions>
            <name>kuga_sub__UpdateAutoEmailRenewalOrderUnchecked</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>kuga_sub__UpdateRenewalOrderAutoCreationDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Kugamon - Okay to Edit - Disable Renewal Order Automation for Primary Order

Condition:
- Primary Order Created &lt; Order Auto Generation Date

Action:
- Update Auto Email Renewal Order to FALSE 
- Update Renewal Order Auto Generation Date to BLANK</description>
        <formula>AND(NOT(ISBLANK(kugo2p__PrimaryOrder__c)), kuga_sub__RenewalOrderAutoCreationDate__c &gt; TODAY())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
