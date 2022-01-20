/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SendGiftToContactInvocableClass {
    global SendGiftToContactInvocableClass() {

    }
    @InvocableMethod(label='Send Gift to Contact' description='Sends gift to the Contact')
    global static void sendGiftMethod(List<lnt.SendGiftToContactInvocableClass.InputVariables> inputs) {

    }
global class InputVariables {
    @InvocableVariable(label='Account Id' required=false)
    global String accountId;
    @InvocableVariable(label='Campaign Id' required=false)
    global String campaignId;
    @InvocableVariable(label='Case Id' required=false)
    global String caseId;
    @InvocableVariable(label='Contact Id' required=true)
    global Id contactId;
    @InvocableVariable(label='Expiration Date' required=false)
    global Date expirationDate;
    @InvocableVariable(label='Opportunity Id' required=false)
    global String opportunityId;
    @InvocableVariable(label='Gift Template Name' required=true)
    global String templateName;
    global InputVariables() {

    }
}
}
