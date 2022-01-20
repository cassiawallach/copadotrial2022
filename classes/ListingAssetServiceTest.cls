@isTest
public with sharing class ListingAssetServiceTest {

    static testMethod void getAssetsBySection() {
        Listing_Profile__c listingProfile = new Listing_Profile__c(Name='Copado Labs');
        insert listingProfile;
        Listing__c listing = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='My SearchString 1', Type__c='Template', Price__c='Free', Rating__c=5, Reviews__c=1, Published__c=true, Get_It_Now_Action__c='Download');
        insert listing;

        List<Listing_Asset__c> las = new List<Listing_Asset__c>();
        Listing_Asset__c la1 = new Listing_Asset__c(Listing__c=listing.Id, Section__c='Carousel', Order__c=1, Caption__c='c1');
        Listing_Asset__c la2 = new Listing_Asset__c(Listing__c=listing.Id, Section__c='Carousel', Order__c=2, Caption__c='c2');
        Listing_Asset__c la3 = new Listing_Asset__c(Listing__c=listing.Id, Section__c='Download', Order__c=1, Caption__c='c3');
        las.add(la1);
        las.add(la2);
        las.add(la3);
        insert las;

        Test.startTest();
        List<Listing_Asset__c> result = ListingAssetService.getAssetsBySection(listing.Id, 'Carousel');
        Test.stopTest();
        system.assertEquals('c1', result.get(0).Caption__c);
        system.assertEquals('c2', result.get(1).Caption__c);
    }
    static testMethod void testCreateAndUpdateListingAsset() {
        Listing_Profile__c listingProfile = new Listing_Profile__c(Name='Copado Labs');
        insert listingProfile;

        Listing__c listing = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='My SearchString 1', Type__c='Template', Price__c='Free', Rating__c=5, Reviews__c=1, Published__c=true, Get_It_Now_Action__c='Download');
        insert listing;
        
        Listing_Asset__c la = new Listing_Asset__c(Listing__c=listing.Id, Section__c='Carousel', Order__c=1, Caption__c='c1');
        Test.startTest();
        Listing_Asset__c result = ListingAssetService.createListingAsset(null);
        system.assertEquals(null, result);
        result = ListingAssetService.createListingAsset(la);
        system.assert(result.Id!=null);

        result.Caption__c='I was changed';
        result = ListingAssetService.updateListingAsset(result);
        Listing_Asset__c actual = [select Id, Caption__c from Listing_Asset__c where Id=:result.Id limit 1];
        system.assertEquals(result.Caption__c, actual.Caption__c);
        Test.stopTest();
    }
    static testMethod void testUpdateListingAssets() {
        Listing_Profile__c listingProfile = new Listing_Profile__c(Name='Copado Labs');
        insert listingProfile;
        Listing__c listing = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='My SearchString 1', Type__c='Template', Price__c='Free', Rating__c=5, Reviews__c=1, Published__c=true, Get_It_Now_Action__c='Download');
        insert listing;

        List<Listing_Asset__c> las = new List<Listing_Asset__c>();
        Listing_Asset__c la1 = new Listing_Asset__c(Listing__c=listing.Id, Section__c='Carousel', Order__c=1, Caption__c='c1');
        Listing_Asset__c la2 = new Listing_Asset__c(Listing__c=listing.Id, Section__c='Carousel', Order__c=2, Caption__c='c2');
        las.add(la1);
        las.add(la2);
        insert las;

        Test.startTest();
        las[0].Caption__c = 'changed';
        las[1].Caption__c = 'changed';

        //method has no rerturn
        ListingAssetService.updateListingAssets(las);

        //query DB and assert caption__c field was set to value, "changed".
        List<Listing_Asset__c> result = [select Id, Caption__c from Listing_Asset__c where Listing__c=:listing.Id];
        system.assertEquals(2, result.size());
        for (Listing_Asset__c la : result) {
            system.assertEquals('changed', la.Caption__c);
        }
        Test.stopTest();
    }
    static testMethod void testDeleteContentDocument() {
        Listing_Profile__c listingProfile = new Listing_Profile__c(Name='Copado Labs');
        insert listingProfile;

        Listing__c listing = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='My SearchString 1', Type__c='Template', Price__c='Free', Rating__c=5, Reviews__c=1, Published__c=true, Get_It_Now_Action__c='Download');
        insert listing;
        
        Listing_Asset__c la = new Listing_Asset__c(Listing__c=listing.Id, Section__c='Carousel', Order__c=1, Caption__c='c1');
        insert la;

        ContentVersion contentVersion = createContentVersion('filename', 'test content');
        insert contentVersion;
        ContentVersion cvResult = getContentVersionById(contentVersion.Id);
        ContentDocumentLink contentDocumentLink = createContentDocumentLink(cvResult.ContentDocumentId, la.Id);
        insert contentDocumentLink;

        Test.startTest();
        Boolean result = ListingAssetService.deletContentDocument(cvResult.Id);
        system.assertEquals(true, result);
    }
    static testMethod void testdeleteAssetAndFiles() {
        Listing_Profile__c listingProfile = new Listing_Profile__c(Name='Copado Labs');
        insert listingProfile;

        Listing__c listing = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='My SearchString 1', Type__c='Template', Price__c='Free', Rating__c=5, Reviews__c=1, Published__c=true, Get_It_Now_Action__c='Download');
        insert listing;
        
        Listing_Asset__c la = new Listing_Asset__c(Listing__c=listing.Id, Section__c='Carousel', Order__c=1, Caption__c='c1');
        insert la;

        ContentVersion contentVersion = createContentVersion('filename', 'test content');
        insert contentVersion;
        
        ContentVersion cvResult = getContentVersionById(contentVersion.Id);
        ContentDocumentLink contentDocumentLink = createContentDocumentLink(cvResult.ContentDocumentId, la.Id);
        insert contentDocumentLink;

        Test.startTest();
        ListingAssetService.deleteAssetAndFiles(la.Id);
        system.assertEquals(0, [select Id from Listing_Asset__c where Listing__c=:listing.Id].size() );
        Test.stopTest();
    }

    private static ContentVersion createContentVersion(String name, String body) {
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.ContentLocation = 'S'; // S = Stored in Salesforce
        contentVersion.PathOnClient = name;
        contentVersion.Title = name;
        contentVersion.VersionData = EncodingUtil.base64Decode(body);
        return contentVersion;
    }
    private static ContentDocumentLink createContentDocumentLink(Id contentDocumentId, Id parentId) {
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
        contentDocumentLink.ContentDocumentId = contentDocumentId;
        contentDocumentLink.LinkedEntityId = parentId;
        contentDocumentLink.ShareType = 'I'; // Inferred permission
        contentDocumentLink.Visibility = 'InternalUsers';
        return contentDocumentLink;
    }
    private static ContentVersion getContentVersionById(Id recordId) {
        return [select Id, ContentDocumentId from ContentVersion where Id=:recordId limit 1];
    }
}