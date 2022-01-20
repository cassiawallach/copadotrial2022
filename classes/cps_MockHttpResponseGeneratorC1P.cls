@isTest
public class cps_MockHttpResponseGeneratorC1P implements HttpCalloutMock {
    
    public HttpResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"isSuccess":true}');
        res.setStatusCode(200);

        return res;
        
    }
    
}