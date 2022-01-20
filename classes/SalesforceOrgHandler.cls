public with sharing class SalesforceOrgHandler implements ITrigger {

    public SalesforceOrgHandler(){

    }
    public void bulkBefore(){
        SalesforceOrgService.prepareData(Trigger.new);
    }

    public void bulkAfter(){
    }

    public void beforeInsert(SObject so){
        Salesforce_Org__c o = (Salesforce_Org__c)so;
        SalesforceOrgService.updateOrgLicensingInfo(o);
    }

    public void beforeUpdate(SObject oldSo, SObject so){
        Salesforce_Org__c o = (Salesforce_Org__c)so;
        SalesforceOrgService.updateOrgLicensingInfo(o);
        SalesforceOrgService.setTopUpDate(o);

    }
    public void beforeDelete(SObject so){
    }

    public void afterInsert(SObject so){
        Salesforce_Org__c o = (Salesforce_Org__c)so;
    }

    public void afterUpdate(SObject oldSo, SObject so){
    }

    public void afterDelete(SObject so){
    }
    public void andFinally(){
    }
}