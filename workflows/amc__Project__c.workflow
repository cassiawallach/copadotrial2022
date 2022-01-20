<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CSAT_needs_to_be_send_out</fullName>
        <description>Notify That CSAT needs to be send out</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Project_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>help@copa.do</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CSAT_Templates/CSAT_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_Send_Project_Completion_Notification</fullName>
        <description>Email Alert: Send Project Completion Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Customer_Success_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>nharris@copado.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>amc__Mission_Control_Email_Templates/Project_Project_Complete_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_Send_Project_Customer_Success_Handover_Notification</fullName>
        <description>Email Alert: Send Project Customer Success Handover Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Customer_Success_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Project_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>amc__Mission_Control_Email_Templates/Project_Customer_Success_Handover_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Send_Project_Owner_Assigned_Notification</fullName>
        <description>Email: Send Project Owner Assigned Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Customer_Success_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>nharris@copado.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>amc__Mission_Control_Email_Templates/Project_Project_Owner_Assigned</template>
    </alerts>
    <fieldUpdates>
        <fullName>FU_Account_Owner_Email</fullName>
        <description>Field Update to populate the Project &apos;Account Owner Email&apos; field</description>
        <field>Account_Owner_Email__c</field>
        <formula>amc__Account__r.Owner.Email</formula>
        <name>FU: Account Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FU_Customer_Success_Manager_Email</fullName>
        <description>Field Update to populate the Project &apos;Customer Success Manager Email&apos; field</description>
        <field>Customer_Success_Manager_Email__c</field>
        <formula>amc__Account__r.Customer_Success_Manager__r.Email</formula>
        <name>FU: Customer Success Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FU_Project_Owner_Email</fullName>
        <description>Field Update to populate the Project &apos;Project Owner Email&apos; field</description>
        <field>Project_Owner_Email__c</field>
        <formula>amc__Project_Owner__r.amc__User__r.Email</formula>
        <name>FU: Project Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Project_Owner_Email_Update</fullName>
        <description>Related to this user story: US-0024142</description>
        <field>Project_Owner_Email__c</field>
        <formula>amc__Project_Owner__r.amc__Email_Lookup__c</formula>
        <name>Project Owner Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Project%3A Populate Account Owner Email</fullName>
        <actions>
            <name>FU_Account_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populates the Account Owner Email field</description>
        <formula>Account_Owner_Email__c &lt;&gt; amc__Account__r.Owner.Email</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Project%3A Populate Customer Success Manager Email</fullName>
        <actions>
            <name>FU_Customer_Success_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populates the Customer Success Manager Email field</description>
        <formula>Customer_Success_Manager_Email__c &lt;&gt; amc__Account__r.Customer_Success_Manager__r.Email</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Project%3A Populate Project Owner Email</fullName>
        <actions>
            <name>FU_Project_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populates the Project Owner Email field</description>
        <formula>Project_Owner_Email__c &lt;&gt; amc__Project_Owner__r.amc__User__r.Email</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Project%3A Send Customer Success Handover Notification</fullName>
        <actions>
            <name>Email_Alert_Send_Project_Customer_Success_Handover_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>amc__Project__c.Send_CSH_Milestone_Notification__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends an Email Alert to the Account Owner, Customer Success Manager and Project Owner when a Milestone is marked as Complete if it has a Milestone Type value of &apos;Customer Success Handover&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Project%3A Send Project Completion Notification</fullName>
        <actions>
            <name>Email_Alert_Send_Project_Completion_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>amc__Project__c.amc__Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <description>Sends an Email Alert to the Account Owner, Customer Success Manager and Customer Success Director when a Project is marked as Complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Project%3A Send Project Owner Assigned Notification</fullName>
        <actions>
            <name>Email_Send_Project_Owner_Assigned_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends an Email Alert to the Account Owner, Customer Success Manager and Customer Success Director when a Project Owner is assigned to a Project</description>
        <formula>AND(Account_Owner_Email__c != null, OR(AND( amc__Project_Owner__c != null, ISNULL(PRIORVALUE(amc__Project_Owner__c)) ), amc__Project_Owner__c &lt;&gt; PRIORVALUE(amc__Project_Owner__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WhenMCProjectComplete</fullName>
        <actions>
            <name>Project_Owner_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>amc__Project__c.amc__Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CSAT_needs_to_be_send_out</name>
                <type>Alert</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
