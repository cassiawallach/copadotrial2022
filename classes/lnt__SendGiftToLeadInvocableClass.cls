/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SendGiftToLeadInvocableClass {
    global SendGiftToLeadInvocableClass() {

    }
    @InvocableMethod(label='Send Gift to Lead' description='Sends gift to the Lead')
    global static void sendGiftMethod(List<lnt.SendGiftToLeadInvocableClass.InputVariables> inputs) {

    }
global class InputVariables {
    @InvocableVariable(label='Campaign Id' required=false)
    global String campaignId;
    @InvocableVariable(label='Expiration Date' required=false)
    global Date expirationDate;
    @InvocableVariable(label='Lead Id' required=true)
    global Id leadId;
    @InvocableVariable(label='Gift Template Name' required=true)
    global String templateName;
    global InputVariables() {

    }
}
}
