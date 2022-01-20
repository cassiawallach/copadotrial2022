public with sharing class ContactTriggerHandler implements ITrigger {
    
    public ContactTriggerHandler() {     
          
    }           
    
    public void bulkBefore() {  
        if(Trigger.new != null)ContactTriggerHelper.prepareData(Trigger.new); 
    }   

    public void bulkAfter() {   
    }   

    public void beforeInsert(SObject so){   
        
        Contact theContact = (Contact)so;
    
        ContactTriggerHelper.updateContact(theContact);
        
        //SG 2020-04-04 - Kangaroo parse marketing info
        ContactTriggerHelper.parseMarketingSourceData(theContact);
 
        //SG 2019-12-14 - Kangaroo Integreation Method
        ContactTriggerHelper.checkExistAccount(theContact);
        
    }   

    public void beforeUpdate(SObject oldSo, SObject so){ 
 
        Contact theContact = (Contact)so;
    
        ContactTriggerHelper.updateContact(theContact);  
        
        //SG 2020-04-04 - Kangaroo parse marketing info
        ContactTriggerHelper.parseMarketingSourceData(theContact);

        //SG 2019-12-14 - Kangaroo Integreation Method
        ContactTriggerHelper.checkExistAccount(theContact);

    }   
    public void beforeDelete(SObject so) {      
    }   

    public void afterInsert(SObject so) {   
        
        //Contact theContact = (Contact)so;
        
        //SG 2020-01-12 - Create lead from contact
        //ContactTriggerHelper.checkExistLead(theContact);
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        Contact NewContact = (Contact)so;
        Contact OldContact = (Contact)oldSo;    
		ContactTriggerHelper.sendanemailOnLikedInValueUpdate(OldContact,NewContact);

        //if the lic type didnt change dont create the lead
        //if(theOldContact.ClickDeploy_License_Type__c == theContact.ClickDeploy_License_Type__c){
            //SG 2020-01-12 - Create lead from contact
            //ContactTriggerHelper.checkExistLead(theContact);

        //}
    }      


    public void afterDelete(SObject so) 
    {
    }   
    public void andFinally()            
    {
    }
    
}