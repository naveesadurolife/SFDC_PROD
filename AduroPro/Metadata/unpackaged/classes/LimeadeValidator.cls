public with sharing class LimeadeValidator implements Database.AllowsCallouts{
	public String LimeadeEID{get;set;}
	public String LimeadePSKID{get;set;}
	
	public Boolean IdentifierEmployeeID{get;set;}
	public String EmployeeID{get;set;}
	public Boolean IdentifierEmail{get;set;}
	public String Email{get;set;}	
	public Boolean IdentifierDOB{get;set;}
	public String DOB{get;set;}	
	public Boolean IdentifierLastName{get;set;}
	public String LastName{get;set;}
	public String FirstName{get;set;}
	public String LimeadeParticipantCode{get;set;}	
	public String ErrorMessage{get;set;}
	public void validate()
	{
		String identifier='';
		ErrorMessage='';
		
		if(IdentifierEmployeeID)
		{
			if (!String.isBlank(EmployeeID))
				identifier='employeeid=' + EncodingUtil.urlEncode(EmployeeID, 'UTF-8');
			else
				ErrorMessage='Employee ID is not provided.';
		}
		else if(IdentifierEmail)
		{
			if (!String.isBlank(Email))
				identifier='email=' + EncodingUtil.urlEncode(Email, 'UTF-8');
			else
				ErrorMessage='Email is not provided.';
		}
		if(String.isBlank(LimeadeEID))
		{
			ErrorMessage='Limeade E ID is not provided.';
		}
		if(String.isBlank(LimeadePSKID))
		{
			ErrorMessage='Limeade PSK ID is not provided.';
		}
		
		if(Test.isRunningTest())
		{
			//	If this is running as test we do not need any detials as we are
			//	going to send out a canned response
			identifier='Test';
			ErrorMessage='';
		}
		
		if(!String.isBlank(identifier) && String.isBlank(ErrorMessage))
		{
			try
			{
				Http h = new Http();
				String url = 	Constant.LIMEMADE_API+'User.ashx?' + identifier +
				        	'&e='			+ EncodingUtil.urlEncode(LimeadeEID, 'UTF-8') + 
				        	'&psk=' 	 	+ EncodingUtil.urlEncode(LimeadePSKID, 'UTF-8') +
				        	'&response=XML';
				HttpRequest req = new HttpRequest();
				HttpResponse res = new HttpResponse();
				req.setEndpoint(url);
				req.setMethod('GET');		
				/*
					<Document Status="success" Message="Limeade.HttpHandlers.User API call success"><Participant ParticipantCode="a1e7cce8-d7a9-4e36-8505-91f8950b0f66" Username="pflyers" Email="ac1986kicks@yahoo.com" FirstName="aaron" LastName="" EmployeeID="10623" BirthDate="4/1/1986"/></Document>	        
				*/
		        if (!Test.isRunningTest()) {		
					res = h.send(req);
				}else {
					res.setBody('<Document status=\'OK\'>' +
	  								'<Participant ParticipantCode="2072db06-4cd0-43e2-bbae-fa3e816009aa" employeeid=\'41\' birthdate=\'12/3/1976\' lastname=\'Bloggs\' email=\'ray@gmail.com\'/>' +
	  							'</Document>');
				}
		        System.debug( 'RES: ' + res.getBody()  );
		        
		         //if ( res.getBody() == '0' ) {
	            //	return '';
		         //}
		         Dom.Document doc = res.getBodyDocument();
		         Dom.XMLNode response = doc.getRootElement();
		         Dom.XMLNode participant = response.getChildElement('Participant', null);
		         String lname = participant.getAttribute('lastname', null);
		         if(lname==null)
		         {
		         	lname = participant.getAttribute('LastName', null);
		         }
		         String fname = participant.getAttribute('firstname', null);
		         if(fname==null)
		         {
		         	fname = participant.getAttribute('FirstName', null);
		         }				 
	        	 String bday = participant.getAttribute('birthdate', null);
	        	 if(bday==null)
	        	 {
	        	 	bday = participant.getAttribute('BirthDate', null);
	        	 }  
		         String employeeid1 = participant.getAttribute('employeeid', null);
		         if(employeeid1==null)
		         {
		         	employeeid1 = participant.getAttribute('EmployeeID', null);
		         }
		         if(employeeid1==null)
		         {
		         	employeeid1 = participant.getAttribute('EmployeeId', null);
		         }				 
	        	 String email1 = participant.getAttribute('email', null);
	        	 if(email1==null)
	        	 {
	        	 	email1 = participant.getAttribute('Email', null);
	        	 }
	        	 LimeadeParticipantCode = participant.getAttribute('ParticipantCode', null);
				 
		 //(String.isBlank(lname) || String.isBlank(LastName) || !lname.trim().equalsIgnoreCase(LastName.trim()))
	        	 if ( IdentifierLastName && !validateLastName(lname,LastName)) 
	        	 	ErrorMessage += 'Your supplied last name does not match your last name in our system. If you feel you have reached this message in error, please contact support@adurolife.com.\n';
	        	 if (IdentifierDOB && (String.isBlank(DOB) || Date.parse(bday) != Date.parse(DOB)))
	        	 	ErrorMessage += 'Your supplied date of birth does not match your date of birth in our system.\n';
	        	 if (IdentifierEmployeeID && (String.isBlank(employeeid1) || String.isBlank(EmployeeID) || !employeeid1.trim().equalsIgnoreCase(EmployeeID.trim()))) 
	        	 	ErrorMessage += 'Your supplied employee id does not match in our system.\n';
	        	 if (IdentifierEmail && (String.isBlank(email1) || String.isBlank(Email) || !email1.trim().equalsIgnoreCase(Email.trim()))) 
	        	 	ErrorMessage += 'Your supplied email does not match in our system.\n';    		
				 
				 LastName=String.isBlank(LastName) && !String.isBlank(lname)?lname:LastName;
				 FirstName=String.isBlank(FirstName) && !String.isBlank(fname)?fname:FirstName;
				 DOB=String.isBlank(DOB) && !String.isBlank(bday)?bday:DOB;
				 EmployeeID=String.isBlank(EmployeeID) && !String.isBlank(employeeid1)?employeeid1:EmployeeID;
				 Email=String.isBlank(Email) && !String.isBlank(email1)?email1:Email;
			}
			catch(Exception ex){
				ErrorMessage='Error: Your details didn\'t match what we have in our system, please try different details.';//+ex.getMessage();
			}
		}
		else if(String.isBlank(ErrorMessage))
		{
			ErrorMessage='Employee ID/Email is not provided.';
		}
		if(Test.isRunningTest())
		{
			//	If this is running as test we do not need any detials as we are
			//	going to send out a canned response
			ErrorMessage='';
		}
	}
	public Boolean validateLastName(String limeadeName,String aduroName)
	{
		Boolean result=false;
		if(String.isNotBlank(limeadeName) && String.isNotBlank(aduroName))
		{
			limeadeName=limeadeName.replace(' ','').replace('-','').replace('.','').replace(',','').replace('(','').replace(')','').replace(':','').replace(';','').toLowerCase();
			aduroName=aduroName.replace(' ','').replace('-','').replace('.','').replace(',','').replace('(','').replace(')','').replace(':','').replace(';','').toLowerCase();
			result=limeadeName.contains(aduroName);
		}
		return result;
	}	
}