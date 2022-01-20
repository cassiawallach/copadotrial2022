//Created by Englhard Consulting August 19th, 2019
trigger contentDocumentLinkTrigger on ContentDocumentLink (before insert) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            contentDocumentLinkHandler.handleTrigger(trigger.new);
        }
    }
}