public abstract class OrderFormControllerAbstract {

    public Order__c newOrder {get; private set;} 
    public Program__c program {get; private set;}
    public Account account {get; private set;}
   	public String e {get; private set;} 
   	public String programid {get; private set;} 
   	public String deviceType {get; private set;} 
   	public Boolean isFitbit {get; private set;} 
    public Boolean submitDisabled {get; private set;}
    public Boolean showEmployeeId {get; private set;}
    
    public String orderType {get; private set;}
    public String titleText {get; private set;}
    
    private DateTime progStart;
    private DateTime progEnd;
    
    public OrderFormControllerAbstract( String e, Boolean test){
    	this.e = e;
    	System.debug( '>>>e: ' + e  );
    	init();
    }

    public OrderFormControllerAbstract( ){
    	isFitbit = false;
    	deviceType = '';//no device type set
        e = ApexPages.currentPage().getParameters().get('e');
        //this url paramater only gets passed in when clicked from the program page (by admins and developers)
        programid = ApexPages.currentPage().getParameters().get('program');
        deviceType = ApexPages.currentPage().getParameters().get('deviceType');
    	if ( deviceType == 'fitbit') {
			isFitbit = true;
		}

   		init();
    }
    
    private void init() {
    	
    	setOrderType();

        if ( e == '' || e == null) {
        	handleGeneralErrors('This page has been called with incorrect parameters. Please try again.' );
        	submitDisabled = true;
        	return;
        }
        account = getAssociatedAccount();
		if ( account == null) {
			handleGeneralErrors('An error occurred accessing your company records.' );
			submitDisabled = true;
			return;
		}
		program = getAssociatedProgram();
		if (program == null) {
			handleGeneralErrors('An active program for your company could not be found.' );
			submitDisabled = true;
			return;
		}
       
		newOrder = new Order__c();
		newOrder.ProgramID__c = program.Id;
		progStart = getDateTime(program.Program_Start_Date__c);
		progEnd = getDateTime(program.Program_End_Date__c);

    }

	public PageReference cancel () {
		return Page.OrderCancel;
	}
    
    public PageReference submit () {

    	if ( program == null || account == null || newOrder == null) {
    		handleGeneralErrors('This page has been called with incorrect parameters. Please try again. ');
            return null;
    	}
    	//cancel if our required fields are missing before doing any other checks
        String missing = getMissingFields(program, newOrder);
		if (missing != ''){
			handleGeneralErrors('Required fields are missing: '+ missing);
			return null;
		}
		
		//validate primary  and secondary credentials if validation is enabled
		String errors = getLimeadeValidationErrors(program, newOrder);
        if (errors != '') { 
        	handleGeneralErrors(errors);
            return null;
        }
        //stop this order getting sent to limeade 
  		if (program.Disable_Limeade_SFDC_Validations__c) {
 			newOrder.Prevent_Limeade_Transfer__c = true;
 		}
        
        //to be appended to the pageurl
		String dupe = 'false';
		newOrder.Order_Type__c = orderType;
		
		if ( isDuplicate()) {
			//don't ping incentive api
			dupe = 'true';
			newOrder.Order_Status__c = 'Duplicate';
		}else {  
			if (program.Enable__c == true ) {  //prob should be called "Enable_Incentives__c"
				updateIncentivePoints();  
			}
			newOrder.Order_Status__c = 'Submitted';
		}
		try{
		   System.debug( logginglevel.FINE, 'about to insert newOrder' );
		   insert newOrder;
		   //add incentive...
			return new PageReference('/apex/OrderSubmitted?duplicate=' + dupe);
		} catch(DmlException ex) {
			
		}
		return null;
    }
    
    //methods below are overridden to customize the controller for different pages
    public abstract Program__c getAssociatedProgram();
    
    public abstract void updateIncentivePoints();
            
    public abstract String getIncentivePointXMLData ();
    
    public abstract void setOrderType();

	
    private void handleGeneralErrors(String message) {
    	message += '<br>If you believe you are seeing this message in error, please contact support@adurolife.com.';
   		ApexPages.Message generalErrors = new ApexPages.Message(ApexPages.Severity.ERROR, message );
        ApexPages.addMessage( generalErrors );
        //submitDisabled = true;
    }
    
    private Datetime getDateTime(Date dateToConvert){

 		Datetime dt = datetime.newInstance(dateToConvert.year(), dateToConvert.month(),dateToConvert.day());
 		return dt;
    }
   
    private Boolean isDuplicate() {
						  					
    	List<Order__c> orders = [	SELECT Order__c.Id, Order__c.OrderDate__c, Order__c.PatientEmailH__c
						  			FROM Order__c 
						  			WHERE Order__c.PatientEmailH__c = :newOrder.PatientEmailH__c
						  				AND Order__c.ProgramID__c = :program.Id
						  				AND Order__c.Order_Type__c = :orderType
						  				AND Order__c.OrderDate__c < :progEnd
						  				AND ( Order__c.OrderDate__c > :progStart OR Order__c.OrderDate__c = :progStart)];
						  					
						  					
		if ( orders.isEmpty()) {
			return false;
		}else {
			return true;
		}
    }
    
    private String getMissingFields(Program__c program, Order__c newOrder) {

        String missing = '';
        
        if(newOrder.PatientFirstName__c == null || newOrder.PatientFirstName__c == '' ){  missing += ' [First Name] '; }  
        if(String.isBlank(newOrder.PatientLastName__c ) ){  missing += ' [Last Name] '; }
        if(newOrder.PatientAddressLine1__c == null || newOrder.PatientAddressLine1__c == '' ){  missing += ' [Address] '; }
        if(newOrder.PatientCity__c == null || newOrder.PatientCity__c == '' ){  missing += ' [City] '; }
        if(newOrder.PatientState__c == null || newOrder.PatientState__c == '' ){  missing += ' [State] '; }  
        if(newOrder.PatientZip__c == null || newOrder.PatientZip__c == '' ){  missing += ' [Zip] '; }
        if(newOrder.PatientPrimaryPhone__c == null || newOrder.PatientPrimaryPhone__c == '' ){  missing += ' [Primary Phone] '; }
        if(program.Limeade_Identifier_Email__c && String.isBlank(newOrder.PatientEmailH__c ) ){  missing += ' [Email] '; }
        if(newOrder.PatientGender__c == null || newOrder.PatientGender__c == '' ){  missing += ' [Sex] '; }  
        if(program.Limeade_Identifier_DOB__c && newOrder.PatientDOB__c == null  ){  missing += ' [Date Of Birth] '; }
        
        if ( program.Limeade_Identifier_Employee_ID__c ) {
        	 if(newOrder.EmployeeID__c == null  ){  missing += ' [Employee ID] '; }
        }
        
        if ( program.FitBit_Show_Employee_Info_Field__c ) {
        	 if(newOrder.Employee_Info__c == null  ){  missing += ' [Employee Info] '; }
        }
        
        return missing;
        
    }
    
    private String getLimeadeValidationErrors (Program__c program, Order__c newOrder) {
    	
    	String errors = '';
    	
    	if (! program.Disable_Limeade_SFDC_Validations__c) {
 			/*if ( ! LimeadeOrderValidator.userExistsInLimeade(	program.Limeade_Identifier_Employee_ID__c,
 															 	newOrder.PatientEmailH__c, 
 																newOrder.EmployeeID__c, 
 																program.Limeade_E_Id__c, 
 																program.Limeade_PSK_ID__c)) { 
	        	if ( program.Limeade_Identifier_Employee_ID__c ) 
	        		errors = ' Your [Employee ID] does not match any information in our system.';
	        	else 
	        		errors = ' Your [Email] does not match any information in our system.'; 
	        	
	        	ApexPages.Message primaryErrors = new ApexPages.Message(ApexPages.Severity.ERROR, errors );
	            ApexPages.addMessage( primaryErrors );
	            return null;
	        }
	        errors = LimeadeOrderValidator.validateLimeadeSecondaryCredentials(newOrder, program);*/
			LimeadeValidator lv=new LimeadeValidator();
			lv.LimeadeEID=program.Limeade_E_Id__c;
			lv.LimeadePSKID=program.Limeade_PSK_ID__c; 
			lv.LastName=newOrder.PatientLastName__c;
			lv.DOB=newOrder.PatientDOB__c.format();
			lv.Email=newOrder.PatientEmailH__c;
			lv.employeeId=newOrder.EmployeeID__c;
			lv.IdentifierLastName=program.Limeade_Identifier_LastName__c;
			lv.IdentifierDOB=program.Limeade_Identifier_DOB__c;
			lv.IdentifierEmail=program.Limeade_Identifier_Email__c;
			lv.IdentifierEmployeeID=program.Limeade_Identifier_Employee_ID__c;
			lv.validate();
			errors=lv.ErrorMessage;
 		}
 		
 		return errors;
    }
    
    

    private Account getAssociatedAccount(){
    	List<Account> accounts = [	SELECT Account.Limeade_e__c, Account.Limeade_PSK__c, Account.Name, Account.Activate_Incentive_Program__c
						  			FROM Account 
						  			WHERE Account.Limeade_e__c = :e];
						  			
		if ( accounts.isEmpty()) 
			return null;
		else				  			
			return accounts[0];
    }

}