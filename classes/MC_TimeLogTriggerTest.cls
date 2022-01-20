/**
 * Created by kheidt on 2019-05-07.
 */

@IsTest
private class MC_TimeLogTriggerTest {

    static User adminUser;
    static User runningUser;
    static List<amc__Time_Log__c> timeLogs;
    static List<Professional_Service_Consumption__c> psConsumptions;
    static Account acct1;
    static Contact cnt;
    static Opportunity oppty1;
    static amc__Project__c mcProject;
    static amc__Role__c role;
    static amc__Milestone__c mcMilestone1;
    static amc__Milestone__c mcMilestone2;
    static amc__Action__c mcAction1;
    static amc__Action__c mcAction2;
    static amc__Time_Log__c timeLog1;
    static amc__Time_Log__c timeLog2;

    static void setup(){
        adminUser = TestDataFactory.setToAdmin(TestDataFactory.createUser());
        insert adminUser;

        System.runAs(adminUser) {
            runningUser = TestDataFactory.setToAdmin(TestDataFactory.createUser());
            runningUser.Alias = 'rrunni';
            runningUser.Username = 'running@user.copadotest';
            insert runningUser;
        }

        System.runAs(runningUser){
            acct1 = TestDataFactory.createAccount('TLTEST', 'EUR');
            insert acct1;

            cnt = TestDataFactory.createContact(acct1.Id, 'TLTest');
            insert cnt;

            oppty1 = TestDataFactory.createOpportunity(acct1, 'TLTST','New Customer');
            oppty1.Amount = 100;
            oppty1.Main_Problems__c = 'some';
            insert oppty1;

            role = TestDataFactory.createMCRole(runningUser);
            insert role;

            mcProject = TestDataFactory.createMCProject(acct1, oppty1, 'TL Test in Unit Test');
            insert mcProject;

            mcMilestone1 = TestDataFactory.createMCMilestone(mcProject,'1',role);
            insert mcMilestone1;

            mcAction1 = TestDataFactory.createMCAction(acct1, mcMilestone1, role,'1');
            insert mcAction1;

            mcMilestone2 = TestDataFactory.createMCMilestone(mcProject,'2',role);
            insert mcMilestone2;

            mcAction2 = TestDataFactory.createMCAction(acct1, mcMilestone2, role,'2');
            insert mcAction2;
        }
    }

    static testMethod void testSingleLog_NotBillable() {
        setup();

        Test.startTest();
        System.runAs(runningUser){
            timeLog1 = TestDataFactory.createMCTimeLog(mcAction1, true,role,2);
            insert timeLog1;
        }
        Test.stopTest();

        List<Professional_Service_Consumption__c> createdConsumptions = [SELECT ID FROM Professional_Service_Consumption__c];
      System.assertEquals(0, createdConsumptions.size());
    }

    static testMethod void testSingleLog_Billable() {
        setup();

        Test.startTest();
        System.runAs(runningUser){
            timeLog1 = TestDataFactory.createMCTimeLog(mcAction1, false, role, 2);
            insert timeLog1;
        }
        Test.stopTest();

        amc__Time_Log__c testLog = [SELECT Id, Name, ProfessionalServiceConsumption__c, amc__Billable_Hours_Completed__c FROM amc__Time_Log__c];
       Professional_Service_Consumption__c testConsumption = [SELECT Id, Meeting_Id__c, Hours_consumed__c FROM Professional_Service_Consumption__c];

       System.assertEquals(testLog.amc__Billable_Hours_Completed__c , testConsumption.Hours_consumed__c);
        System.assertEquals(testLog.Id, testConsumption.Meeting_Id__c);
        System.assertEquals(testConsumption.Id, testLog.ProfessionalServiceConsumption__c);

    }

    static testMethod void testMultipleLogs() {
        setup();

        timeLogs = new List<amc__Time_Log__c>();
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction1, true, role, i);
            timeLogs.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction1, false, role, i);
            timeLogs.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction2, true, role, i);
            timeLogs.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction2, false, role, i);
            timeLogs.add(log);
        }

        Test.startTest();
        System.runAs(runningUser){
            insert timeLogs;
        }
        Test.stopTest();

        Map<Id, amc__Time_Log__c> createdLogs = new Map<Id, amc__Time_Log__c>([
                SELECT Id, Name, ProfessionalServiceConsumption__c, amc__Billable_Hours_Completed__c
                FROM amc__Time_Log__c
                WHERE amc__Non_Billable__c = false
        ]);

        Map<Id,Professional_Service_Consumption__c> createdConsumptions = new Map<Id, Professional_Service_Consumption__c>([
                SELECT Id, Meeting_Id__c, Hours_consumed__c FROM Professional_Service_Consumption__c
        ]);

        System.assertEquals(40, createdConsumptions.size());

        System.assertEquals(createdLogs.values().size(),createdConsumptions.values().size());
        for(Professional_Service_Consumption__c psc : createdConsumptions.values()){
            System.assert(createdLogs.keySet().contains(psc.Meeting_Id__c));
        }

        for(amc__Time_Log__c tl : createdLogs.values()){
            System.assert(createdConsumptions.keySet().contains(tl.ProfessionalServiceConsumption__c));
            System.assertEquals(tl.amc__Billable_Hours_Completed__c, createdConsumptions.get(tl.ProfessionalServiceConsumption__c).Hours_consumed__c);
        }
    }

    static testMethod void testMultipleLogsNewAndUpdate() {
        setup();

        timeLogs = new List<amc__Time_Log__c>();
        List<amc__Time_Log__c> timeLogsToUpdate = new List<amc__Time_Log__c>();

        //create logs for insert
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction1, true, role, i);
            timeLogs.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction1, false, role, i);
            timeLogs.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction2, true, role, i);
            timeLogs.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction2, false, role, i);
            timeLogs.add(log);
        }

        //create logs for update
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction1, true, role, i);
            timeLogsToUpdate.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction1, false, role, i);
            timeLogsToUpdate.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction2, true, role, i);
            timeLogsToUpdate.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction2, false, role, i);
            timeLogsToUpdate.add(log);
        }

        insert timeLogsToUpdate;
        Integer listSize = timeLogsToUpdate.size();

        //update the value
        for(Integer i = 0; i< listSize; i++){
            timeLogsToUpdate[i].amc__Hours_Completed__c = i +10;
        }

        Test.startTest();
        System.runAs(runningUser){
            timeLogsToUpdate.addAll(timeLogs);
            upsert timeLogsToUpdate;

        }
        Test.stopTest();

        Map<Id, amc__Time_Log__c> createdLogs = new Map<Id, amc__Time_Log__c>([
                SELECT Id, Name, ProfessionalServiceConsumption__c, amc__Billable_Hours_Completed__c
                FROM amc__Time_Log__c
                WHERE amc__Non_Billable__c = false
        ]);

        Map<Id,Professional_Service_Consumption__c> createdConsumptions = new Map<Id, Professional_Service_Consumption__c>([
                SELECT Id, Meeting_Id__c, Hours_consumed__c FROM Professional_Service_Consumption__c
        ]);

        System.assertEquals(80, createdConsumptions.size());

        System.assertEquals(createdLogs.values().size(),createdConsumptions.values().size());
        for(Professional_Service_Consumption__c psc : createdConsumptions.values()){
            System.assert(createdLogs.keySet().contains(psc.Meeting_Id__c));
        }

        for(amc__Time_Log__c tl : createdLogs.values()){
            System.assert(createdConsumptions.keySet().contains(tl.ProfessionalServiceConsumption__c));
            System.assertEquals(tl.amc__Billable_Hours_Completed__c, createdConsumptions.get(tl.ProfessionalServiceConsumption__c).Hours_consumed__c);
        }
    }

    static testMethod void testMultipleLogs_SomeWithoutAccounts() {
        setup();
		Test.startTest();
        timeLogs = new List<amc__Time_Log__c>();
        List<amc__Time_Log__c> timeLogsToUpdate = new List<amc__Time_Log__c>();

        //remove account from action. if no account is specified, the logic should not consider it
        mcAction1.Account__c = null;
        update mcAction1;

        //create logs for insert
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction1, true, role, i);
            timeLogs.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction1, false, role, i);
            timeLogs.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction2, true, role, i);
            timeLogs.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction2, false, role, i);
            timeLogs.add(log);
        }

        //create logs for update
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction1, true, role, i);
            timeLogsToUpdate.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction1, false, role, i);
            timeLogsToUpdate.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction2, true, role, i);
            timeLogsToUpdate.add(log);
        }
        for(Integer i=0; i<20;i++ ){
            amc__Time_Log__c log = TestDataFactory.createMCTimeLog(mcAction2, false, role, i);
            timeLogsToUpdate.add(log);
        }

        insert timeLogsToUpdate;
        Integer listSize = timeLogsToUpdate.size();

        //update the value
        for(Integer i = 0; i< listSize; i++){
            timeLogsToUpdate[i].amc__Hours_Completed__c = i +10;
        }

        
        System.runAs(runningUser){
            timeLogsToUpdate.addAll(timeLogs);
            upsert timeLogsToUpdate;

        }
        

        Map<Id, amc__Time_Log__c> createdLogs = new Map<Id, amc__Time_Log__c>([
                SELECT Id, Name, ProfessionalServiceConsumption__c, amc__Billable_Hours_Completed__c
                FROM amc__Time_Log__c
                WHERE amc__Non_Billable__c = false
                AND amc__Action__r.Account__c != null
        ]);

        Map<Id,Professional_Service_Consumption__c> createdConsumptions = new Map<Id, Professional_Service_Consumption__c>([
                SELECT Id, Meeting_Id__c, Hours_consumed__c FROM Professional_Service_Consumption__c
        ]);
		Test.stopTest();
        System.assertEquals(40, createdConsumptions.size());

        for(Professional_Service_Consumption__c psc : createdConsumptions.values()){
            System.assert(createdLogs.keySet().contains(psc.Meeting_Id__c));
        }

        for(amc__Time_Log__c tl : createdLogs.values()){
            System.debug(LoggingLevel.INFO, 'key set: ' + createdConsumptions.keySet());
            System.debug(LoggingLevel.INFO, 'current Id: ' + tl.ProfessionalServiceConsumption__c);
            System.assert(createdConsumptions.keySet().contains(tl.ProfessionalServiceConsumption__c));
            System.assertEquals(tl.amc__Billable_Hours_Completed__c, createdConsumptions.get(tl.ProfessionalServiceConsumption__c).Hours_consumed__c);
        }
    }

    public static testmethod void testLogDeletion(){
        setup();
		Test.startTest();
        timeLog1 = TestDataFactory.createMCTimeLog(mcAction1, false, role,2);
        insert timeLog1;

        timeLog2 = TestDataFactory.createMCTimeLog(mcAction2, true, role, 3);
        insert timeLog2;

        List<Professional_Service_Consumption__c> createdConsumptions = [SELECT ID FROM Professional_Service_Consumption__c];
        System.assertEquals(1, createdConsumptions.size());

        
        System.runAs(runningUser){
            delete timeLog1;
            delete timeLog2;
        }
        
        createdConsumptions = [SELECT ID FROM Professional_Service_Consumption__c];
        Test.stopTest();
        System.assertEquals(0, createdConsumptions.size());

    }
}