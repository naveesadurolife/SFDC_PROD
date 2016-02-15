/*******************************************************************************
Author: Navees Ahmed
Email: gullwall@gmail.com
Description:  update orders to check if they exist in limeade
 
system.schedule('JobValidateOrders1', '0 5 * * * ?', new JobValidateOrders());
system.schedule('JobValidateOrders2', '0 20 * * * ?', new JobValidateOrders());
system.schedule('JobValidateOrders3', '0 35 * * * ?', new JobValidateOrders());
system.schedule('JobValidateOrders4', '0 50 * * * ?', new JobValidateOrders());
********************************************************************************/
global class JobValidateOrders  implements Schedulable,Database.Batchable<Sobject>, Database.AllowsCallouts {
	
    public String query = 'Select '+
		 				'ProgramID__r.Limeade_PSK_ID__c,'+
		 				'ProgramID__r.Limeade_Identifier_LastName__c,'+
	      				'ProgramID__r.Limeade_Identifier_Employee_ID__c,'+
		 				'ProgramID__r.Limeade_Identifier_Email__c,'+
	      				'ProgramID__r.Limeade_Identifier_DOB__c,'+
		 				'ProgramID__r.Limeade_E_Id__c,'+ 
		 				'ProgramID__r.Id,'+ 
		 				'ProgramID__c,'+
	      				'PatientEmailH__c,'+ 
		 				'EmployeeID__c,'+
		 				'Order_Status__c,'+
		 				'PatientLastName__c,'+
		 				'Error_Message__c,'+
		 				'PatientDOB__c,'+
		 				'Number_of_Validation_Attempt__c,'+
		 				'Last_Validation_Attempt__c '+
		 				'From Order__c '+
	      				'Where  ProgramID__r.Prevent_Automatic_Results_Transfer__c != true AND '+
	      				'( ProgramID__r.Program_Status__c != \'Draft\' AND ProgramID__r.Program_Status__c != \'Cancelled\' ) AND '+
	      				'(In_Limeade__c=null OR In_Limeade__c=\'\' OR In_Limeade__c=\'No\' ) AND (Number_of_Validation_Attempt__c=null OR Number_of_Validation_Attempt__c<3)';	
    global void execute(SchedulableContext SC) {
        JobValidateOrders batch = new JobValidateOrders(); 
        Id batchId = Database.executeBatch(batch,1);  
    }    
     global Database.QueryLocator start(Database.BatchableContext info){    
		 Set<String> SetLimeadeValidateOrderTypes=Constant.SetLimeadeValidateOrderTypes; 
		 query += ' AND Order_Type__c IN :SetLimeadeValidateOrderTypes ';
         return Database.getQueryLocator(query); 
     }  

     global void execute(Database.BatchableContext BC, List<Sobject> scope){
		 Set<Id> orderIDs=new Set<Id>();
     	for(Sobject s:scope)
     	{
     		Order__c o=(Order__c)s;
			orderIDs.add(o.Id);
			o.Number_of_Validation_Attempt__c=(o.Number_of_Validation_Attempt__c==null?1:(o.Number_of_Validation_Attempt__c+1));
			o.Last_Validation_Attempt__c=Date.today();
			LimeadeValidator lv=new LimeadeValidator();
			lv.LimeadeEID=o.ProgramId__r.Limeade_E_Id__c;
			lv.LimeadePSKID=o.ProgramId__r.Limeade_PSK_ID__c; 
			lv.LastName=o.PatientLastName__c!=null?o.PatientLastName__c:null;
			lv.DOB=o.PatientDOB__c!=null?o.PatientDOB__c.format():null;
			lv.Email=o.PatientEmailH__c!=null?o.PatientEmailH__c:null;
			lv.employeeId=o.EmployeeID__c!=null?o.EmployeeID__c:null;
			lv.IdentifierLastName=o.ProgramId__r.Limeade_Identifier_LastName__c;
			lv.IdentifierDOB=o.ProgramId__r.Limeade_Identifier_DOB__c;
			lv.IdentifierEmail=o.ProgramId__r.Limeade_Identifier_Email__c;
			lv.IdentifierEmployeeID=o.ProgramId__r.Limeade_Identifier_Employee_ID__c;
			lv.validate();
			if(String.isBlank(lv.ErrorMessage))
			{
				o.Error_Message__c='';
				o.In_Limeade__c='Yes';
				o.Limeade_Participant_Code__c=lv.LimeadeParticipantCode;
			}
			else
			{
				o.Error_Message__c=lv.ErrorMessage;
				o.In_Limeade__c='No';
			}
     		/*{
	     		String errors='';
	 			Program__c prog=new Program__c(Limeade_Identifier_Employee_ID__c=o.ProgramID__r.Limeade_Identifier_Employee_ID__c,Limeade_E_Id__c=o.ProgramID__r.Limeade_E_Id__c,Limeade_PSK_ID__c=o.ProgramID__r.Limeade_PSK_ID__c,Limeade_Identifier_LastName__c=o.ProgramID__r.Limeade_Identifier_LastName__c,Limeade_Identifier_DOB__c=o.ProgramID__r.Limeade_Identifier_DOB__c,Limeade_Identifier_Email__c=o.ProgramID__r.Limeade_Identifier_Email__c);													
				errors = LimeadeOrderValidator.validateLimeadeSecondaryCredentials(o, prog);
				o.Number_of_Validation_Attempt__c=(o.Number_of_Validation_Attempt__c==null?1:(o.Number_of_Validation_Attempt__c+1));
				o.Last_Validation_Attempt__c=Date.today();
				system.debug('errors======================='+errors);
				if(String.isBlank(errors))
				{
					o.Error_Message__c='';
					o.In_Limeade__c='Yes';
				}
				else
				{
					o.Error_Message__c=errors;
					o.In_Limeade__c='No';
				}   
     		} */ 		
     	}
     	update scope;
		OrderTriggerHandler.UpdateBestWorstScoreNow(orderIDs);
     }  

     global void finish(Database.BatchableContext BC){} 
	static testmethod void test() {
		Account acct;
		Contact con;
		Program__c currentYearProgram;
		Order__c currentYearOrder;
		acct=TestDataGenerator.getOneAccount();
		con=TestDataGenerator.getOneContact();
		currentYearProgram=TestDataGenerator.getOneProgram();
		currentYearProgram.Program_Start_Date__c=Date.newInstance(Date.today().year(), 1, 1);
		currentYearProgram.Program_End_Date__c=Date.newInstance(Date.today().year(), 12, 31);
		currentYearProgram.Program_Status__c='Active';
		currentYearProgram.Limeade_Live_Date__c=Date.today();
		currentYearProgram.Program_Manager__c=Userinfo.getUserId();
		currentYearProgram.Outcomes_Mg_Type__c='Individual';		
		update currentYearProgram;
		
		currentYearOrder = new Order__c( 
			ProgramID__c = currentYearProgram.Id, 
			Contact__c=con.Id,
			PatientFirstName__c = 'Pat_1',
			PatientLastName__c = 'SoliantBear_1',
			PatientEmailH__c = 'pb@example.com',
			PatientDOB__c = date.newinstance(1960, 2, 17),
			Order_Type__c = 'HTK',
			Order_Status__c = 'Received',
			In_Limeade__c='No',
			Height_Feet__c = 6.0, Height_Inches__c = 3.0,
			Weight__c = 100.00, BMI__c = 30.00,
			RLdl__c = 100.0, RHdl__c = 100.0, RTrig__c = 100.0,
			RCho__c = 100.0, BP_Systolic__c = 100.0, BP_Diastolic__c = 100.0, RFpg__c = 40.0,
			Tobacco__c='Y',Waist__c=40,BF__c=3,HR_Pulse__c=66
		);
		insert currentYearOrder;		
				
		Test.startTest();
		
		// Schedule the test job 		
		String sch = '0 30 19 * * ? ' + String.valueOf(Date.today().year()); //Class runs every day at 2:30 PM during the year 2011.
		String jobId = System.schedule(
			'JobValidateOrdersTest'
			, sch
		    , new JobValidateOrders()
		);
		 
		 // Get the information from the CronTrigger API object 
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
		      				FROM CronTrigger WHERE id = :jobId];
		
		// Verify the job has not run 
		System.assertEquals(0, ct.TimesTriggered);
		
		// Verify the next time the job will run 
		String nextrun = String.valueOf(Date.today().year()) + '-'
							+ String.valueOf(Date.today().month()) + '-'
							+ String.valueOf(Date.today().day())
							+ ' 19:30:00';
		
		System.assert( ct.NextFireTime > Datetime.now() );
		
		currentYearOrder.EmployeeID__c = '41';
		currentYearOrder.PatientLastName__c = 'Bloggs';
		currentYearOrder.PatientEmailH__c = 'ray@gmail.com';
		currentYearOrder.PatientDOB__c = date.newinstance(1976, 12, 3);	
		update currentYearOrder;
        JobValidateOrders batch1 = new JobValidateOrders(); 
        Id batchId1 = Database.executeBatch(batch1,1); 	
        
        Database.executeBatch(new JobValidateProgramContacts(currentYearProgram.Id), 10); 
        	
		Test.stopTest();
	}     
}