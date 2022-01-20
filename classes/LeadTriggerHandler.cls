public class LeadTriggerHandler implements ITrigger {   

   
    public LeadTriggerHandler(){
        //if(Trigger.new != null)LeadTriggerHelper.prepareData(Trigger.new); 
    }
    
    public void bulkBefore(){}
    
    public void bulkAfter(){}
 
    public void beforeInsert(SObject so){
        
      
        Lead theLead = (Lead)so;
            
        //check if lead has 3 or and less than update lead status and Free
        //LeadTriggerHelper.setFreeMQL(theLead);  

        /*
        //check if lead has more than 15 deploys then convert opportunity
        LeadTriggerHelper.checkProOppty(theLead);


        //create an ent oppty if pro or more or using ent features
        LeadTriggerHelper.checkEntOppty(theLead); 
        */   
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){       
        Lead oldLead = (Lead)oldSo;
        Lead theLead = (Lead)so;

        //always check if lead has 3 or more update lead status and Free
        //LeadTriggerHelper.setFreeMQL(theLead);
        /*
        if(oldLead.ClickDeploy_Enterprise_Trial_Started__c == false && 
            theLead.ClickDeploy_Enterprise_Trial_Started__c == true){
            
            //create an ent oppty
            LeadTriggerHelper.checkEntOppty(theLead);
        } else if (oldLead.ClickDeploy_License_Type__c == 'Free' && 
            theLead.ClickDeploy_License_Type__c == 'Professional'){
            
            //close-win the free oppty
            LeadTriggerHelper.checkClosedProOppty(theLead);

            //create an ent oppty
            LeadTriggerHelper.checkEntOppty(theLead);
        } else if (oldLead.ClickDeploy_License_Type__c == 'Enterprise' && 
            theLead.ClickDeploy_License_Type__c == 'Professional'){
            
            //create an ent oppty
            LeadTriggerHelper.checkEntOppty(theLead);
        } else {
            //check if lead has 15 or more update lead status and creaet pro opp
            LeadTriggerHelper.checkProOppty(theLead);        
        }
        */

    }
    
    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){}
    
    public void afterDelete(SObject so){}
    
    public void andFinally(){}
}