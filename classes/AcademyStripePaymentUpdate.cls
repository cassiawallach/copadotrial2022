public without sharing class AcademyStripePaymentUpdate {

    public static String stripeEndpoint = 'https://api.stripe.com/v1/charges/';
    public static ltcomm__Payment_Settings__c paymentSettings {
        get {
            if(paymentSettings == null) {
                paymentSettings = [SELECT Id, ltcomm__Use_Sandbox__c, ltcomm__Stripe_Secret_Key_Production__c, ltcomm__Stripe_Secret_Key_Sandbox__c FROM ltcomm__Payment_Settings__c WHERE Name = 'PaymentSettings'];
            }
            return paymentSettings;
        }
        set;
    }

    @InvocableMethod(Description='Update Payment Detail in Stripe')
    public static void updatePaymentDetails(List<Id> learningOrderIds) {

        List<ltcomm__Learning_Order_Item__c> orderItems = [
                SELECT Id, ltcomm__Learning_Assignment__r.Name, ltcomm__Learning_Plan_Assignment__r.Name, ltcomm__Learning_Trac_Assignment__r.Name, ltcomm__Purchased_By__r.Name, ltcomm__Purchased_By__r.Email, ltcomm__ObjectId__c
                FROM ltcomm__Learning_Order_Item__c
                WHERE ltcomm__Learning_Order__c IN :learningOrderIds
                ORDER BY CreatedDate DESC
                LIMIT 1
        ];

        List<ltcomm__Learning_Order_Transaction__c> transactions = [
                SELECT Id, ltcomm__Transaction_Id__c
                FROM ltcomm__Learning_Order_Transaction__c
                WHERE ltcomm__Learning_Order__c IN :learningOrderIds
                AND ltcomm__Transaction_Id__c != NULL
                AND ltcomm__Transaction_Status__c = 'Paid'
                AND ltcomm__Error__c = NULL
                ORDER BY CreatedDate DESC
                LIMIT 1
        ];

        if(orderItems.isEmpty() || transactions.isEmpty()) {
            AcademyStripePaymentUpdate.sendErrorEmailToAcademy('Could not find order item or transaction with this learning order id: ' + learningOrderIds[0], learningOrderIds[0]);
            return;
        }

        String description = orderItems[0].ltcomm__Purchased_By__r.Name + ' / ';

        AcademyStripePaymentUpdate.updateChargeInStripe(transactions[0].ltcomm__Transaction_Id__c, description, orderItems[0].ltcomm__ObjectId__c, orderItems[0].ltcomm__Purchased_By__r.Email);


    }

    @Future(Callout=true)
    public static void updateChargeInStripe(String transactionId, String description, Id objectId, String receiptEmail) {
        String objectApiName = objectId.getSobjectType().getDescribe().getName();
        List<SObject> boughtRecord = new List<SObject>();
        boughtRecord = Database.query('SELECT Name FROM ' + objectApiName + ' WHERE Id = :objectId');

        if(boughtRecord.isEmpty()) {
            AcademyStripePaymentUpdate.sendErrorEmailToAcademy('Could not find record with id: ' + objectId, transactionId);
            return;
        }

        if(String.isNotBlank((String) boughtRecord[0].get('Name'))) {
            description += (String) boughtRecord[0].get('Name');
        }

        Http http = new Http();
        HttpRequest req = new HttpRequest();

        String username = paymentSettings.ltcomm__Use_Sandbox__c ? paymentSettings.ltcomm__Stripe_Secret_Key_Sandbox__c : paymentSettings.ltcomm__Stripe_Secret_Key_Production__c;
        String password = '';
        stripeEndpoint += transactionId;

        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        req.setEndpoint(stripeEndpoint);
        req.setMethod('POST');
        req.setBody('description=' + EncodingUtil.urlEncode(description, 'UTF-8') + '&receipt_email=' + EncodingUtil.urlEncode(receiptEmail, 'UTF-8'));

        try {
            HttpResponse response = new HttpResponse();
            if(Test.isRunningTest()) {
                response.setStatus('ok');
                response.setStatusCode(200);
            } else {
                response = http.send(req);
            }
        } catch(CalloutException excp) {
            AcademyStripePaymentUpdate.sendErrorEmailToAcademy(excp.getMessage(), transactionId);
        }

    }

    public static void sendErrorEmailToAcademy(String errorMessage, String learningTransactionId) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{
                'academy@copado.com'
        });
        email.setSubject('Error occurred on Stripe update for ' + learningTransactionId);
        email.setPlainTextBody('Hello Academy team \n Error occurred while updating description and receipt email for transaction: ' + learningTransactionId + '\n Error message is: ' + errorMessage);
        emails.add(email);
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails, false);
    }

}