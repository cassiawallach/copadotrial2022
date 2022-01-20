public with sharing class CopadoMonitorComponentController {
    static final Integer JWT_SESSION_TIMEOUT = 1800;
    static final String JWT_SESSION_CERTIFICATE = 'copado2022'; // sf cert name in Setup -> "Certificate and Key Management"

    public String getRefreshToken() {
        String subject = '' + UserInfo.getOrganizationId() + '_' + UserInfo.getUserId();
        Auth.JWT jwt = new Auth.JWT();
        jwt.setSub(subject);
        jwt.setValidityLength(JWT_SESSION_TIMEOUT);
        Auth.JWS myJws = new Auth.JWS(jwt, JWT_SESSION_CERTIFICATE);
        return myJws.getCompactSerialization();
    }

    public String getCoralogixToken() {
        return 'e6cc19d1-0a78-1fec-c4bd-759ba9752226'; // TODO: store this somewhere else.
    }
}