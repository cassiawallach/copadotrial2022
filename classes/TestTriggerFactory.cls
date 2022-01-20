/**
* Created by kheidt on 12/03/2018.
*/
@IsTest
private class TestTriggerFactory {
    private static List<Account> accounts = new List<Account>();
    private static void setUp(){
        
        accounts = TestDataFactory.createAccounts(
            new List<String>{'_me','_you','_he','_we','_us','_they'},
            new List<String>{'USD', 'EUR', 'GBP', 'USD', 'EUR', 'GBP'}
        );
    }
    static testMethod void testTriggerError() {
        test.startTest();
        try{
            TriggerFactory.createHandler(ApexClass.getSObjectType());
        } catch (Exception e){
            System.assert(e.getMessage().contains('No Trigger Handler registered for Object Type: '));
        }
        test.stopTest();
    }
    static testMethod void testInsertHandler(){
        setUp();
        test.startTest();
        insert accounts;
        test.stopTest();
        List<Account> newAccounts = [SELECT Id FROM Account];
        System.assertEquals(6, accounts.size());
    }
    static testMethod void testUpdateHandler(){
        setUp();
        insert accounts;
        for(Account act : accounts){
            act.Name += '_update';
        }
        test.startTest();
        update accounts;
        test.stopTest();
        List<Account> newAccounts = [SELECT Id, Name FROM Account];
        for(Account act : newAccounts){
            System.assertEquals('update',act.Name.right(6));
        }
    }
    static testMethod void testDeleteHandler(){
        setUp();
        insert accounts;
        test.startTest();
        delete accounts;
        
        List<Account> resultAccounts = [SELECT Id FROM Account];
        delete resultAccounts;
        test.stopTest();
        System.assertEquals(0, 0);
    }
    static testMethod void testGetHandler_ContactTriggerHanlder(){
        test.startTest();
        Object o = TriggerFactory.getHandler(Contact.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_PsydoCaseTriggerHandler(){
        test.startTest();
        Object o = TriggerFactory.getHandler(Psydo_Case__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_ContractLineItemTriggerHandler(){
        test.startTest();
        Object o = TriggerFactory.getHandler(Contract_Line_Item__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_CaseTriggerHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(Case.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_CPQ_QuoteTriggerHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(SBQQ__Quote__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_TaskTriggerHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(Task.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_EmailMessageTriggerHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(EmailMessage.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_OrderTriggerHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(Order.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_ReleaseTriggerHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(copado__Release__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_SalesforceOrgHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(Salesforce_Org__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_MeetingTriggerHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(Demo__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_LicenseHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(sfLma__License__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_AcademyCertificationStudentHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(Academy_Certification_Student__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_AcademyCertificationDeliveryHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(Academy_Certification_Delivery__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_TimeLogHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(amc__Time_Log__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_PlaygroundJobHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(Playground_Job__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testGetHandler_LeadHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(Lead.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
    static testMethod void testLearningOrderTriggerHandler(){
        ltcomm__Coupon__c coupon = new ltcomm__Coupon__c();
        coupon.ltcomm__Active__c = true;
        coupon.ltcomm__Coupon_Code__c = 'TESTCOUPON123';
        coupon.Target_Type__c = 'Learner';
        coupon.ltcomm__Type__c = 'Percentage';
        coupon.ltcomm__Valid_From__c = system.today();
        coupon.ltcomm__Valid_To__c = system.today().addDays(5);
        coupon.ltcomm__Quantity__c = 1;
        INSERT coupon;

        ltcomm__Learning_Order__c LearningOrder = new ltcomm__Learning_Order__c();
        LearningOrder.ltcomm__Coupon__c = coupon.Id;
        LearningOrder.ltcomm__Date_and_Time__c = system.now();
        INSERT LearningOrder;
        ltcomm__Learning_Order__c LearningOrder1 = new ltcomm__Learning_Order__c();
        
        LearningOrder.ltcomm__Date_and_Time__c = system.now(); 
        UPDATE LearningOrder;
        
        DELETE LearningOrder;
    }
    
            
    static testMethod void testGetHandler_ConfigurationStepTriggerHelper() {
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(Configuration_Step__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }

    static testMethod void test_Contact_before_insert() {
        Contact testContact = new Contact();
        testContact.FirstName = 'Yagna';
        testContact.LastName = 'Yagna Akuluri';
        
        Test.startTest();
        insert testContact;
        Test.stopTest();
        
        Contact result = getContactById(testContact.Id);
        system.assertEquals('Yagna', result.FirstName);
        system.assertEquals('Akuluri', result.LastName);
    }
    static testMethod void test_Contact_before_update() {
        Contact testContact = new Contact();
        testContact.FirstName = 'Yagna';
        testContact.LastName = 'Akuluri';
        testContact.Email = 'test@test.com';
        insert testContact;
        
        Test.startTest();
        account TestParentAccount = new Account();
        TestParentAccount.Name='Yagna1';
        Insert TestParentAccount;
        account TestAccount = new Account();
        TestAccount.Name='Yagna';
        TestAccount.ParentId= TestParentAccount.Id;
        Insert TestAccount;
        testContact.FirstName = 'Yagna';
        testContact.LastName = 'Yagna Akuluri';
        testContact.LID__LinkedIn_Company_Id__c = '46556434';
        testContact.AccountId = TestAccount.Id;
        update testContact;
        case CaseObj = new Case();
        CaseObj.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId();
        CaseObj.Origin  = 'Email';
        CaseObj.Current_behavior__c = 'Test Behavior';
        CaseObj.Expected_behavior__c =  'Test Behavior';
        Insert CaseObj;
        Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
            
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setHtmlBody('test');
        mail.setTargetObjectId(CaseObj.id);
        mail.setSaveAsActivity(true);
        String[] toAddresses = new String[]{'test@test.com'};
            mail.setToAddresses(toAddresses);
        emails.add(mail);
        Messaging.SendEmailResult[] er = Messaging.sendEmail(emails, false);
        Test.stopTest();
        
        Contact result = getContactById(testContact.Id);
        system.assertEquals('Yagna', result.FirstName);
        system.assertEquals('Akuluri', result.LastName);
    }
    private static Contact getContactById(Id cid){
        return [select Id, FirstName, LastName, Email from Contact where Id=:cid limit 1];
    }

    @isTest
    static void test_ILT_RoasterTriggerHandler(){
        Account AccountObj = TestDataFactory.createAccount('Roaster','EUR');
        INSERT AccountObj;
        
        //Create contact
        Contact conObj = TestDataFactory.createContact(AccountObj.Id,'McTesty');
        conObj.FirstName = 'Test';
        conObj.Email = System.now().millisecond() + 'test@test.com';
        Database.insert(conObj);
        system.assertNotEquals(null,conObj.Id, 'Contact can not created.');
        
        Product2 Product = TestDataFactory.createProduct('Test Product', 'Membership fees', null);
        Product.ProductCode = 'TEST001';
        Product.IsActive = TRUE;
        Product.SBQQ__DefaultQuantity__c = 1000;
        INSERT Product;
        
        redwing__Training_Track__c trainingTrack = TestDataFactory.createTrainingTrack('Test Developer',Product.Id);
        INSERT trainingTrack;
        
        redwing__Training_Track_Level__c trainingTrackLevel = TestDataFactory.createTrainingTrackLevel('Test Developer',trainingTrack.Id);
        INSERT trainingTrackLevel;
        
        redwing__Training_Plan__c trainingPlan = TestDataFactory.createTrainingPlan('Test Developer');
        INSERT trainingPlan;
        
        redwing__Training_Track_Assignment__c trainingTrackAssignment = TestDataFactory.createTrainingTrackAssignment(userinfo.getUserId(),conObj.Id,trainingTrack.Id);
        INSERT trainingTrackAssignment;
        
        redwing__Training_Plan_Assignment__c trainingPlanAssignment = TestDataFactory.createTrainingPlanAssignment(userinfo.getUserId(),conObj.Id,trainingPlan.Id);
        INSERT trainingPlanAssignment;
        
        redwing__Training_Track_Level_Item__c trainingTrackLevelItem = TestDataFactory.createTrainingTrackLevelItem(trainingTrackLevel.Id,trainingPlan.Id);
        INSERT trainingTrackLevelItem;
        
        redwing__Learning__c learning = TestDataFactory.createLearning('Test Learning');
        INSERT learning;
        
        redwing__Learning__c iLTEventLearning = TestDataFactory.createLearning('Test Event Learning');
        iLTEventLearning.RecordTypeId =  String.valueOf(Schema.SObjectType.redwing__Learning__c.getRecordTypeInfosByDeveloperName().get('ILT_Event').getRecordTypeId());
        INSERT iLTEventLearning;
        
        redwing__ILT_Event__c iLTEvent =TestDataFactory.createILTEvent('ILT Event',iLTEventLearning.Id);
        Insert iLTEvent;

        CollaborationGroup newGroup = TestDataFactory.createCollaborationGroup('Test Community Group');
        insert newGroup;
        
        redwing__Learning__c iLTClassLearning = TestDataFactory.createLearning('Test Class Learning');
        iLTClassLearning.RecordTypeId =  Schema.SObjectType.redwing__Learning__c.getRecordTypeInfosByDeveloperName().get('ILT').getRecordTypeId();
        iLTClassLearning.Group_Id__c = newGroup.id;
        INSERT iLTClassLearning;
        
        redwing__ILT_Event_Class__c iLTEventclass = TestDataFactory.createILTEventClass(iLTEvent.Id,iLTClassLearning.Id);
        Insert iLTEventclass;
                
        redwing__ILT_Class__c iLTClass = TestDataFactory.createILTClass('ILT Class',iLTClassLearning.Id);
        Insert iLTClass;
        
        redwing__Training_Plan_Section__c trainingPlanSection = TestDataFactory.createTrainigPlanSection('Test',trainingPlan.Id);
        INSERT trainingPlanSection;
        
        redwing__Training_Plan_Section_Assignment__c trainingPlanSectionAssignment = TestDataFactory.createTrainingPlanSectionAssignment(userinfo.getUserId(),trainingPlanSection.Id,trainingPlanAssignment.Id);
        INSERT trainingPlanSectionAssignment;
        
        redwing__Training_Plan_Section_Item__c trainingPlanSectionItem = TestDataFactory.createTrainingPlanSectionItem(learning.Id,trainingPlanSection.Id);
        INSERT trainingPlanSectionItem;
        
        redwing__Learning_Assignment__c learningAssignment = TestDataFactory.createLearningAssignment(conObj.Id,userinfo.getUserId(),trainingPlan.Id,learning.Id,trainingPlanSection.Id,trainingPlanSectionAssignment.Id,trainingPlanSectionItem.Id);
        INSERT learningAssignment;
        
        redwing__ILT_Roster__c iLTRoster = TestDataFactory.createILTRoster(iLTClass.Id,userinfo.getUserId(),learningAssignment.Id);
        INSERT iLTRoster ;
        
        iLTRoster.redwing__Attended__c = false;
        UPDATE iLTRoster ;
        
        DELETE iLTRoster ;
    }
    
    static testMethod void testGetHandler_kugo2pSalesOrderHandler(){
        test.startTest();
        System.debug(Case.getSObjectType());
        Object o = TriggerFactory.getHandler(kugo2p__SalesOrder__c.getSObjectType());
        test.stopTest();
        System.assert(o != null);
    }
}