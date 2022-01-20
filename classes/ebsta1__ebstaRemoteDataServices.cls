/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ebstaRemoteDataServices {
    @RemoteAction
    global static String ActionAlert(String alertId) {
        return null;
    }
    @RemoteAction
    global static String AddEmailDocumentTo(String emailId, String accountId) {
        return null;
    }
    @RemoteAction
    global static String AddEmailDocumentToV2(String emailId, String accountId, String contactId) {
        return null;
    }
    @RemoteAction
    global static String AddEmailDocumentToV3(String emailId, String whoId) {
        return null;
    }
    @RemoteAction
    global static ebsta1.AddEmailDocumentResult AddEmailDocumentToV4(String emailId, String accountId, String contactId) {
        return null;
    }
    @RemoteAction
    global static String AddSFToEmailDocument(String sfId, String emailId) {
        return null;
    }
    @RemoteAction
    global static String AlertsInformation(String salesforceId, Integer rowsPerPage, Integer pageNumber) {
        return null;
    }
    @RemoteAction
    global static String AlertsInformationGraph(ebsta1.SearchResultsPagedRequestV2 newSearchRequest, Integer alertsVersion) {
        return null;
    }
    @RemoteAction
    global static String AlertsInformationV2(String salesforceId, Integer rowsPerPage, Integer pageNumber) {
        return null;
    }
    @RemoteAction
    global static String BlackListAllActivity(String emailAddress) {
        return null;
    }
    @RemoteAction
    global static String BlackListAllActivityAndContact(String emailAddress) {
        return null;
    }
    @RemoteAction
    global static String BlackListEmailAddress(String emailAddress) {
        return null;
    }
    @RemoteAction
    global static String BlackListMailItem(String emailId) {
        return null;
    }
    @RemoteAction
    global static String ClearToken() {
        return null;
    }
    @RemoteAction
    global static String GetActivityTab(ebsta1.SearchResultsPagedRequestV2 newSearchRequest) {
        return null;
    }
    @RemoteAction
    global static String GetActivityTabV2(ebsta1.SearchResultsPagedRequestV2 newSearchRequest, Integer searchIndexVersion) {
        return null;
    }
    @RemoteAction
    global static String GetAdminReport() {
        return null;
    }
    @RemoteAction
    global static String GetAdminReportDownload() {
        return null;
    }
    @RemoteAction
    global static String GetAdminTeamView() {
        return null;
    }
    @RemoteAction
    global static ebsta1.ComplexAddSearchRequestResult GetComplexAddSearchResults(String searchTerm, Integer searchType) {
        return null;
    }
    @RemoteAction
    global static String GetEmailAttachmentDownloadLink(String attachmentId) {
        return null;
    }
    @RemoteAction
    global static String GetMailboxConnectionStatusV2() {
        return null;
    }
    @RemoteAction
    global static ebsta1.ComplexAddSearchRequestResult GetRelatedObjects(String searchTerm, Integer searchType) {
        return null;
    }
    @RemoteAction
    global static String GetSearchRecievedPaged(String searchTerm, Integer rowsPerPage, Integer pageNumber) {
        return null;
    }
    @RemoteAction
    global static String GetSearchRecievedPagedWithFiltersV2(ebsta1.SearchResultsPagedRequestV2 newSearchRequest) {
        return null;
    }
    @RemoteAction
    global static String GetSearchRecievedPagedWithFilters(String searchTerm, Integer rowsPerPage, Integer pageNumber, String orderBy, List<ebsta1.SearchFilter> filters) {
        return null;
    }
    @RemoteAction
    global static String GetSearchSentPaged(String searchTerm, Integer rowsPerPage, Integer pageNumber) {
        return null;
    }
    @RemoteAction
    global static String GetWebUserSecurity() {
        return null;
    }
    @RemoteAction
    global static ebsta1.ActivityViewSettings Get_ActivityViewSettings() {
        return null;
    }
    @RemoteAction
    global static String IgnoreAlert(Long alertId) {
        return null;
    }
    @RemoteAction
    global static String IgnoreAlertV2(String alertId) {
        return null;
    }
    @RemoteAction
    global static String KeepAlive() {
        return null;
    }
    @RemoteAction
    global static String LogError(String errorMessage, String salesforceId, String objectId) {
        return null;
    }
    @RemoteAction
    global static String LogEvent(String eventName, String actionTaken, Integer eventId) {
        return null;
    }
    @RemoteAction
    global static String LogPackageVersion() {
        return null;
    }
    @RemoteAction
    global static String LogPostInstall(Integer installType, String newVersion, String previousVersion, String organizationId, String organizationName, String userEmailAddress) {
        return null;
    }
    @RemoteAction
    global static void LogPostInstallV2(Integer installType, String newVersion, String previousVersion, String organizationId, String organizationName, String userEmailAddress) {

    }
    @RemoteAction
    global static void LogPostInstallV3(ebsta1.PostInstallRequest request) {

    }
    @RemoteAction
    global static String ProcessAlertUpdate(String salesforceId, String updateField, String newValue) {
        return null;
    }
    @RemoteAction
    global static Map<Integer,List<Boolean>> SaveAttachment(String attachmentId, List<List<String>> complexAddRows) {
        return null;
    }
    @RemoteAction
    global static void Save_ActivityViewSettings_State(ebsta1.ActivityViewSettings newActivitySettings) {

    }
    @RemoteAction
    global static String SearchRecEmails(String searchTerm) {
        return null;
    }
    @RemoteAction
    global static String SearchSentEmails(String searchTerm) {
        return null;
    }
    @RemoteAction
    global static String SetupAdminTeams() {
        return null;
    }
    global static String UpdateAlertResults(String jsonResult) {
        return null;
    }
    @RemoteAction
    global static String getAttachmentList(String emailId) {
        return null;
    }
    @RemoteAction
    global static String getEbstaScore(String mainSalesforceId) {
        return null;
    }
    @RemoteAction
    global static String getEmailPreview(String emailId) {
        return null;
    }
    @RemoteAction
    global static String getEmailText(String emailId) {
        return null;
    }
    @RemoteAction
    global static String getHelloWorld() {
        return null;
    }
    @RemoteAction
    global static String getLicenceStatus() {
        return null;
    }
    @RemoteAction
    global static String getLicenceStatusV2() {
        return null;
    }
    @RemoteAction
    global static String getRelationshipResult(String searchTerm) {
        return null;
    }
    @RemoteAction
    global static String getRelationshipResultV2(ebsta1.SearchResultsPagedRequestV2 searchResultsPagedRequestV2Obj) {
        return null;
    }
    @RemoteAction
    global static String getRelationshipResultV3(ebsta1.SearchResultsPagedRequestV2 searchResultsPagedRequestV2Obj, Integer searchIndexVersion) {
        return null;
    }
    @RemoteAction
    global static ebsta1.SearchResultsPagedRequestV2 getSearchResultsPagedRequestV2Object(String mainSalesforceId, String relatedAccountId, String mainObjectName, String relationshipKeyValue) {
        return null;
    }
}
