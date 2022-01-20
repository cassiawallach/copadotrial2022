public without sharing class  CaseTriggerHelper {
    public static Map<String, Contact> contactMap = new Map<String, Contact>();
    public static Map<String, Contact> commmunityContactmap = new Map<String, Contact>();
    public static Map<Id, Id> contactAccountMap = new Map<Id, Id>();
    public static Map<Integer, Entitlement> entitlementMap = new Map<Integer, Entitlement>();
    public static Map<String, Entitlement> entitlementAccountsMap = new Map<String, Entitlement>();
    public static List<Id> resolveCases = new List<Id>();
    public static Map<Id, Case> caseMap = new Map<Id, Case>();
    public static List<CaseComment> commentsToInsert = new List<CaseComment>();
    public static map<String,user> CommunityUserMap;
    
    
    public static void prepareData(List<SObject> records, Boolean isBeforeInsert){
        Set<String> emailSet = new Set<String>();
        Set<Id> contactSet = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        for(SObject so : records) {
            Case c = (Case)so;
            if (c.Access_Code__c == null && isBeforeInsert && c.Subject != null &&  c.Subject.contains('CS')) {
                try {
                    c.Access_Code__c = Integer.valueOf(c.Subject.substring(c.Subject.indexOf('CS') + 2, c.Subject.indexOf('CS') + 9).remove('.'));
                } catch (Exception e) {
                    try {
                        c.Access_Code__c = Integer.valueOf(c.Subject.substring(c.Subject.indexOf('CS') + 2, c.Subject.indexOf('CS') + 8));
                    } catch (Exception ex) {
                        //Just leave the Access Code empty.
                    }
                }
            }
            caseIds.add(c.Id);
            if (c.SuppliedEmail!=null) emailSet.add(c.SuppliedEmail);
            if (c.ContactId!=null) contactSet.add(c.ContactId);
            //Traceability for Community Users
            if (UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'PowerCustomerSuccess') emailSet.add(UserInfo.getUserEmail());
            if(c.Access_Code__c !=null && c.Access_Code__c >0){
                entitlementMap.put(c.Access_Code__c.intValue(),null);
            }
        }
        CommunityUserMap = new map<String,user>([SELECT Id, contactId,contact.Email FROM user WHERE Email IN : emailSet AND ContactId!=Null]);
        for(String UserId : CommunityUserMap.keySet()){
            contactSet.add(CommunityUserMap.get(UserId).ContactId);
        }
        
        caseMap = new Map<Id, Case>([select Id, Entitlement.BusinessHoursId, Entitlement.Working_Business_hours__c, Last_email__c from Case where Id IN:caseIds]);
        for(Contact c : [select Id, Email, AccountId from Contact where (Email IN :emailSet) OR (Id IN :contactSet)]){
            contactMap.put(c.Email, c);
            commmunityContactmap.put(c.id,c);
            contactAccountMap.put(c.Id, c.AccountId);
        }
        Set<ID> accIds = new Set<ID>();
        
        for(Entitlement e:[select Id, AccountId, Access_Code__c, Name from Entitlement where EndDate>=TODAY and StartDate<=TODAY]){
            entitlementMap.put(e.Access_Code__c.intValue(), e);
            
            entitlementAccountsMap.put(e.AccountId, e);
            system.debug('$$' +entitlementAccountsMap);
            accIds.add(e.AccountId);
        }
        
        
    }
    
    public static void setCaseContact(Case c){
        
        if (contactMap.containsKey(c.SuppliedEmail)) {
            c.ContactId = contactMap.get(c.SuppliedEmail).Id;
            c.AccountId = contactMap.get(c.SuppliedEmail).AccountId;
        }
        else if (c.SuppliedEmail == null) {
            //Community User Route
            if ((UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'PowerCustomerSuccess')) {
                c.ContactId = CommunityUserMap.get(userinfo.getUserId()).contactId;
                c.AccountId = commmunityContactmap.get(CommunityUserMap.get(userinfo.getUserId()).contactId).AccountId;
            }
            else {
                //No supplied email -> we have a contact!
                if(!contactAccountMap.isEmpty() && contactAccountMap.containsKey(c.ContactId)) {
                    c.AccountId = contactAccountMap.get(c.ContactId);
                }
            }
        }
        if (c.Access_Code__c != null &&
            c.Access_Code__c > 0 &&
            entitlementMap.containsKey(c.Access_Code__c.intValue()) &&
            entitlementMap.get(c.Access_Code__c.intValue()) != null) {
                if (String.isBlank(c.AccountId))  {
                    //use the accountId of the entitlement    
                    c.AccountId = entitlementMap.get(c.Access_Code__c.intValue()).AccountId;
                }
                c.EntitlementId = entitlementMap.get(c.Access_Code__c.intValue()).Id;
                if (entitlementMap.get(c.Access_Code__c.intValue()).Name.contains('Premier')) {
                    c.Is_Premier_Support__c = true;
                }
            }
        
        if (String.isBlank(c.EntitlementId)) {
            //If no entitlement so far, we try to locate the Account's entitlement
            if (c.AccountId != null && entitlementAccountsMap.containsKey(c.AccountId)) {
                c.EntitlementId = entitlementAccountsMap.get(c.AccountId).Id ;
                system.debug('et1 '+c.EntitlementId);
                if (entitlementAccountsMap.get(c.AccountId).Name.contains('Premier')) {
                    c.Is_Premier_Support__c = true;
                }
            }
            
            
            if (String.isBlank(c.EntitlementId )){
                system.debug('test');
                //If still no Entitlement... set default Entitlement to Standard Support
                c.EntitlementId = entitlementMap.get(1) != null ? entitlementMap.get(1).Id : null;
                
                
            }
        }
    }
    
    public static void CompleteResolutionTimeMilestone(Case c){
        if (UserInfo.getUserType() == 'Standard'){
            DateTime completionDate = System.now();
            if((c.isClosed == true)&&((c.SlaStartDate <= completionDate)&&(c.SlaExitDate == null)))resolveCases.add(c.Id);
        }
    }
    public static void updateCaseBusinessHours(Case oldCase, Case newCase){
        if(oldCase.Priority == newCase.Priority){
                if(newCase.Priority=='Critical' || newCase.Priority=='Urgent'){
                    newCase.BusinessHoursId = caseMap.get(newCase.Id).Entitlement.BusinessHoursId;
                }
                if(newCase.Priority=='High' || newCase.Priority=='Medium'){
                    newCase.BusinessHoursId = caseMap.get(newCase.Id).Entitlement.Working_Business_hours__c;
                }        
        }
    }
    public static void completeMilestones(){
        DateTime completionDate = System.now();
        if(resolveCases.isEmpty() == false)MilestoneUtils.completeMilestone(resolveCases, 'Resolution Time', completionDate);
    }
}