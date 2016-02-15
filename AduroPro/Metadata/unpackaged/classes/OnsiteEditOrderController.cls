public  class OnsiteEditOrderController {

    public Order__c ord {get; set;} 
    public Program__c program {get; private set;}
    //public Account account {get; private set;}
    public Contact contact {get; set;}
    public WW_Event__c event {get; private set;}
    public Boolean checkLimeade {get; set;}
    
    public List<SelectOption> gender {get; set;} 
    public String selectedGender {get; set;}
    
    public String message {get; private set;}
    public String errorMessage {get; private set;}
	public String errorMessageStyle {get; private set;}
    
    private static final String VISIBLE_STYLE = '';
    private static final String INVISIBLE_STYLE = 'display:none;';
    
    public String sliderDisplayStyle {get; private set;}
    //public String metaRefresh {get; private set;}
	//public String metaContent {get; private set;}
    
    public String programid {get; private set;}
    public String accountid {get; private set;}
    public String eventid {get; private set;}
    public String orderid {get; private set;}
    public String contactid {get; private set;}
    
    public String returnpage {get; private set;}
    public String returnurl {get; private set;}
    
    
    
    public OnsiteEditOrderController( ){

		checkLimeade = true;
		sliderDisplayStyle =  INVISIBLE_STYLE; 
		
        try {
        	programid = ApexPages.currentPage().getParameters().get('program');
        	eventid = ApexPages.currentPage().getParameters().get('event');
        	orderid = ApexPages.currentPage().getParameters().get('order');
        	contactid = ApexPages.currentPage().getParameters().get('contact');
        	returnpage = ApexPages.currentPage().getParameters().get('returnpage');
        	returnurl = '/apex/' + returnpage + '?event=' + eventid;
        	
        }catch (Exception ex) {
        }
   		program = 	[SELECT Program__c.Id, Program__c.Name, Program__c.Program_End_Date__c, Program__c.Limeade_E_Id__c,
							Program__c.Limeade_Identifier_Employee_ID__c, Program__c.Limeade_Identifier_DOB__c,
							Program__c.Limeade_Identifier_Email__c, Program__c.Limeade_Identifier_LastName__c,
							Program__c.Program_Start_Date__c, Program__c.Enable__c, Program__c.Limeade_PSK_ID__c,
							Program__c.Activity_Device_Note_to_User__c,
							Program__c.Disable_Limeade_SFDC_Validations__c,
							Program__c.Special_Order_Instructions__c, FitBit_Show_Employee_Info_Field__c 
					 FROM 	Program__c
					 WHERE 	Program__c.Id  = :programid LIMIT 1];
					 
		event = 	[SELECT e.Id, e.Name, e.Event_Date__c, e.Start_Time__c, e.End_Time__c, e.Event_Status__c, e.Employer__c, e.Program__c
        			 FROM WW_Event__c e 
        			 WHERE e.Id = :eventid  ];
			  		 
		contact =	[SELECT c.Sex__c, c.Phone, c.LastName, c.Id, c.FirstName, c.Employee_ID__c, c.Email, c.Birthdate 
					 FROM Contact c
					 WHERE c.Id = :contactid LIMIT 1];
					 
		
		if (orderid != null && orderid != ''){
			 
			sliderDisplayStyle =  VISIBLE_STYLE; 
			ord = 	[SELECT o.PatientPrimaryPhone__c, o.PatientLastName__c, o.PatientGender__c, o.PatientFirstName__c,
						 	o.PatientEmailH__c, o.PatientDOB__c, o.Onsite_Card_Code__c, o.EmployeeID__c 
			  		 FROM 	Order__c o
			  		 WHERE 	o.Id = :orderid LIMIT 1];
			  		 
		}
  		 
		if (contact != null && program != null){
			init();
		}
    

    }
    
    private void init(){

    	//hand build gender list to exclude "other" which is an option on the standard order gender field
    	buildGenderList(contact);
    	changeErrorMessageVisibility(false);
    }

	public PageReference cancelNewOrder() {
        changeErrorMessageVisibility(false);
		return new PageReference('/apex/CheckIn?event=' + eventid);
	}
    
    public PageReference submit () {
    
    	System.debug( logginglevel.FINE, '----------------------->in submit. Contact is ' + contact );
        String missing = '';
        message = '';
        String errors = '';
        changeErrorMessageVisibility(false);
        
		if(isBlank(contact.FirstName))      	  { missing += ' [First Name] ';}       
		if(isBlank(contact.LastName))       	  { missing += ' [Last Name] ';}        
		if(isBlank(contact.Email))         		  { missing += ' [Email] ';}           
		//if( null == contact.BirthDate)            { missing += ' [Date of Birth] ';}
	
		if ( selectedGender != '0') {
			contact.Sex__c = selectedGender;
		}

        if ( program.Limeade_Identifier_Employee_ID__c ) {
        	 if( null == contact.Employee_ID__c ){  missing += ' [Employee ID] '; }
        }

        //cancel if our required fields are missing before doing any other checks
		if (missing != '') {
    		missing = 'The following field values are missing and are required:<br/>' + missing;
    		changeErrorMessageVisibility(true);
    		errorMessage = missing;
    		 System.debug( logginglevel.FINE, '----------------------->fields are missing ' + missing );
    		return null;
    	}
        //validate primary  and secondary credentials if validation is allowed
        if (ord != null) {
        	
        	System.debug( logginglevel.FINE, '----------------------->order is not null' + ord );
        	copyContactDetailsToOrder();
        	
        	if (!program.Disable_Limeade_SFDC_Validations__c && checkLimeade) {
	 			if ( ! LimeadeOrderValidator.userExistsInLimeade(program.Limeade_Identifier_Employee_ID__c, ord.PatientEmailH__c, 
	 			ord.EmployeeID__c, program.Limeade_E_Id__c, program.Limeade_PSK_ID__c)) { 
		        	if ( program.Limeade_Identifier_Employee_ID__c ) 
		        		errors = ' Your [Employee ID] does not match any information in our system.'; 
		        	else 
		        		errors = ' Your [Email] does not match any information in our system.'; 
		        	
		        	changeErrorMessageVisibility(true);
	    			errorMessage = errors;
	    			return null;
		        }
		        errors = LimeadeOrderValidator.validateLimeadeSecondaryCredentials(ord, program);
	 		}else {
	 			//stop this order getting sent to limeade
	 			ord.Prevent_Limeade_Transfer__c = true;
	 		}
        }

        if (errors != '') { 
        	changeErrorMessageVisibility(true);
    		errorMessage = errors;
    		return null;
        }
		try{
		   System.debug( logginglevel.FINE, '----------------------->about to update contact' );
		   update contact;
		   if (ord != null) {
		   		update ord;
		   }
		} catch(DmlException ex) {
			
		}
		
		message = 'Success! ' + contact.FirstName + ' ' + contact.LastName + ' was updated succesfully.';
		System.debug( logginglevel.FINE, '----------------------->success message is:' + message );

		//metaRefresh = 'refresh';
		//metaContent = '5; url=/apex/CheckIn?event=' + eventid;
		//completely refresh the page
		//init();
		//changeErrorMessageVisibility(false);
		return null;
    }
    
    public PageReference goBackToOrigin(){
    	return new PageReference(returnurl);
    }
    
    
    private void changeErrorMessageVisibility(Boolean show) {
    	if ( show ) {
    		errorMessageStyle = VISIBLE_STYLE;
    	}else {
    		errorMessageStyle = INVISIBLE_STYLE;
    	}
    }

    private void buildGenderList(Contact contact){
    	gender = new List<SelectOption>();
    	gender.add(new SelectOption('0', '--None--')); 
    	gender.add(new SelectOption('Female', 'Female')); 
    	gender.add(new SelectOption('Male', 'Male')); 
    	selectedGender = gender[0].getValue();
    	
    	if (contact.Sex__c == 'Male' ){
    		selectedGender = gender[2].getValue();
    	}
    	if (contact.Sex__c == 'Female' ){
    		selectedGender = gender[1].getValue();
    	}
    	else{
    		selectedGender = gender[0].getValue();
    	}
    }
    
     private Boolean isBlank ( String val) {
    	if ( null == val || val == ''){
    		return true;
    	}
    	return false;
    }
    
    private void copyContactDetailsToOrder(){
		ord.PatientFirstName__c = contact.FirstName;
		ord.PatientLastName__c = contact.LastName;
		ord.PatientEmailH__c = contact.Email;
		ord.PatientPrimaryPhone__c = contact.Phone;
		ord.PatientDOB__c = contact.Birthdate;
		ord.PatientGender__c = contact.Sex__c;
		ord.EmployeeID__c = contact.Employee_ID__c;
		//because we used a contact to create the order, we don't want a contact created this time
		//ord.Dont_Create_Contact__c = true;
    }
    
    static testMethod void testOnsiteEditOrderController(){
    	Account acct = TestDataGenerator.getOneAccount();
    	Program__c prog = TestDataGenerator.getOneProgram();
    	WW_Event__c wwevent = TestDataGenerator.getOneEvent();
    	Contact contact = TestDataGenerator.getOneContact();
    	
    	contact.FirstName =  'Caspar'; 
		contact.LastName =  'Wiggle'; 
		contact.Email =  'rapsac@noone.com'; 
		contact.Phone =  '6509723342'; 
		contact.Birthdate =  Date.today();
		contact.Sex__c =  'Male'; 
		contact.Employee_ID__c = '41'; 
    	
    	
    	PageReference ref = new PageReference('/apex/OnsiteEditOrder?event=' + wwevent.Id + '&program=' + prog.Id + '&contact=' + contact.Id);
    	Test.setCurrentPage(ref); 
    
    	OnsiteEditOrderController controller = new OnsiteEditOrderController (); 
    	controller.contact = contact;
    	controller.submit();
    	controller.cancelNewOrder();
    	
    	Order__c ord = new Order__c();
    	ord.PatientFirstName__c = contact.FirstName;
		ord.PatientLastName__c = contact.LastName;
		ord.PatientEmailH__c = contact.Email;
		ord.PatientPrimaryPhone__c = contact.Phone;
		ord.PatientDOB__c = contact.Birthdate;
		ord.PatientGender__c = contact.Sex__c;
		ord.EmployeeID__c = contact.Employee_ID__c;
		ord.ProgramID__c = prog.Id;
		insert ord;

		prog.Enable__c = true;
		ref = new PageReference('/apex/OnsiteEditOrder?event=' + wwevent.Id + '&program=' + prog.Id + '&contact=' + contact.Id + '&order=' + ord.Id);
    	Test.setCurrentPage(ref); 
    
    	controller = new OnsiteEditOrderController ();
    	controller.program.Disable_Limeade_SFDC_Validations__c = false;
    	controller.checkLimeade = true;
    	controller.submit();
    	controller.cancelNewOrder();
		
		ref = new PageReference('/apex/OnsiteEditOrder?event=' + wwevent.Id + '&program=' + prog.Id + '&contact=' + contact.Id + '&order=' + ord.Id);
    	Test.setCurrentPage(ref); 
    
    	controller = new OnsiteEditOrderController ();
    	controller.program.Disable_Limeade_SFDC_Validations__c = false;
    	controller.checkLimeade = true;
    	controller.submit();
    	controller.cancelNewOrder();
    	
    	ref = new PageReference('/apex/OnsiteEditOrder?event=' + wwevent.Id + '&program=' + prog.Id + '&contact=' + contact.Id + '&order=' + ord.Id);
    	Test.setCurrentPage(ref); 
    
    	controller = new OnsiteEditOrderController ();
    	controller.program.Disable_Limeade_SFDC_Validations__c = false;
    	controller.checkLimeade = true;
    	controller.contact.Employee_ID__c = null;
    	controller.contact.FirstName = '';
    	controller.submit();
    	controller.cancelNewOrder();

    }

}