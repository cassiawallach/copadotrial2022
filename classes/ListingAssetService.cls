public with sharing class ListingAssetService {

    @AuraEnabled(cacheable=true)
    public static List<Listing_Asset__c> getAssetsBySection(String listingId, String section) {
        system.debug('### ListingID: '+listingId+' SECTION:'+section);
        return [select Id, Name, Caption__c, Content_Type__c, Customer_Resource__c, Listing__c, Section__c, ContentVersion_Id__c, Order__c
         from Listing_Asset__c where Listing__c=:listingId and Section__c=:section order by Order__c ASC];
    }

    @AuraEnabled
    public static Listing_Asset__c createListingAsset(Listing_Asset__c la) {
        system.debug('Listing Asset: '+la);
        if (la!=null) {
            insert la;
            return la;
        }
        else {
            return null;
        }
    }

    @AuraEnabled
    public static Listing_Asset__c updateListingAsset(Listing_Asset__c la) {
        system.debug('Listing Asset: '+la);
        Id contentVersionId = getContentVersionId(la.ContentVersion_Id__c);
        la.ContentVersion_Id__c = contentVersionId;
        update la;
        return la;
    }

    @AuraEnabled
    public static void updateListingAssets(List<Listing_Asset__c> assets) {
        if (assets==null || assets.size()==0) return;
        update assets;
    }

    @AuraEnabled
    public static Boolean deletContentDocument(Id contentVersionId) {
        system.debug('Received delete request: '+contentVersionId);
        try {
            system.debug('try: ');
            ContentVersion cv = [select Id, ContentDocumentId from ContentVersion where Id=:contentVersionId limit 1];
            system.debug('CV: '+cv);
            ContentDocument cd = new ContentDocument(Id=cv.ContentDocumentId);
            system.debug('CD: '+cd);
            delete cd;
            system.debug('...deleted. returning true.');
            return true;
        }
        catch(Exception e) {
            system.debug('Error during content document deletion: '+e.getMessage());
            return false;
        }
    }

    @AuraEnabled
    public static void deleteAssetAndFiles(Id assetId) {
        if (assetId==null) return;
        List<ContentDocument> deletions = new List<ContentDocument>();
        List<ContentDocumentLink> files = [select ContentDocumentId, LinkedEntityId from ContentDocumentLink where LinkedEntityId=:assetId and LinkedEntity.Type='Listing_Asset__c'];
        for (ContentDocumentLink file : files) {
            deletions.add(new ContentDocument(Id=file.ContentDocumentId));
        }

        Listing_Asset__c asset = new Listing_Asset__c(Id=assetId);
        delete asset;
        delete deletions;
    }

    private static Id getContentVersionId(Id contentDocumentId) {
        try {
            ContentVersion cv = [select Id from ContentVersion where ContentDocumentId=:contentDocumentId limit 1];
            return cv.Id;
        }
        catch(Exception e) {
            return null;
        }
    }
}