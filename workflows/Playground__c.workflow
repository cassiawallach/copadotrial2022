<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Community_User_that_all_sandboxes_are_created</fullName>
        <description>Email Community User that all sandboxes are created</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Academy/Playground_All_Sandboxes_created</template>
    </alerts>
</Workflow>
