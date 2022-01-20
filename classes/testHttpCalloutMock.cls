@isTest
public class testHttpCalloutMock implements HttpCalloutMock{
	protected  Integer code; 
	protected  String status; 
	protected  String body;
	
	public testHttpCalloutMock(Integer c, String s, String b){
		this.code=c;
		this.status=s;
		this.body=b;
	}
    public HttpResponse respond(HTTPRequest req){
    	HttpResponse res = new HttpResponse();
    	res.setStatus(status);
    	res.setStatusCode(code);
    	res.setBody(body);
    	return res;
    }
}