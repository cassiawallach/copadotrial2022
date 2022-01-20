global class ScheduleLeadConvert implements Schedulable {
	global void execute(SchedulableContext sc) {
		LeadConvertBatch lcb = new LeadConvertBatch();
		database.executebatch(lcb,1);
	}
}