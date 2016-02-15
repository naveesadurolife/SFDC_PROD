/*******************************************************************************
Author: Navees Ahmed
Email: gullwall@gmail.com
Description:  
 
system.schedule('JobIndividualIncentivizer1', '0 7 * * * ?', new JobIndividualIncentivizer());
system.schedule('JobIndividualIncentivizer2', '0 22 * * * ?', new JobIndividualIncentivizer()); 
system.schedule('JobIndividualIncentivizer3', '0 37 * * * ?', new JobIndividualIncentivizer());
system.schedule('JobIndividualIncentivizer4', '0 52 * * * ?', new JobIndividualIncentivizer());
********************************************************************************/
global class JobIndividualIncentivizer  implements Schedulable,Database.Batchable<Sobject>, Database.AllowsCallouts {
	global void execute(SchedulableContext SC) {
		//check if there are 5 active batch jobs
		//In some cases, might need to add "Status='Queued' " to the criteria
		if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){ 
		    JobIndividualIncentivizer batch = new JobIndividualIncentivizer(); 
		    Id batchId = Database.executeBatch(batch,1);  
		} 
		/*else {
		   //schedule this same schedulable class again in 30 mins
		   JobIndividualIncentivizer sc = new JobIndividualIncentivizer();
		   Datetime dt = Datetime.now() + (0.024305); // i.e. 30 mins
		   String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
		   Id schedId = System.Schedule('MatrixRetry'+timeForScheduler,timeForScheduler,sc);
		}*/	    
	} 
	global Database.QueryLocator start(Database.BatchableContext info){  
		Set<String> SetLimeadeSendOrderTypes=Constant.SetLimeadeSendOrderTypes;
	 	String query='Select Id,ProgramID__r.Biometric_Completion_Incentive_Id__c,PatientEmailH__c,In_Limeade__c,Order_Status__c,Limeade_Participant_Code__c, ';
 			   query+=' Contact__c,ProgramID__r.Tests_Included_in_Results_Based_Program__c,Incentivizer_Message__c  ';
 			   query+=' From Order__c Where In_Limeade__c=\'Yes\' AND Order_Status__c=\'Sent Limeade\' AND  Limeade_Participant_Code__c!=null AND ';
 			   //query+=' ProgramID__r.Outcomes_Mg_Type__c!=null AND  ';
 			  query+=' Order_Type__c IN :SetLimeadeSendOrderTypes AND ';
 			  query+=' ProgramID__r.Biometric_Completion_Incentive_Id__c!=null AND  ';
 			  query+=' Biometric_Completion_Incentive_Sent__c=null AND  ';
 			   query+=' ProgramID__r.Tests_Included_in_Results_Based_Program__c!=null AND ';
 			   query+=' ProgramID__r.Limeade_E_Id__c!=null AND ProgramID__r.Limeade_E_Id__c!=\'\' AND ';
 			   query+=' ProgramID__r.Limeade_PSK_ID__c!=null AND ProgramID__r.Limeade_PSK_ID__c!=\'\' AND ProgramID__r.Program_Status__c=\'Active\'';
 			   query+=' AND ProgramID__r.Incentive_When_All_Test_Complete__c=true';
			  query+=' AND (Order_Type__c !=\'Physician Form\' OR (Incentivize__c=TRUE AND Order_Type__c =\'Physician Form\' AND Phys_Signature__c=\'Yes\')) ';
 			  // query+=' AND Id=\'a0Sn00000009QdZ\' ';
	 	return Database.getQueryLocator(query);  
    }  
    global void execute(Database.BatchableContext BC, List<Sobject> scope){ 
    	if(scope!=null && scope.size()>0)
    	{
    		Order__c o=(Order__c) scope[0];
    		ProcessOrder(o);
    	}
    }
    public static void ProcessOrder(Order__c o)
    {
    	if(o!=null)
    	{
    		Set<String> SetLimeadeSendOrderTypes=Constant.SetLimeadeSendOrderTypes;
    		try{
		 		o=[Select Id,
		 			PatientEmailH__c,In_Limeade__c,
		 			EmployeeID__c,
		 			Limeade_Response__c,
		 			Order_Status__c,
		 			Limeade_Participant_Code__c,
	 			    Contact__c,
	 			    Incentivizer_Message__c,
	 			    Biometric_Completion_Incentive_Sent__c,
	 			    BP_Systolic__c,BP_Diastolic__c,BMI_Calculated__c,RFpg__c,Tobacco__c,RCho__c,RHdl__c,RLdl__c,LDL_HDL_Ratio__c,
	 			    Waist_to_Height_Ratio__c,Waist__c,BF__c,HR_Pulse__c,TC_HDL_Ratio__c,TC_LDL_Ratio__c,RTrig__c,Weight__c,
	 			    Height_Inches__c,Height_Feet__c,
	 			    ProgramID__r.Tests_Included_in_Results_Based_Program__c,
	 			    ProgramID__r.Biometric_Completion_Incentive_Id__c,
	 			    ProgramID__r.Limeade_E_Id__c,
	 			    ProgramID__r.Limeade_PSK_ID__c,
	 			    ProgramId__r.Limeade_Identifier_Email__c,
	 			    ProgramId__r.Limeade_Identifier_Employee_ID__c
	 			   From Order__c 
	 			   Where In_Limeade__c='Yes' AND Order_Status__c='Sent Limeade' AND  Limeade_Participant_Code__c!=null AND
	 			         ProgramID__r.Biometric_Completion_Incentive_Id__c!=null AND
	 			  		 Biometric_Completion_Incentive_Sent__c=null AND
	 			    	 ProgramID__r.Tests_Included_in_Results_Based_Program__c!=null AND 
	 			         ProgramID__r.Limeade_E_Id__c!=null AND ProgramID__r.Limeade_E_Id__c!='' AND 
	 			   		 ProgramID__r.Limeade_PSK_ID__c!=null AND ProgramID__r.Limeade_PSK_ID__c!='' 
	 			   		 AND ProgramID__r.Program_Status__c='Active' 
	 			   		 AND Order_Type__c IN :SetLimeadeSendOrderTypes AND Id=:o.Id ];
				String[] testsIncluded=o.ProgramID__r.Tests_Included_in_Results_Based_Program__c.split(';');
				Boolean allTestsCompleted=false;
				for(String testIncluded:testsIncluded)
				{
					allTestsCompleted=false;
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE && o.BP_Systolic__c!=null && o.BP_Diastolic__c!=null)
					{
						allTestsCompleted=true;
					} 
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_BMI && o.BMI_Calculated__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_GLUCOSE && o.RFpg__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_TOBACCO && o.Tobacco__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_CHOLESTEROL && o.RCho__c!=null)
					{
						allTestsCompleted=true;
					}	
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_HDL && o.RHdl__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_TRIGLYCERIDES && o.RTrig__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_LDL && o.RLdl__c!=null)
					{
						allTestsCompleted=true;
					} 
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_HDL_LDL && o.LDL_HDL_Ratio__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_WTHR && o.Waist_to_Height_Ratio__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_BODY_FAT && o.BF__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_HEART_RATE && O.HR_Pulse__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_TCH_LDL && o.TC_LDL_Ratio__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_TCH_HDL && o.TC_HDL_Ratio__c!=null)
					{
						allTestsCompleted=true;
					} 
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_WAIST && o.Waist__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_SYSTOLIC && o.BP_Systolic__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_DIASTOLIC && o.BP_Diastolic__c!=null)
					{
						allTestsCompleted=true;
					}
					if(testIncluded==Constant.OUTCOMES_TEST_INCLUDED_WEIGHT && o.Weight__c!=null)
					{
						allTestsCompleted=true;
					}
					if(allTestsCompleted==false)
					{
						break;
					}
				}
				if(allTestsCompleted)
				{
					//String participantXML=JobOutcomesManagementNew.getIncentivePointParticipant(o.PatientEmailH__c, o.ProgramID__r.Biometric_Completion_Incentive_Id__c);
    				String participantXML = '';
					participantXML += '<Participant ';
					if(o.ProgramId__r.Limeade_Identifier_Email__c)
						participantXML += 'email="' + EncodingUtil.urlEncode(o.PatientEmailH__c, 'UTF-8')  + '"';
					if(o.ProgramId__r.Limeade_Identifier_Employee_ID__c)
						participantXML += 'employeeid="' + EncodingUtil.urlEncode(o.EmployeeID__c, 'UTF-8')  + '"';						 
					participantXML += ' incentiveevent="' + o.ProgramID__r.Biometric_Completion_Incentive_Id__c  + '"' ;
					participantXML += '/>';					
					string Participants=JobOutcomesManagementNew.getIncentivePointParticipants(participantXML);
					system.debug('Participants====================='+Participants);
					HttpResponse res = JobOutcomesManagementNew.updateIncentivePoints(o.ProgramID__r.Limeade_E_Id__c, o.ProgramID__r.Limeade_PSK_ID__c,Participants);
					String limeadeResponse='Sent='+Participants+',Response='+res.getBody();
			        Dom.Document doc = res.getBodyDocument();
			        Dom.XMLNode response = doc.getRootElement();
			        String status = response.getAttribute('Status', null); 
			        String ImportSuccessRowCount = response.getAttribute('ImportSuccessRowCount', null);
			        String IntegrationFailureRowCount = response.getAttribute('IntegrationFailureRowCount', null);
			        ImportSuccessRowCount=ImportSuccessRowCount==null?'0':ImportSuccessRowCount;
			        // && Integer.valueOf(ImportSuccessRowCount)==setTestBeingSent.size()
			        if ( 
			        		res.getStatusCode() == 200  && 
		        			Integer.valueOf(ImportSuccessRowCount)==1
		        			&& Integer.valueOf(IntegrationFailureRowCount)==0
			        	) 
			        {
			        	o.Biometric_Completion_Incentive_Sent__c=Datetime.Now();
			        }	
			        o.Limeade_Response__c=limeadeResponse;
			        update o;				 
				}			   		 
    		}
    		catch(Exception ex){} 		
    	}	
    }
    global void finish(Database.BatchableContext BC){}   
}