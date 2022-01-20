public without sharing class ILT_RosterTriggerHelper {
    
    public static map<String,CollaborationGroupMember> collaborationGroupMembers = new Map<String,CollaborationGroupMember>();
    public static Map<Id,redwing__ILT_Class__c> iltClasses;
    public static Map<Id,User> userMap;
    public static EmailTemplate emailTemplateHTML;
    public static OrgWideEmailAddress[] orgWideEmailAddressValue;
    public static String successCommunityURL = '';
    public static void prepareData(List<SObject> records){
        set<String> iltClassIds = new set<String>();
        set<String> userIds = new set<String>();
        for(SObject so : records){
            redwing__ILT_Roster__c roster = (redwing__ILT_Roster__c)so;
            iltClassIds.add(roster.redwing__ILT_Class__c);
            userIds.add(roster.redwing__User__c);
        }
        userMap = new Map<Id,User>([SELECT Id,FirstName,LastName,Email FROM USER WHERE Id IN:userIds]);
        iltClasses= new Map<Id,redwing__ILT_Class__c>([SELECT Id,redwing__Learning__r.Group_Id__c FROM redwing__ILT_Class__c WHERE Id IN : iltClassIds]);
        Network successNetwork = [SELECT Id From Network WHERE Name = 'Success' LIMIT 1];
        if(!Test.isRunningTest()){
            ConnectApi.Community comm = ConnectApi.Communities.getCommunity(successNetwork.Id);
            successCommunityURL = comm.siteUrl;
        }
        OrgWideEmailAddressValue = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address = 'academy@copa.do' LIMIT 1];
        emailTemplateHTML = [SELECT Id, HtmlValue FROM EmailTemplate WHERE Name = :System.Label.Discussion_Group_registration_Template_Name LIMIT 1]; 
    }
    
    public static void addMemberInDiscussionGroup(redwing__ILT_Roster__c roster){
        if(roster.redwing__ILT_Class__c != Null && iltClasses.containsKey(roster.redwing__ILT_Class__c) && iltClasses.get(roster.redwing__ILT_Class__c).redwing__Learning__r.Group_Id__c != NULL){
            CollaborationGroupMember groupMember = new CollaborationGroupMember();
            groupMember.memberid = roster.redwing__User__c;
            groupMember.CollaborationGroupId = iltClasses.get(roster.redwing__ILT_Class__c).redwing__Learning__r.Group_Id__c;
            collaborationGroupMembers.put(roster.redwing__User__c+'_'+groupMember.CollaborationGroupId,groupMember);
        }
    }
    
    public static void addCollaborationGroupMembersAndSendEmailNotify(){
        if(collaborationGroupMembers.size()>0){
            try{
                Insert collaborationGroupMembers.values();
            }
            catch(exception e){
                system.debug(e.getMessage()); //exception throws if user is already member of the group 
            }
            Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
                for(CollaborationGroupMember groupMember : collaborationGroupMembers.values()){
                    String htmlTemp = emailTemplateHTML.HtmlValue.replaceAll('(\\r|\\n)+', '');
                    htmlTemp = htmlTemp.replace('recipientUserFirstName',userMap.get(groupMember.memberid).FirstName );
                    String discussionGroupURL = System.Label.SuccessCommunityURL+groupMember.CollaborationGroupId;
                    htmlTemp = htmlTemp.replace('discussionGroupURL',successCommunityURL +'/'+groupMember.CollaborationGroupId);
                    List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setHtmlBody(htmlTemp);
                    mail.setSaveAsActivity(true);
                    String[] toAddresses = new String[]{userMap.get(groupMember.memberid).Email};
                        mail.setToAddresses(toAddresses);
                    if(orgWideEmailAddressValue.size() != 0)mail.setOrgWideEmailAddressId(orgWideEmailAddressValue[0].id);
                    emails.add(mail);
                }
            
            Messaging.SendEmailResult[] er = Messaging.sendEmail(emails, false);
        }
    }
}