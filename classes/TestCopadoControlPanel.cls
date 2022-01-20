@isTest
private class TestCopadoControlPanel {

    static testMethod void test1() {
        CopadoControlPanel con = new CopadoControlPanel();
        PageReference p2 = con.runLeadConvertBatch();
        
        Copado_Settings__c settings = Copado_Settings__c.getValues('Default');
        if(settings == null){
        	settings = new Copado_Settings__c(Name='Default', Last_run_transaction_batch__c=DateTime.now().addDays(-1));
        	insert settings;
        }
        else{
        	settings.Last_run_transaction_batch__c = DateTime.now().addDays(-1);
        	update settings;
        }
        system.assertEquals(null, p2);
    }
    
    public static testMethod void Test15_to_18_a() {
        // For the test methods, I've taken three values where I manually calculated the additional 3 chars expected
        String orig1 = '001A0000006Vm9r';
        System.AssertEquals(orig1+'IAC', CopadoControlPanel.sfdc15To18(orig1));
        
        String orig2 = '003A0000005QB3A';
        System.AssertEquals(orig2+'IAW', CopadoControlPanel.sfdc15To18(orig2));
        
        String orig3 = '003A0000008qb1s';
        System.AssertEquals(orig3+'IAA', CopadoControlPanel.sfdc15To18(orig3));
    }
    public static testMethod void Full15_18test(){
        CopadoControlPanel con = new CopadoControlPanel();
        con.string15 = '001A0000006Vm9r';
        con.convert15To18();
        system.assertEquals('001A0000006Vm9rIAC', con.string18);
    }
}