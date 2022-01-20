public class CopadoUserStoryTriggerHandler {
    
    public static Set<Id> parentIds;
    public static EmailTemplate EmailTemplate_for_userStoryStatusUpdate;
    public static OrgWideEmailAddress[] OrgWideEmailAddressValue;
    public static List<String> BusinessOwnerIds;
    Public static map<Id,user> UserStoryBusinessOwners;
    Public static String RachelWongUserId;
    Public static Id APO_userStory_recordTypeId = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByDeveloperName().get('APO_User_Story').getRecordTypeId();
    public static void PrepareData(List<copado__User_Story__c> UserStoriesUpdatedRecords){
        BusinessOwnerIds = new list<String>();
        
        for(copado__User_Story__c us : UserStoriesUpdatedRecords){
            BusinessOwnerIds.add(us.Business_Owner__c);
        }
        RachelWongUserId = [SELECT Id FROM User WHERE Email LIKE '%rwong@copa%' LIMIT 1].Id;
        UserStoryBusinessOwners = new  map<Id,user>([SELECT Id,FirstName,Email FROM USER WHERE Id IN : BusinessOwnerIds]);
        OrgWideEmailAddressValue = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address = 'academy@copa.do' LIMIT 1];
        EmailTemplate_for_userStoryStatusUpdate = [SELECT Id, HtmlValue FROM EmailTemplate WHERE Name = :System.Label.User_Story_Status_Email_template_Name LIMIT 1];
    }
    
    public static void prepareDataForEstimationRollup(List<copado__User_Story__c> updatedUserStories){
        Set<Id> subTaskIds = new Set<Id>();
        parentIds = new Set<Id>();
        Id subtaskRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('Subtask').getRecordTypeId();
        
        for(copado__User_Story__c us : updatedUserStories){
            if(us.RecordTypeId == subtaskRT && us.Parent_User_Story__c != null){
                parentIds.add(us.Parent_User_Story__c);
            }
        }
    }
    
    public static void removeUserStoryPoints(List<copado__User_Story__c> childStories){
        if(parentIds.isEmpty()){
            return;
        } 
        
        Map<Id, copado__User_Story__c> parentStoriesToUpdate = new Map<Id, copado__User_Story__c>([SELECT Id, copado__Story_Points_SFDC__c, copado__Story_Points_Other__c 
                                                                                                   FROM copado__User_Story__c 
                                                                                                   WHERE Id IN :parentIds]);
        For(copado__User_Story__c cus : childStories){
            if(parentStoriesToUpdate.get(cus.Parent_User_Story__c) == null){
                continue;
            } 
            copado__User_Story__c parentStory = parentStoriesToUpdate.get(cus.Parent_User_Story__c);
            parentStory.copado__Story_Points_SFDC__c = (parentStory.copado__Story_Points_SFDC__c == null) ? 0 : parentStory.copado__Story_Points_SFDC__c;
            parentStory.copado__Story_Points_Other__c = (parentStory.copado__Story_Points_Other__c == null) ? 0 : parentStory.copado__Story_Points_Other__c;
            
            parentStory.copado__Story_Points_SFDC__c -= cus.copado__Story_Points_SFDC__c == null ? 0 : cus.copado__Story_Points_SFDC__c;
            parentStory.copado__Story_Points_Other__c -= cus.copado__Story_Points_Other__c == null ? 0 : cus.copado__Story_Points_Other__c;
        }
        
        update parentStoriesToUpdate.values();
        
    }
    
    public static void rollupUserStoryPoints(){
        if(parentIds.isEmpty()){
            return;
        } 
        
        List<AggregateResult> totalPoints = [SELECT Parent_User_Story__c parentId, 
                                             SUM(copado__Story_Points_Other__c) totalOther, 
                                             SUM(copado__Story_Points_SFDC__c) totalSFDC
                                             FROM copado__User_Story__c 
                                             WHERE Parent_User_Story__c IN :parentIds
                                             GROUP BY Parent_User_Story__c];
        
        List<copado__User_Story__c> parentStories = new List<copado__User_Story__c>();
        For(AggregateResult ar : totalPoints){
            parentStories.add(new copado__User_Story__c(Id = (Id)ar.get('parentId'), 
                                                        copado__Story_Points_Other__c = (Decimal)ar.get('totalOther'), 
                                                        copado__Story_Points_SFDC__c = (Decimal)ar.get('totalSFDC')));
        }
        
        update parentStories;
        
    }
    
    Public static void OnUserStoryStatusChangeNotifyByEmail(Map<Id,copado__User_Story__c>  UserStoryOldMap,Map<Id,copado__User_Story__c>  UserStoryNewMap){
        Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
            for(Id userStoryId : UserStoryOldMap.keyset()){
                if(UserStoryOldMap.get(userStoryId).copado__Status__c != UserStoryNewMap.get(userStoryId).copado__Status__c && UserStoryNewMap.get(userStoryId).copado__Status__c == 'Ready for Testing' && UserStoryNewMap.get(userStoryId).RecordTypeId ==  APO_userStory_recordTypeId ){
                    
                    String EmailHtmlValue = EmailTemplate_for_userStoryStatusUpdate.HtmlValue.replaceAll('(\\r|\\n)+', '');
                    String StatusOldValue= UserStoryOldMap.get(userStoryId).copado__Status__c==NULL?'BLANK VALUE': UserStoryOldMap.get(userStoryId).copado__Status__c;
                    String StatusNewValue= UserStoryNewMap.get(userStoryId).copado__Status__c==NULL?'BLANK VALUE': UserStoryNewMap.get(userStoryId).copado__Status__c;
                    EmailHtmlValue = EmailHtmlValue.replace('StatusOldValue', StatusOldValue ).replace('StatusNewValue', StatusNewValue).replace('UserStoryAutoNumber',UserStoryNewMap.get(userStoryId).Name);
                   String UserStoryURL= userStoryId==NULL?'': System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+userStoryId;
                    EmailHtmlValue = EmailHtmlValue.replace('UserStoryURL',UserStoryURL);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    EmailHtmlValue = EmailHtmlValue.replace('RecipientUserFirstName','Rachel');
                    mail.setHtmlBody(EmailHtmlValue);
                    mail.setSaveAsActivity(true);
                    String[] toAddresses = new String[]{'rwong@copa.do'};
                        mail.setToAddresses(toAddresses);
                    
                    if(OrgWideEmailAddressValue.size() != 0)mail.setOrgWideEmailAddressId(OrgWideEmailAddressValue[0].id);
                    emails.add(mail);
                    
                    if(UserStoryNewMap.get(userStoryId).Business_Owner__c != Null){
                        Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
                        EmailHtmlValue = EmailHtmlValue.replace('Rachel',UserStoryBusinessOwners.get(UserStoryNewMap.get(userStoryId).Business_Owner__c).FirstName);
                        mail2.setHtmlBody(EmailHtmlValue);                    
                        mail2.setSaveAsActivity(true);
                        toAddresses = new String[]{UserStoryBusinessOwners.get(UserStoryNewMap.get(userStoryId).Business_Owner__c).Email};
                            mail2.setToAddresses(toAddresses);
                        if(OrgWideEmailAddressValue.size() != 0)mail2.setOrgWideEmailAddressId(OrgWideEmailAddressValue[0].id);
                        emails.add(mail2);
                    }
                }
            }
        if(emails.size()>0){
            Messaging.SendEmailResult[] er = Messaging.sendEmail(emails, false);
        }
    }
}