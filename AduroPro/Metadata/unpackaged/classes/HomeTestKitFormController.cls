public class HomeTestKitFormController extends OrderFormControllerAbstract {

	
	public HomeTestKitFormController(String e, Boolean test) {
		super (e,test);
	}
	
	public HomeTestKitFormController() {
		super ();
	}
	override public Program__c getAssociatedProgram() {
    	//get the program id that is selected to include a htk component and is currently active.
		List<Program__c> programs = new List<Program__c>();
		
		if (programid != null && programid != '') {
			programs = [ SELECT p.Id, p.Name,   p.Program_End_Date__c, p.Limeade_E_Id__c,	p.Limeade_Identifier_Employee_ID__c, 
								p.Limeade_Identifier_DOB__c, p.Limeade_Identifier_Email__c, p.Limeade_Identifier_LastName__c, 
								p.Program_Start_Date__c, p.Enable__c, p.Limeade_PSK_ID__c,	p.Activity_Device_Note_to_User__c, 
								p.Disable_Limeade_SFDC_Validations__c, p.Special_Order_Instructions__c, FitBit_Show_Employee_Info_Field__c ,
								p.Non_Branded_Form__c
						   FROM Program__c p
						   WHERE p.Id = :programid ];
		}else {
			programs = [ SELECT p.Id, p.Name,   p.Program_End_Date__c, p.Limeade_E_Id__c,	p.Limeade_Identifier_Employee_ID__c, 
								p.Limeade_Identifier_DOB__c, p.Limeade_Identifier_Email__c, p.Limeade_Identifier_LastName__c, 
								p.Program_Start_Date__c, p.Enable__c, p.Limeade_PSK_ID__c,	p.Activity_Device_Note_to_User__c, 
								p.Disable_Limeade_SFDC_Validations__c, p.Special_Order_Instructions__c, FitBit_Show_Employee_Info_Field__c ,
								p.Non_Branded_Form__c
						   FROM Program__c p
						   WHERE p.Include_HTK_Component__c = true
						 			AND p.Program_Status__c = 'Active' 
						 			AND p.Limeade_E_Id__c = :e ];
								 	
		}
		
		if ( programs.isEmpty() ) {
    		return null;
		}
		return programs[0];
		
	}

    override public void updateIncentivePoints() {

    	try {
    		String xmlData = getIncentivePointXMLData();
	    	
	
			Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        HttpResponse res = new HttpResponse();
	        req.setTimeout(59000);
	        
        	String url = Constant.LIMEMADE_API+'Upload.ashx?' ;
				        	
			String body = 	'e=' +    EncodingUtil.urlEncode(e, 'UTF-8') + 
				        	'&psk=' +  EncodingUtil.urlEncode(program.Limeade_PSK_ID__c, 'UTF-8') +
				        	'&response=XML' +
				        	'&format=XML' + 
				        	'&type=IncentivePoints' + 
				        	//'&data=' +  EncodingUtil.urlEncode(xmlData, 'UTF-8') ;
				        	'&data=' +  xmlData ;

			req.setEndpoint(url);
			req.setMethod('POST');
			req.setHeader('Content-Length', body.length().format());
			req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
			req.setBody(body);

	        
	        System.debug( logginglevel.FINE, 'XML: ' + xmlData );
	        System.debug( logginglevel.FINE, 'REQ: ' + req.getBody() );
	        
	
			 if (!Test.isRunningTest()) {
				res = h.send(req);
			}
	        System.debug( logginglevel.FINE, 'RES: ' + res );
	        System.debug( logginglevel.FINE, 'RES BODY: ' + res.getBody() );
    	}
    	
    	catch (Exception e) {
    		
    	}

    }
    
    
        
    override public String getIncentivePointXMLData () {
    	String xmlData = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Document>';
		xmlData += '<Participant ' + 
						'email="' + newOrder.PatientEmailH__c  + '"' + 
						' incentiveevent="' + '22'  + '"' + 
						'/></Document>';
		return xmlData;
    }
    
    override public void setOrderType(){
		orderType = 'HTK';
		titleText = 'Home Test Kit Order Form';
    	
    }
    
	static testMethod void testHomeTestKitFormController() {   
		
		//invalid e
		Account a=new Account(Name='abc',Limeade_e__c='abc');
		insert a;
		Program__c p=new Program__c(Limeade_E_Id__c='abc',Include_HTK_Component__c=true,Program_Status__c = 'Active',Limeade_Identifier_Email__c=true,Program_Start_Date__c=Date.today(),Program_End_Date__c=Date.today().addDays(300),Limeade_PSK_ID__c='psk',Limeade_Live_Date__c=Date.today(),Program_Manager__c=UserInfo.getUserId() );
		p.HA_Option_Alert_Value_Calls__c='Yes';
		p.HA_Option_Custom_Result_Message__c='No';
		p.HA_Option_HAHC_Website_for_Results__c='Yes';
		p.HA_Option_Other_reporting__c='No';
		p.HA_Option_Replacement_Kits__c='Yes';
		p.HA_option_Resolve_On_Hold__c='Yes';
		p.HA_Option_Result_file_to_Customer__c='Yes';
		p.Estimated_Participants__c=5;
		p.HA_Option_Reminder_Calls__c='NA';
		p.HA_Option_Physician_Requisition__c='HAHC';
		p.HA_Option_Participant_Result_Reports__c='Customer to mail';
		p.HA_Option_Other__c='NA';
		p.HA_Option_Kit_Distribution__c='Direct to: Participants';
		p.HA_Option_Number_of_Kits__c=4;
		p.Limeade_Identifier_LastName__c=true;
		p.Account__c=a.Id;
		insert p;
		HomeTestKitFormController controller = new HomeTestKitFormController('nonexistant company',true);
		system.assertEquals(true , controller.submitDisabled); 
		
		controller = new HomeTestKitFormController('abc1',true);
		//system.assertEquals(true , controller.submitDisabled); 
		
		//no data in fields
		controller = null;
		controller = new HomeTestKitFormController('abc',true);
		PageReference ref = controller.submit();
		system.assertEquals(null, ref);
		
		ref = controller.cancel();
		system.assertEquals('/apex/ordercancel', ref.getUrl());
		
		controller.newOrder.PatientFirstName__c = 'Joelle';
		controller.newOrder.PatientLastName__c = 'Bloggs';
		controller.newOrder.PatientAddressLine1__c = '72 Liardet Street';
		controller.newOrder.PatientAddressLine2__c = '72 Liardet Street';
		controller.newOrder.PatientCity__c = 'Wellington';
		controller.newOrder.PatientState__c = 'Wellington';
		controller.newOrder.PatientZip__c = '94401';
		controller.newOrder.PatientPrimaryPhone__c = '6506969310';
		controller.newOrder.PatientGender__c = 'Male';
		controller.newOrder.PatientDOB__c = date.newinstance(1976, 12, 3);
		
		//user not found with email check, not employee check
		controller.program.Limeade_Identifier_Employee_ID__c = true;
		//ref = controller.submit();
		//system.assertEquals(null, ref);
		
		//all details in place
		controller.newOrder.EmployeeID__c = '41';
		controller.newOrder.PatientEmailH__c = 'ray@gmail.com';
		controller.program.Enable__c = true;
		
		ref = controller.submit();
		system.assertEquals('/apex/OrderSubmitted?duplicate=false', ref.getUrl());
			
		
		Boolean result = LimeadeOrderValidator.userExistsInLimeade(true, 'here@there', '1', 'blah', 'blah');
		system.assertEquals(true, result);
		
		result = LimeadeOrderValidator.userExistsInLimeade(false, 'here@there', '1', 'blah', 'blah');
		system.assertEquals(true, result);
		
		controller = new HomeTestKitFormController();

	}   
    

}