@IsTest
private with sharing class AcademyStripePaymentUpdateTest {

    @TestSetup static void setupData() {
        redwing__Training_Plan__c learningPlan = new redwing__Training_Plan__c(Name='Test Plan');
        insert learningPlan;

        ltcomm__Payment_Settings__c paymentSetting  = new ltcomm__Payment_Settings__c();
        paymentSetting.Name = 'PaymentSettings';
        paymentSetting.ltcomm__Use_Sandbox__c = true;
        paymentSetting.ltcomm__Stripe_Secret_Key_Sandbox__c = 'sandbox-secret-key-stripe';
        paymentSetting.ltcomm__Stripe_Secret_Key_Production__c = 'production-secret-key-stripe';
        insert paymentSetting;

    }

    @IsTest static void testStripeUpdateSuccess(){

        redwing__Training_Plan__c learningPlan = [SELECT Id, Name FROM redwing__Training_Plan__c WHERE Name = 'Test Plan'];

        ltcomm__Learning_Order__c newOrder = new ltcomm__Learning_Order__c();
        newOrder.ltcomm__Amount__c = 200;
        newOrder.ltcomm__Purchased_By__c = UserInfo.getUserId();
        newOrder.ltcomm__Status__c = 'Paid';
        insert newOrder;

        ltcomm__Learning_Order_Item__c orderItem = new ltcomm__Learning_Order_Item__c();
        orderItem.ltcomm__Learning_Order__c = newOrder.Id;
        orderItem.ltcomm__ObjectId__c = learningPlan.Id;
        orderItem.ltcomm__Status__c = true;
        orderItem.ltcomm__Purchased_By__c = UserInfo.getUserId();
        insert orderItem;

        ltcomm__Learning_Order_Transaction__c orderTransaction = new ltcomm__Learning_Order_Transaction__c();
        orderTransaction.ltcomm__Learning_Order__c = newOrder.Id;
        orderTransaction.ltcomm__Transaction_Id__c = 'transaction-id';
        orderTransaction.ltcomm__Transaction_Status__c = 'Paid';
        insert orderTransaction;

        AcademyStripePaymentUpdate.updatePaymentDetails(new List<String>{newOrder.Id});
        AcademyStripePaymentUpdate.sendErrorEmailToAcademy('test meessage', orderTransaction.Id);
    }

    @IsTest static void testStripeUpdateError(){

        ltcomm__Learning_Order__c newOrder = new ltcomm__Learning_Order__c();
        newOrder.ltcomm__Amount__c = 200;
        newOrder.ltcomm__Purchased_By__c = UserInfo.getUserId();
        newOrder.ltcomm__Status__c = 'Paid';
        insert newOrder;

        ltcomm__Learning_Order_Transaction__c orderTransaction = new ltcomm__Learning_Order_Transaction__c();
        orderTransaction.ltcomm__Learning_Order__c = newOrder.Id;
        orderTransaction.ltcomm__Transaction_Id__c = 'transaction-id';
        orderTransaction.ltcomm__Transaction_Status__c = 'Paid';
        insert orderTransaction;
    }
    
}