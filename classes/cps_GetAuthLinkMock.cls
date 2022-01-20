@isTest global class cps_GetAuthLinkMock implements HttpCalloutMock{
    global HttpResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(302);
        resp.setHeader('Location', 'https://mockresponse.com/test');
        resp.setBody('{"exchange_url":"", authorization_link:""}');
        return resp;
    }
}