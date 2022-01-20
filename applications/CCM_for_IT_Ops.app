<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <brand>
        <headerColor>#0070D2</headerColor>
        <logoVersion>1</logoVersion>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>Copado Change Management Tool for IT Operations</description>
    <formFactors>Small</formFactors>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <label>CCM for IT Ops</label>
    <navType>Console</navType>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>IT_Ops_User_Story_Record_Page</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>copado__User_Story__c</pageOrSobjectType>
        <recordType>copado__User_Story__c.IT_Operations</recordType>
        <type>Flexipage</type>
        <profile>IT Operations</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>IT_Ops_User_Story_Record_Page</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>copado__User_Story__c</pageOrSobjectType>
        <recordType>copado__User_Story__c.IT_Operations</recordType>
        <type>Flexipage</type>
        <profile>System Administrator (IT Ops)</profile>
    </profileActionOverrides>
    <tabs>copado__Project__c</tabs>
    <tabs>copado__Sprint__c</tabs>
    <tabs>copado__User_Story__c</tabs>
    <tabs>standard-Case</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>CCM_for_IT_Ops_UtilityBar</utilityBar>
    <workspaceConfig>
        <mappings>
            <tab>copado__Project__c</tab>
        </mappings>
        <mappings>
            <tab>copado__Sprint__c</tab>
        </mappings>
        <mappings>
            <fieldName>copado__Project__c</fieldName>
            <tab>copado__User_Story__c</tab>
        </mappings>
        <mappings>
            <tab>standard-Case</tab>
        </mappings>
    </workspaceConfig>
</CustomApplication>
