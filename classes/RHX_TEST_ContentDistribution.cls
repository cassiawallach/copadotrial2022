@isTest(SeeAllData=true)
public class RHX_TEST_ContentDistribution {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM ContentDistribution LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new ContentDistribution()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}