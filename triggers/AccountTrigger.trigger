trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(AccountService.accountTriggerActive){
        System.debug('@@@ Entering Account Trigger @@@');
        TriggerFactory.createHandler(Account.sObjectType);
    }
    else{
        System.debug('@@@ Skipping Account Trigger @@@');
    }
}