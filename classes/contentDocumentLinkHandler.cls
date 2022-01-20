//Created by Englhard Consulting August 19th, 2019
public class contentDocumentLinkHandler {
	
    public static void handleTrigger(LIST<ContentDocumentLink> cdlList){
        
        //Gather Agreement Id to Primary Document Id Map
        MAP<Id,Id> aToPdIdMap = new MAP<Id,Id>();
        //List of Agreements to set Primary Document with
        LIST<Agreement__c> aList = new LIST<Agreement__c>();
        for(ContentDocumentLink cdl: cdlList){
            //Ensure the right object is tied to the Content Document Link
            if(string.valueOf(cdl.LinkedEntityId).startsWith(Agreement__c.sObjectType.getDescribe().getKeyPrefix())){
                //Add to Agreement Id to Primary Document Id Map
                aToPdIdMap.put(cdl.LinkedEntityId,cdl.ContentDocumentId);
            }
        }
        //Check if Map is null
        if(!aToPdIdMap.isEmpty()){
            //Get agreements
            aList = [SELECT Id, Primary_Document__c FROM Agreement__c WHERE Id IN: aToPdIdMap.keySet()];
            for(Agreement__c a : aList){
                if(a.Primary_Document__c == Null){
                    //Set primary document
                    a.Primary_Document__c = aToPdIdMap.get(a.Id);
                }
            }
            update aList;
        }
    }
}