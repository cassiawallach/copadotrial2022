public with sharing class ConfigurationStepTriggerHelper implements ITrigger {
    public void bulkBefore(){}
    
    public void bulkAfter(){}
    
    public void beforeInsert(SObject so){
        Configuration_Step__c cs = (Configuration_Step__c)so;
        if(cs.Package_Installation_Key__c != null && cs.Package_Installation_Key__c != ''){
           cs.Package_Installation_Key__c = cps_Crypto.encryptString(cs.Package_Installation_Key__c);
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Configuration_Step__c oldCs = (Configuration_Step__c)oldSo;
        Configuration_Step__c cs = (Configuration_Step__c)so;
        if(cs.Package_Installation_Key__c != null && cs.Package_Installation_Key__c != '' && (cs.Package_Installation_Key__c != oldCs.Package_Installation_Key__c)){
           cs.Package_Installation_Key__c = cps_Crypto.encryptString(cs.Package_Installation_Key__c); 
        }
    }
    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){}
    
    public void afterDelete(SObject so){}
    public void andFinally(){}
}