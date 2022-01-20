/**
 * @author Philipp Rackwitz
 * @version: 1.0
 * @description: This is the utility class that goes with the ListingAssetFileUtility LWC component. 
 * The purpose is facilitate the update of the ContentVersion_Id__c field with the right record Id.
 * The update to the record is handled by the LWC component.
 */
public with sharing class listingAssetFileUtilityService {
    /**
     * Wrapper class to display the information in the LWC component.
     */
    public class AssetFile {
        @AuraEnabled
        public String fileName { get; set; }

        @AuraEnabled
        public String fileType { get; set; }

        @AuraEnabled
        public Id contentVersionId { get; set; }
    }

    /**
     * This method queries the ContentDocumentLink and ContentDocument object to retrieve the related files and
     * the associated ContentVersionId values.
     * @param  assetId The record id to the Listing_Asset__c record.
     * @return         A list of AssetFile object is returned.
     */
    @AuraEnabled(cacheable=true)
    public static List<AssetFile> getFiles(Id assetId) {
        system.debug('### '+assetId);
        Set<Id> cdIDs = new Set<Id>();
        List<AssetFile> afs = new List<AssetFile>();
        
        for (ContentDocumentLink file : [select ContentDocumentId, LinkedEntityId from ContentDocumentLink where LinkedEntityId=:assetId and LinkedEntity.Type='Listing_Asset__c']) {
            cdIDs.add(file.ContentDocumentId);
        }
        for (ContentDocument cd : [SELECT Id, LatestPublishedVersionId, Title, FileType, FileExtension FROM ContentDocument where Id IN:cdIDs]) {
            AssetFile af = new AssetFile();
            af.fileName = cd.Title;
            af.fileType = cd.FileType;
            af.contentVersionId = cd.LatestPublishedVersionId;
            afs.add(af);
        }
        return afs;
    }
}