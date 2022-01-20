trigger OrderTrigger on Order (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(!OrderTriggerHelper.inTrigger){
        System.debug('@@@ Entering Order Trigger @@@');
        TriggerFactory.createHandler(Order.sObjectType);         
    }
    else{
        System.debug('@@@ Skipping Order Trigger @@@');
    }
}