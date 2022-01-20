@isTest
public with sharing class listingAssetFileUtilityServiceTest {
    static testMethod void testGetFiles() {
        Listing_Profile__c profile = new Listing_Profile__c(Name='Copado Labs');
        insert profile;

        Listing__c listing = new Listing__c(Name='Listing 1', Listing_Profile__c = profile.Id);
        insert listing;

        Listing_Asset__c ass1 = new Listing_Asset__c( Listing__c=listing.Id);
        insert ass1;

        ContentVersion conVer1 = new ContentVersion( Title='Name1', PathOnClient='test', VersionData=Blob.valueof('file 1') );
        ContentVersion conVer2 = new ContentVersion( Title='Name2', PathOnClient='test', VersionData=Blob.valueof('file 2') );
        List<ContentVersion> conVerList = new List<ContentVersion>();
        conVerList.add(conVer1);
        conVerList.add(conVer2); 
        insert conVerList;

        Set<Id> ids = new Set<Id>();
        for (ContentVersion cv : conVerList) {
            ids.add(cv.Id);
        }

        List<ContentDocumentLink> cdls = new List<ContentDocumentLink>();
        for (ContentVersion cv : [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN:ids]) {
            ContentDocumentLink cdl = new ContentDocumentLink( LinkedEntityId=ass1.Id, ContentDocumentId=cv.ContentDocumentId, ShareType='I' );
            cdls.add(cdl);
        }
        insert cdls;

        Test.startTest();
        List<listingAssetFileUtilityService.AssetFile> result = listingAssetFileUtilityService.getFiles(ass1.Id);
        system.assertEquals(2, result.size());
        Test.stopTest();
    }
}