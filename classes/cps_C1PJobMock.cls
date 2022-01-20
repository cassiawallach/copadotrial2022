@isTest
public class cps_C1PJobMock implements HttpCalloutMock {
  protected Integer code;
  protected String status;
  protected String body;
  protected Map<String, String> responseHeaders;
  public cps_C1PJobMock(Integer code, String status, String body, Map<String, String> responseHeaders) {
    this.code = code;
    this.status = status;
    this.body = body;
    this.responseHeaders = responseHeaders;
  }

  public HTTPResponse respond(HTTPRequest req) {
      HttpResponse mockResponse = new HttpResponse();
      //mockResponse.setBody('Playground_Job__c:{Status__c=In progress, Action__c=GitSetup, JobId__c=430c0e95-4771-4c66-9b42-d1eb277186b5, Id=a7O1l0000008XfOEAU, CurrencyIsoCode=EUR}');
      
      for (String key : this.responseHeaders.keySet()) {
        mockResponse.setHeader(key, this.responseHeaders.get(key));
      }
      mockResponse.setBody(this.body);
      mockResponse.setStatusCode(this.code);
      mockResponse.setStatus(this.status);
      return mockResponse;
  }
}