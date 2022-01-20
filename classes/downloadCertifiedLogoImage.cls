public class downloadCertifiedLogoImage {
    @AuraEnabled
    Public Static ResponseWrap checkUserIsCertified(){
        ResponseWrap response = new ResponseWrap();
        response.IsError = TRUE;
        response.result = new List<String>();
        MAP<Id,String> Certification_ProgramIdWithNameMap = new MAP<Id,String>();
        Set<Id> Certification_ProgramIds = new Set<Id>();
        List<User> LoggedInUser = [SELECT Id,email, ContactId FROM USER WHERE Id =: UserInfo.getUserId()];
        List<Academy_Certification__c> Academy_CertificationList = [SELECT Id, Certification_Student__r.Contact__c, Certification_Program__c,Certification_Program__r.Name FROM Academy_Certification__c WHERE Certification_Student__r.Contact__c =: LoggedInUser.get(0).ContactId AND Status__c = 'Valid'];
        if(Academy_CertificationList.size()>0){
            for(Academy_Certification__c AC : Academy_CertificationList){
                Certification_ProgramIds.add(AC.Certification_Program__c);
                Certification_ProgramIdWithNameMap.put(AC.Certification_Program__c,AC.Certification_Program__r.Name);
            }
            if(Certification_ProgramIds.size()>0){
                list<String> tempCertification_ProgramIds = new List<String>();
                List<ContentDocumentLink> ContentDocumentLinkList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:Certification_ProgramIds];
                if(ContentDocumentLinkList.size()>0){
                    response.IsError = FALSE;
                    for(ContentDocumentLink ContentDocumentLinkObj : ContentDocumentLinkList){
                        if(Certification_ProgramIdWithNameMap.containskey(ContentDocumentLinkObj.LinkedEntityId)){
                            tempCertification_ProgramIds.add(ContentDocumentLinkObj.LinkedEntityId);
                            response.result.add(Certification_ProgramIdWithNameMap.get(ContentDocumentLinkObj.LinkedEntityId)+'___'+ContentDocumentLinkObj.ContentDocumentId);
                        }
                    }
                    if(tempCertification_ProgramIds.size() != Certification_ProgramIds.size()){
                        for(String ids : Certification_ProgramIds){
                            if(!tempCertification_ProgramIds.contains(ids)){
                                response.result.add(Certification_ProgramIdWithNameMap.get(ids)+'___'+'No Preview');
                            }
                        }
                    }
                }
            }            
        }
        RETURN response;
    }
    
    @AuraEnabled
    Public Static CretificateDownloadResponse downloadCertificate(){
        CretificateDownloadResponse response = new CretificateDownloadResponse();
        response.IsError = TRUE;
        response.Academy_CertificationList = new List<Academy_Certification__c>();
        response.CertificateLogoList = new List<String>();
        MAP<Id,String> Certification_ProgramIdWithNameMap = new MAP<Id,String>();
        Set<Id> Certification_ProgramIds = new Set<Id>();
        List<User> LoggedInUser = [SELECT Id,email, ContactId FROM USER WHERE Id =:UserInfo.getUserId()];
        List<Academy_Certification__c> academyCertifications = [SELECT Id,Certification_Id__c,Certification_Examination__r.Date__c,Expiration_Date__c,Earned_Date__c,Certification_Program__r.Name, Certification_Student__c,Certification_Student__r.Contact__r.EMAIL, Status__c, Student_Name__c FROM Academy_Certification__c WHERE Certification_Student__r.Contact__c =: LoggedInUser.get(0).ContactId ORDER BY Expiration_Date__c];

        // Map containing Contact Id + Certification Program Id as a Key and Valid certificate as a value
        Map<String,Academy_Certification__c> contactCertificationProgramKeyWithValidCertificateMap = new Map<String,Academy_Certification__c>();
        // Map containing Contact Id + Certification Program Id as a Key and
        // Expired Certificate ( with no other valid Certificate for same Certificate Program ) as a value
        Map<String,Academy_Certification__c> contactCertificationProgramKeyWithExpiredCertificateMap = new Map<String,Academy_Certification__c>();
        for(Academy_Certification__c AC : academyCertifications){
            String mapKey = String.valueOf(AC.Certification_Student__r.Contact__c) + String.valueof(AC.Certification_Program__c);
            if(AC.Status__c == 'Valid') {
                contactCertificationProgramKeyWithValidCertificateMap.put(mapKey, AC);
            }
            else if(AC.Status__c == 'Expired' && !contactCertificationProgramKeyWithValidCertificateMap.containsKey(mapKey)) {
                contactCertificationProgramKeyWithExpiredCertificateMap.put(mapKey, AC);
            }
            if(contactCertificationProgramKeyWithValidCertificateMap.containsKey(mapKey) && contactCertificationProgramKeyWithExpiredCertificateMap.containsKey(mapKey)) {
                contactCertificationProgramKeyWithExpiredCertificateMap.remove(mapKey);
            }
        }
        response.Academy_CertificationList.addAll(contactCertificationProgramKeyWithValidCertificateMap.values());
        response.Academy_CertificationList.addAll(contactCertificationProgramKeyWithExpiredCertificateMap.values());

        if(response.Academy_CertificationList.size()>0){
            for(Academy_Certification__c AC : response.Academy_CertificationList){
                Certification_ProgramIds.add(AC.Certification_Program__c);
                Certification_ProgramIdWithNameMap.put(AC.Certification_Program__c,AC.Certification_Program__r.Name);
            }
            if(Certification_ProgramIds.size()>0){
                list<String> tempCertification_ProgramIds = new List<String>();
                List<ContentDocumentLink> ContentDocumentLinkList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:Certification_ProgramIds];
                if(ContentDocumentLinkList.size()>0){
                    response.IsError = FALSE;
                    for(ContentDocumentLink ContentDocumentLinkObj : ContentDocumentLinkList){
                        if(Certification_ProgramIdWithNameMap.containskey(ContentDocumentLinkObj.LinkedEntityId)){
                            tempCertification_ProgramIds.add(ContentDocumentLinkObj.LinkedEntityId);
                            response.CertificateLogoList.add(Certification_ProgramIdWithNameMap.get(ContentDocumentLinkObj.LinkedEntityId)+'___'+ContentDocumentLinkObj.ContentDocumentId);
                        }
                    }
                    if(tempCertification_ProgramIds.size() != Certification_ProgramIds.size()){
                        for(String ids : Certification_ProgramIds){
                            if(!tempCertification_ProgramIds.contains(ids)){
                                response.CertificateLogoList.add(Certification_ProgramIdWithNameMap.get(ids)+'___'+'No Preview');
                            }
                        }
                    }
                }
            }            
        }
        RETURN response;
    }
    
    public class ResponseWrap{
        @AuraEnabled Public boolean IsError;
        @AuraEnabled Public List<String> result;
    }
    public class CretificateDownloadResponse{
        @AuraEnabled Public boolean IsError;
        @AuraEnabled Public List<String> CertificateLogoList;
        @AuraEnabled Public List<Academy_Certification__c> Academy_CertificationList;
    }
}