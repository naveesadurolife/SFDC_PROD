global class JobValidateProgramContacts implements Database.Batchable<sObject>, Database.AllowsCallouts{
   global final String programId;
   global Program__c program;
   global JobValidateProgramContacts(String programId){
             this.programId=programId;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
   		
   		program=[Select id,Account__c From Program__c Where Id=:programId];
   		String accountID=program.Account__c;
   		//String programID=program.Id;
   		String query='Select Id,LastName,Email,Employee_ID__c,Birthdate,Last_Validated_For_Program__c,Exist_In_Limeade__c From Contact Where AccountId=:accountID and (Last_Validated_For_Program__c!=:programId OR Exist_In_Limeade__c=false) ';
        return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   	   	program=[Select id,Account__c,Limeade_E_Id__c,Limeade_PSK_ID__c,Limeade_Identifier_Employee_ID__c,
   	   				Limeade_Identifier_DOB__c,Limeade_Identifier_LastName__c,Limeade_Identifier_Email__c From Program__c Where Id=:programId];
      	for(Sobject s : scope)
      	{
      		Contact c=(Contact)s;
      		String error=validateContactInLimeade(c,program);
      		if(String.isBlank(error))
      		{
      			c.Exist_In_Limeade__c=true;
      		}
      		c.Last_Validated_For_Program__c=program.Id;
      	}
      	update scope;
   }
    public static String validateContactInLimeade (Contact con, Program__c prog) {
    	Http h = new Http();
    	String mainIdentifier = '';
    	String errors = '';
    	if (prog.Limeade_Identifier_Employee_ID__c) {
    		mainIdentifier = 'employeeid=' + EncodingUtil.urlEncode(con.Employee_ID__c, 'UTF-8');
    	}else {
    		mainIdentifier = 'email=' + EncodingUtil.urlEncode(con.Email, 'UTF-8');
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

	        System.debug( 'RES: ' + res.getBody()  );
	        
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
	         String employeeid = participant.getAttribute('employeeid', null);
	         if(employeeid==null)
	         {
	         	employeeid = participant.getAttribute('EmployeeID', null);
	         }
        	 String email = participant.getAttribute('email', null);
        	 if(email==null)
        	 {
        	 	email = participant.getAttribute('Email', null);
        	 }
        	 if ( prog.Limeade_Identifier_LastName__c && lname != con.LastName) 
        	 	errors += 'Your supplied last name does not match your lastname in our system.\n';
        	 if (prog.Limeade_Identifier_DOB__c && Date.parse(bday) != con.Birthdate) 
        	 	errors += 'Your supplied date of birth does not match your date of birth in our system.\n';
        	 if (prog.Limeade_Identifier_Employee_ID__c && employeeid != con.Employee_ID__c) 
        	 	errors += 'Your supplied employee id does not match in our system.\n';
        	 if (prog.Limeade_Identifier_Email__c && email != con.Email) 
        	 	errors += 'Your supplied email does not match in our system.\n';           	 	        	 	
 
        }
        catch (Exception e) {
        	System.debug( logginglevel.FINE, 'SOLIANT ERROR: ' + e  );
			errors = 'Your details could not be found in our system.\n'+e.getMessage(); 
        }
        //default case:
        return errors;
    }
   global void finish(Database.BatchableContext BC){

   }
}