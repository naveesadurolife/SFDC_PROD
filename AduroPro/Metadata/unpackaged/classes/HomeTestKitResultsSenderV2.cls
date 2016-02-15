/*******************************************************************************
Author: Caspar Harmer
Email: charmer@soliantconsulting.com
Description:  Send results to Limeade in batches

String sch = '0 0 * * * ?'; //runs every hour.
system.schedule('AutoLimeadeSender', sch, new OrderTransferMarshaller());
********************************************************************************/
global class HomeTestKitResultsSenderV2 implements Database.Batchable<sObject>, Database.AllowsCallouts {

   //global final Id program;
   
   private String employer {get;set;}
   private Boolean ignoreTransferSetting {get;set;}
   
   String xmlData = '';
   
   global HomeTestKitResultsSenderV2(){ 
   		setDefaults();
   }

   global HomeTestKitResultsSenderV2(String employer, Boolean ignoreTransferSetting){
		setDefaults();
		//if this query is going to be just for a particular program, then the id will be passed in.
		this.employer = employer;
		this.ignoreTransferSetting = ignoreTransferSetting;
   }

   	private void setDefaults() {
		this.employer = '';
		this.ignoreTransferSetting = false;
	}
	

   global Database.QueryLocator start(Database.BatchableContext BC){
   	
   		System.debug( logginglevel.FINE, 'Query locator has begun...' );
   	
   		String query = '';
   		String transferClause = ' AND ProgramID__r.Prevent_Automatic_Results_Transfer__c != true ';
		Set<String> SetLimeadeSendOrderTypes=Constant.SetLimeadeSendOrderTypes;
		query = 'SELECT PatientEmailH__c, Order_Status__c, Limeade_E__c, Limeade_PSK__c, EmployeeID__c,' +
						' ProgramID__r.Limeade_Live_Date__c, Limeade_Transfer_Complete__c, BF__c, ' + 
						' ProgramID__r.Limeade_Identifier_DOB__c,ProgramID__r.Limeade_Identifier_Email__c,ProgramID__r.Limeade_Identifier_Employee_ID__c,ProgramID__r.Limeade_Identifier_LastName__c,'+
						' Height_Feet__c, Height_Inches__c, Weight__c, BMI__c, RLdl__c, RHdl__c, ' +
						' RTrig__c, RCho__c,RFpg__c, BP_Systolic__c, BP_Diastolic__c , Limeade_Transfer_First_Failed__c, '  +
						' PatientFirstName__c, PatientLastName__c , PatientDOB__c, PatientGender__c ,' +		
						' BP_Systolic_Best__c,BP_Diastolic_Best__c,BMI_Best__c,RFpg_Best__c,RCho_Best__c,RHdl_Best__c,'+
						'RLdl_Best__c,LDL_HDL_Ratio_Best__c,Waist_to_Height_Ratio_Best__c,BF_Best__c,HR_Pulse_Best__c,'+
						'TC_HDL_Ratio_Best__c,RTrig_Best__c,Tobacco_Free_Best__c,Height_Inches_Best__c,Height_Feet_Best__c,Weight_Best__c,Limeade_Participant_Code__c '+							
				' FROM Order__c' + 
				' WHERE Order_Status__c=\'Received\'' +
					  ' AND ( ProgramID__r.Program_Status__c != \'Draft\' AND ProgramID__r.Program_Status__c != \'Cancelled\' )' +
					  ' AND ProgramID__r.Limeade_Live_Date__c < TOMORROW '  +
				      //' AND Limeade_E__c = \''+ employer + '\'' +
				      ' AND Order_Type__c IN :SetLimeadeSendOrderTypes '+
				      ' AND In_Limeade__c=\'Yes\' '+
				      //' AND ( Order_Type__c = \'HTK\' OR Order_Type__c = \'Onsite Test\'  OR Order_Type__c = \'Physician Form\' )' +
				      ' AND Order__c.Prevent_Limeade_Transfer__c != true ' +
						transferClause ;
						
						//order type clause:
						//' AND Order_Type__c = \'HTK\'' +


		System.debug( logginglevel.FINE, ignoreTransferSetting );
		System.debug( logginglevel.FINE, query );
		
		return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<Order__c> scope){

		System.debug( logginglevel.FINE, 'Soliant: batch process beginning' );
		System.debug( logginglevel.FINE, scope );

		executeHelper(scope);

	}
	
	global void finish(Database.BatchableContext BC){
	}
	
	public void executeHelper ( List<Order__c> scope) {

		Order__c[] orderSubset = new Order__c[]{};
		//Order__c[] orderSubset = new Order__c[]{};
		
   	   	String e = '';
   	   	String psk = '';

		if (scope.size() == 0) {
			return;
		}

		xmlData = '';
		
		String email = '';
		String employeeid = '';
		String patientfname = '';
		String patientlname = '';
		String heightfeet = '';
		String heightinches = '';
		String weight = '';
		String bmi = '';
		String bodyfat = '';
		String ldlcholesterol = '';
		String hdlcholesterol = '';
		String triglycerides = '';
		String totalcholesterol = '';
		String bloodpressuresystolic = '';
		String bloodpressurediastolic = '';
		String bloodglucose = '';
		String gender = '';
		String birthdate = '';
		

		
		Integer counter = 0;  
		
		
		for(Order__c o : scope){
			
			
			if(o.ProgramID__r.Limeade_Identifier_Employee_ID__c || o.ProgramID__r.Limeade_Identifier_Email__c)
			{
				orderSubset.add(o);
				e = o.Limeade_E__c;
				psk = o.Limeade_PSK__c;
				if (xmlData =='') {
					xmlData = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Document>';
				}
				employeeid = o.EmployeeID__c != null ?						' employeeid="' + o.EmployeeID__c  + '"' : ' employeeid=""' ;
				email = o.PatientEmailH__c != null ?						' email="' + o.PatientEmailH__c  + '"' : '' ;
	
				patientfname = o.PatientFirstName__c != null ?				' firstname="' + o.PatientFirstName__c  + '"' : '' ;
				patientlname = o.PatientLastName__c != null ?				' lastname="' + o.PatientLastName__c  + '"' : '' ; 
				heightfeet = o.Height_Feet_Best__c != null ?						' heightfeet="' + Integer.valueOf(o.Height_Feet_Best__c)  + '"' : '' ;
				heightinches = o.Height_Inches_Best__c != null ?					' heightinches="' + Integer.valueOf(o.Height_Inches_Best__c)  + '"' : '' ; 
				weight = o.Weight_Best__c != null ?								' weight="' + Integer.valueOf(o.Weight_Best__c)  + '"' : '' ;               
				bmi = o.BMI_Best__c != null ?									' bmi="' + (Decimal)o.BMI_Best__c.setScale(1)  + '"' : '' ;                
				bodyfat = o.BF_Best__c != null ?									' bodyfat="' + (Decimal)o.BF_Best__c.setScale(1)  + '"' : '' ;             
				ldlcholesterol = o.RLdl_Best__c != null ?						' ldlcholesterol="' + Integer.valueOf(o.RLdl_Best__c)  + '"' : '' ;       
				hdlcholesterol = o.RHdl_Best__c != null ?						' hdlcholesterol="' + Integer.valueOf(o.RHdl_Best__c)  + '"' : '' ;        
				triglycerides = o.RTrig_Best__c != null ?						' triglycerides="' + Integer.valueOf(o.RTrig_Best__c)  + '"' : '' ;           
				totalcholesterol =   o.RCho_Best__c != null ?					' totalcholesterol="' + (Decimal)o.RCho_Best__c.setScale(1)  + '"' : '' ;       
				bloodpressuresystolic = o.BP_Systolic_Best__c != null ?			' bloodpressuresystolic="' + Integer.valueOf(o.BP_Systolic_Best__c)  + '"' : '' ;   
				bloodpressurediastolic = o.BP_Diastolic_Best__c != null ?		' bloodpressurediastolic="' + Integer.valueOf(o.BP_Diastolic_Best__c)  + '"' : '' ;
				bloodglucose = o.RFpg_Best__c != null ?							' bloodglucose="' + Integer.valueOf(o.RFpg_Best__c)  + '"' : '' ;		
	
				if (o.PatientGender__c != null) {
					String g = o.PatientGender__c.toUpperCase();
					
					if (g == 'F' || g == 'FEMALE'){
						gender = ' gender="' + 'F'  + '"';
					}
					else if (g == 'M' || g == 'MALE'){
						gender = ' gender="' + 'M'  + '"';
					}
					else gender = '';
					
				}
				if (o.PatientDOB__c != null) {
					Datetime dt = Datetime.newInstance(o.PatientDOB__c, Time.newInstance(0, 0, 0, 0));
					birthdate = ' birthdate="' + dt.format('MM/dd/yyyy')  + '"' ;
				}
				
				xmlData += '<Participant' + 
					(o.ProgramID__r.Limeade_Identifier_Employee_ID__c? employeeid:'') +
					(o.ProgramID__r.Limeade_Identifier_Email__c?email:'') + 
					patientfname +                    
					(o.ProgramID__r.Limeade_Identifier_LastName__c?patientlname:'') +    
					heightfeet +                    
					heightinches +                    
					weight +                          
					bmi +  
					bodyfat +                           
					ldlcholesterol +                  
					hdlcholesterol +                  
					triglycerides +                   
					totalcholesterol +                
					bloodpressuresystolic +            
					bloodpressurediastolic +  
					bloodglucose +
					//gender + 
					//(o.ProgramID__r.Limeade_Identifier_DOB__c?birthdate:'') +
					'/>';
					
				counter += 1; 
				//send data on every third record
				//if (Math.mod(counter,3) == 0 && counter < 31) {
					xmlData += '</Document>';
					if ( upload(xmlData, e, psk, orderSubset.size()) ) {
			  			setSuccess(orderSubset);
					}else {
						setFailure(orderSubset);//else, we had a failure - try sending again next time
					}
					xmlData = '';
					orderSubset.clear();
				//}
			}
		}
		if (xmlData != '' && counter < 31) {
			xmlData += '</Document>';
			if ( upload(xmlData, e, psk,orderSubset.size()) ) {
	  			setSuccess(orderSubset);
			}else {
				setFailure(orderSubset);//else, we had a failure - try sending again next time
			}
		}
		if(!Test.isRunningTest())
			update scope;
		//System.debug( logginglevel.FINE, 'PROCESSED_LIST' + scope );

	}
  
    public Boolean upload(String xmlData, String e, String psk, Integer numOrders){
    
    	String successMessage = numOrders+' rows succeeded';//numOrders + ' biometric screening records uploaded';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(59000);
        
        String url = Constant.LIMEMADE_API+'Upload.ashx?' ;
		        	
		String body = 'e=' +    EncodingUtil.urlEncode(e, 'UTF-8') + 
		        	'&psk=' +  EncodingUtil.urlEncode(psk, 'UTF-8') +
		        	'&type=Biometrics' + 
		        	'&format=XML' +
		        	'&biosrc=WellMetrics' + 
//		        	'&data=' +  EncodingUtil.urlEncode(xmlData, 'UTF-8') +
 					'&data=' +  xmlData +
		        	'&debug=true&response=XML';
		system.debug('body======='+body);
		{
			/*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {'gullwall@gmail.com'}; 
			mail.setToAddresses(toAddresses);
			mail.setSubject('Error');
			mail.setHtmlBody(body);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
			//Account a=[Select How_to_Award_Pts_in_Limeade__c From Account where id='001Q000000crXlJ'];
			//a.How_to_Award_Pts_in_Limeade__c+='=='+body;
			//update a;			
		}
		req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Length', url.length().format());
        req.setBody(body);
        System.debug( logginglevel.FINE, 'SOLIANT -------------------------->>DATA : ' + xmlData );
        System.debug( logginglevel.FINE, 'SOLIANT -------------------------->>BODY : ' + body );
        System.debug( logginglevel.FINE, 'SOLIANT -------------------------->>Request: ' + req );
		//try {
			HttpResponse res ;
			if (!Test.isRunningTest()) {
				res = h.send(req);
			}
			else if (Test.isRunningTest())
			{
				res = new HttpResponse();
				res.setBody('<?xml version="1.0" encoding="utf8"?> <ImportJob Status="error" Message="At least one row failed to Import to database." Description="Import BiometricsMapping 6/17/2013 on SERVER1" ReportName="BiometricsCSV" ProviderName="limeadeprovider" EmployerName="Fabrikam" ArchiveFileSize="1050" ImportTotalRowCount="8" ImportSuccessRowCount="7" ImportFailedRowCount="0" ImportSkipRowCount="0" IntegrationTotalRowCount="7" IntegrationSuccessRowCount="4" IntegrationFailureRowCount="3" IntegrationSkipRowCount="0" IntegrationAddRowCount="2" IntegrationUpdateRowCount="2" IntegrationDeleteRowCount="0" /> ');			
			}			
			System.debug( logginglevel.FINE, 'SOLIANT - http result: ' + res );
			System.debug( logginglevel.FINE, 'SOLIANT - results body: ' + res.getBody() );
         Dom.Document doc = res.getBodyDocument();
         Dom.XMLNode response = doc.getRootElement();
         String status = response.getAttribute('Status', null);
         String IntegrationSuccessCount = response.getAttribute('IntegrationSuccessRowCount', null);
		System.debug( 'status -------------------------->>status: ' + status );
		System.debug( 'IntegrationSuccessCount -------------------------->>IntegrationSuccessCount: ' + IntegrationSuccessCount );				
			if ( res.getStatusCode() == 200 ) {
				if(status.toLowerCase()=='success' && Integer.valueOf(IntegrationSuccessCount)==numOrders )
				{
					return true;
				}
				/*if(res.getBody().contains(successMessage)){
					return true;
				}*/
			}
		//}//catch (Exception excep) {
		//	System.debug('EXCEPTION============'+excep.getMessage());
		//	System.debug('EXCEPTION============'+excep.getStackTraceString());
		//}
		return false;

    }
    
    	
	public void setSuccess (List<Order__c> items) {
		DateTime dt = System.now();
		for(Order__c o : items){
			o.Order_Status__c = 'Sent Limeade';
			o.Limeade_Transfer_Complete__c = dt;
			o.Limeade_Transfer_First_Failed__c = null;
		}
	}
	public void setFailure (List<Order__c> items) {
		DateTime dt = System.now();
		for(Order__c o : items){
			if (o.Limeade_Transfer_First_Failed__c == null) {
				o.Limeade_Transfer_First_Failed__c = dt;
			}
		}
	}
	/*private String getUrlParameterAsDoubleString(String param, Integer value) {
		return this.getUrlParameterAsDoubleString(param, Double.valueOf(value));
	}
	private String getUrlParameterAsDoubleString(String param, Double value) {
		if (value != null) {
			return ' ' + param + '="' + Double.valueOf(value)  + '"';
		}else {
			return '';
		}
	}
	
	private String getUrlParameterAsIntegerString(String param, Double value) {
		return this.getUrlParameterAsIntegerString(param, Integer.valueOf(value));
	}
	private String getUrlParameterAsIntegerString(String param, Integer value) {
		if (value != null) {
			return ' ' + param + '="' + Integer.valueOf(value)  + '"';
		}else {
			return '';
		}
	}*/
    
    //used in for testing the database call.
	public void checkDatabaseCall() {

		/*								  
		List<Order__c> orders = [	SELECT 	PatientEmailH__c, Order_Status__c, Limeade_E__c, Limeade_PSK__c, EmployeeID__c, 
											ProgramID__r.Limeade_Live_Date__c, Limeade_Transfer_Complete__c, 
											Height_Feet__c, Height_Inches__c, Weight__c, BMI__c, RLdl__c, 
											RHdl__c, RTrig__c, RCho__c, BP_Systolic__c, BP_Diastolic__c 
									FROM Order__c
									WHERE Order__c.Order_Status__c = 'Received' 
										AND Order__c.Limeade_E__c = 'wellmetrics demo' 
				      					AND ( Order_Type__c = 'HTK' OR Order_Type__c = 'Onsite Test' ) ];
										 
										  
   									
   		System.debug( logginglevel.FINE, orders );
   									
   		executeHelper(orders);*/

	}
	
	static testMethod void test1HomeTestKitResultsSenderV2() {
        Test.StartTest();
        HomeTestKitResultsSenderV2 rs = new HomeTestKitResultsSenderV2('wellmetric demo', true);
        ID batchprocessid = Database.executeBatch(rs);
   		Test.StopTest();
    }
    
    static testMethod void test2HomeTestKitResultsSenderV2() {      
        Program__c testProgram = TestDataGenerator.getOneProgram();
        Order__c[] orders = new List<Order__c>();
        Set<Id> orderIds = new Set<Id>();
        for( Integer i = 0; i < 5; i++ ){
				Order__c theOrder = new Order__c( 
					ProgramID__c = testProgram.Id, 
					PatientFirstName__c = 'Pat_'+i,
					PatientLastName__c = 'SoliantBear_'+i,
					PatientEmailH__c = i+'pb@example.com',
					PatientDOB__c = date.newinstance(1960, 2, 17),
					Order_Type__c = 'HTK',
					Order_Status__c = 'Received',
					Limeade_Participant_Code__c='123asas'
				);				
				orders.add( theOrder );
		}
		for( Integer i = 5; i < 10; i++ ){
				Order__c theOrder = new Order__c( 
					ProgramID__c = testProgram.Id, 
					PatientFirstName__c = 'Pat_'+i,
					PatientLastName__c = 'SoliantBear_'+i,
					PatientEmailH__c = i+'pb@example.com',
					PatientDOB__c = date.newinstance(1960, 2, 17),
					Order_Type__c = 'HTK',
					Order_Status__c = 'Received',
					Height_Feet__c = 6.0, Height_Inches__c = 3.0,
        			Weight__c = 200.00, BMI__c = 30.00,
        			RLdl__c = 345.0, RHdl__c = 345.0, RTrig__c = 345.0,
        			RCho__c = 345.0, BP_Systolic__c = 345.0, BP_Diastolic__c = 345.0, RFpg__c = 40.0,Limeade_Participant_Code__c='123asas'
				);				
				orders.add( theOrder );
		}
        insert orders;
       
        testProgram.Prevent_Automatic_Results_Transfer__c = true;
        testProgram.Limeade_Live_Date__c = date.newinstance(2011, 12, 20);
		
		orders = [ SELECT PatientEmailH__c, Order_Status__c, Limeade_E__c, Limeade_PSK__c, ProgramID__r.Limeade_Live_Date__c, Limeade_Transfer_Complete__c, Limeade_Transfer_First_Failed__c,
				 ProgramID__r.Limeade_Identifier_DOB__c,ProgramID__r.Limeade_Identifier_Email__c,ProgramID__r.Limeade_Identifier_Employee_ID__c,ProgramID__r.Limeade_Identifier_LastName__c,
						Height_Feet__c, Height_Inches__c, Weight__c, BMI__c, RLdl__c, RHdl__c, RTrig__c, RCho__c, RFpg__c, BP_Systolic__c, BP_Diastolic__c, EmployeeID__c,  BF__c, 
						PatientFirstName__c, PatientLastName__c , PatientDOB__c, PatientGender__c,
						BP_Systolic_Best__c,BP_Diastolic_Best__c,BMI_Best__c,RFpg_Best__c,RCho_Best__c,RHdl_Best__c,
						RLdl_Best__c,LDL_HDL_Ratio_Best__c,Waist_to_Height_Ratio_Best__c,BF_Best__c,HR_Pulse_Best__c,
						TC_HDL_Ratio_Best__c,RTrig_Best__c,Tobacco_Free_Best__c,Height_Inches_Best__c,Height_Feet_Best__c,Weight_Best__c,Limeade_Participant_Code__c  
				   FROM Order__c WHERE PatientLastName__c LIKE 'SoliantBear_%' ];
		
		HomeTestKitResultsSenderV2 rs = new HomeTestKitResultsSenderV2('wellmetric demo', true);
   		rs.executeHelper(orders);
   		Order__c[] noOrders = new List<Order__c>(); 
   		rs.executeHelper(noOrders);
   		rs.upload( 'bunch of xml', 'wellmetric demo', 'b3dda09c-1317-433c-9809-359ce8f2f61f', 1);
   		
   		Test.StartTest();
        rs = new HomeTestKitResultsSenderV2('wellmetric demo', true);
        Id batchprocessid = Database.executeBatch(rs);
   		Test.StopTest();
   		
   		rs.setFailure(orders);
   		rs.setSuccess(orders);
   		
   		update orders;
   		
   		orders = [ SELECT Id FROM Order__c 
   					WHERE Order_Status__c = 'Sent Limeade' AND PatientLastName__c LIKE 'SoliantBear_%' ];
   		system.assertEquals( orders.size(), 10 );

    }


}