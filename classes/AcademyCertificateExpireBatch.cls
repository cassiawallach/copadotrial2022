global class AcademyCertificateExpireBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Name, Expiration_Date__c, Status__c FROM Academy_Certification__c WHERE Status__c = 'Valid' AND Expiration_Date__c<:System.today() ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Academy_Certification__c> scope){
        if(scope.size()>0){
            List<Academy_Certification__c> scopeList = new List<Academy_Certification__c>();
            for(Academy_Certification__c Academy_Certification : scope){
                Academy_Certification.Status__c='Expired';
                scopeList.add(Academy_Certification);
            }
            if(scopeList.size()>0){
                UPDATE scopeList;  
            }
        }        
    }
    
    global void finish(Database.BatchableContext BC){
    }
}