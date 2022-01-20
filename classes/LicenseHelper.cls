public without sharing class LicenseHelper {
    
    private static List<sfFma__FeatureParameterInteger__c> fpiUpsert;
    private static List<sfLma__License__c> fpiUpdate;
    private static List<String> salesforceOrgIds;
    private static List<Salesforce_Org__c> updateOrgs;
    private static Map<String,Id> featureParameters = new Map<String,Id>();
    private static Map<String,Id> FeatureParameterIntegerMap= new Map<String,Id>();
    private static Map<Id,sfLma__Package__c> CopadoDeployerPackage;
    
    public static void prepareData(List<SObject> records) {
        FeatureParameterIntegerMap = NEW Map<String,Id>();
        fpiUpsert = new List<sfFma__FeatureParameterInteger__c>();
        fpiUpdate = new List<sfLma__License__c>();
        salesforceOrgIds = new List<String>();
        updateOrgs = new List<Salesforce_Org__c>();
        //Modified by Sagar Sharma
        //Start 
        CopadoDeployerPackage = new Map<Id,sfLma__Package__c>([SELECT Id FROM sfLma__Package__c WHERE Name = 'Copado Deployer' LIMIT 1 ]);
        Set<Id> LicenseIds = new Set<Id>();
        sfLma__License__c licenseObj = new sfLma__License__c();
        if(records.size()>0){
            for(sObject licenseSObject : records){
                licenseObj = (sfLma__License__c)licenseSObject;
                LicenseIds.add(LicenseObj.Id);
            }
        }
        List<sfFma__FeatureParameterInteger__c> FeatureParameterInteger = new List<sfFma__FeatureParameterInteger__c>([SELECT Id, External_Id__c,sfFma__License__c FROM sfFma__FeatureParameterInteger__c WHERE sfFma__License__c IN: LicenseIds]); 
        for(sfFma__FeatureParameterInteger__c FPI : FeatureParameterInteger){
            FeatureParameterIntegerMap.put(FPI.External_Id__c,FPI.sfFma__License__c);
        }
        //End
        for (sfFma__FeatureParameter__c fp: [SELECT Id, sfFma__FullName__c, sfFma__DataType__c, sfFma__Namespace_Prefix__c FROM sfFma__FeatureParameter__c]) {
            featureParameters.put(fp.sfFma__FullName__c + fp.sfFma__DataType__c + fp.sfFma__Namespace_Prefix__c, fp.Id);
        }
    }
    public static void prepareDataOnInsert(Map<id,SObject> records){
        list<sfLma__License__c> LIcenseList  = [SELECT id FROM sfLma__License__c LIMIT 10000 ];
        LIcenseList.clear();
        set<id> SubscriberOrgIds = new set<Id>();
        sfLma__License__c licenseObj = new sfLma__License__c();
        list<sfLma__License__c> updateLicenses = new list<sfLma__License__c>();
        if(records.size()>0){
            for(SObject licenseSObject : records.values()){
                system.debug(records.values());
                licenseObj = (sfLma__License__c)licenseSObject;
                if(LicenseObj.sfLma__Lead__c == NULL){
                    if(licenseObj.Salesforce_Org__c==NULL ){
                        SubscriberOrgIds.add(LeadConvertBatch.ID15to18(licenseObj.sfLma__Subscriber_Org_ID__c));
                    }
                }
            }
            system.debug(SubscriberOrgIds);
        }
        map<Id,Salesforce_Org__c> SalesforceOrgs = new map<Id,Salesforce_Org__c>([SELECT Id,OrgId__c from Salesforce_Org__c where OrgId__c IN : SubscriberOrgIds]);
        map<Id,Salesforce_Org__c> SubscriberOrgIdWithSalesforceOrg = new map<Id,Salesforce_Org__c>();
        for(String SalesforceOrgId : SalesforceOrgs.keySet()){
            SubscriberOrgIdWithSalesforceOrg.put(SalesforceOrgs.get(SalesforceOrgId).OrgId__c,SalesforceOrgs.get(SalesforceOrgId));
        }
        system.debug(SubscriberOrgIdWithSalesforceOrg);
        map<String,Salesforce_Org__c> LicenseIdWithSalesforceOrg = new map<String,Salesforce_Org__c>();
        for(SObject licenseSObject : records.values()){
            licenseObj = (sfLma__License__c)licenseSObject;
            if(LicenseObj.sfLma__Lead__c == NULL){
                if(licenseObj.Salesforce_Org__c==NULL && LicenseObj.sfLma__Lead__c == NULL && !SubscriberOrgIdWithSalesforceOrg.containskey(LeadConvertBatch.ID15to18(licenseObj.sfLma__Subscriber_Org_ID__c))){
                    Salesforce_Org__c SalesforceOrgObj = new Salesforce_Org__c();
                    SalesforceOrgObj.Name='AutoCreated_'+LeadConvertBatch.ID15to18(licenseObj.sfLma__Subscriber_Org_ID__c);
                    SalesforceOrgObj.OrgId__c = LeadConvertBatch.ID15to18(licenseObj.sfLma__Subscriber_Org_ID__c);
                    LicenseIdWithSalesforceOrg.put(licenseObj.Id,SalesforceOrgObj);
                }
                else if(SubscriberOrgIdWithSalesforceOrg.containskey(LeadConvertBatch.ID15to18(licenseObj.sfLma__Subscriber_Org_ID__c))){
                    sfLma__License__c updateLicenseObj = new sfLma__License__c();
                    updateLicenseObj.Id = licenseObj.id;
                    //licenseObj.Salesforce_Org__c = SubscriberOrgIdWithSalesforceOrg.get(LeadConvertBatch.ID15to18(licenseObj.sfLma__Subscriber_Org_ID__c)).Id;
                    updateLicenseObj.Salesforce_Org__c = SubscriberOrgIdWithSalesforceOrg.get(LeadConvertBatch.ID15to18(licenseObj.sfLma__Subscriber_Org_ID__c)).Id;
                    updateLicenses.add(updateLicenseObj);
                }
            }
        }
        if(LicenseIdWithSalesforceOrg.size()>0){
            INSERT LicenseIdWithSalesforceOrg.values();
            for(SObject licenseSObject : records.values()){
                licenseObj = (sfLma__License__c)licenseSObject;
                if(LicenseObj.sfLma__Lead__c == NULL){
                    if(licenseObj.Salesforce_Org__c==NULL && LicenseObj.sfLma__Lead__c == NULL && !SubscriberOrgIdWithSalesforceOrg.containskey(LeadConvertBatch.ID15to18(licenseObj.sfLma__Subscriber_Org_ID__c))){
                        if(LicenseIdWithSalesforceOrg.containsKey(licenseObj.id)){
                            sfLma__License__c updateLicenseObj = new sfLma__License__c();
                            updateLicenseObj.Id = licenseObj.id;
                            updateLicenseObj.Salesforce_Org__c = LicenseIdWithSalesforceOrg.get(licenseObj.id).Id;
                            // licenseObj.Salesforce_Org__c = LicenseIdWithSalesforceOrg.get(licenseObj.id).Id;
                            updateLicenses.add(updateLicenseObj);
                        }
                    }
                }
            }
        }
        if(updateLicenses.size()>0){
            system.debug('updateLicenses');
            system.debug(updateLicenses);
            UPDATE updateLicenses;
        }
    }
    public static void createZeroFeatureParameterIntegers(sfLma__License__c oldLicense, sfLma__License__c newLicense) {
        if (oldLicense.Salesforce_Org__c != newLicense.Salesforce_Org__c && newLicense.Salesforce_Org__c != null) {
            //CCM Feature Parameter
            sfFma__FeatureParameterInteger__c fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__CCM_Licenses_EnabledIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__CCM_Licenses_Enabled',
                sfFma__FullName__c = 'copado__CCM_Licenses_Enabled',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }
            
            
            //CAD Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__CAD_Licenses_EnabledIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__CAD_Licenses_Enabled',
                sfFma__FullName__c = 'copado__CAD_Licenses_Enabled',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }
            
            //CCH Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__CCH_Licenses_EnabledIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__CCH_Licenses_Enabled',
                sfFma__FullName__c = 'copado__CCH_Licenses_Enabled',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }
            
            //CST Licenses Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__CST_Licenses_EnabledIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__CST_Licenses_Enabled',
                sfFma__FullName__c = 'copado__CST_Licenses_Enabled',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }
            
            //EE Licenses Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__EE_Licenses_EnabledIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__EE_Licenses_Enabled',
                sfFma__FullName__c = 'copado__EE_Licenses_Enabled',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }
            
            //ADD Licenses Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__ADD_Licenses_EnabledIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__ADD_Licenses_Enabled',
                sfFma__FullName__c = 'copado__ADD_Licenses_Enabled',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }
            
            //CST Minutes Packages Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__CST_Minutes_PackagesIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__CST_Minutes_Packages',
                sfFma__FullName__c = 'copado__CST_Minutes_Packages',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }   
            
            //CBM Licenses Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__CBM_BranchesIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__CBM_Branches',
                sfFma__FullName__c = 'copado__CBM_Branches',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }
            
            //Functions Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__FunctionsIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__Functions',
                sfFma__FullName__c = 'copado__Functions',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }
            
            //Hard Limit Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__CustomFunctionHardCreditLimitIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__CustomFunctionHardCreditLimit',
                sfFma__FullName__c = 'copado__CustomFunctionHardCreditLimit',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }
            
            //Soft Limit Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__CustomFunctionSoftCreditLimitIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__CustomFunctionSoftCreditLimit',
                sfFma__FullName__c = 'copado__CustomFunctionSoftCreditLimit',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            }
            
            //Functions Usage Feature Parameter
            fpi = new sfFma__FeatureParameterInteger__c(
                sfFma__License__c = newLicense.Id,
                sfFma__FeatureParameter__c = featureParameters.get('copado__CustomFunctionCreditUsageIntegercopado'),
                External_Id__c = newLicense.Salesforce_Org__c + '_' + 'copado__CustomFunctionCreditUsage',
                sfFma__FullName__c = 'copado__CustomFunctionCreditUsage',
                Expiration_Date__c = null,
                sfFma__Value__c = 0);
            if(!FeatureParameterIntegerMap.containsKey(fpi.External_Id__c)){
                if(CopadoDeployerPackage.containsKey(newLicense.sfLma__Package__c)){
                    fpiUpsert.add(fpi);
                }
            } 
        }  
    }
    
    public static void forceParameterIntegersUpdate(sfLma__License__c oldLicense, sfLma__License__c newLicense) {
        fpiUpdate.add(newLicense);
    }
    
    public static void setOrgEdition(sfLma__License__c license) {
        if (license.Salesforce_Org__c != null) {
            Salesforce_Org__c org = new Salesforce_Org__c();
            org.Id = license.Salesforce_Org__c;
            org.Org_Edition__c = license.sfLma__Org_Edition__c;
            updateOrgs.add(org);
        }
    }
    
    public static void upsertFeatureParameterIntegers () {
        if(fpiUpsert.size()>0){
            upsert fpiUpsert;
        }
    }
    
    public static void updateForcedFPIs () {
        update [SELECT Id FROM sfFma__FeatureParameterInteger__c WHERE sfFma__License__c IN :fpiUpdate];
    }
    
    public static void updateOrgs () {
        if (!updateOrgs.isEmpty()) {
            upsert updateOrgs;
        }
    }
    
    /** 
* This method is used by the Playground Creation Wizard (NodeJS) to retrieve a license ID
* and make sure that the license is then converted into a Salesforce_Org__c and Salesforce_User__c record.
* 
* @param licenseId		This is the license Id to be queried for which will convert the associated lead.
* @return				The webserviceResult object is returned that contains parameters like isSuccess, status, statusMessage. 
*/
    public static LicenseHelper.webServiceResult convertLeadToLicense(Id licenseId){
        LicenseHelper.webServiceResult wsr = new LicenseHelper.webServiceResult();
        LeadStatus convertStatus = [select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        
        //First check if the lead has been converted already into a Salesforce record.
        sfLma__License__c license = [select Id, Name, IsDeleted, sfLma__Lead__c, Salesforce_Org__c, Salesforce_User__c, sfLma__Subscriber_Org_ID__c, sfLma__Org_Edition__c, 
                                     sfLma__Lead__r.Company, sfLma__Lead__r.Email, sfLma__Lead__r.FirstName, sfLma__Lead__r.LastName, sfLma__Lead__r.Batch_Convert_Lead__c, sfLma__Lead__r.IsConverted
                                     from sfLma__License__c 
                                     where IsDeleted=false and Id=:licenseId limit 1];
        if(license.sfLma__Lead__c==null || license.sfLma__Lead__r.IsConverted==true){
            system.debug('License '+license.Name+' ('+license.Id+') has already been converted to a Salesforce Org: '+license.Salesforce_Org__c);
            wsr.isSuccess = true;
            wsr.status = 201;
            return wsr;
        }
        Id leadId = license.sfLma__Lead__c;
        
        //Now that we know we need to convert the lead let's do conversion
        //First set the default lead owner as it cannot be a group (it must be a user).
        String orgId18Char = LeadConvertBatch.ID15to18(license.sfLma__Subscriber_Org_ID__c);
        String defaultLeadOwnerId = Copado_Settings__c.getValues('Default').Default_Lead_Owner__c;
        Lead theLead = new Lead(Id=license.sfLma__Lead__c, OrgId__c=orgId18Char, OwnerId=defaultLeadOwnerId);
        update theLead;
        
        //Before we modify database, let's set a system restore point.
        Savepoint sp = Database.setSavepoint();
        try {
            system.debug('### inserting Salesforce_Org__c');
            Salesforce_Org__c newOrg = new Salesforce_Org__c (Name=license.sfLma__Lead__r.Company, OrgId__c=orgId18Char, Org_Edition__c=license.sfLma__Org_Edition__c);
            upsert newOrg OrgId__c;
            
            system.debug('### inserting Salesforce_User__c');
            Salesforce_User__c newUser = new Salesforce_User__c(Email__c=license.sfLma__Lead__r.Email, First_Name__c=license.sfLma__Lead__r.FirstName, Last_Name__c=license.sfLma__Lead__r.LastName, Salesforce_Org__c=newOrg.Id, External_Id__c=license.sfLma__Lead__c);
            insert newUser;
            
            system.debug('### Updating License');
            license.sfLma__Lead__c = null;
            license.Salesforce_Org__c = newOrg.Id;
            license.Salesforce_User__c = newUser.Id;
            update license;
            
            system.debug('### Converting Lead');
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(leadId);
            lc.setOwnerId(defaultLeadOwnerId);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            
            system.debug('### deleting Account');
            delete new Account(Id=lcr.getAccountId());
            wsr.isSuccess = true;
            wsr.status = 201;
            wsr.statusMessage = 'Lead successfully converted and Account deleted.';
            return wsr;
        }
        catch (Exception e) {
            Database.rollback(sp);
            system.debug('DML Operations rolled-back because of error: '+e.getMessage());
            wsr.isSuccess = false;
            wsr.status = 500;
            wsr.statusMessage = e.getMessage();
            return wsr;
        }
        
    }
    
    /**
* This method will assign Copado licenses (Feature_Parameter values) to the associate license.
* A sync from the sfLma (Salesforce License Management App) is then automatically performed to provision those licenses
* in the customer app.
* 
* @param licenseId				The license Id to pe provisioned.
* @param body				 	JSON String
* 								This will assign 1 CCM license to the customer org.
* @return 						LicenseHelper.webServiceResult object that contains parameters like isSuccess, status, statusMessage.
*/
    public static LicenseHelper.webServiceResult provisionCopadoLicenses(Id licenseId, String body) {
        LicenseHelper.webServiceResult wsr = new LicenseHelper.webServiceResult();
        Map<String, Map<String, Object>> assignments = parseBody(body);
        system.debug('### Map 1: '+assignments);
        system.debug('licenseId::'+licenseId);
        system.debug('assignments::'+assignments);
        if(assignments==null || String.isEmpty(licenseId)) {
            system.debug('Internal server error.');
            wsr.isSuccess = false;
            wsr.status = 500;
            wsr.statusMessage = 'The license ID was null or it was an invalid String.  LicenseId Parameter: '+licenseId;
            return wsr;
        }
        
        // queryFeatureParameters against license and make sure we have some.
        // todo what if we don't have feature parameters?
        List<sfFma__FeatureParameterInteger__c> fpis = [select Id, sfFma__FullName__c, sfFma__Value__c, Expiration_Date__c, sfFma__License__r.Salesforce_Org__c FROM sfFma__FeatureParameterInteger__c
                                                        where sfFma__License__c=:licenseId];
        String orgId = '';
        // now assign featureParamter values (integers) to feature Parameters
        for(sfFma__FeatureParameterInteger__c fpi : fpis) {
            orgId = fpi.sfFma__License__r.Salesforce_Org__c;
            if(assignments.containsKey(fpi.sfFma__FullName__c)) {
                Map<String, Object> fp = assignments.get(fpi.sfFma__FullName__c);
                system.debug('### Found key: '+fpi.sfFma__FullName__c);
                system.debug(''+fp);
                Integer value = (fp.get('licenses')==null)? null : (Integer)fp.get('licenses');
                Integer expireIn = (fp.get('expireIn')==null)? null : (Integer)fp.get('expireIn');
                Date expirationDate = (fp.get('expirationDate')==null)? null : Date.valueOf(String.valueOf(fp.get('expirationDate')));
                
                fpi.sfFma__Value__c = value;
                fpi.Expiration_Date__c = (expireIn==null)? expirationDate : Date.today().addDays(expireIn);    
            }
        }
        try {
            update fpis;
            wsr.isSuccess = true;
            wsr.status = 201;
            syncFeatures(orgId);
            return wsr;
        }
        catch(Exception e) {
            system.debug('Error during update: '+e.getMessage());
            wsr.isSuccess = false;
            wsr.status = 500;
            wsr.statusMessage = e.getMessage();
            return wsr;
        }
    }
    
    /**
* This method will update the License record.  As Playground email addresses may contain gmail, or other 'non-valid' email addresses,
* this method will ensure that the license record is not set to 'Suspended'.
* Expected Input '{"status": "Active","forceactive": true,"licenses": -1}'
* 
* @param body					JSON String
* @return 						LicenseHelper.webServiceResult object that contains parameters like isSuccess, status, statusMessage.
*/
    public static LicenseHelper.webServiceResult updateLicense(Id licenseId, String body) {
        LicenseHelper.webServiceResult wsr = new LicenseHelper.webServiceResult();
        String status;  //The status of the license (Active or Suspended).
        Integer licenseCount; //How many licenses should be assigned. -1 = Org wide license.
        Boolean forceActive; //Sets the force to remain active checkbox to true
        
        Map<String, Object> returnMap = new Map<String, Object>();
        try {
            returnMap = (Map<String, Object>)JSON.deserializeUntyped(body);
            status = (String)returnMap.get('status');
            licenseCount = (Integer)returnMap.get('licenses');
            forceActive = (boolean)returnMap.get('forceactive');
        }
        catch(Exception e) {
            wsr.isSuccess = false;
            wsr.status = 500;
            wsr.statusMessage = 'Error parsing JSON: '+e.getMessage();
            return wsr;
        }
        
        sfLma__License__c license = new sfLma__License__c();
        try {
            license = [select Id, Force_to_remain_Active__c, sfLma__Is_Sandbox__c from sfLma__License__c where Id=:licenseId];
        }
        catch (QueryException qe) {
            wsr.isSuccess = false;
            wsr.status = 500;
            wsr.statusMessage = 'A matching license record could not be found using the record Id:'+licenseId +'; Exception:'+qe.getMessage();
            return wsr;
        }
        
        try {
            license.Force_to_remain_Active__c = forceActive;
            license.sfLma__Status__c = status;
            license.sfLma__Seats__c = (license.sfLma__Is_Sandbox__c)? -1 : licensecount;
            update license;
            wsr.isSuccess = true;
            wsr.status = 201;
            return wsr;
        }
        catch(Exception e) {
            system.debug('Error during license update: '+e.getMessage());
            wsr.isSuccess = false;
            wsr.status = 500;
            wsr.statusMessage = 'Error during license update: '+e.getMessage();
            return wsr;
        }
    }
    
    /**
* This method will take the jsonString input, and parse this to return a map.
* If the input cannot be parsed it will return a null so that the provisioning process can be aborted and an error
* can be returned.
* Format: JSON String
* 
* @param jsonString			This String content to be parsed
* @return 						Map<String, Map<String, Object>>
*/
    public static Map<String, Map<String, Object>> parseBody(String jsonString) {
        system.debug('Parsing String: '+jsonString);
        Map<String, Map<String, Object>> returnMap = new Map<String, Map<String, Object>>();
        if(String.isBlank(jsonString))return null;
        try{
            List<Object> features = (List<Object>)JSON.deserializeUntyped(jsonString);
            for(Object o : features) {
                Map<String, Object> fMap = (Map<String, Object>)o;
                for(String featureName : fMap.keySet()) {
                    Map<String, Object> tmp = (Map<String, Object>)fMap.get(featureName);
                    returnMap.put(featureName, tmp);
                }
            }
            return returnMap;
        }
        catch(Exception e){
            system.debug('Error during parsing: '+e.getMessage());
            return null;
        }
    }
    
    
    @future(callout=true)
    private static void syncFeatures(Id orgId){
        admin_utilities.syncFeatures(orgId);
    }
    
    /**
* This class is used to return a consistent response to a connecting system.
* isSuccess is boolean if the job has successfully completed.
* status is an Integer and the standard HTML status codes should returned. 
* e.g. 201=Creted; 401=Unauthorized; 500=Internal Server Error
*/
    public class webServiceResult {
        public Boolean isSuccess {get;set;}
        public Integer status {get;set;}
        public String statusMessage {get;set;}
        public String body {get;set;}
    }
}