<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_7_days_prior_to_Invoice_Date</fullName>
        <ccEmails>accountsreceivable@copado.com</ccEmails>
        <description>Email alert 7 days prior to Invoice Date</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>kugo2p__Kugamon_Templates/Kugamon_Online_Invoice_Email_Template_Copado_Edit1</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Status_to_Sent</fullName>
        <field>kugo2p__RecordStatus__c</field>
        <formula>&apos;Sent&apos;</formula>
        <name>Update Status to Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Invoice %3A email alert 7 days prior to Invoice Date</fullName>
        <active>true</active>
        <formula>NOT(ISBLANK( kugo2p__InvoiceDate__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_alert_7_days_prior_to_Invoice_Date</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_Status_to_Sent</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>kugo2p__KugamonInvoice__c.kugo2p__InvoiceDate__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
