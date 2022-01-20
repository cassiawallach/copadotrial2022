@isTest
public class TestOpportunitySetController {
    static testMethod void moveOppsToEndOfNextMonth(){
        Account testAccount = TestDataFactory.createAccount('My Account','EUR');        
        insert testAccount ;     
                
        List<Opportunity> opps = new List<Opportunity>();
        
        Opportunity opp1 = TestDataFactory.createOpportunity(testAccount, 'Opp1', 'New Customer');
        opp1.Main_Problems__c = 'Opp Main Problems';
        opp1.closeDate = Date.newInstance(2015, 03, 1);
        insert opp1;
        
        Opportunity opp2 = TestDataFactory.createOpportunity(testAccount, 'Opp2', 'New Customer');
        opp2.Main_Problems__c = 'Opp Main Problems';
        opp2.closeDate = Date.newInstance(2015, 03, 15);
        insert opp2;
        
        Opportunity opp3 = TestDataFactory.createOpportunity(testAccount, 'Opp3', 'New Customer');
        opp3.Main_Problems__c = 'Opp Main Problems';
        opp3.closeDate = Date.newInstance(2015, 03, 31);
        insert opp3;        
        
        opps.add(opp1);
        opps.add(opp2);
        opps.add(opp3);
        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(opps);
        OpportunitySetController ext = new OpportunitySetController(con);
        ext.records = opps;
        
        Test.startTest();
        PageReference pr = ext.moveToNextMonth();
        Test.stopTest();
        List<Opportunity> results = [SELECT Id, CloseDate FROM Opportunity];
        for(Opportunity o : results){
            Date expected = Date.newInstance(2015, 4, 30);
            System.assertEquals(expected, o.CloseDate);
        }
    }
}