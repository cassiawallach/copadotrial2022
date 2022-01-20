@isTest 
public class slack_tst_Value_Stream_Map {
    @isTest 
     static void testTrigger() {
     copadovsm__Value_Stream_Map__c obj0 = new copadovsm__Value_Stream_Map__c(
                copadovsm__Object__c = 'Account',
                copadovsm__Primary_Field__c = 'Type',
                copadovsm__Record_Types__c = 'master',
                Name = 'Rolled CA Test Scenario',
                copadovsm__Active__c = false,
                copadovsm__Operator_Field__c = 'OwnerId');
     
     insert obj0;
    }
}