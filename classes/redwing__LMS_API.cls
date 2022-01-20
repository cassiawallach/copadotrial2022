/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LMS_API {
    global LMS_API() {

    }
    global static redwing.vILTApexResponse addMeetingRegistrants(Map<String,Object> params, String providerType) {
        return null;
    }
    global static Map<String,redwing.LMS_API.APIParam> callAPI(Map<String,redwing.LMS_API.APIParam> params) {
        return null;
    }
    global static void changeAttendedStatusILTRosters(Id sessionId, Map<String,Object> values) {

    }
    global static redwing.vILTApexResponse createAccountMember(Map<String,Object> params, String providerType) {
        return null;
    }
    global static List<redwing__ILT_Roster__c> createILTRosterForILTSession(Id sessionId, Id userId) {
        return null;
    }
    global static Map<String,User> createILTRosterUser(String firstname, String lastname, String email) {
        return null;
    }
    global static redwing.vILTApexResponse createMeeting(Map<String,Object> meetingParams, String providerType) {
        return null;
    }
    global static void createTrainingPlanAccessRequest(Id userId, Id trainingPlanId, String comments) {

    }
    global static redwing.vILTApexResponse deleteMeeting(Map<String,Object> meetingParams, String providerType) {
        return null;
    }
    global static String exportLearningObject(Id learningId, Boolean serializePretty) {
        return null;
    }
    global static String exportQuestionBank(Id questionBankId, Boolean serializePretty) {
        return null;
    }
    global static String exportTrainingPlan(Id trainingPlanId, Boolean serializePretty) {
        return null;
    }
    global static String exportTrainingTrack(Id trainingTrackId, Boolean serializePretty) {
        return null;
    }
    global static List<redwing__Training_Activity__c> getActivitiesForUser() {
        return null;
    }
    global static redwing__ILT_Class__c getILTClassDetails(Id recordId) {
        return null;
    }
    global static List<redwing__ILT_Class__c> getILTClassesDetails(Set<Id> recordIds) {
        return null;
    }
    global static Map<Id,List<redwing__Learning_Assignment__c>> getILTClassesWaitlistedAssignments(Set<Id> classIds) {
        return null;
    }
    global static List<redwing__ILT_Class__c> getILTClasses(Date startDate, Date endDate, String filters) {
        return null;
    }
    global static List<redwing__ILT_Class__c> getILTClasses(Set<Id> learningIds, Date startDate, Date endDate, String filters) {
        return null;
    }
    global static List<redwing__ILT_Instructor__c> getILTInstructorsForUser(Set<Id> instructorIds) {
        return null;
    }
    global static List<User> getILTInstructors() {
        return null;
    }
    global static Id getILTLearning(Id sessionId) {
        return null;
    }
    global static List<redwing__Training_Activity__c> getILTLearningActivities(Id learningId) {
        return null;
    }
    global static List<redwing__ILT_Roster__c> getILTRosters(Id recordId) {
        return null;
    }
    global static List<redwing__ILT_Session__c> getILTSessionsById(Set<Id> sessionIds) {
        return null;
    }
    global static List<redwing__ILT_Session__c> getILTSessions(Set<Id> iltClassIds) {
        return null;
    }
    global static Map<Id,redwing__Training_Track__c> getLanguageTrackMapping(Set<Id> trainingTrackIds) {
        return null;
    }
    global static Map<Id,redwing__Training_Plan__c> getLanguageTrainingPlanMapping(Set<Id> tpIds) {
        return null;
    }
    global static redwing__Learning_Assignment__c getLearningAssignmentDetails(String assignmentId, Id userId) {
        return null;
    }
    global static Map<Id,redwing__Learning__c> getLearningDetails(Set<Id> learningIds) {
        return null;
    }
    global static redwing__Learning_Version__c getLearningVersionDetails(Id learningVersionId, String learningType) {
        return null;
    }
    global static Id getLinkedIdSF1(System.PageReference ref, Schema.SObjectType expectedType) {
        return null;
    }
    global static String getPrerequisites(String inputJSON) {
        return null;
    }
    global static Map<Id,Map<Id,redwing.LMSUtils.TotalPrerequisitesForTargetWrapper>> getPrerequisites(Set<Id> userIds, Set<Id> targetIds, String prerequisiteType) {
        return null;
    }
    global static Id getTranslatedTrack(Id userId, Id trackId, Map<Id,User> activeUsers, Map<Id,redwing__Training_Track__c> languageTracks) {
        return null;
    }
    global static Id getTranslatedTrainingPlan(Id userId, Id tplanId, Map<Id,User> activeUsers, Map<Id,redwing__Training_Plan__c> languagePlans) {
        return null;
    }
    global static void importJSON(String jsonData, Boolean addTimeStamps) {

    }
    global static Boolean isILTClassesIntersect(redwing__ILT_Class__c iltClass1, redwing__ILT_Class__c iltClass2) {
        return null;
    }
    global static Boolean isILTSessionIntersectWithILTClass(redwing__ILT_Session__c iltSession, redwing__ILT_Class__c iltClass) {
        return null;
    }
    global static Boolean isILTSessionsIntersect(redwing__ILT_Session__c iltSession1, redwing__ILT_Session__c iltSession2) {
        return null;
    }
    global static Boolean isPageReferenceSF1(System.PageReference ref) {
        return null;
    }
    global static String launchTrainingPlanItemJSON(Id sectionItemId, String versionBehavior) {
        return null;
    }
    global static System.PageReference publishLearning(Id learningObjectId) {
        return null;
    }
    global static System.PageReference publishLearning(Id learningObjectId, Id selectedContent, String VersionSelectionBehavior) {
        return null;
    }
    global static void refreshAchievementsLeaderBoard(String communityId) {

    }
    global static void refreshPlansLeaderBoard(String communityId) {

    }
    global static redwing.vILTApexResponse removeRegistrants(Map<String,Object> params, String providerType) {
        return null;
    }
    global static redwing.vILTApexResponse updateMeeting(Map<String,Object> meetingParams, String providerType) {
        return null;
    }
    global static void upsertActivityAssignments(Set<Id> selectedUserIds, Id activityId, Id communityId, Date dueDate) {

    }
    global static void upsertAssignmentsForCommunity(Set<Id> selectedUserIds, Id trainingPlanId, Id communityId) {

    }
    global static void upsertAssignments(Set<Id> selectedUserIds, Id trainingPlanId) {

    }
    global static void upsertPlanAssignmentsFromReport(Id trainingPlanId, Id reportId, Id communityId, Date dueDate, String customColumnIndex) {

    }
    global static void upsertPlanAssignments(Set<Id> selectedUserIds, Id trainingPlanId, Id communityId, Date dueDate) {

    }
    global static void upsertTrackAssignments(Set<Id> selectedUserIds, Id trackId, Id communityId) {

    }
    global static redwing.vILTApexResponse validateAccountMember(Map<String,Object> params, String providerType) {
        return null;
    }
global class APIParam {
    global Boolean booleanValue;
    global Date dateValue;
    global Id idValue;
    global List<SObject> listSObjectValue;
    global Set<Id> setIdsValue;
    global String stringValue;
    global APIParam() {

    }
}
}
