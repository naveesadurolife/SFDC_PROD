/*******************************************************************************
Author: Caspar Harmer
Email: charmer@soliantconsulting.com
Description:  Schedule send results to Limeade in batches

system.schedule('LimeadeOrderSendScheduler00', '0 0 * * * ?', new LimeadeOrderSendScheduler());
system.schedule('LimeadeOrderSendScheduler15', '0 15 * * * ?', new LimeadeOrderSendScheduler());
system.schedule('LimeadeOrderSendScheduler30', '0 30 * * * ?', new LimeadeOrderSendScheduler());
system.schedule('LimeadeOrderSendScheduler45', '0 45 * * * ?', new LimeadeOrderSendScheduler());
********************************************************************************/
global with sharing class LimeadeOrderSendScheduler implements Schedulable,Database.Batchable<Sobject>, Database.AllowsCallouts {
	
	global void execute(SchedulableContext sc){

		/*List<AggregateResult> employers = [	SELECT ProgramID__r.Limeade_E_Id__c FROM Order__c 
									WHERE Order_Status__c = 'Received' 
									AND ( ProgramID__r.Program_Status__c != 'Draft' OR ProgramID__r.Program_Status__c != 'Cancelled' )
									GROUP BY ProgramID__r.Limeade_E_Id__c ];
		
		Integer size = employers.size() > 5 ? 5 : employers.size();
							
		for ( Integer i = 0 ; i < size ; i++ ) { 
			LimeadeOrderSender sender = new LimeadeOrderSender(String.valueOf(employers[i].get('Limeade_E_Id__c')), false);
			//do not set higher than 30 unless you also edit the HomeTestKitResultSenderV2 to send batches bigger than 3 each (salesforce limit)
        	ID batchprocessid = Database.executeBatch(sender,10); 
		}
													
		System.debug( logginglevel.FINE, employers );
		System.debug( logginglevel.FINE, size );*/
        LimeadeOrderSendScheduler batch = new LimeadeOrderSendScheduler(); 
        Id batchId = Database.executeBatch(batch,5);		
	}
   global Database.QueryLocator start(Database.BatchableContext BC){
   	
   		System.debug( logginglevel.FINE, 'Query locator has begun...' );
   	
   		String query = ''; 
   		String transferClause =' AND ProgramID__r.Prevent_Automatic_Results_Transfer__c != true ';
		Set<String> SetLimeadeSendOrderTypes=Constant.SetLimeadeSendOrderTypes; 
		query = 'SELECT PatientEmailH__c, Order_Status__c, Limeade_E__c, Limeade_PSK__c, EmployeeID__c,' +
						' ProgramID__r.Limeade_Live_Date__c, Limeade_Transfer_Complete__c, BF__c, ' + 
						' ProgramID__r.Limeade_Identifier_DOB__c,ProgramID__r.Limeade_Identifier_Email__c,ProgramID__r.Limeade_Identifier_Employee_ID__c,ProgramID__r.Limeade_Identifier_LastName__c,'+
						' Height_Feet__c, Height_Inches__c, Weight__c, BMI__c, RLdl__c, RHdl__c, ' +
						' RTrig__c, RCho__c,RFpg__c, BP_Systolic__c, BP_Diastolic__c , Limeade_Transfer_First_Failed__c, '  +
						' PatientFirstName__c, PatientLastName__c , PatientDOB__c, PatientGender__c,Date_of_Test__c,Limeade_Biometric_Date__c, ' +		
						' BP_Systolic_Best__c,BP_Diastolic_Best__c,BMI_Best__c,RFpg_Best__c,RCho_Best__c,RHdl_Best__c,'+
						'RLdl_Best__c,LDL_HDL_Ratio_Best__c,Waist_to_Height_Ratio_Best__c,BF_Best__c,HR_Pulse_Best__c,A1C__c,A1C_Best__c,'+
						'TC_HDL_Ratio_Best__c,RTrig_Best__c,Tobacco_Free_Best__c,Height_Inches_Best__c,Height_Feet_Best__c,Weight_Best__c,Limeade_Participant_Code__c '+	
				' FROM Order__c' +  
				' WHERE Order_Status__c=\'Received\'' +
					  ' AND ( ProgramID__r.Program_Status__c = \'Active\' )' +
					  ' AND ProgramID__r.Limeade_Live_Date__c < TOMORROW '  +
				      //' AND Limeade_E__c = \''+ employer + '\'' +
				      ' AND Order_Type__c IN :SetLimeadeSendOrderTypes '+
				      ' AND In_Limeade__c=\'Yes\' '+
				      //' AND ( Order_Type__c = \'HTK\' OR Order_Type__c = \'Onsite Test\'  OR Order_Type__c = \'Physician Form\' )' +
				      ' AND Order__c.Prevent_Limeade_Transfer__c != true ' +
	   					' AND (Order_Type__c !=\'Physician Form\' OR (Order_Type__c =\'Physician Form\' AND Phys_Signature__c=\'Yes\')) '+
						transferClause ;
						
						//order type clause:
						//' AND Order_Type__c = \'HTK\'' +


		System.debug(  query );
		
		return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<Order__c> scope){

		System.debug( logginglevel.FINE, 'Soliant: batch process beginning' );
		System.debug( logginglevel.FINE, scope );
		LimeadeOrderSender los=new LimeadeOrderSender();
		los.executeHelper(scope);

	}
	global void finish(Database.BatchableContext BC){} 	
	static testmethod void test() {
		Test.startTest();
		
		// Schedule the test job 		
		String sch = '0 30 19 * * ? ' + String.valueOf(Date.today().year()); //Class runs every day at 2:30 PM during the year 2011.
		String jobId = System.schedule(
			'LimeadeOrderSendSchedulerTest'
			, sch
		    , new LimeadeOrderSendScheduler()
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
		
		Test.stopTest();
	}
}