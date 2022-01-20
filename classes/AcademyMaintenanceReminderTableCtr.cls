public without sharing class AcademyMaintenanceReminderTableCtr {

    public String contactIdApex { get; set; }

    public AcademyMaintenanceReminderTableCtr() {

    }

    public List<AcademyCertificationMaintenanceStatus> getContactCertifications() {
        List<AcademyCertificationMaintenanceStatus> certificationMaintenanceStatuses = new List<AcademyCertificationMaintenanceStatus>();

        List<Academy_Certification__c> certifications = [
                SELECT Id, Name, Certification_Program__r.Name, Expiration_Date__c, Status__c, Certification_Examination__r.Learning__r.Name, Earned_Date__c
                FROM Academy_Certification__c
                WHERE Certification_Student__r.Contact__c = :contactIdApex
        ];

        if(certifications == null || certifications.isEmpty()) {
            return certificationMaintenanceStatuses;
        }

        Map<Id, redwing__Training_Plan__c> activeMaintenancePlans = new Map<Id, redwing__Training_Plan__c>([
                SELECT Id, Name, redwing__Start_Date__c, Schedule_Days_for_Reminder__c, Maintenance_Expiration_Date__c, redwing__End_Date__c
                FROM redwing__Training_Plan__c
                WHERE Is_Maintenance_Plan__c = TRUE
                AND redwing__Start_Date__c < :Date.today()
                AND Maintenance_Expiration_Date__c >= :Date.today()
        ]);
        System.debug('Total active maintenance: ' + activeMaintenancePlans.keySet().size());

        List<redwing__Learning_Assignment__c> completedAssignments = [
                SELECT Id, redwing__Contact__c, redwing__Training_Plan__c
                FROM redwing__Learning_Assignment__c
                WHERE redwing__Training_Plan__c IN :activeMaintenancePlans.keySet()
                AND redwing__Progress__c = 'Completed'
                AND redwing__Contact__c = :contactIdApex
        ];

        System.debug('Total completed maintenance: ' + completedAssignments.size());

        Set<String> completedPrograms = new Set<String>();
        for(redwing__Learning_Assignment__c tps : completedAssignments){
            completedPrograms.add(tps.redwing__Training_Plan__c);
        }


        List<redwing__Training_Plan_Section_Item__c> sectionItems = [SELECT Id, redwing__Learning__r.Academy_Certification_Program__c,
                redwing__Training_Plan_Section__r.redwing__Training_Plan__c
        FROM redwing__Training_Plan_Section_Item__c
        WHERE redwing__Training_Plan_Section__r.redwing__Training_Plan__c IN :activeMaintenancePlans.keySet()
        AND redwing__Learning__r.Academy_Certification_Program__c != NULL];
        System.debug('Total sectionItems maintenance: ' + sectionItems.size());

        /*if(sectionItems.isEmpty()) {
            return certificationMaintenanceStatuses;
        }*/

        Map<String, String> activePrograms = new Map<String, String> ();
        for(redwing__Training_Plan_Section_Item__c tps : sectionItems){
            activePrograms.put(tps.redwing__Learning__r.Academy_Certification_Program__c, tps.redwing__Training_Plan_Section__r.redwing__Training_Plan__c);
        }

        for(Academy_Certification__c ac : certifications) {
            if(activePrograms.containsKey(ac.Certification_Program__c)){
                if(completedPrograms.contains(activePrograms.get(ac.Certification_Program__c))){
                    AcademyCertificationMaintenanceStatus acms = new AcademyCertificationMaintenanceStatus(ac.Certification_Program__r.Name, 'Maintenance completed', 'No Action Needed', ac.Expiration_Date__c);
                    certificationMaintenanceStatuses.add(acms);
                } else {
                    AcademyCertificationMaintenanceStatus acms = new AcademyCertificationMaintenanceStatus(ac.Certification_Program__r.Name, 'Maintenance not completed', 'Complete maintenance exam', ac.Expiration_Date__c);
                    certificationMaintenanceStatuses.add(acms);
                }
            } else {
                AcademyCertificationMaintenanceStatus acms = new AcademyCertificationMaintenanceStatus(ac.Certification_Program__r.Name, 'Maintenance not needed', 'No Action Needed', ac.Expiration_Date__c);
                certificationMaintenanceStatuses.add(acms);
            }

        }

        return certificationMaintenanceStatuses;

    }

    public class AcademyCertificationMaintenanceStatus {
        public String credentialName { get; set; }
        public String credentialStatus { get; set; }
        public String actionsToTake { get; set; }
        public Date expirationDate { get; set; }

        public AcademyCertificationMaintenanceStatus(String credentialName, String credentialStatus, String actionsToTake, Date expirationDate) {
            this.credentialName = credentialName;
            this.credentialStatus = credentialStatus;
            this.actionsToTake = actionsToTake;
            this.expirationDate = expirationDate;
        }
    }

}