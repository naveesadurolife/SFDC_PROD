public  class OnsiteNewOrderController {

    public Order__c newOrder {get; set;} 
    public Program__c program {get; private set;}
    public Account account {get; private set;}
    public Contact sourceContact{get; set;} 
    public Boolean checkLimeade {get; set;}
    public String cardCode {get; set;}
    public List<SelectOption> gender {get; set;} 
    public String selectedGender {get; set;}
    
    
    public String errorMessage {get; private set;}
	public String errorMessageStyle {get; private set;}
    
    private static final String VISIBLE_STYLE = '';
    private static final String INVISIBLE_STYLE = 'display:none;';
    //private static final String META_REFRESH_CONTENT = '5; url=/apex/CheckIn?event=' + ;
    //<meta http-equiv="refresh" content="0; url=http://www.yourdomain.com/index.html">-->
    
    public String metaRefresh {get; private set;}
	public String metaContent {get; private set;}
    
    public String programid {get; private set;}
    public String accountid {get; private set;}
    public String eventid {get; private set;}
    public String cId {get; private set;}
    public String message {get; private set;}
    
    public OnsiteNewOrderController( ){

		checkLimeade = false;
		
        try {
        	programid = ApexPages.currentPage().getParameters().get('program');
        	eventid = ApexPages.currentPage().getParameters().get('event');
        	cId = ApexPages.currentPage().getParameters().get('cId');
        	cardCode = ApexPages.currentPage().getParameters().get('cc');
        	
        }catch (Exception ex) {
        }
   		program = [ SELECT 	p.Id, p.Name, p.Program_End_Date__c, p.Limeade_E_Id__c,
							p.Limeade_Identifier_Employee_ID__c, p.Limeade_Identifier_DOB__c,
							p.Limeade_Identifier_Email__c, p.Limeade_Identifier_LastName__c,
							p.Program_Start_Date__c, p.Enable__c, p.Limeade_PSK_ID__c,
							p.Activity_Device_Note_to_User__c, p.Disable_Limeade_SFDC_Validations__c,
							p.Special_Order_Instructions__c, FitBit_Show_Employee_Info_Field__c 
						   FROM Program__c p
						   WHERE p.Id  = :programid LIMIT 1];
    
    	init();
    }
    
    private void init(){
    	//fill in all the known elements of the order.
    	newOrder = new Order__c();
    	newOrder.ProgramId__c = programid;
    	newOrder.WW_Event__c = eventid;
    	newOrder.Order_Type__c = 'Onsite Test';
    	newOrder.Order_Status__c = 'Submitted';

		try
		{
    		sourceContact = [    SELECT c.Id, c.Name, c.FirstName, c.LastName, c.AccountId, c.Email, c.Birthdate, c.Employee_ID__c, c.Sex__c, c.Phone,Most_Recent_Onsite_Checkin__c
                			FROM Contact c 
                			WHERE  c.Id = :cId LIMIT 1 ];
	    		newOrder.PatientFirstName__c = sourceContact.FirstName;
	    		newOrder.PatientLastName__c = sourceContact.LastName;
	    		newOrder.PatientEmailH__c = sourceContact.Email;
	    		newOrder.Onsite_Card_Code__c=cardCode;
	    		newOrder.Check_In_Time__c=DateTime.now();
	    		//newOrder.PatientPrimaryPhone__c = sourceContact.Phone;
	    		newOrder.PatientDOB__c = sourceContact.Birthdate;
	    		//newOrder.PatientGender__c = sourceContact.Sex__c;
	    		newOrder.EmployeeID__c = sourceContact.Employee_ID__c  ;
	    		newOrder.Contact__c = sourceContact.Id;
	    		//because we used a contact to create the order, we don't want a contact created this time
	    		newOrder.Dont_Create_Contact__c = true;
	    		
	    		sourceContact.Most_Recent_Onsite_Checkin__c = eventid;	    		              						
		}
		catch(Exception ex){}
    	
    	//hand build gender list to exclude "other" which is an option on the standard order gender field
    	buildGenderList();
    	
    	changeErrorMessageVisibility(false);
    }

	public PageReference cancelNewOrder() {
		String missing = '';
        message = '';
        String errors = '';
        changeErrorMessageVisibility(false);
		return new PageReference('/apex/CheckIn?event=' + eventid);
	}
    
    public PageReference submit () {
    
        String missing = '';
        message = '';
        String errors = '';
        changeErrorMessageVisibility(false);
        
		if(String.isBlank(cId) && isBlank(newOrder.PatientFirstName__c))      { missing += ' [First Name] ';}       
		if((String.isBlank(cId) || program.Limeade_Identifier_LastName__c) && isBlank(newOrder.PatientLastName__c))       { missing += ' [Last Name] ';}        
		if((String.isBlank(cId) || program.Limeade_Identifier_Email__c) && isBlank(newOrder.PatientEmailH__c))         { missing += ' [Email] ';}           
		if(program.Limeade_Identifier_DOB__c && null == newOrder.PatientDOB__c)            { missing += ' [Date of Birth] ';}
		//if(isBlank(newOrder.Onsite_Card_Code__c))      { missing += ' [Card Code] ';} 
		if( program.Limeade_Identifier_Employee_ID__c && String.isBlank(newOrder.EmployeeID__c) ){  missing += ' [Employee ID] '; }
		if(isBlank(cardCode))      { missing += ' [Card Code] ';}   
    	Order__c tempOrder;
    	try
    	{
    		tempOrder=[select id,Contact__c from order__c where ProgramID__c=:program.Id and Onsite_Card_Code__c=: cardCode and WW_Event__c=:eventid limit 1];
    	}
    	catch(Exception ex)
    	{
    	}
    	//missing += ' '+tempOrder;
    	if(tempOrder!=null && (sourceContact==null || sourceContact.Id!=tempOrder.Contact__c) )
    	{
    		changeErrorMessageVisibility(true);
    		missing += ' [Please enter unique Card Code] ';
    	}		
		//if ( selectedGender != '0') {
		//	newOrder.PatientGender__c = selectedGender;
		//}

       /* if ( program.Limeade_Identifier_Employee_ID__c ) {
        	 if( null == newOrder.EmployeeID__c ){  missing += ' [Employee ID] '; }
        }*/

        //cancel if our required fields are missing before doing any other checks
		if (missing != '') {
    		missing = 'The following field values are missing and are required:<br/>' + missing;
    		changeErrorMessageVisibility(true);
    		errorMessage = missing;
    		return null;
    	}
        //validate primary  and secondary credentials if validation is allowed
  		if ( !checkLimeade) {
 			errors = LimeadeOrderValidator.validateLimeadeSecondaryCredentials(newOrder, program);
 		}else {
 			//stop this order getting sent to limeade
 			//newOrder.Prevent_Limeade_Transfer__c = true;
 		}

        if (errors != '') { 
        	changeErrorMessageVisibility(true);
    		errorMessage = errors;//  Check to make sure the last name, email are correct. Also make sure the email is the same email used to log into the employee\'s online platform.  If you fail after few attempts, then click the "Verify Contact Details in Limeade" button so that it shows red and you will be able to check in the employee without validating against Limeade.';//errors;
    		return null;
        }
		try{
		   System.debug( logginglevel.FINE, 'about to insert newOrder' );
		   if(sourceContact!=null ) update sourceContact;
		  /* else
		   {
	    		sourceContact.FirstName=newOrder.PatientFirstName__c;
	    		sourceContact.LastName=newOrder.PatientLastName__c;
	    		sourceContact.Email=newOrder.PatientEmailH__c;
	    		sourceContact.Birthdate=newOrder.PatientDOB__c;
	    		sourceContact.Employee_ID__c=newOrder.EmployeeID__c;
	    		//because we used a contact to create the order, we don't want a contact created this time
	    		newOrder.Dont_Create_Contact__c = true;
	    		
	    		sourceContact.Most_Recent_Onsite_Checkin__c = eventid;		   	
		   }
		   newOrder.Contact__c = sourceContact.Id;
		   */
		   newOrder.Check_In_Time__c=DateTime.now();
		   newOrder.Onsite_Card_Code__c=cardCode;
		   
		   insert newOrder;
			
			//PageReference pr=Page.OnsiteConsent;
			//pr.setRedirect(true);
			//pr.getParameters().put('oId',newOrder.Id);
			//pr.getParameters().put('eventId',eventid);
			//return pr;	
			message = 'Success! ' + newOrder.PatientFirstName__c + ' ' + newOrder.PatientLastName__c + ' is now checked in.';
			metaRefresh = 'refresh';
			metaContent = '5; url=/apex/CheckIn?event=' + eventid;
			init();				   
		} catch(Exception ex) {
			changeErrorMessageVisibility(true);
			errorMessage='Error: '+ex.getMessage();
		}

		
		//completely refresh the page
		
		
		//return new PageReference('/apex/CheckIn?event=' + eventid);
		return null;
    }
    
    public PageReference goBackToCheckinPage(){
    	return new PageReference('/apex/CheckIn?event=' + eventid);
    }
    
    
    private void changeErrorMessageVisibility(Boolean show) {
    	if ( show ) {
    		errorMessageStyle = VISIBLE_STYLE;
    	}else {
    		errorMessageStyle = INVISIBLE_STYLE;
    	}
    }

   /* private Datetime getDateTime(Date dateToConvert){

 		Datetime dt = datetime.newInstance(dateToConvert.year(), dateToConvert.month(),dateToConvert.day());
 		return dt;
    }*/
    
    /*public Boolean userExistsInLimeade(Boolean employeeIdIsIdentifier, String email, String employeeId, String e, String psk){
    
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
	        String url = Constant.LIMEMADE_API+'CheckAvailability.ashx?' +
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
    }
    
    private String validateLimeadeSecondaryCredentials (Order__c ord, Program__c prog) {
    	 
    	
    	 
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
	        String url = Constant.LIMEMADE_API+'User.ashx?' + mainIdentifier +
	        	'&e='			+ EncodingUtil.urlEncode(prog.Limeade_E_Id__c, 'UTF-8') + 
	        	'&psk=' 	 	+ EncodingUtil.urlEncode(prog.Limeade_PSK_ID__c, 'UTF-8') +
	        	'&format=XML';
	        
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
        	 String bday = participant.getAttribute('birthdate', null);  

        	 if ( prog.Limeade_Identifier_LastName__c && lname != ord.PatientLastName__c) 
        	 	errors += 'Your supplied last name does not match your lastname in our system.';
        	 if (prog.Limeade_Identifier_DOB__c && Date.parse(bday) != ord.PatientDOB__c) 
        	 	errors += 'Your supplied date of birth does not match your date of birth in our system.';
 
        }
        catch (Exception e) {
        	System.debug( logginglevel.FINE, 'SOLIANT ERROR: ' + e  );
			errors = 'Your details could not be found in our system.';
        }
        //default case:
        return errors;
    }
    */
    
    public void buildGenderList(){
    	gender = new List<SelectOption>();
    	gender.add(new SelectOption('0', '--None--')); 
    	gender.add(new SelectOption('Female', 'Female')); 
    	gender.add(new SelectOption('Male', 'Male')); 
    	selectedGender = gender[0].getValue();
    }
    
     private Boolean isBlank ( String val) {
    	if ( null == val || val == ''){
    		return true;
    	}
    	return false;
    }
    
    static testMethod void OnsiteNewOrderController(){
    	Account acct = TestDataGenerator.getOneAccount();
    	Program__c prog = TestDataGenerator.getOneProgram();
    	WW_Event__c wwevent = TestDataGenerator.getOneEvent();
    	Contact c=TestDataGenerator.getOneContact();
    	c.AccountId=acct.Id;
    	update c;
    	PageReference ref = new PageReference('/apex/OnsiteNewOrder?event=' + wwevent.Id + '&program=' + prog.Id+'&cId='+c.Id);
    	Test.setCurrentPage(ref); 
    
    	OnsiteNewOrderController controller = new OnsiteNewOrderController (); 
    	controller.submit();
    	controller.cancelNewOrder();
    	
    	controller.newOrder.PatientFirstName__c     =  'Caspar'; 
		controller.newOrder.PatientLastName__c      =  'Wiggle'; 
		controller.newOrder.PatientAddressLine1__c  =  '72 Liardet Street'; 
		controller.newOrder.PatientCity__c          =  'Wellington'; 
		controller.newOrder.PatientState__c         =  'CA'; 
		controller.newOrder.PatientZip__c           =  '94401'; 
		controller.newOrder.PatientPrimaryPhone__c  =  '6509723342'; 
		controller.newOrder.PatientEmailH__c        =  'rapsac@noone.com'; 
		controller.newOrder.PatientGender__c        =  'Male'; 
		controller.newOrder.PatientDOB__c           =  Date.today();
		controller.newOrder.Onsite_Card_Code__c     =  '123'; 
		controller.submit();
    	controller.cancelNewOrder();
    	
    	controller.newOrder.PatientFirstName__c     =  'Caspar'; 
		controller.newOrder.PatientLastName__c      =  'Harmer'; 
		controller.newOrder.PatientAddressLine1__c  =  '72 Liardet Street'; 
		controller.newOrder.PatientCity__c          =  'Wellington'; 
		controller.newOrder.PatientState__c         =  'CA'; 
		controller.newOrder.PatientZip__c           =  '94401'; 
		controller.newOrder.PatientPrimaryPhone__c  =  '6509723342'; 
		controller.newOrder.PatientEmailH__c        =  'rapsac@gmail.com'; 
		controller.newOrder.PatientGender__c        =  'Male'; 
		controller.newOrder.PatientDOB__c           =  Date.today();
		controller.newOrder.Onsite_Card_Code__c     =  '123'; 
		controller.submit();
    	controller.cancelNewOrder();
    	
    	
    }

}