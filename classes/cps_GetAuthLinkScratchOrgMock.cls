@isTest global class cps_GetAuthLinkScratchOrgMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req) {
    HttpResponse resp = new HttpResponse();
    resp.setStatusCode(302);
    resp.setHeader('Location', 'https://test.salesforce.com/');
    resp.setBody('{"exchange_url":"", authorization_link:""}');
    return resp;
  }
}