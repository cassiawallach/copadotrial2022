/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class G2Assets {
    global String AccountId {
        get;
        set;
    }
    global String APIToken {
        get;
        set;
    }
    global String BaseUrl {
        get;
        set;
    }
    global Boolean fullAccess {
        get;
        set;
    }
    global Boolean isEmbedded {
        get;
        set;
    }
    global String ProductList {
        get;
        set;
    }
    global String RawProductList {
        get;
        set;
    }
    global String RecordId {
        get;
        set;
    }
    global String Type {
        get;
        set;
    }
    global G2Assets() {

    }
    @RemoteAction
    global static String AddToFolder(String assetId, String folderId, String type) {
        return null;
    }
    @RemoteAction
    global static String CreateAndAddToFolder(String name, String description, String assetId, String type, Boolean shared) {
        return null;
    }
    @RemoteAction
    global static List<G2Crowd__G2_Event__c> GetAccountEvents(String AccountId) {
        return null;
    }
    @RemoteAction
    global static List<G2Crowd.G2Assets.Favorite> GetFavorites(String folderId) {
        return null;
    }
    @RemoteAction
    global static List<G2Crowd__G2_Related_Event__c> GetLeadEvents(String LeadId) {
        return null;
    }
    @RemoteAction
    global static G2Crowd__G2_Asset_Folder__c ReloadFolder(String folderId) {
        return null;
    }
    @RemoteAction
    global static List<G2Crowd__G2_Asset_Folder__c> ReloadFolders() {
        return null;
    }
    @RemoteAction
    global static String RemoveFavorite(String id) {
        return null;
    }
    @RemoteAction
    global static String RemoveFolder(String id) {
        return null;
    }
    global static G2Crowd__G2_Favorite__c SaveFavorite(String assetId, String folderId, String type) {
        return null;
    }
    global static G2Crowd__G2_Asset_Folder__c SaveFolder(String name, String description, Boolean shared) {
        return null;
    }
    @RemoteAction
    global static String UpdateFolder(String name, String Description, Boolean Shared, String id) {
        return null;
    }
global class Favorite {
    global Map<String,String> answers {
        get;
        set;
    }
    global G2Crowd__G2_Favorite__c favorite {
        get;
        set;
    }
    global Favorite(G2Crowd__G2_Favorite__c f, List<G2Crowd__G2_Review_Answer__c> ras) {

    }
}
}
