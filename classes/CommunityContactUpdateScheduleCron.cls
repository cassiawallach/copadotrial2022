public class CommunityContactUpdateScheduleCron {
    public CommunityContactUpdateScheduleCron(){
        CommunityContactUpdateSchedulerClass ctrl = new CommunityContactUpdateSchedulerClass ();
        string strSeconds = '0';
        string strMinutes = '30';
        string strHours = '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23';
        string strDay_of_month = '*';
        string strMonth = '*';
        string strDay_of_week = '?';
        String sch = strSeconds + ' ' + strMinutes + ' ' + strHours + ' ' + strDay_of_month + ' ' + strMonth + ' ' + strDay_of_week;
        String SchedullerName = 'Community user contact update';
        system.schedule(SchedullerName, sch, ctrl);
    }
}