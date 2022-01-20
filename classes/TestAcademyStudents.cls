@isTest
private class TestAcademyStudents {

	@isTest 
	private static void testAcademyStudentUnknownRequestError() {
		Academy_API_Settings__c AAS = new Academy_API_Settings__c();
    	AAS.trusted_IP_Address__c = 'AC16DFF0C26F327074C5079287876515B25FD91D3AD3D1E4C434341296B6CA40';
    	AAS.Name='ValidNode';
    	insert (AAS);
     	RestRequest re = new RestRequest();
     	RestResponse rp = new RestResponse();
     	re.requestURI = '/services/apexrest/';
     	re.remoteAddress = '192.168.1.1';
     	re.addHeader('httpMethod', 'GET');
     	re.addHeader('Idtoken', 'AC16DFF0C26F327074C5079287876515B25FD91D3AD3D1E4C434341296B6CA40XXX');
     	re.addParameter('student_Name', 'Federico Mahuel');
     	RestContext.request = re;
     	RestContext.response = rp;
        Test.startTest();
     	AcademyStudents.show();
     	System.assertEquals(rp.responseBody,Blob.valueOf('{"errorMessage":"Forbidden"}'));
        Test.stopTest();
	}
    
    @isTest 
	private static void testAcademyStudentUnknownRequest() {
		Academy_API_Settings__c AAS = new Academy_API_Settings__c();
    	AAS.trusted_IP_Address__c = 'AC16DFF0C26F327074C5079287876515B25FD91D3AD3D1E4C434341296B6CA40';
    	AAS.Name='ValidNode';
    	insert (AAS);
     	RestRequest re = new RestRequest();
     	RestResponse rp = new RestResponse();
     	re.requestURI = '/services/apexrest/';
     	re.remoteAddress = '192.168.1.1';
     	re.addHeader('httpMethod', 'GET');
     	re.addHeader('Idtoken', 'AC16DFF0C26F327074C5079287876515B25FD91D3AD3D1E4C434341296B6CA40');
     	re.addParameter('student_Name', 'Federico Mahuel');
     	RestContext.request = re;
     	RestContext.response = rp;
        Test.startTest();
     	AcademyStudents.show();
     	System.assertEquals(rp.responseBody,Blob.valueOf('{"errorMessage":"No student registered for Federico Mahuel"}'));
        Test.stopTest();
	}

	@isTest
    private static void testAcademyStudentKnownRequest() {
        RestResponse rp = new RestResponse();
        Contact c = new Contact(FirstName ='David1', LastName ='Pinett1',Email = 'pinett1@copa.do');
        insert c;
        Test.startTest();
        String b = '<?xml version="1.0" encoding="ISO-8859-1"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:WSUser.CreateUserResponse xmlns:ns1="urn:WSService"><return xsi:type="xsd:int">115</return></ns1:WSUser.CreateUserResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        Test.setMock(HttpCalloutMock.class, new testHttpCalloutMock(200,'Success', b));
        Academy_Certification_Student__c cs = new Academy_Certification_Student__c();
        cs.Student_Id__c = 'user1@demo.com';
        cs.Contact__c = c.Id;
        //cs.Chamilo_id__c = '12';
        insert cs;
        Academy_Certification_Program__c acp = new Academy_Certification_Program__c(Name = 'Student', Copado_Version__c = 'V10', Status__c = 'Valid');
	    insert acp;
        Academy_Certification__c ac = new Academy_Certification__c(Certification_Student__c=cs.id, Certification_Program__c =acp.id, Status__c='Valid');
        insert ac;
	    Academy_Certification_Examination__c  ace = new Academy_Certification_Examination__c (Certification_Program__c=acp.Id, Certification_Student__c=cs.id,Status__c = 'Approved',Date__c = datetime.newInstance(2018, 9, 15, 12, 30, 0), Academy_Certification2__c = ac.Id);
	    insert ace;

        Academy_API_Settings__c AAS = new Academy_API_Settings__c();
        AAS.trusted_IP_Address__c = 'AC16DFF0C26F327074C5079287876515B25FD91D3AD3D1E4C434341296B6CA40';
        AAS.Name='ValidNode';
        insert (AAS);
        RestRequest re = new RestRequest();
        re.requestURI = '/services/apexrest/';
        re.addHeader('httpMethod', 'GET');
        re.addHeader('Idtoken', 'AC16DFF0C26F327074C5079287876515B25FD91D3AD3D1E4C434341296B6CA40');
        re.addParameter('student_Name', 'David Pinett');
        RestContext.request = re;
        RestContext.response = rp;
        AcademyStudents.show();
        Test.stopTest();
	}

}