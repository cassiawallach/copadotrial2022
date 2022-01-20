@istest
public class CertificationResetScheduleTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		CertificationResetSchedule testsche = new CertificationResetSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}