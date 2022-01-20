@isTest
public class TestMultiRequestMock {

    public static testmethod void testCallouts() {
        testHttpCalloutMock request1 = new testHttpCalloutMock(200, 'Complete', '[{"Name": "sForceTest1"}]');
        testHttpCalloutMock request2 = new testHttpCalloutMock(200, 'Complete', '[{"LastName": "Test Last Name"}]');

        Map<String, HttpCalloutMock> calloutMap = new Map<String, HttpCalloutMock>();
        calloutMap.put('http://copado.heroku.com', request1);
        calloutMap.put('http://copado.recurly.com',request2);
		system.assertEquals(2, calloutMap.size());

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(calloutMap);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        multiCalloutTest();
        System.assertEquals('[{"Name": "sForceTest1"}][{"LastName": "Test Last Name"}]',resultTest);
    }
	private static String resultTest;
	static void multiCalloutTest(){
		Http h1 = new Http();
		Httprequest req1 = new Httprequest();
		req1.setEndpoint('http://copado.heroku.com');
		req1.setMethod('GET');
		HttpResponse res1 = h1.send(req1);
		
		Http h2 = new Http();
		Httprequest req2 = new Httprequest();
		req2.setEndpoint('http://copado.recurly.com');
		req2.setMethod('GET');
		HttpResponse res2 = h2.send(req2);
		resultTest = res1.getBody()+res2.getBody();
	}
}