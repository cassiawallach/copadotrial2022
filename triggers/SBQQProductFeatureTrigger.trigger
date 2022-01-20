trigger SBQQProductFeatureTrigger on SBQQ__ProductFeature__c (after insert, after update, after delete, after undelete) {
  Schema.SObjectType transformToObject = kugo2p__ConfigurationGroup__c.getSobjectType();
  Schema.SObjectField externalId = kugo2p__ConfigurationGroup__c.ProductFeatureId__c;

  if ( Trigger.isAfter && Trigger.isInsert ){
    zealynxsf.sync.handleTrigger(Trigger.new, null, Trigger.operationType, transformToObject, externalId );
  }
  if ( Trigger.isAfter && Trigger.isUpdate ){
    zealynxsf.sync.handleTrigger(Trigger.new, Trigger.old, Trigger.operationType, transformToObject, externalId );
  }
  if ( Trigger.isAfter && Trigger.isDelete ){
    zealynxsf.sync.handleTrigger(Trigger.old, null, Trigger.operationType, transformToObject, externalId );
  }
  if ( Trigger.isAfter && Trigger.isUndelete ){
    zealynxsf.sync.handleTrigger(Trigger.new, null, Trigger.operationType, transformToObject, externalId );
  }
}