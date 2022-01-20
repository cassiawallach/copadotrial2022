trigger SBQQDiscountScheduleTrigger on SBQQ__DiscountSchedule__c (after insert, after update, after delete, after undelete) {
  Schema.SObjectType transformToObject = kugo2p__TieredPricing__c.getSobjectType();
  Schema.SObjectField externalId = kugo2p__TieredPricing__c.DiscountScheduleId__c;
  if ( Trigger.isAfter && Trigger.isInsert ){
    zealynxsf.Sync.handleTrigger(Trigger.new, null, Trigger.operationType, transformToObject, externalId );
  }
  if ( Trigger.isAfter && Trigger.isUpdate ){
    zealynxsf.Sync.handleTrigger(Trigger.new, Trigger.old, Trigger.operationType, transformToObject, externalId );
  }
  if ( Trigger.isAfter && Trigger.isDelete ){
    zealynxsf.Sync.handleTrigger(Trigger.old, null, Trigger.operationType, transformToObject, externalId );
  }
  if ( Trigger.isAfter && Trigger.isUndelete ){
    zealynxsf.Sync.handleTrigger(Trigger.new, null, Trigger.operationType, transformToObject, externalId );
  }
  
}