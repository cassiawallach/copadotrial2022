public without sharing class LearningOrderTriggerHelper{
    
    public static void prepareData(List<SObject> records){
        Set<String> CouponIds = new Set<String>();
        for(SObject so : records){
            ltcomm__Learning_Order__c LearningOrder = (ltcomm__Learning_Order__c)so;
            if(LearningOrder.ltcomm__Coupon__c!=Null){
                CouponIds.add(LearningOrder.ltcomm__Coupon__c);
            }
        }
        if(CouponIds.size()>0){
            UpdateNumberOfUsed(CouponIds);
        }
    }
    public static void UpdateNumberOfUsed(Set<String> CouponIds){
        Map<Id,ltcomm__Coupon__c> CouponsMap = new Map<Id,ltcomm__Coupon__c>([Select id, name,number_of_Used__c,(SELECT Id, ltcomm__Coupon__c, ltcomm__Purchased_By__c, ltcomm__Status__c FROM ltcomm__Learning_Orders__r) From ltcomm__Coupon__c WHERE Id IN: CouponIds]);
        Map<String,ltcomm__Coupon__c> updateCouponMap = new Map<String,ltcomm__Coupon__c>();
        for(String couponId : CouponsMap.keySet()){
            if(CouponsMap.containskey(couponId)){
                ltcomm__Coupon__c TempCoupon = new ltcomm__Coupon__c();
                TempCoupon.Id = couponId;
                TempCoupon.number_of_Used__c = CouponsMap.get(couponId).ltcomm__Learning_Orders__r.size();
                updateCouponMap.put(couponId,TempCoupon);
            }
            if(updateCouponMap.size()>0){
               UPDATE updateCouponMap.values();
            }
            system.debug('updateCouponMap:'+updateCouponMap.values());
        }
    }
    
    public static void InsertionPreventForTargetTypeLearner(ltcomm__Learning_Order__c NewRecord){
        if(NewRecord.ltcomm__Coupon__c != null){
            Map<Id,ltcomm__Learning_Order__c> LearnerOrders = new Map<Id,ltcomm__Learning_Order__c>([SELECT Id,ltcomm__Coupon__c,ltcomm__Coupon__r.Target_Type__c FROM ltcomm__Learning_Order__c WHERE ltcomm__Coupon__c =:NewRecord.ltcomm__Coupon__c AND ltcomm__Purchased_By__c=:NewRecord.ltcomm__Purchased_By__c  AND ltcomm__Coupon__r.Target_Type__c = 'Learner']);
            if(LearnerOrders.size()>0){
                NewRecord.addError('You have already redeemed this code.');
            }
        }
    }
}