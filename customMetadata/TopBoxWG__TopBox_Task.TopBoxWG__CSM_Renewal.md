<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Renewal</label>
    <protected>false</protected>
    <values>
        <field>TopBoxWG__Assignee_Field_Name__c</field>
        <value xsi:type="xsd:string">Customer_Success_Manager__c</value>
    </values>
    <values>
        <field>TopBoxWG__Assignee_Id__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>TopBoxWG__Assignee_UserId__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>TopBoxWG__CSM_Due_Weekday__c</field>
        <value xsi:type="xsd:string">Friday</value>
    </values>
    <values>
        <field>TopBoxWG__CSM_Reminder_Weekday__c</field>
        <value xsi:type="xsd:string">Monday</value>
    </values>
    <values>
        <field>TopBoxWG__CSM_Task_Hour__c</field>
        <value xsi:type="xsd:double">6.0</value>
    </values>
    <values>
        <field>TopBoxWG__CSM_Task_Minute__c</field>
        <value xsi:type="xsd:double">0.0</value>
    </values>
    <values>
        <field>TopBoxWG__CSM_Task_Type__c</field>
        <value xsi:type="xsd:string">Renewal</value>
    </values>
    <values>
        <field>TopBoxWG__Comments__c</field>
        <value xsi:type="xsd:string">This is an automated notification to remind you to begin Active Recruiting activities for {{Name}}, as this account will be included in the Copado Engage feedback campaign on {{date}}. Active Recruiting typically entails the following steps:

0) Make sure the Account record is up to date, ESPECIALLY the company name of the implementation partner since this is referenced directly in the Onboarding questionnaire.

1) Collaborate internally with your AE and RM to draft the list of contacts who should be involved in the program. Denote their Contact Role on the Contact Record following the guidance outlined below.

- Salesforce Executive = the person who holds the budget and signs off on the contract. Titles may include VP/Head of Applications/CRM/IT
- Champion = The person who shepherds Copado through the purchase and implementation process. Titles may include Program Manager, Director of IT, Director of CRM
- Influencer = End Copado users may report into this person or they may be a trusted Admin. They do not own the budget or make the final decision. Titles may include DevOps Leader, DevOps Manager
*Smaller accounts may not have an Influencer
- Copado Owner = Person who owns day to day use of Copado. They may be the administrator of Copado, assigning licenses, deciding when to upgrade, etc. Titles may include Solution/Salesforce/Platform Architect, Release Manager, or DevOps Engineer/Manager at a smaller company.

2) Educate your customer-Champion in the account about the Copado Engage program. Position the program with, “Will you help us help you by answering a short assessment that helps us drive the right improvements? The assessment is planned to launch on {{date}}, will take no more than 5 minutes, and I (and my colleagues across the company) am personally committed to follow-up and address what you tell us. Will you participate?”

3) Upon receiving your champion’s opt-in/agreement to participate, “In order to make sure we’re addressing the optimal areas for {{Name}}, it’s important that we understand the various perspectives of key contacts. I am committed to being transparent, sharing results with you, and using feedback to drive the right improvements. Who else is in a good position to assess the relationship between our two companies and the value that we provide to {{Name}}?”

If your Champion declines, “My priority is ensure success for both of us. What are your concerns about the process, and how would you prefer to get the feedback from your colleagues around the business to know where to focus?” Gather the information and bring to Katie for possible exec-sponsor engagement or postponement.

4) Finally, ask your champion if they would be willing to help you gain an affirmative opt-in to participate from the other contacts, “I have a brief email that I’d like to ask that you forward on to these other people. Will you help me gain their agreement to participate so we can be confident that we’re addressing the right areas moving forward?”</value>
    </values>
    <values>
        <field>TopBoxWG__Due_Date_Hours__c</field>
        <value xsi:type="xsd:double">72.0</value>
    </values>
    <values>
        <field>TopBoxWG__Due_Date_Reminders__c</field>
        <value xsi:type="xsd:string">Hour-based</value>
    </values>
    <values>
        <field>TopBoxWG__Due_Date__c</field>
        <value xsi:type="xsd:string">Hours Before</value>
    </values>
    <values>
        <field>TopBoxWG__Email_CC_Email_Addresses__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>TopBoxWG__Email_CC_Field_Names__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>TopBoxWG__Feedback_Contact_Me_Value__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>TopBoxWG__Feedback_Followup_Type__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>TopBoxWG__Is_Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>TopBoxWG__Reminder_Hours__c</field>
        <value xsi:type="xsd:double">504.0</value>
    </values>
    <values>
        <field>TopBoxWG__Reminder__c</field>
        <value xsi:type="xsd:string">Hours Before</value>
    </values>
    <values>
        <field>TopBoxWG__Searchable_Subject_Text__c</field>
        <value xsi:type="xsd:string">{{Name}} will be included in {{month}} {{type}}</value>
    </values>
    <values>
        <field>TopBoxWG__Send_Notification_Email__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>TopBoxWG__Subject__c</field>
        <value xsi:type="xsd:string">{{search text}} Copado Engage feedback wave</value>
    </values>
    <values>
        <field>TopBoxWG__Task_Type__c</field>
        <value xsi:type="xsd:string">CSM</value>
    </values>
</CustomMetadata>
