/**
 * Created by kheidt on 2019-05-06.
 */

public with sharing class MC_TimeLogHelper {


    public Map<Id, amc__Time_Log__c> timeLogMap                            = new Map<Id, amc__Time_Log__c>();
    public Map<Id, Professional_Service_Consumption__c> psConsumptionMap   = new Map<Id, Professional_Service_Consumption__c>();
    public List<amc__Time_Log__c> timeLogs = new List<amc__Time_Log__c>();
    public List<Professional_Service_Consumption__c> psConsumptions = new List<Professional_Service_Consumption__c>();

    public void convertTimeLogsToConsumption(Map<Id, amc__Time_Log__c> logMap){
        //set main class variables
        timeLogMap = setTimeLogMap(logMap);
        System.debug('set the time log map: ' + timeLogMap);

        Set<Id> pscIds = new Set<Id>();
        for(amc__Time_Log__c tl : timeLogMap.values()){
            if(tl.ProfessionalServiceConsumption__c != null){
                pscIds.add(tl.ProfessionalServiceConsumption__c);
            }
        }

        psConsumptionMap = this.getPSConsumptionMap(pscIds);
        System.debug('set the consumption map: ' + psConsumptionMap);

        //run logic
        this.linkLogsAndConsumption();
    }

    public Map<Id, Professional_Service_Consumption__c> getPSConsumptionMap(Set<Id> psIds){
        Map<Id, Professional_Service_Consumption__c> psMap = new Map<Id, Professional_Service_Consumption__c>(
        [
                SELECT Id, Name, Hours_consumed__c, Account__c
                FROM Professional_Service_Consumption__c
                WHERE Id IN :psIds
        ]
        );

        this.psConsumptionMap = psMap;
        return psMap;
    }

    public Map<Id, amc__Time_Log__c> setTimeLogMap( Map<Id, amc__Time_Log__c> tlMap){

        this.timeLogMap = this.getTimeLogMap(tlMap.keySet());
        return timeLogMap;
    }

    //link time logs and maps

    public void linkLogsAndConsumption(){

        System.debug('starting the for loop');

        for(Id i:timeLogMap.keySet()){
            amc__Time_Log__c tl = timeLogMap.get(i);
            Professional_Service_Consumption__c thisPS;

            //only consider billable items:
            if(!tl.amc__Non_Billable__c) {

                System.debug('This log is billable: ' + tl);

                //for each time log, get the consumption record
                if (tl.ProfessionalServiceConsumption__c != null || tl.ProfessionalServiceConsumption__c == '') {

                    //if the log already has a consumption, we will just get it from the map.
                    thisPS = psConsumptionMap.get(tl.ProfessionalServiceConsumption__c);
                }
                //for time logs without consumption, we need to create the consumption record
                else {

                    //create empty parent relationship record, required according to apex logic
                    Professional_Service_Consumption__c relation = new Professional_Service_Consumption__c(
                            Meeting_Id__c = tl.Id
                    );

                    tl.ProfessionalServiceConsumption__r = relation;

                    //create the real record we want to store in the database
                    thisPS = this.createPSConsumption(tl);

                    //we need to update the child records with the new reference
                    timeLogs.add(tl);
                }

                //set the hours on the consumption. works for new logs and if you change hours later on
                thisPS = this.updatePSConsumption(tl, thisPS);

                psConsumptions.add(thisPS);

            } else{
                System.debug(System.LoggingLevel.INFO , 'the following log is not billable: ' + tl);
            }
        }

        //perform DML
        upsert psConsumptions;
        upsert timeLogs;
    }

    public void deleteRelatedConsumption(amc__Time_Log__c log){

        Professional_Service_Consumption__c delPsc;

        //get related consumption
        if(log.ProfessionalServiceConsumption__c != null) {

            delPsc = getPSConsumption(log.ProfessionalServiceConsumption__c);

            System.debug('The following consumption will be deleted: ' + delPsc);
            delete delPsc;
        } else{
            System.debug('The log which was deleted has no Consumption related to it');
        }
    }

    //get time logs
    public Professional_Service_Consumption__c getPSConsumption(String psID){

        Professional_Service_Consumption__c ps = [
                SELECT Id, Name, Hours_consumed__c, Account__c
                FROM Professional_Service_Consumption__c
                WHERE Id = :psID
        ];

        return ps;
    }

    public Professional_Service_Consumption__c createPSConsumption(amc__Time_Log__c timeLog){

        Professional_Service_Consumption__c ps = new Professional_Service_Consumption__c();



        ps.Account__c = timeLog.amc__Action__r.Account__c;
        ps.Meeting_Id__c = timeLog.Id;
        ps.Meeting_Date__c = Date.today();
        ps.Meeting_Notes__c = 'Auto created with the time log';
        ps.Meeting_Date__c = timeLog.amc__Date__c;

        return ps;
    }

    public Professional_Service_Consumption__c updatePSConsumption(
            amc__Time_Log__c timeLog,
            Professional_Service_Consumption__c ps
    ){

        ps.Hours_consumed__c = timeLog.amc__Billable_Hours_Completed__c;

        return ps;
    }

    public Map<Id, amc__Time_Log__c> getTimeLogMap(Set<Id> logIds){
        Map<Id, amc__Time_Log__c> newMap = new Map<Id, amc__Time_Log__c>(
        [
                SELECT
                        Id,
                        Name,
                        ProfessionalServiceConsumption__c,
                        amc__Non_Billable__c,
                        amc__Hours_Completed__c,
                        amc__Billable_Hours_Completed__c,
                        amc__Action__r.Account__c,
                        amc__Action__r.amc__Milestone__r.amc__Project__r.Name,
                        ProfessionalServiceConsumption__r.Meeting_Id__c,
                        amc__Date__c
                FROM amc__Time_Log__c
                WHERE Id IN :logIds
                AND amc__Action__r.Account__c != null
        ]);
        return newMap;
    }
}