public without sharing class Copado_Package_installer{
    @AuraEnabled
    public static List<copado__Release__c> getAllReleaseRecords(){
        RETURN [SELECT 
                Id, Name, copado__Planned_Date__c, copado__Description__c, copado__Status__c, 
                Visible_in_Community__c, copado__Version__c, Installation_Link_in_Sandbox__c, Installation_Link_in_Production__c, Documentation_Release_Notes__c 
                FROM 
                copado__Release__c 
                WHERE 
                Visible_in_Community__c = TRUE AND 
                copado__Planned_Date__c !=NULL
                ORDER BY copado__Planned_Date__c DESC
               ];
    }
}