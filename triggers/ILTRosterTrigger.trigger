trigger ILTRosterTrigger on redwing__ILT_Roster__c (before insert, before update, before delete, after insert, after update, after delete, after undelete){
    TriggerFactory.createHandler(redwing__ILT_Roster__c.sObjectType);
}