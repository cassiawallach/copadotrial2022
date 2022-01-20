global class LeadConvertBatch implements Database.Batchable<sObject>{
    
    global final LeadStatus convertStatus;
    
    global LeadConvertBatch(){
        convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, sfLma__Subscriber_Org_ID__c, sfLma__Account__c, sfLma__Contact__c, sfLma__Lead__c, sfLma__Org_Edition__c
                                            FROM sfLma__License__c 
                                            WHERE sfLma__Account__c = null AND 
                                                sfLma__Lead__c != null AND 
                                                sfLma__Lead__r.IsConverted = false AND
                                                sfLma__Lead__r.Batch_Convert_Lead__c = true]);
    }
    global void execute(Database.BatchableContext BC, List<sfLma__License__c> scope) {
        
        Map<String,Id> orgsMap = new Map<String,Id>();
        Map<String,List<Salesforce_User__c>> usersOrgsMap = new Map<String,List<Salesforce_User__c>>();
        Set<String> orgIdSet = new Set<String>();
        List<Lead> updateLeads = new List<Lead>();
        List<Account> deleteAccount = new List<Account>();
        String defaultLeadOwnerId = Copado_Settings__c.getValues('Default').Default_Lead_Owner__c;
        for(sfLma__License__c license : scope){
            //We assign Leads to be converted to Phil, so the process doesn't fail when converting Leads coming from the AppExchange installation
            updateLeads.add(new Lead(Id=license.sfLma__Lead__c, OrgId__c=ID15to18(license.sfLma__Subscriber_Org_ID__c), OwnerId = defaultLeadOwnerId));
            orgIdSet.add(ID15to18(license.sfLma__Subscriber_Org_ID__c));
            orgsMap.put(ID15to18(license.sfLma__Subscriber_Org_ID__c), null);
        }
        update updateLeads;

        //Company fails with SObject row retrieved without querying for it error, don't know why...
        Map<Id,Lead> leadsMap = new Map<Id,Lead>([SELECT Company, Email, FirstName, LastName, Batch_Convert_Lead__c, IsConverted 
                                                    FROM Lead 
                                                   WHERE Id IN :updateLeads]);

        for(Salesforce_Org__c org : [select Id, OrgId__c from Salesforce_Org__c where OrgId__c IN :orgIdSet]) {
            usersOrgsMap.put(org.OrgId__c, null);
            orgsMap.put(ID15to18(org.OrgId__c), org.Id);
        }

        for(Salesforce_User__c sfus : [select Id, Email__c, Salesforce_Org__r.OrgId__c from Salesforce_User__c where Salesforce_Org__r.OrgId__c IN: orgIdSet]) {
            List<Salesforce_User__c> tmpUsers = usersOrgsMap.get(ID15to18(sfus.Salesforce_Org__r.OrgId__c));
            
            if (tmpUsers == null) {
                tmpUsers = new List<Salesforce_User__c>();
            }

            tmpUsers.add(sfus);
            usersOrgsMap.put(ID15to18(sfus.Salesforce_Org__r.OrgId__c), tmpUsers);
        }

        for(sfLma__License__c license : scope) {

            if (leadsMap.containsKey(license.sfLma__Lead__c)) {
                if (leadsMap.get(license.sfLma__Lead__c).IsConverted == false) {

                    Salesforce_Org__c newOrg = null;
                    Salesforce_User__c newUser = null;

                    //if we have an existing account we will use that based on the orgId. Else we will create an account on conversion
                    Id useOrgId = (orgsMap.get(ID15to18(license.sfLma__Subscriber_Org_ID__c))==null)?null:orgsMap.get(ID15to18(license.sfLma__Subscriber_Org_ID__c));
                    Id useUserId;

                    List<Salesforce_User__c> users = usersOrgsMap.get(ID15to18(license.sfLma__Subscriber_Org_ID__c));

                    if(users!=null && users.size()>0){
                        for(Salesforce_User__c u : users){
                            if(u.Email__c == leadsMap.get(license.sfLma__Lead__c).Email) {
                                useUserId = u.Id;
                            }
                        }
                    }

                    if (useOrgId == null) {
                        newOrg = new Salesforce_Org__c(
                            Name = leadsMap.get(license.sfLma__Lead__c).Company,
                            OrgId__c = ID15to18(license.sfLma__Subscriber_Org_ID__c),
                            Org_Edition__c = license.sfLma__Org_Edition__c);
                        insert newOrg;
                        useOrgId = newOrg.Id;
                    }
                    if (useUserId == null) {
                        newUser = new Salesforce_User__c(
                            Email__c = leadsMap.get(license.sfLma__Lead__c).Email,
                            First_Name__c = leadsMap.get(license.sfLma__Lead__c).FirstName,
                            Last_Name__c = leadsMap.get(license.sfLma__Lead__c).LastName,
                            Salesforce_Org__c = useOrgId,
                            External_Id__c = license.sfLma__Lead__c);

                        insert newUser;
                        useUserId = newUser.Id;
                    }
                    
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(new Lead(Id=license.sfLma__Lead__c).Id);
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    
                    license.sfLma__Lead__c = null;
                    license.Salesforce_Org__c = useOrgId;
                    license.Salesforce_User__c = useUserId;
                    deleteAccount.add(new Account(Id=lcr.getAccountId()));
                    update license;
                }
            }
        }

        delete deleteAccount;
    }



    public static String ID15to18(String inID) {
        if (inID.length() == 18) { return inID; }
        else if (inID.length() != 15) { return ''; }
        else {
            String suffix = '';
            for (Integer i = 0; i < 3; i++) {
                Integer flags = 0;
                for (Integer j = 0; j < 5; j++) {
                    String c = inID.substring(i*5+j, i*5+j+1);
                    if ( ( c.compareTo('A') >= 0 ) && ( c.compareTo('Z') <= 0 ) ) {
                        flags += 1 << j;
                    }
                }
                suffix = suffix + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ012345'.substring(flags, flags+1);
            }
            return inID + suffix;
        }
    }
    global void finish(Database.BatchableContext BC){}
}