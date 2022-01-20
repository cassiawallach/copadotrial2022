public with sharing class LicenseHandler implements ITrigger{

    public LicenseHandler(){
    }

    public void bulkBefore(){
        LicenseHelper.prepareData(Trigger.new);
        //if(trigger.new != null && Trigger.IsInsert ) LicenseHelper.prepareDataOnBeforeInsert(Trigger.new);
    }

    public void bulkAfter(){
    }

    public void beforeInsert(SObject so){
    }

    public void beforeUpdate(SObject oldSo, SObject so){
    }

    public void beforeDelete(SObject so){
    }

    public void afterInsert(SObject so){
        if(trigger.newMap != null && Trigger.IsInsert && boolean.valueOf(SYSTEM.Label.LicenseTriggerSalesForceOrgCode)) LicenseHelper.prepareDataOnInsert(Trigger.newMap);
    }

    public void afterUpdate(SObject oldSo, SObject so){
        LicenseHelper.createZeroFeatureParameterIntegers((sfLma__License__c)oldSo, (sfLma__License__c)so);
        LicenseHelper.forceParameterIntegersUpdate((sfLma__License__c)oldSo, (sfLma__License__c)so);
        LicenseHelper.setOrgEdition((sfLma__License__c)so);
    }

    public void afterDelete(SObject so){
    }

    public void andFinally(){
        LicenseHelper.upsertFeatureParameterIntegers();
        LicenseHelper.updateForcedFPIs();
        LicenseHelper.updateOrgs();
    }
}