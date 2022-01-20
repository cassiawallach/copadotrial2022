trigger Product2Trigger on Product2 (after update) {

    Schema.SObjectType transformToObject = kugo2p__AdditionalProductDetail__c.getSobjectType();
    List<UserPackageLicense> usrPkgLicenseList = [SELECT UserId, PackageLicense.NamespacePrefix FROM UserPackageLicense WHERE PackageLicense.NamespacePrefix =: Label.Kugamon_Namespace];
    Set<Id> usrIds = new Set<Id>();
    
    if(!usrPkgLicenseList.isEmpty() && usrPkgLicenseList.size()>0) {
        for(UserPackageLicense upl : usrPkgLicenseList) {
            usrIds.add(upl.UserId);   
        }       
    }  
   
    if(!usrIds.isEmpty() && usrIds.contains(userinfo.getUserId())) {
        Schema.SObjectField externalId = kugo2p__AdditionalProductDetail__c.Product2Id__c;
        if ( Trigger.isAfter && Trigger.isUpdate ){
            zealynxsf.Sync.handleTrigger(Trigger.new, Trigger.old, Trigger.operationType, transformToObject, externalId );
        }
    }  
}