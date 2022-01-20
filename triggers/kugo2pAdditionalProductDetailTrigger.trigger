trigger kugo2pAdditionalProductDetailTrigger on kugo2p__AdditionalProductDetail__c (before insert) {
  for ( kugo2p__AdditionalProductDetail__c r : Trigger.New ){
    if ( r.kugo2p__ReferenceProduct__c != null ){
      r.Product2Id__c = r.kugo2p__ReferenceProduct__c;
    }
  }
}