@IsTest
public class CustomStringSearchLookupControllerTest {
	@IsTest
	public static void testGetImpactedAreas() {
		CommunityWrapper.ResponseWrap response = CustomStringSearchLookupController.getImpactedAreas('test','copadoSupport','Case_Impacted_Areas__mdt');
		List <CommunityWrapper.CustomSobject> returnList = (List <CommunityWrapper.CustomSobject>) response.result;
		System.assertEquals(TRUE, returnList.size() > 0);
	}
}