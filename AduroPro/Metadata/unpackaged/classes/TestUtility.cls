public class TestUtility {

	public static Account createAccount(integer counter){
		Account objAcc = new Account();
		Id partnerAccType='01270000000DyAE';
		
		objAcc.Name='TestName_' + counter;
		objAcc.RecordTypeId=partnerAccType;
		
		return objAcc;
	}	//	end of createAccount
	
	public static Account createEmployerAccount(integer counter){
		Account objAcc = new Account();
		Id employerRecordtype = '01270000000Dy9y';
		
		objAcc.Name='TestName_' + counter;
		objAcc.Website='www.test.test';
		objAcc.RecordTypeId=employerRecordtype;
		
		return objAcc;
	}	//	end of createEmployerAccount
	
	public static Contact createParticipantContact(integer counter, Account objAcc, 
											string validEmail, Program__c objProg,
											Contact coach){
		Contact objCon = new Contact();
		Id participantId='01270000000Hhwc';
		
		objCon.FirstName='TestFirst_' + counter;
		objCon.LastName='TestLast_' + counter;
		objCon.RecordTypeID=participantId;
		objCon.Sex__c='Male';
		objCon.Email='test@test.com';
		objCon.Limeade_Identifier_Email__c=validEmail;
		objCon.Birthdate=Date.ValueOf('1980-01-01');
		objCon.First_Contact_with_a_Coach__c=Date.today().addDays(-15);
		objcon.AccountId=objAcc.Id;
		objCon.Program__c=objProg.Id;
		objCon.Method_of_First_Contact__c='Other';
		objCon.Primary_Reason_for_Coaching__c='Points';
		objCon.Source_of_Referral__c='Other';
		objCon.Contact__c=coach.Id;
		objCon.Withings_User__c=true;
		objCon.Withings_User_Id__c=null;
		objCon.Temp_Request_Key__c=null;
		objCon.Temp_Request_Secret__c=null;
		objCon.Withings_User_Token__c=null;
		objCon.Withings_User_Secret__c=null;
		
		return objCon;
		
	}	//	end of createParticipantContact
	
	public static Program__c createProgram(integer counter, Account objAcc){
		Program__c objProg = new Program__c(Name='TestProgram_' + counter,
											Account__c = objAcc.Id);
		return objProg;
	}	//	end of createProgram
	
	public static Contact createStandardContact(integer Counter){
		Contact objCon = new Contact(LastName='TestLast_' + counter);
		
		return objcon;
	}	//	end of createStandardContact
	
	public static Contact createStandardContactWithAddress(integer Counter){
		Contact objCon = new Contact(LastName='TestLast_' + counter);
		objCon.MailingStreet = 'Test Street';
		objCon.MailingCity = 'TestCity';
		objCon.MailingState = 'VA';
		objCon.MailingPostalCode = '23456'; 
		objCon.MailingCountry = 'US';
		
		return objcon;
	}	//	end of createStandardContact
	
	public static Goal__c createGoal(integer counter, Contact objCon){
		Goal__c objGoal = new Goal__c(Contact__c = objCon.Id,
										Goal_Type__c='Lifestyle',
										Goal_Name__c='TestGoal_'+counter,
										Created_Date__c=Date.today().addDays(-15),
										Capacity_for_Change__c='Action',
										Program_Name__c='Ignite Health Recovery Program_PDMS',
										Overall_Goal_Status__c = 'In Progress');
		
		return objGoal;
	}	//	end of createGoal
	
	public static EmailTemplate createEmailTemplate(){
		Id folderId='00Dn0000000DUon';
		Id letterHeadId='01670000000HYZ7';
		
		EmailTemplate e = new EmailTemplate(developerName = 'test', 
											FolderId = folderId, 
											TemplateType= 'Html',
											TemplateStyle='freeform',
											BrandTemplateId=letterHeadId,
											Name = 'Withings OAuth Request');
		
		return e;
		
	}	//	end of createEmailTemplate
	
	public static string getSampleMearuseData(){
		return '{"status":0,"body":{"updatetime":1426966001,"measuregrps":[{"grpid":332641449,"attrib":0,"date":1426963625,"category":1,"measures":[{"value":108903,"type":1,"unit":-3}]},{"grpid":331205638,"attrib":0,"date":1426711210,"category":1,"measures":[{"value":109933,"type":1,"unit":-3}]},{"grpid":317720843,"attrib":0,"date":1424191924,"category":1,"measures":[{"value":82,"type":9,"unit":0},{"value":142,"type":10,"unit":0},{"value":89,"type":11,"unit":0},{"value":-1000,"type":18,"unit":-3}]},{"grpid":315974272,"attrib":0,"date":1423845542,"category":1,"measures":[{"value":72,"type":9,"unit":0},{"value":128,"type":10,"unit":0},{"value":84,"type":11,"unit":0},{"value":-1000,"type":18,"unit":-3}]},{"grpid":315619056,"attrib":0,"date":1423783644,"category":1,"measures":[{"value":105,"type":11,"unit":0}]},{"grpid":315555577,"attrib":0,"date":1423772000,"category":1,"measures":[{"value":87,"type":9,"unit":0},{"value":151,"type":10,"unit":0},{"value":99,"type":11,"unit":0},{"value":-1000,"type":18,"unit":-3}]},{"grpid":315552686,"attrib":0,"date":1423771352,"category":1,"measures":[{"value":108550,"type":1,"unit":-3}]},{"grpid":314685849,"attrib":0,"date":1423605726,"category":1,"measures":[{"value":91,"type":11,"unit":0}]},{"grpid":315620032,"attrib":2,"date":1423270800,"category":1,"measures":[{"value":112173,"type":1,"unit":-3},{"value":-1000,"type":18,"unit":-3}]},{"grpid":312720882,"attrib":0,"date":1423235692,"category":1,"measures":[{"value":92,"type":9,"unit":0},{"value":150,"type":10,"unit":0},{"value":83,"type":11,"unit":0},{"value":-1000,"type":18,"unit":-3}]},{"grpid":312720879,"attrib":0,"date":1423235603,"category":1,"measures":[{"value":71,"type":9,"unit":0},{"value":112,"type":10,"unit":0},{"value":70,"type":11,"unit":0},{"value":-1000,"type":18,"unit":-3}]},{"grpid":313313081,"attrib":0,"date":1423234956,"category":1,"measures":[{"value":97,"type":11,"unit":0}]},{"grpid":313313078,"attrib":0,"date":1423234906,"category":1,"measures":[{"value":127,"type":11,"unit":0},{"value":98,"type":54,"unit":0}]},{"grpid":313313076,"attrib":0,"date":1423234827,"category":1,"measures":[{"value":90,"type":11,"unit":0},{"value":99,"type":54,"unit":0}]},{"grpid":313313073,"attrib":0,"date":1423234704,"category":1,"measures":[{"value":102,"type":11,"unit":0}]},{"grpid":313313070,"attrib":0,"date":1423234626,"category":1,"measures":[{"value":107,"type":11,"unit":0}]},{"grpid":313313067,"attrib":0,"date":1423234576,"category":1,"measures":[{"value":94,"type":11,"unit":0}]},{"grpid":313313064,"attrib":0,"date":1423188131,"category":1,"measures":[{"value":91,"type":11,"unit":0},{"value":98,"type":54,"unit":0}]},{"grpid":312358353,"attrib":2,"date":1423174207,"category":1,"measures":[{"value":62,"type":9,"unit":0},{"value":119,"type":10,"unit":0},{"value":70,"type":11,"unit":0},{"value":-1000,"type":18,"unit":-3}]},{"grpid":312358330,"attrib":2,"date":1423174198,"category":1,"measures":[{"value":1727,"type":4,"unit":-3}]}]}}';
	}	//	end of getSampleMearuseData
	
	public static WW_Event__c createEvent(integer counter, Account objAcc){
		Id bioConRecordType = '01270000000HlFZ';
		WW_Event__c objEvent = new WW_Event__c();
		objEvent.Name = 'Test Event_'+counter;
		objEvent.Employer__c = objAcc.id;
		objEvent.Screeners_Needed__c=10;
		
		return objEvent;
	}	//	end of createEvent
	
	public static Event_Resource__c createEventResource(integer counter, Account objAcc, Contact objCon, WW_Event__c objAduroEvent){
		Event_Resource__c objEvtResource = new Event_Resource__c();
		objEvtResource.Account__c = objAcc.Id;
		objEvtResource.Contact__c = objCon.Id;
		objEvtResource.WW_Event__c = objAduroEvent.Id;
		
		return objEvtResource;
	}	//	end of createEventResource
	
	public static String getTestGMapsMatrix(){
		return '{ '+ 
				'   "destination_addresses" : [ "San Francisco, CA, USA" ], '+ 
				'   "origin_addresses" : [ "Vancouver, BC, Canada" ], '+ 
				'   "rows" : [ '+ 
				'      { '+ 
				'         "elements" : [ '+ 
				'            { '+ 
				'               "distance" : { '+ 
				'                  "text" : "1,529 km", '+ 
				'                  "value" : 1528699 '+ 
				'               }, '+ 
				'               "duration" : { '+ 
				'                  "text" : "14 hours 56 mins", '+ 
				'                  "value" : 53777 '+ 
				'               }, '+ 
				'               "status" : "OK" '+ 
				'            } '+ 
				'         ] '+ 
				'      } '+ 
				'   ], '+ 
				'   "status" : "OK" '+ 
				'}';
	}
	
	public static Order__c createOrder(integer counter, 
										Program__c objProgram, 
										string orderType, 
										string limeadeParticipantCode,
										date dateOfTest,
										string patientFirstName,
										string patientLastName,
										string patientEmail,
										date patientDOB){
		
		Order__c objOrder = new Order__c(ProgramID__c = objProgram.Id, 
											Order_Type__c = orderType, 
											Limeade_Participant_Code__c = limeadeParticipantCode,
											Date_of_Test__c = dateOfTest,
											PatientFirstName__c = patientFirstName,
											PatientLastName__c =  patientLastName,
											PatientEmailH__c = patientEmail,
											PatientDOB__c = patientDOB);
		
		return objOrder;		
	}
}	//	end of TestUtility