public class OrderLimeadeValidator {
	public static Boolean userExistsInLimeade(Boolean employeeIdIsIdentifier, String email, String employeeId, String e, String psk){
    
		String mainIdentifier = '';    
    
    	if (e == null) {
            return false;
        }
    	if (employeeId == null  ) { 
    		employeeId = '';
    	}
    	
    	if (employeeIdIsIdentifier == true) {
    		mainIdentifier = 'uid=' + EncodingUtil.urlEncode(employeeId, 'UTF-8');
    	}else {
    		mainIdentifier = 'email=' + EncodingUtil.urlEncode(email, 'UTF-8');
    	}

        Http h = new Http();
        try{

	        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
	        String url = 	Constant.LIMEMADE_API+'User.ashx?' +
				        	'employeeid=' 	+ EncodingUtil.urlEncode(employeeId, 'UTF-8') +
				        	'&email=' 		+ EncodingUtil.urlEncode(email, 'UTF-8') +
				        	'&e='			+ EncodingUtil.urlEncode(e, 'UTF-8') + 
				        	'&psk=' 	 	+ EncodingUtil.urlEncode(psk, 'UTF-8')+
				        	'&response=XML';
	        
	        HttpRequest req = new HttpRequest();
	        HttpResponse res = new HttpResponse();
	        req.setEndpoint(url);
	        req.setMethod('GET');

			if (!Test.isRunningTest()) {
				res = h.send(req);
			}else {
				return true;
				res.setBody('<Document status=\'OK\'>' +
  								'<Participant employeeid=\'41\' birthdate=\'12/3/1976\' lastname=\'Bloggs\' email=\'ray@gmail.com\'/>' +
  							'</Document>');
			}
	         Dom.Document doc = res.getBodyDocument();
	         Dom.XMLNode response = doc.getRootElement();
	         Dom.XMLNode participant = response.getChildElement('Participant', null);
	         String employeeidxml = participant.getAttribute('employeeid', null);
	         if(employeeidxml==null)
	         {
	         	employeeidxml = participant.getAttribute('EmployeeID', null);
	         }
        	 String emailxml = participant.getAttribute('email', null); 
        	 if(emailxml==null)
        	 {
        	 	emailxml= participant.getAttribute('Email', null); 
        	 } 
        	 system.debug('employeeid==============='+employeeid);
        	 system.debug('emailxml==============='+emailxml);
        	 if (employeeIdIsIdentifier && employeeid != employeeIdxml)
        	 { 
        	 	system.debug('ifffffffffff==============='+employeeid);
        	 	return false;
        	 }
        	 else if (email != emailxml)
        	 { 
        	 	system.debug('effffff==============='+employeeid);
        	 	return false;
        	 } 
    	 	 else
    	 	 { 
    	 	 	system.debug('eeeeeeeeee==============='+employeeid);
        	 	return true;
    	 	 }  
	       /* if ( res.getBody() == '0' ) {
	        	//getLimeadeUserId(employeeId);
            	return true;
	        }*/
        }
        catch (Exception excep) {

        }
        //default case:
        return false;
    }	
	/*public static Boolean userExistsInLimeade(Boolean employeeIdIsIdentifier, String email, String employeeId, String e, String psk){
    
		String mainIdentifier = '';    
    
    	if (e == null) {
            return false;
        }
    	if (employeeId == null  ) {
    		employeeId = '';
    	}
    	
    	if (employeeIdIsIdentifier == true) {
    		mainIdentifier = 'employeeid=' + EncodingUtil.urlEncode(employeeId, 'UTF-8');
    	}else {
    		mainIdentifier = 'email=' + EncodingUtil.urlEncode(email, 'UTF-8');
    	}

        Http h = new Http();
        try{

	        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
	        String url = 	Constant.LIMEMADE_API+'CheckAvailability.ashx?' +
				        	'employeeid=' 	+ EncodingUtil.urlEncode(employeeId, 'UTF-8') +
				        	'&email=' 		+ EncodingUtil.urlEncode(email, 'UTF-8') +
				        	'&e='			+ EncodingUtil.urlEncode(e, 'UTF-8') + 
				        	'&psk=' 	 	+ EncodingUtil.urlEncode(psk, 'UTF-8');
	        
	        HttpRequest req = new HttpRequest();
	        HttpResponse res = new HttpResponse();
	        req.setEndpoint(url);
	        req.setMethod('GET');

			if (!Test.isRunningTest()) {
				res = h.send(req);
			}else {
				res.setBody('0');
			}

	        if ( res.getBody() == '0' ) {
	        	//getLimeadeUserId(employeeId);
            	return true;
	        }
        }
        catch (Exception excep) {

        }
        //default case:
        return false;
    }*/
    
    public static String validateLimeadeSecondaryCredentials (Order__c ord, Program__c prog) {
    	 
    	
    	 
    	//String employeeId, String dob, String lastname
    	Http h = new Http();
    	String mainIdentifier = '';
    	String errors = '';
    	
    	
    	
    	if (prog.Limeade_Identifier_Employee_ID__c) {
    		mainIdentifier = 'employeeid=' + EncodingUtil.urlEncode(ord.EmployeeID__c, 'UTF-8');
    	}else {
    		mainIdentifier = 'email=' + EncodingUtil.urlEncode(ord.PatientEmailH__c, 'UTF-8');
    	}
    	
        try{

	        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
	        String url = 	Constant.LIMEMADE_API+'User.ashx?' + mainIdentifier +
				        	'&e='			+ EncodingUtil.urlEncode(prog.Limeade_E_Id__c, 'UTF-8') + 
				        	'&psk=' 	 	+ EncodingUtil.urlEncode(prog.Limeade_PSK_ID__c, 'UTF-8') +
				        	'&response=XML';
	        
	        HttpRequest req = new HttpRequest();
	        HttpResponse res = new HttpResponse();
	        
	        req.setEndpoint(url);
	        req.setMethod('GET');
	        
	        if (!Test.isRunningTest()) {
				res = h.send(req);
			}else {
				res.setBody('<Document status=\'OK\'>' +
  								'<Participant employeeid=\'41\' birthdate=\'12/3/1976\' lastname=\'Bloggs\' email=\'ray@gmail.com\'/>' +
  							'</Document>');
			}

	        System.debug( logginglevel.FINE, 'RES: ' + res.getBody()  );
	        
	         if ( res.getBody() == '0' ) {
            	return '';
	         }
	         
	         Dom.Document doc = res.getBodyDocument();
	         Dom.XMLNode response = doc.getRootElement();
	         Dom.XMLNode participant = response.getChildElement('Participant', null);
	         String lname = participant.getAttribute('lastname', null);
	         if(lname==null)
	         {
	         	lname = participant.getAttribute('LastName', null);
	         }
        	 String bday = participant.getAttribute('birthdate', null);
        	 if(bday==null)
        	 {
        	 	bday = participant.getAttribute('BirthDate', null);
        	 }   

        	 if ( prog.Limeade_Identifier_LastName__c && lname != ord.PatientLastName__c) 
        	 	errors += 'Your supplied last name does not match your lastname in our system.\n';
        	 if (prog.Limeade_Identifier_DOB__c && Date.parse(bday) != ord.PatientDOB__c) 
        	 	errors += 'Your supplied date of birth does not match your date of birth in our system.\n';
 
        }
        catch (Exception e) {
        	System.debug( logginglevel.FINE, 'SOLIANT ERROR: ' + e  );
			errors = 'Your details could not be found in our system.\n';
        }
        //default case:
        return errors;
    }
    
    static testMethod void testLimeadeValidator() {   
		
		Program__c prog = TestDataGenerator.getOneProgram();
		Order__c ord = TestDataGenerator.getOneOrder();

		ord.PatientFirstName__c = 'Joelle';
		ord.PatientLastName__c = 'Bloggs';
		ord.PatientAddressLine1__c = '72 Liardet Street';
		ord.PatientAddressLine2__c = '72 Liardet Street';
		ord.PatientCity__c = 'Wellington';
		ord.PatientState__c = 'Wellington';
		ord.PatientZip__c = '94401';
		ord.PatientPrimaryPhone__c = '6506969310';
		ord.PatientGender__c = 'Male';
		ord.PatientDOB__c = date.newinstance(1976, 12, 3);
		
		OrderLimeadeValidator.userExistsInLimeade(false, ord.PatientEmailH__c, ord.EmployeeID__c,
		prog.Limeade_E_Id__c, prog.Limeade_PSK_ID__c);
		
		OrderLimeadeValidator.userExistsInLimeade(true, ord.PatientEmailH__c, ord.EmployeeID__c,
		prog.Limeade_E_Id__c, prog.Limeade_PSK_ID__c);
		
		OrderLimeadeValidator.validateLimeadeSecondaryCredentials(ord, prog);
		
				
		ord.EmployeeID__c = '41';
		ord.PatientEmailH__c = 'ray@gmail.com';
		prog.Enable__c = true;
		
		OrderLimeadeValidator.userExistsInLimeade(false, ord.PatientEmailH__c, ord.EmployeeID__c,
		prog.Limeade_E_Id__c, prog.Limeade_PSK_ID__c);
		
		OrderLimeadeValidator.userExistsInLimeade(true, ord.PatientEmailH__c, ord.EmployeeID__c,
		prog.Limeade_E_Id__c, prog.Limeade_PSK_ID__c);
		
		OrderLimeadeValidator.validateLimeadeSecondaryCredentials(ord, prog);

		prog.Limeade_Identifier_Employee_ID__c = true;
		OrderLimeadeValidator.validateLimeadeSecondaryCredentials(ord, prog);
		
		
		prog.Limeade_Identifier_LastName__c = true;
		prog.Limeade_Identifier_DOB__c = true;
		ord.PatientLastName__c = 'Bain';
		ord.PatientDOB__c = date.newinstance(1981, 12, 3);
		OrderLimeadeValidator.validateLimeadeSecondaryCredentials(ord, prog);

	}   
    
    
}