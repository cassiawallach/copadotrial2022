<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Coupon_Request_Approved</fullName>
        <description>Coupon Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>mentorship@copado.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Academy/Coupon_Request_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Coupon_to_Active</fullName>
        <field>ltcomm__Active__c</field>
        <literalValue>1</literalValue>
        <name>Update Coupon to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
