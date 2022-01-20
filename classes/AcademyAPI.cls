/**
 * Created by gaviriajesus on 16/05/2018.
   Class Used to create external integration for Academy
 */
public with sharing class AcademyAPI {

    private static final string ACADEMY_SOAP_URL = 'https://academy.copa.do/main/webservices/soap.php';
    private static final string ACADEMY_SOAP_TESTIP = 'https://academy.copa.do/main/webservices/testip.php';

    public static Set<Id> createdUsers = new Set<Id>();


    private static String ip = '';
    public static String getIp(){
        system.debug('[AcademyAPI.getIp]');
        if(ip == ''){ip = calcIp();}
        return ip;
    }

    private static String calcIp(){
        system.debug('[AcademyAPI.calcIp]');
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ACADEMY_SOAP_TESTIP);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        system.debug(res.getBody());
        return String.valueOf(res.getBody());
    }

    @future (callout=true)
    public static void sendSOAPrequest(String parts, String name, String namespace, String prefix, String sId){
        system.debug('[AcademyAPI.sendSOAPrequest]');
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ACADEMY_SOAP_URL);
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('SOAPAction', ACADEMY_SOAP_URL+'/'+prefix+'.'+name);
        req.setMethod('POST');
        List<AcademyAPI.Part> ps = (List<AcademyAPI.Part>)JSON.deserialize(parts, List<AcademyAPI.Part>.class);
        Dom.Document doc = genAcademyEnvelope(ps, name, namespace, prefix);
        req.setBodyDocument(doc);
        HttpResponse res = h.send(req);
        String resString = String.valueOf(res.getBody());
        system.debug('[AcademyAPI.sendSOAPrequest]resString '+resString);
        String academyId = pareSOAPresponse(resString);
        if(String.isNotBlank(academyId) && String.isNotBlank(sId)){
            updateStudent(ps,academyId,sId);
        }
    }

    public static void updateStudent(List<AcademyAPI.Part> ps, String academyId, String sId){
        system.debug('[AcademyAPI]updateStudentChamiloId');
        Academy_Certification_Student__c student = new Academy_Certification_Student__c();
        student.Id = sId;
        student.Chamilo_Id__c = academyId;
        createdUsers.add(sId);
        update student;

        //update Student with the retrieved Id and Send Email with generated password
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {ps[3].Val};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('academy@copa.do');
        List<OrgWideEmailAddress> owea = [SELECT Id from OrgWideEmailAddress where Address = 'academy@copa.do' Limit 1];
        if(owea.size()>0){
            mail.setOrgWideEmailAddressId(owea[0].Id);
        }
        EmailTemplate registrationET = [Select Id, HtmlValue, Subject From EmailTemplate where DeveloperName = 'Academy_Registration'];
        mail.setSubject(registrationET.Subject);
        String formattedBody = String.format(registrationET.HtmlValue, new List<String>{ps[0].val+' '+ps[1].val,ps[3].val,ps[4].val});
        mail.setHtmlBody(formattedBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }


    public static String pareSOAPresponse(String res){
        Xmlstreamreader reader = new Xmlstreamreader(res);
        while(reader.hasNext()) {
            if (reader.getEventType() == xmlTag.START_ELEMENT) {
                system.debug(reader.getLocalName());
                if ('return' == reader.getLocalName()) {
                    reader.next();
                    if(reader.hasText()){
                        return reader.getText();
                    }
                }else if('faultstring' == reader.getLocalName()){
                    reader.next();
                    if(reader.hasText()){
                        throw new AcademyAPI.AcademyAPIException(reader.getText());
                    }
                }
            }
            reader.next();
        }
        return '';
    }


    public static DOM.Document genAcademyEnvelope(List<Part> parts, String name, String namespace, String prefix){

        DOM.Document doc = new DOM.Document();
        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String soapEncode = 'http://schemas.xmlsoap.org/soap/encoding/';
        String xsd = 'http://www.w3.org/2001/XMLSchema';
        String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
        dom.XmlNode envelope = doc.createRootElement('Envelope', soapNS, 'SOAP-ENV');
        envelope.setNamespace('xsd', xsd);
        envelope.setNamespace('xsi', xsi);
        envelope.setNamespace('SOAP-ENC', soapEncode);
        envelope.setAttributeNS('encodingStyle', soapEncode, soapNS, null);
        dom.XmlNode body = envelope.addChildElement('Body', soapNS, 'SOAP-ENV');
        dom.XmlNode envelopeInput = body.addChildElement(name, namespace, prefix);
        addInputBody(parts, envelopeInput);
        return doc;
    }

    public static List<Part> getPartsForUser(Academy_Certification_Student__c student, Contact c){
        List<Part> parts = new List<Part>();
        parts.add(new Part('firstname', c.FirstName));
        parts.add(new Part('lastname', c.LastName));
        parts.add(new Part('status', '5'));
        parts.add(new Part('loginname', String.isNotBlank(student.Student_Email__c) ? student.Student_Email__c : c.Email ));
        parts.add(new Part('password', genPass()));
        parts.add(new Part('encrypt_method', ''));
        parts.add(new Part('user_id_field_name', ''));
        parts.add(new Part('user_id_value', ''));
        parts.add(new Part('visibility', student.Active__c ? '1' : '0'));
        parts.add(new Part('email', String.isNotBlank(student.Student_Email__c) ? student.Student_Email__c : c.Email ));
        parts.add(new Part('language', 'english'));
        parts.add(new Part('phone', c.Phone));
        parts.add(new Part('expiration_date', '2028-01-01'));
        parts.add(new Part('extras', ''));
        return parts;
    }

    public static List<Part> getPartsForEditUser(Academy_Certification_Student__c student, Contact c){
        List<Part> parts = new List<Part>();
        parts.add(new Part('user_id_field_name', 'chamilo_user_id'));
        parts.add(new Part('user_id_value', student.Chamilo_Id__c));
        parts.add(new Part('firstname', c.FirstName));
        parts.add(new Part('lastname', c.LastName));
        parts.add(new Part('status', '5'));
        parts.add(new Part('loginname', String.isNotBlank(student.Student_Email__c) ? student.Student_Email__c : c.Email ));
        parts.add(new Part('password', ''));
        parts.add(new Part('encrypt_method', ''));
        parts.add(new Part('email', String.isNotBlank(student.Student_Email__c) ? student.Student_Email__c : c.Email ));
        parts.add(new Part('language', 'english'));
        parts.add(new Part('phone', c.Phone));
        parts.add(new Part('expiration_date', '2028-01-01'));
        parts.add(new Part('extras', ''));
        return parts;
    }


    public static List<Part> getPartsForVisibilityUser(String chamiloId){
        List<Part> parts = new List<Part>();
        parts.add(new Part('user_id_field_name', 'chamilo_user_id'));
        parts.add(new Part('user_id_value', chamiloId));
        return parts;
    }

    public static List<Part> getPartsForSubscribeUserToCourse(String studentChamiloId, String courseChamiloId ){
        List<Part> parts = new List<Part>();
        parts.add(new Part('course_id_field_name', 'chamilo_course_id'));
        parts.add(new Part('course_id_value', courseChamiloId));
        parts.add(new Part('user_id_field_name', 'chamilo_user_id'));
        parts.add(new Part('user_id_value', studentChamiloId));
        parts.add(new Part('status', '5'));
        return parts;
    }


    private static void addInputBody(List<Part> parts, dom.XmlNode envelopeInput){
        envelopeInput.addChildElement('secret_key', '', '').addTextNode(getSecretKey());
        for(Part p: parts){
            envelopeInput.addChildElement(p.key, '', '').addTextNode(p.val);
        }
    }

    public static String getSecretKey(){
        return EncodingUtil.convertToHex(Crypto.generateDigest('SHA1',Blob.valueOf(getIp()+Copado_Hierarchy_Settings__c.getOrgDefaults().Academy_Config_Key__c)));
    }

    public Static string genPass(){
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,10);
    }

    public class Part{
        String key;
        String val;

        public Part (String k, String v){
            This.key = k;
            This.val = (String.isNotBlank(v) ? v : '');
        }

    }

    public class AcademyAPIException extends Exception {}

}