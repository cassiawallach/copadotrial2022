@isTest global class cps_GetCopadoAuthLinkWithFrontdoorMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req) {
    HttpResponse resp = new HttpResponse();
    resp.setStatusCode(302);
    resp.setHeader('Location', 'https://login.salesforce.com/');
    resp.setBody('{"exchange_url":"", "authorization_link":"", "frontDoor":"https://trialorgfrontdoor.my.salesforce.com/secur/frontdoor.jsp?sid=accesstoken"}');
    return resp;
  }
}