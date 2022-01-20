global class ScheduleAssetConvertBatch {
	global void execute(SchedulableContext sc) {
		AssetConvertBatch con = new AssetConvertBatch();
	    Database.executeBatch(con);
	}
}