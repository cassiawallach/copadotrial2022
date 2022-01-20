public class MultiRequestMock implements HttpCalloutMock {
	Map<String, HttpCalloutMock> requests;

	public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
		this.requests = requests;
	}
	public HTTPResponse respond(HTTPRequest req) {
		
		boolean contains = requests.containsKey(req.getEndpoint());
		if (contains == true) {
			HttpCalloutMock mock = requests.get(req.getEndpoint());
			return mock.respond(req);
		} else {
			List<HttpCalloutMock> mocks = requests.values();
			if(mocks.size() > 0){
				return mocks[0].respond(req);
			}
			else {
				return null;
			}
		}
	}
}