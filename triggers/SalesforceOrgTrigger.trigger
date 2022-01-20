trigger SalesforceOrgTrigger on Salesforce_Org__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(SalesforceOrgService.salesforceOrgTriggerActive){
        System.debug('@@@ Entering Salesforce_Org__c Trigger @@@');
        TriggerFactory.createHandler(Salesforce_Org__c.sObjectType);
    }
    else{
        System.debug('@@@ Skipping Salesforce_Org__c Trigger @@@');
    }
}