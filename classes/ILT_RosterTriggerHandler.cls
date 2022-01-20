public  with sharing  class ILT_RosterTriggerHandler implements ITrigger {
    public ILT_RosterTriggerHandler(){
    }
    
    public void bulkBefore(){
        if(Trigger.new != null )ILT_RosterTriggerHelper.prepareData(Trigger.new);
    }
    
    public void bulkAfter(){
    }
    
    public void beforeInsert(SObject so){
         redwing__ILT_Roster__c roster = (redwing__ILT_Roster__c)so;
        ILT_RosterTriggerHelper.addMemberInDiscussionGroup(roster);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
    }
    
    public void beforeDelete(SObject so){
    }
    
    public void afterInsert(SObject so){
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
    }
    
    public void afterDelete(SObject so){
    }
    
    public void andFinally(){
        if(checkRecursive.runOnce()){
            ILT_RosterTriggerHelper.addCollaborationGroupMembersAndSendEmailNotify();
        }
        
    }
}