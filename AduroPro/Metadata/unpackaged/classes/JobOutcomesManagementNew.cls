/*******************************************************************************
Author: Navees Ahmed
Email: gullwall@gmail.com
Description:  
 
system.schedule('JobOutcomesManagementNew1', '0 5 * * * ?', new JobOutcomesManagementNew());
//system.schedule('JobOutcomesManagementNew2', '0 20 * * * ?', new JobOutcomesManagementNew()); 
system.schedule('JobOutcomesManagementNew3', '0 35 * * * ?', new JobOutcomesManagementNew());
//system.schedule('JobOutcomesManagementNew4', '0 50 * * * ?', new JobOutcomesManagementNew());
********************************************************************************/
global class JobOutcomesManagementNew  implements Schedulable,Database.Batchable<Sobject>, Database.AllowsCallouts {
	global void execute(SchedulableContext SC) {
	    JobOutcomesManagementNew batch = new JobOutcomesManagementNew(); 
	    Id batchId = Database.executeBatch(batch,1);  
	} 
	global Database.QueryLocator start(Database.BatchableContext info){  
		Set<String> SetLimeadeSendOrderTypes=Constant.SetLimeadeSendOrderTypes;
	 	String query='Select Id,ProgramID__r.Improvement_Type__c,ProgramID__r.Outcomes_Mg_Type__c,PatientEmailH__c,In_Limeade__c,Order_Status__c,Limeade_Participant_Code__c, ';
 			   query+=' Contact__c,ProgramID__r.Tests_Included_in_Results_Based_Program__c,Incentivizer_Message__c  ';
 			   query+=' From Order__c Where In_Limeade__c=\'Yes\' AND Order_Status__c=\'Sent Limeade\' AND  Limeade_Participant_Code__c!=null AND ';
 			   query+=' ProgramID__r.Outcomes_Mg_Type__c!=null AND  ';
 			   query+=' Order_Type__c IN :SetLimeadeSendOrderTypes AND ';
 			   query+=' ProgramID__r.Tests_Included_in_Results_Based_Program__c!=null AND ';
 			   query+=' ProgramID__r.Limeade_E_Id__c!=null AND ProgramID__r.Limeade_E_Id__c!=\'\' AND ';
 			   query+=' ProgramID__r.Limeade_PSK_ID__c!=null AND ProgramID__r.Limeade_PSK_ID__c!=\'\' AND Incentive_Sent__c=false AND ProgramID__r.Program_Status__c=\'Active\'';
 			  // query+=' AND Id=\'a0Sn00000008Rjp\' ';
	 	return Database.getQueryLocator(query);  
    }  
    global void execute(Database.BatchableContext BC, List<Sobject> scope){ 
    	if(scope!=null && scope.size()>0)
    	{
    		Order__c o=(Order__c) scope[0];
    		ProcessOrder(o);
    	}
    }
    global void finish(Database.BatchableContext BC){}    
    public static void ProcessOrder(Order__c o)
    {
   		String testToBePerformed;
    	//Map<Id,Order__c> mapOrders;
    	Program__c p;
    	Map<String,Range> mapRanges=new Map<String,Range>();
    	Order newOrder;
    	Order oldOrder;
    	if(o==null || String.isBlank(o.Limeade_Participant_Code__c))
    	{
    		return;
    	}
    	else if(o.ProgramID__r.Outcomes_Mg_Type__c.contains('Group'))
    	{
    		List<Contact> listC=[Select id From Contact Where Limeade_ParticipantCode__c=:o.Limeade_Participant_Code__c];
    		if(listC.size()>1)
    		{
    			o.Incentivizer_Message__c='Multiple Contacts with same Limeade Participant Code.';
    			update o;
    			return;
    		}
    	}
    	if(o!=null)
    	{
    		o =[Select Weight__c, Weight_Sent__c, Waist_to_Height_Ratio__c, Waist_to_Height_Ratio_Sent__c, Waist__c, 
    								Waist_Sent__c, Tobacco__c, Tobacco_Free_Sent__c, TC_HDL_Ratio__c, TC_HDL_Ratio_Sent__c, RTrig__c, 
    								RTrig_Sent__c, RLdl__c, RLdl_Sent__c, RHdl__c, RHdl_Sent__c, RFpg__c, RFpg_Sent__c, RCho__c, RCho_Sent__c, 
    								ProgramID__r.Name, ProgramID__r.Id, ProgramID__c, Prevent_Limeade_Transfer__c, Order_Type__c, 
    								Order_Status__c, OrderDate__c, LDL_HDL_Ratio__c, LDL_HDL_Ratio_Sent__c, In_Limeade__c, 
    								Height_Total_Inches__c, Height_Total_Inches_Sent__c, Height_Inches__c, Height_Inches_Sent__c, 
    								Height_Ft_Sent__c, Height_Feet__c, Heart_Rate_Sent__c, HR_Pulse__c, Fasting_Y_N__c, Contact__c, 
    								Body_Fat_Sent__c, BP_Systolic__c, BP_Systolic_Sent__c, BP_Diastolic__c, BP_Diastolic_Sent__c, BMI__c, 
    								BMI_Sent__c, BF__c, Account__c,PatientEmailH__c,PatientGender__c,Limeade_Response__c,Incentive_Sent__c,
    								ProgramID__r.Program_Start_Date__c,ProgramID__r.Program_End_Date__c,ProgramID__r.Program_Status__c,
    								Orders_Compared_Best__c,Orders_Compared_Worst__c,
									A1C__c,A1C_Best__c,A1C_Worst__c,Points_A1C__c,Results_A1C__c,A1C_Sent__c
	    							,BP_Systolic_Best__c,BP_Diastolic_Best__c,BMI_Best__c,RFpg_Best__c,RCho_Best__c,RHdl_Best__c,RTrig_Best__c,
									RLdl_Best__c,LDL_HDL_Ratio_Best__c,Waist_to_Height_Ratio_Best__c,BF_Best__c,HR_Pulse_Best__c,TC_HDL_Ratio_Best__c
									,BP_Systolic_Worst__c,BP_Diastolic_Worst__c,BMI_Worst__c,RFpg_Worst__c,RCho_Worst__c,RHdl_Worst__c,RTrig_Worst__c,
									RLdl_Worst__c,LDL_HDL_Ratio_Worst__c,Waist_to_Height_Ratio_Worst__c,BF_Worst__c,HR_Pulse_Worst__c,TC_HDL_Ratio_Worst__c,
									Results_HDL_LDL__c,Results_BMI__c,Results_Body_Fat__c,Results_BP__c,Results_Glucose__c,Results_HDL__c,Results_Heart_Rate__c,
									Results_LDL__c,Results_TCH_HDL__c,Results_Tobacco_Free__c,Results_Waist_Height__c,Results_TChol__c,Results_Trig__c,
									Points_BMI__c,Points_Body_Fat__c,Points_BP__c,Points_Glucose__c,Points_HDL__c,Points_Heart_Rate__c,
									Points_LDL__c,Points_TChol__c,Points_Tobacco_Free__c,Points_Trig__c,Points_Wst_Ht__c,Tests_Met_The_Criteria__c,
									TC_LDL_Ratio_Sent__c,Results_TCH_LDL__c,TC_LDL_Ratio_Best__c,TC_LDL_Ratio_Worst__c,
									Waist_Best__c,Waist_Worst__c,Results_Waist__c,Points_Wst__c,Tests_Not_Met_The_Criteria__c,
									Results_Systolic__c,Results_Diastolic__c,Points_Systolic__c,Points_Diastolic__c,
									Medically_Inadvisable__c,Physician_Alternative_Action__c,
									Weight_Best__c,Weight_Worst__c,Results_Weight__c,EmployeeID__c																				    								
    								From Order__c Where Id=:o.Id AND Limeade_Participant_Code__c!=null];
    		try
    		{
				/*Individual_Waist_Height_ID__c,
				Individual_Waist_ID__c,
				Individual_Triglyceride_ID__c,
				Individual_TChol_ID__c,
				Individual_TCH_HDL__c,
				Individual_TCH_LDL__c,
				Individual_LDL_ID__c,
				Individual_Heart_Rate_ID__c,
				Individual_HDL_ID__c,
				Individual_Body_Fat_ID__c,
				Individual_BP_ID__c,
				Individual_Glucose_ID__c,
				Individual_BMI_ID__c,
				Individual_Tobacco_Free_ID__c,
				Individual_HDL_LDL_ID__c,
				Individual_Diastolic_ID__c,
				Individual_Systolic_ID__c,*/    			
				p=[Select Limeade_E_Id__c,Limeade_PSK_ID__c,Tests_Included_in_Results_Based_Program__c,Program_Status__c,
							Outcomes_Mg_Type__c,Number_of_Passes_Needed__c,Improvement_Type__c,Group_XX_ID__c,
							Pts_BMI__c,
							Pts_Body_Fat__c,
							Pts_BP__c,
							Pts_Glucose__c,
							Pts_HDL__c,
							Pts_Heart_Rate__c,
							Pts_LDL__c,
							Pts_TChol__c,
							Pts_Tobacco_Free__c,
							Pts_Triglycerides__c,
							Pts_Waist_Height__c,
							Pts_Waist__c,
							Pts_Diastolic__c,
							Pts_Systolic__c,		
							Pts_Weight__c,
							Pts_A1C__c,
	 			    		Limeade_Identifier_Email__c,
	 			    		Limeade_Identifier_Employee_ID__c,												
							(Select Id, Program__c, Test_Type__c, Male_Low__c, Male_High__c, Male_Number__c, 
							Female_Low__c, Female_High__c, Female_Number__c,Improvement_Id__c,Incentive_ID__c,
							Medically_Inadvisable_Id__c,Physician_Alternative_Action_Qualified__c 
							From Ranges__r) 
						From Program__c 
						Where Id=:o.ProgramID__c
						AND Outcomes_Mg_Type__c!=null
						AND Tests_Included_in_Results_Based_Program__c!=null
						AND Limeade_E_Id__c!=null AND Limeade_E_Id__c!='' 
						AND Limeade_PSK_ID__c!=null AND Limeade_PSK_ID__c!=''
						AND Prevent_Automatic_Incentivation_Transfer__c=false
						AND Program_Status__c='Active']; 
				testToBePerformed=p.Tests_Included_in_Results_Based_Program__c;
				for(Range__c r:p.Ranges__r)
				{
					Range ra=new Range();
					ra.testType=r.Test_Type__c;
					ra.incentiveId=r.Incentive_Id__c;
					ra.improvementId=r.Improvement_Id__c;
					ra.medicallyInadvisableId=r.Medically_Inadvisable_Id__c;
					ra.physicianAlternativeAction=r.Physician_Alternative_Action_Qualified__c;
					if(!String.isBlank(o.PatientGender__c) && o.PatientGender__c=='Male')
					{
						ra.low=r.Male_Low__c;
						ra.high=r.Male_High__c;
						ra.impNumber=(r.Male_Number__c==null?0:r.Male_Number__c);
					}
					else
					{
						ra.low=r.Female_Low__c;
						ra.high=r.Female_High__c;
						ra.impNumber=(r.Female_Number__c==null?0:r.Female_Number__c);						
					}
					mapRanges.put(r.Test_Type__c,ra);
				}
    		}
    		catch(Exception ex){}
    		if(o!=null && p!=null && mapRanges.size()>0 && o.Contact__c!=null && o.In_Limeade__c!=null && o.In_Limeade__c=='Yes' && o.Order_Status__c!=null && o.Order_Status__c=='Sent Limeade' && p.Tests_Included_in_Results_Based_Program__c!=null)
    		{
    			Boolean isImprovement=!String.isBlank(p.Improvement_Type__c);
    			newOrder=new Order();
    			newOrder=calculateImprovement(newOrder,o,p,mapRanges);
    			newOrder=updateWithInRangeAndResult(o,newOrder,mapRanges,testToBePerformed);
    			newOrder.MedicallyInadvisable=String.isBlank(o.Medically_Inadvisable__c)?'':o.Medically_Inadvisable__c;
    			newOrder.PhysicianAlternativeAction=String.isBlank(o.Physician_Alternative_Action__c)?false:(o.Physician_Alternative_Action__c=='Yes'?true:false);
    			system.debug('newOrder===============***********'+newOrder);
				Set<String> setTestBeingSent=new Set<String>();
				String groupParticipants='';
				String individualParticipants='';
				system.debug('newOrder.BPSystolicIsIncluded && newOrder.BPDiastolicIsIncluded==============================='+newOrder.BPSystolicIsIncluded +'_' +newOrder.BPDiastolicIsIncluded);
				system.debug('newOrder.BPSystolicIsWithInRange && newOrder.BPDiastolicIsWithInRange==============================='+newOrder.BPSystolicIsWithInRange +'_' +newOrder.BPDiastolicIsWithInRange);
				system.debug('newOrder.BPSystolicIsImproved && newOrder.BPDiastolicIsImproved==============================='+newOrder.BPSystolicIsImproved +'_' +newOrder.BPDiastolicIsImproved);
				//&& newOrder.BPDiastolicIsIncluded
				if(
					newOrder.BPIsIncluded 
					&& (
						(newOrder.BPSystolicIsWithInRange && newOrder.BPDiastolicIsWithInRange) || 
						(isImprovement && newOrder.BPSystolicIsImproved && newOrder.BPDiastolicIsImproved) ||
						(newOrder.BPSystolicIsWithInRange && isImprovement && newOrder.BPDiastolicIsImproved) ||
						(newOrder.BPDiastolicIsWithInRange && isImprovement && newOrder.BPSystolicIsImproved)  ||
						newOrder.MedicallyInadvisable.contains(Constant.OUTCOMES_MEDICALLY_INADVISABLE_BP) ||
						(newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE).physicianAlternativeAction)
						)
					)
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE+'=============');
					//system.debug('1======================'+newOrder.MedicallyInadvisable.contains(Constant.OUTCOMES_MEDICALLY_INADVISABLE_BP));
					//system.debug('2======================'+p.Outcomes_Mg_Type__c.contains('Individual'));
					//system.debug('3======================'+String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE).medicallyInadvisableId));
					if(newOrder.MedicallyInadvisable.contains(Constant.OUTCOMES_MEDICALLY_INADVISABLE_BP) && mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE) && p.Outcomes_Mg_Type__c.contains('Individual') && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE).medicallyInadvisableId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE); 
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE).medicallyInadvisableId);
					}					
					else if( mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE) && 
							((newOrder.BPSystolicIsWithInRange && newOrder.BPDiastolicIsWithInRange) || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE).physicianAlternativeAction) ) && 
							p.Outcomes_Mg_Type__c.contains('Individual') && 
							String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE); 
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE).incentiveId);
					}
					else if(isImprovement && mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE) && newOrder.BPSystolicIsImproved && newOrder.BPDiastolicIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE); 
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c)) 
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}
				} 
				if(
					newOrder.BPSystolicIsIncluded &&
					 ( newOrder.BPSystolicIsWithInRange  || (isImprovement && newOrder.BPSystolicIsImproved) || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC).physicianAlternativeAction))
					)
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_SYSTOLIC+'=============');
					if( mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC) && 
						(newOrder.BPSystolicIsWithInRange  || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC).physicianAlternativeAction)) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_SYSTOLIC);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC).incentiveId);
					}
					else if(isImprovement && mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC) && newOrder.BPSystolicIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_SYSTOLIC);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_SYSTOLIC);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}
				}
				if(
					newOrder.BPDiastolicIsIncluded
					&& ( newOrder.BPDiastolicIsWithInRange  || (isImprovement && newOrder.BPDiastolicIsImproved) || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC).physicianAlternativeAction))
					)
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_DIASTOLIC+'=============');
					if( mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC) && 
						(newOrder.BPDiastolicIsWithInRange  || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC).physicianAlternativeAction)) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_DIASTOLIC);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC).incentiveId);
					}
					else if(isImprovement && mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC) && newOrder.BPDiastolicIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_DIASTOLIC);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_DIASTOLIC);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}
				}				 				
				if(
					newOrder.BMIIsIncluded &&
					((isImprovement && newOrder.BMIIsImproved) || newOrder.BMIIsWithInRange || 
					newOrder.MedicallyInadvisable.contains(Constant.OUTCOMES_MEDICALLY_INADVISABLE_BMI) || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BMI).physicianAlternativeAction))
					)
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_BMI+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_BMI) && newOrder.MedicallyInadvisable.contains(Constant.OUTCOMES_MEDICALLY_INADVISABLE_BMI) && p.Outcomes_Mg_Type__c.contains('Individual') && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BMI).medicallyInadvisableId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BMI);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BMI).medicallyInadvisableId);
					}					
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_BMI) && 
							(newOrder.BMIIsWithInRange  || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BMI).physicianAlternativeAction)) && 
							p.Outcomes_Mg_Type__c.contains('Individual') && 
							String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BMI).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BMI);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BMI).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_BMI) && isImprovement && newOrder.BMIIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BMI).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BMI);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BMI).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BMI);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}
				if(
					newOrder.RFpgIsIncluded &&
					((isImprovement && newOrder.RFpgIsImproved) || 
						newOrder.RFpgIsWithInRange || 
						newOrder.MedicallyInadvisable.contains(Constant.OUTCOMES_MEDICALLY_INADVISABLE_GLUCOSE)  || (newOrder.physicianAlternativeAction  && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_GLUCOSE+'=============');
					
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING) && newOrder.MedicallyInadvisable.contains(Constant.OUTCOMES_MEDICALLY_INADVISABLE_GLUCOSE) && p.Outcomes_Mg_Type__c.contains('Individual') && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING).medicallyInadvisableId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_GLUCOSE);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING).medicallyInadvisableId);
					}					
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING) && 
							(newOrder.RFpgIsWithInRange  || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING).physicianAlternativeAction)) && 
							p.Outcomes_Mg_Type__c.contains('Individual') && 
							String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_GLUCOSE);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING) && isImprovement && newOrder.RFpgIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_GLUCOSE);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_GLUCOSE);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}
										
				}
				if(testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_TOBACCO) && 
					newOrder.TobaccoIsIncluded &&
					((isImprovement && newOrder.TobaccoIsImproved) || o.Tobacco__c=='Y')
					)
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_TOBACCO+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TOBACCO) && o.Tobacco__c=='Y' && p.Outcomes_Mg_Type__c.contains('Individual') && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TOBACCO).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TOBACCO);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TOBACCO).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TOBACCO) && isImprovement && newOrder.TobaccoIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TOBACCO).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TOBACCO);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TOBACCO).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TOBACCO);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}
				if(
					newOrder.RChoIsIncluded &&
					((isImprovement && newOrder.RChoIsImproved) || newOrder.RChoIsWithInRange || (newOrder.physicianAlternativeAction  && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL).physicianAlternativeAction)))				
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_CHOLESTEROL+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL) && 
						(newOrder.RChoIsWithInRange  || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL).physicianAlternativeAction))&& 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_CHOLESTEROL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL) && isImprovement && newOrder.RChoIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_CHOLESTEROL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_CHOLESTEROL);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}
				if(
					newOrder.RHdlIsIncluded && 
					((isImprovement && newOrder.RHdlIsImproved) ||newOrder.RHdlIsWithInRange  || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_HDL+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_HDL) && 
						(newOrder.RHdlIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL).physicianAlternativeAction)) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_HDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_HDL) && isImprovement && newOrder.RHdlIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_HDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_HDL);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}
				if(
					newOrder.RLdlIsIncluded && 
					((isImprovement && newOrder.RLdlIsImproved) || newOrder.RLdlIsWithInRange || 
					newOrder.MedicallyInadvisable.contains(Constant.OUTCOMES_MEDICALLY_INADVISABLE_LDL) || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_LDL).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_LDL+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_LDL) && newOrder.MedicallyInadvisable.contains(Constant.OUTCOMES_MEDICALLY_INADVISABLE_LDL) && p.Outcomes_Mg_Type__c.contains('Individual') && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_LDL).medicallyInadvisableId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_LDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_LDL).medicallyInadvisableId);
					}					
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_LDL) && 
							(newOrder.RLdlIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_LDL).physicianAlternativeAction)) && 
							p.Outcomes_Mg_Type__c.contains('Individual') && 
							String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_LDL).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_LDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_LDL).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_LDL) && isImprovement && newOrder.RLdlIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_LDL).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_LDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_LDL).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_LDL);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}
				if(
					newOrder.LDLHDLRatioIsIncluded && 
					((isImprovement && newOrder.LDLHDLRatioIsImproved) || newOrder.LDLHDLRatioIsWithInRange  || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL_LDL).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_HDL_LDL+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_HDL_LDL) && 
						(newOrder.LDLHDLRatioIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL_LDL).physicianAlternativeAction)) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL_LDL).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_HDL_LDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL_LDL).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_HDL_LDL) && isImprovement && newOrder.LDLHDLRatioIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL_LDL).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_HDL_LDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL_LDL).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_HDL_LDL);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}
				if(
					newOrder.WaistIsIncluded &&				
					((isImprovement && newOrder.WaistIsImproved) || newOrder.WaistIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_WAIST+'=============');
					if( mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_WAIST) &&  
						(newOrder.WaistIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST).physicianAlternativeAction)) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_WAIST);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_WAIST) && isImprovement && newOrder.WaistIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_WAIST);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_WAIST);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}				
				if(
					newOrder.WaistToHeightRatioIsIncluded && 
					((isImprovement && newOrder.WaistToHeightRatioIsImproved) || newOrder.WaistToHeightRatioIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_WTHR+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT) && 
						(newOrder.WaistToHeightRatioIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT).physicianAlternativeAction)) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_WTHR);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT) && isImprovement && newOrder.WaistToHeightRatioIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_WTHR);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_WTHR);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}
				if(
					newOrder.BFIsIncluded && 
					((isImprovement && newOrder.BFIsImproved) || newOrder.BFIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BODY_FAT).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_BODY_FAT+'=============');
					if( mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_BODY_FAT) && 
						(newOrder.BFIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BODY_FAT).physicianAlternativeAction)) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BODY_FAT).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BODY_FAT);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BODY_FAT).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_BODY_FAT) && isImprovement && newOrder.BFIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BODY_FAT).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BODY_FAT);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BODY_FAT).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_BODY_FAT);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}
				if(
					newOrder.HRPulseIsIncluded && 			
					((isImprovement && newOrder.HRPulseIsImproved) || newOrder.HRPulseIsWithInRange || (newOrder.physicianAlternativeAction  && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HEART_RATE).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_HEART_RATE+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_HEART_RATE) &&  
						(newOrder.HRPulseIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HEART_RATE).physicianAlternativeAction )) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HEART_RATE).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_HEART_RATE);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HEART_RATE).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_HEART_RATE) && isImprovement && newOrder.HRPulseIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HEART_RATE).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_HEART_RATE);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HEART_RATE).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_HEART_RATE);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}
				if(
					newOrder.TCHDLRatioIsIncluded && 		
					((isImprovement && newOrder.TCHDLRatioIsImproved) || newOrder.TCHDLRatioIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_HDL).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_TCH_HDL+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TCH_HDL) && 
						(newOrder.TCHDLRatioIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_HDL).physicianAlternativeAction )) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_HDL).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TCH_HDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_HDL).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TCH_HDL) && isImprovement && newOrder.TCHDLRatioIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_HDL).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TCH_HDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_HDL).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TCH_HDL);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}					
				}
				if(
					newOrder.TCLDLRatioIsIncluded && 		
					((isImprovement && newOrder.TCLDLRatioIsImproved) || newOrder.TCLDLRatioIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_LDL).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_TCH_LDL+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TCH_LDL) && 
						(newOrder.TCLDLRatioIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_LDL).physicianAlternativeAction ))  && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_LDL).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TCH_LDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_LDL).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TCH_LDL) && isImprovement && newOrder.TCLDLRatioIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_LDL).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TCH_LDL);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_LDL).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TCH_LDL);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}						
				}				
				if(
					newOrder.RTrigIsIncluded && 		
					((isImprovement && newOrder.RTrigIsImproved) || newOrder.RTrigIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_TRIGLYCERIDES+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES) && 
						(newOrder.RTrigIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES).physicianAlternativeAction )) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TRIGLYCERIDES);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES) && isImprovement && newOrder.RTrigIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TRIGLYCERIDES);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_TRIGLYCERIDES);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}						
				}	
				if(
					newOrder.WeightIsIncluded && 		
					((isImprovement && newOrder.WeightIsImproved) || newOrder.WeightIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WEIGHT).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_WEIGHT+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_WEIGHT) && 
						(newOrder.WeightIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WEIGHT).physicianAlternativeAction) ) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WEIGHT).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_WEIGHT);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WEIGHT).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_WEIGHT) && isImprovement && newOrder.WeightIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WEIGHT).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_WEIGHT);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WEIGHT).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_WEIGHT);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}						
				}
				if(
					newOrder.A1CIsIncluded && 		
					((isImprovement && newOrder.A1CIsImproved) || newOrder.A1CIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_A1C).physicianAlternativeAction)))
				{
					system.debug('========='+Constant.OUTCOMES_TEST_INCLUDED_A1C+'=============');
					if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_A1C) && 
						(newOrder.A1CIsWithInRange || (newOrder.physicianAlternativeAction && mapRanges.get(Constant.OUTCOMES_TEST_TYPE_A1C).physicianAlternativeAction) ) && 
						p.Outcomes_Mg_Type__c.contains('Individual') && 
						String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_A1C).incentiveId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_A1C);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_A1C).incentiveId);
					}
					else if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_A1C) && isImprovement && newOrder.A1CIsImproved && String.isNotBlank(mapRanges.get(Constant.OUTCOMES_TEST_TYPE_A1C).improvementId))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_A1C);
						individualParticipants+=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, mapRanges.get(Constant.OUTCOMES_TEST_TYPE_A1C).improvementId);
					}					
					if(p.Outcomes_Mg_Type__c.contains('Group') && !String.isBlank(p.Group_XX_ID__c))
					{
						setTestBeingSent.add(Constant.OUTCOMES_TEST_INCLUDED_A1C);
						groupParticipants=getIncentivePointParticipant(p.Limeade_Identifier_Email__c,o.PatientEmailH__c,p.Limeade_Identifier_Employee_ID__c,o.EmployeeID__c, p.Group_XX_ID__c);
					}						
				}				
				if(!String.isBlank(individualParticipants) || !String.isBlank(groupParticipants))
				{
					if(p.Outcomes_Mg_Type__c.contains('Group'))
					{
						if(setTestBeingSent.size()>=p.Number_of_Passes_Needed__c )
							groupParticipants=groupParticipants;
						else 
						{
							groupParticipants='';
							//individualParticipants='';
						}
					}
					if(!p.Outcomes_Mg_Type__c.contains('Individual'))
					{
						individualParticipants='';
					}										
					if(!String.isBlank(individualParticipants) || !String.isBlank(groupParticipants))
					{
						string Participants=getIncentivePointParticipants(individualParticipants+groupParticipants); 
						system.debug('Participants====================='+Participants);
						HttpResponse res = updateIncentivePoints(p.Limeade_E_Id__c, p.Limeade_PSK_ID__c,Participants);
						String limeadeResponse='Sent='+Participants+',Response='+res.getBody();
				        Dom.Document doc = res.getBodyDocument();
				        Dom.XMLNode response = doc.getRootElement();
				        String status = response.getAttribute('Status', null); 
				        String ImportSuccessRowCount = response.getAttribute('ImportSuccessRowCount', null);
				        ImportSuccessRowCount=ImportSuccessRowCount==null?'0':ImportSuccessRowCount;
				        // && Integer.valueOf(ImportSuccessRowCount)==setTestBeingSent.size()
				        if ( 
				        		res.getStatusCode() == 200  && 
				        		(
				        			(p.Outcomes_Mg_Type__c=='Individual') ||
				        			(p.Outcomes_Mg_Type__c=='Group' && Integer.valueOf(ImportSuccessRowCount)==1) || 
				        			(p.Outcomes_Mg_Type__c=='Group + Individual' && Integer.valueOf(ImportSuccessRowCount)>=1)
				        		)
				        	) 
				        {
				        	o.Limeade_Response__c=limeadeResponse;
				        	o.Incentive_Sent__c=true;
							////////////////////
							/*o.Results_HDL_LDL__c=newOrder.LDLHDLRatioResult;
							o.Results_BMI__c=newOrder.BMIResult ;
							o.Results_Body_Fat__c=newOrder.BFResult ;
							o.Results_BP__c=newOrder.BPResult ;
							o.Results_Glucose__c=newOrder.RFpgResult ;
							o.Results_HDL__c=newOrder.RHdlResult ;
							o.Results_Heart_Rate__c=newOrder.HRPulseResult ;
							o.Results_LDL__c=newOrder.RLdlResult ;
							o.Results_TCH_HDL__c=newOrder.TCHDLRatioResult ;
							o.Results_Tobacco_Free__c=newOrder.TobaccoResult ;
							o.Results_Trig__c=newOrder.RTrigResult ;
							o.Results_Waist_Height__c=newOrder.WaistToHeightRatioResult ;
							o.Results_Waist__c=newOrder.WaistResult ;
							o.Results_TCH_LDL__c=newOrder.TCLDLRatioResult ;
							o.Results_TChol__c=newOrder.RChoResult ;
							
							o.Points_BMI__c=newOrder.BMIResult!='At Risk'?p.Pts_BMI__c:null;
							o.Points_Body_Fat__c=newOrder.BFResult!='At Risk'?p.Pts_Body_Fat__c:null;
							o.Points_BP__c=newOrder.BPResult!='At Risk'?p.Pts_BP__c:null;
							o.Points_Glucose__c=newOrder.RFpgResult!='At Risk'?p.Pts_Glucose__c:null;
							o.Points_HDL__c=newOrder.RHdlResult!='At Risk'?p.Pts_HDL__c:null;
							o.Points_Heart_Rate__c=newOrder.HRPulseResult!='At Risk'?p.Pts_Heart_Rate__c:null;
							o.Points_LDL__c=newOrder.RLdlResult!='At Risk'?p.Pts_LDL__c:null;
							o.Points_TChol__c=newOrder.TCHDLRatioResult!='At Risk'?p.Pts_TChol__c:null;
							o.Points_Tobacco_Free__c=newOrder.TobaccoResult!='At Risk' && !String.isBlank(newOrder.TobaccoResult)?p.Pts_Tobacco_Free__c:null;
							o.Points_Trig__c=newOrder.RTrigResult!='At Risk'?p.Pts_Triglycerides__c:null;
							o.Points_Wst_Ht__c=newOrder.WaistToHeightRatioResult!='At Risk'?p.Pts_Waist_Height__c:null;	
							o.Points_Wst__c=newOrder.WaistResult!='At Risk'?p.Pts_Waist__c:null;
							*/								
							////////////////////
											        	
				        	updateSentFields(o,setTestBeingSent);				        	
				        }
					}					
				}
				//////////////////////////
				o.Results_HDL_LDL__c=newOrder.LDLHDLRatioResult;
				o.Results_BMI__c=newOrder.BMIResult ;
				o.Results_Body_Fat__c=newOrder.BFResult ;
				o.Results_BP__c=newOrder.BPResult ;
				o.Results_Systolic__c=newOrder.BPSystolicResult ;
				o.Results_Diastolic__c=newOrder.BPDiastolicResult ;
				o.Results_Glucose__c=newOrder.RFpgResult ;
				o.Results_HDL__c=newOrder.RHdlResult ;
				o.Results_Heart_Rate__c=newOrder.HRPulseResult ;
				o.Results_LDL__c=newOrder.RLdlResult ;
				o.Results_TCH_HDL__c=newOrder.TCHDLRatioResult ;
				o.Results_Tobacco_Free__c=newOrder.TobaccoResult ;
				o.Results_Trig__c=newOrder.RTrigResult ;
				o.Results_Waist_Height__c=newOrder.WaistToHeightRatioResult ;
				o.Results_Waist__c=newOrder.WaistResult ;
				o.Results_TCH_LDL__c=newOrder.TCLDLRatioResult ;
				o.Results_TChol__c=newOrder.RChoResult ;
				o.Results_Weight__c=newOrder.WeightResult ; 
				o.Results_A1C__c=newOrder.A1CResult ;
				
				o.Points_BMI__c=newOrder.BMIResult!='At Risk'?p.Pts_BMI__c:null;
				o.Points_Body_Fat__c=newOrder.BFResult!='At Risk'?p.Pts_Body_Fat__c:null;
				o.Points_BP__c=newOrder.BPResult!='At Risk'?p.Pts_BP__c:null;
				o.Points_Systolic__c=newOrder.BPSystolicResult!='At Risk'?p.Pts_Systolic__c:null;
				o.Points_Diastolic__c=newOrder.BPDiastolicResult!='At Risk'?p.Pts_Diastolic__c:null;
				o.Points_Glucose__c=newOrder.RFpgResult!='At Risk'?p.Pts_Glucose__c:null;
				o.Points_HDL__c=newOrder.RHdlResult!='At Risk'?p.Pts_HDL__c:null;
				o.Points_Heart_Rate__c=newOrder.HRPulseResult!='At Risk'?p.Pts_Heart_Rate__c:null;
				o.Points_LDL__c=newOrder.RLdlResult!='At Risk'?p.Pts_LDL__c:null;
				o.Points_TChol__c=newOrder.RChoResult!='At Risk'?p.Pts_TChol__c:null;
				o.Points_Tobacco_Free__c=newOrder.TobaccoResult!='At Risk' && !String.isBlank(newOrder.TobaccoResult)?p.Pts_Tobacco_Free__c:null;
				o.Points_Trig__c=newOrder.RTrigResult!='At Risk'?p.Pts_Triglycerides__c:null;
				o.Points_Wst_Ht__c=newOrder.WaistToHeightRatioResult!='At Risk'?p.Pts_Waist_Height__c:null;	
				o.Points_Wst__c=newOrder.WaistResult!='At Risk'?p.Pts_Waist__c:null;
				o.Points_Weight__c=newOrder.WeightResult!='At Risk'?p.Pts_Weight__c:null; 					
				o.Points_A1C__c=newOrder.A1CResult!='At Risk'?p.Pts_A1C__c:null; 					
				//////////////////////////
				String setTestBeingSentString = '';
				String[] testToBePerformedArray=testToBePerformed.split(';');
				system.debug('testToBePerformed=================='+testToBePerformed);
				system.debug('setTestBeingSent=================='+setTestBeingSent);
				Set<String> allTests=new Set<String>();
				allTests.addAll(testToBePerformedArray);
				for(String s:setTestBeingSent) {
				   setTestBeingSentString += (setTestBeingSentString==''?'':',')+s;
				   allTests.remove(s);
				}				
				o.Tests_Met_The_Criteria__c=setTestBeingSentString;
				o.Tests_Not_Met_The_Criteria__c=String.valueOf(allTests);
				system.debug('setTestBeingSentString=================='+setTestBeingSentString);
				system.debug('String.valueOf(allTests)=================='+String.valueOf(allTests));
				update o;			   			
    		}     								
    	}   	
    }
	public static String getIncentivePointParticipants (String Participants) {
    	String xmlData = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Document>';
		xmlData += Participants + 
						'</Document>';
		return xmlData;
    }
	public static String getIncentivePointParticipant (Boolean emailIdentifier,String email,Boolean employeeIdIdentifier,String employeeId,String incentiveID) {
    	/*String xmlData = '';
		xmlData += '<Participant ' + 
						'email="' + EncodingUtil.urlEncode(email, 'UTF-8')  + '"' + 
						' incentiveevent="' + incentiveID  + '"' + 
						'/>';
		return xmlData;*/
		String participantXML = '';
		participantXML += '<Participant ';
		if(emailIdentifier)
			participantXML += ' email="' + EncodingUtil.urlEncode(email, 'UTF-8')  + '"';
		if(employeeIdIdentifier)
			participantXML += ' employeeid="' + EncodingUtil.urlEncode(employeeId, 'UTF-8')  + '"';						 
		participantXML += ' incentiveevent="' + incentiveID  + '"' ;
		participantXML += '/>';	
		return participantXML;		
    }   
	public static String getIncentivePointParticipant (String email,String incentiveID) {
    	String xmlData = '';
		xmlData += '<Participant ' + 
						'email="' + EncodingUtil.urlEncode(email, 'UTF-8')  + '"' + 
						' incentiveevent="' + incentiveID  + '"' + 
						'/>';
		return xmlData;
    }     
	public static HttpResponse updateIncentivePoints(String e,String psk,String xmlData) {

    	//try {
    		//String xmlData = getIncentivePointXMLData(email,incentiveID);
			Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        HttpResponse res = new HttpResponse();
	        req.setTimeout(59000);
        	String url = Constant.LIMEMADE_API+'Upload.ashx?' ;
			String body = 	'e=' +    EncodingUtil.urlEncode(e, 'UTF-8') + 
				        	'&psk=' +  EncodingUtil.urlEncode(psk, 'UTF-8') +
				        	'&response=XML' +
				        	'&format=XML' + 
				        	'&type=IncentivePoints' + 
				        	'&data=' +  xmlData ;
			req.setEndpoint(url);
			req.setMethod('POST');
			req.setHeader('Content-Length', body.length().format());
			req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
			req.setBody(body);
	        System.debug('XML:======== ' + xmlData );
	        System.debug('REQ:========== ' + req.getBody() );
			 if (!Test.isRunningTest()) {
				res = h.send(req);
			}
			else
			{
				res.setBody('<?xml version="1.0" encoding="utf-8"?>'+
							'<ImportJob Status="error" Message="At least one row failed." Description="Import IncentivePointsMapping - 1/15/2014 on DEVBUILDSERVER" ReportName="IncentivePointsCSV" ProviderName="limeadeprovider" EmployerName="AduroDev" ArchiveFileSize="346" ImportTotalRowCount="9" ImportSuccessRowCount="9" ImportFailedRowCount="0" ImportSkipRowCount="0" IntegrationTotalRowCount="9" IntegrationSuccessCount="3" IntegrationFailureRowCount="6" IntegrationSkipRowCount="0" IntegrationAddRowCount="0" IntegrationUpdateRowCount="3" IntegrationDeleteRowCount="0" JobID="174904" StartTime="1/15/2014 7:48:17 PM" CompleteTime="1/15/2014 7:48:21 PM">'+
							'</ImportJob>');
				res.setStatusCode(200);				
			}
	        System.debug('RES:============== ' + res );
	        System.debug('RES BODY:==================' + res.getBody() );
    	//}
    	//catch (Exception ex) {
    	//}
    	return res;
    }  
    //order will be sent by reference, no need to return value
    private static void updateSentFields(Order__c o,Set<String> setTestBeingSent)
    {
    	if(o!=null)
    	{
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE))
        	{
        		o.BP_Systolic_Sent__c=DateTime.now();
        		o.BP_Diastolic_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_SYSTOLIC))
        	{
        		o.BP_Systolic_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_DIASTOLIC))
        	{
        		o.BP_Diastolic_Sent__c=DateTime.now();
        	}        	        	
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_BMI))
        	{
        		o.BMI_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_GLUCOSE))
        	{
        		o.RFpg_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_TOBACCO))
        	{
        		o.Tobacco_Free_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_CHOLESTEROL))
        	{
        		o.RCho_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_HDL))
        	{
        		o.RHdl_Sent__c=DateTime.now();
        	}			        	
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_LDL))
        	{
        		o.RLdl_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_HDL_LDL))
        	{
        		o.LDL_HDL_Ratio_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_WAIST))
        	{
        		o.Waist_Sent__c=DateTime.now();
        	}        	
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_WTHR))
        	{
        		o.Waist_to_Height_Ratio_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_BODY_FAT))
        	{
        		o.Body_Fat_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_HEART_RATE))
        	{
        		o.Heart_Rate_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_TCH_HDL))
        	{
        		o.TC_HDL_Ratio_Sent__c=DateTime.now(); 
        	}	
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_TCH_LDL))
        	{
        		o.TC_LDL_Ratio_Sent__c=DateTime.now(); 
        	}        	
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_TRIGLYCERIDES))
        	{
        		o.RTrig_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_WEIGHT))
        	{
        		o.Weight_Sent__c=DateTime.now();
        	}
        	if(setTestBeingSent.contains(Constant.OUTCOMES_TEST_INCLUDED_A1C))
        	{
        		o.A1C_Sent__c=DateTime.now();
        	} 			
    	}	
    }        
    public static Boolean isWithInRange(String testType,Decimal orderValue,Map<String,Range> mapRanges)
    {
    	Boolean result=false;
    	if(!String.isBlank(testType) && orderValue!=null && mapRanges!=null && mapRanges.containsKey(testType))
    	{
    		Range r=mapRanges.get(testType);
    		if(r.low!=null && r.high!=null && r.low<=orderValue && r.high>=orderValue)
    		{
    			result=true;
    		}
    	}
    	return result;
    }
    public static Order calculateImprovement(Order newOrder,Order__c currentOrder,Program__c p,Map<String,Range> mapRanges)
    {
    	List<Order> listOrders=new List<Order>();
		if(newOrder!=null && currentOrder!=null && p!=null && mapRanges!=null && !String.isBlank(p.Improvement_Type__c))
		{
			if(currentOrder.BP_Systolic_Best__c!=null && currentOrder.BP_Systolic_Worst__c!=null && currentOrder.BP_Systolic_Best__c<=currentOrder.BP_Systolic_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.BPSystolicImproved=currentOrder.BP_Systolic_Worst__c-currentOrder.BP_Systolic_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.BPSystolicImproved=currentOrder.BP_Systolic_Worst__c-currentOrder.BP_Systolic_Best__c;
						newOrder.BPSystolicImproved=(newOrder.BPSystolicImproved/(currentOrder.BP_Systolic_Worst__c==0?1:currentOrder.BP_Systolic_Worst__c));
					}
					if(newOrder.BPSystolicImproved>=r.impNumber)
					{
						newOrder.BPSystolicIsImproved=true;
					}
					else{newOrder.BPSystolicImproved=0;}					
				}
			}
			if(currentOrder.BP_Diastolic_Best__c!=null && currentOrder.BP_Diastolic_Worst__c!=null && currentOrder.BP_Diastolic_Best__c<=currentOrder.BP_Diastolic_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.BPDiastolicImproved=currentOrder.BP_Diastolic_Worst__c-currentOrder.BP_Diastolic_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.BPDiastolicImproved=currentOrder.BP_Diastolic_Worst__c-currentOrder.BP_Diastolic_Best__c;
						newOrder.BPDiastolicImproved=(newOrder.BPDiastolicImproved/(currentOrder.BP_Diastolic_Worst__c==0?1:currentOrder.BP_Diastolic_Worst__c));
					}
					if(newOrder.BPDiastolicImproved>=r.impNumber)
					{
						newOrder.BPDiastolicIsImproved=true;
					}
					else{newOrder.BPDiastolicImproved=0;}					
				}
			}
			if(currentOrder.BMI_Best__c!=null && currentOrder.BMI_Worst__c!=null && currentOrder.BMI_Best__c<=currentOrder.BMI_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_BMI))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BMI);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.BMIImproved=currentOrder.BMI_Worst__c-currentOrder.BMI_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.BMIImproved=currentOrder.BMI_Worst__c-currentOrder.BMI_Best__c;
						newOrder.BMIImproved=(newOrder.BMIImproved/(currentOrder.BMI_Worst__c==0?1:currentOrder.BMI_Worst__c));
						system.debug('newOrder.BMIImproved=========================='+newOrder.BMIImproved);
					}
					if(newOrder.BMIImproved>=r.impNumber)
					{
						newOrder.BMIIsImproved=true;
					}
					else{newOrder.BMIImproved=0;}					
				}
			}
			if(currentOrder.RFpg_Best__c!=null && currentOrder.RFpg_Worst__c!=null && currentOrder.RFpg_Best__c<=currentOrder.RFpg_Worst__c)
			{
				String outcomeTestType='';
				if(String.isBlank(currentOrder.Fasting_Y_N__c) || currentOrder.Fasting_Y_N__c=='Y')
				{
					outcomeTestType=Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING;
				}
				else
				{
					outcomeTestType=Constant.OUTCOMES_TEST_TYPE_GLUCOSE_NON_FASTING;
				}
				if(mapRanges.containsKey(outcomeTestType))
				{
					Range r=mapRanges.get(outcomeTestType);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.RFpgImproved=currentOrder.RFpg_Worst__c-currentOrder.RFpg_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.RFpgImproved=currentOrder.RFpg_Worst__c-currentOrder.RFpg_Best__c;
						newOrder.RFpgImproved=(newOrder.RFpgImproved/(currentOrder.RFpg_Worst__c==0?1:currentOrder.RFpg_Worst__c));
					}
					if(newOrder.RFpgImproved>=r.impNumber)
					{
						newOrder.RFpgIsImproved=true;
					}
					else{newOrder.RFpgImproved=0;}					
				}
			}
			if(currentOrder.Tobacco__c!=null && currentOrder.Tobacco__c=='Y')	
			{
				newOrder.TobaccoIsImproved=true;
			}
			if(currentOrder.RCho_Best__c!=null && currentOrder.RCho_Worst__c!=null && currentOrder.RCho_Best__c<=currentOrder.RCho_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.RChoImproved=currentOrder.RCho_Worst__c-currentOrder.RCho_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.RChoImproved=currentOrder.RCho_Worst__c-currentOrder.RCho_Best__c;
						newOrder.RChoImproved=(newOrder.RChoImproved/(currentOrder.RCho_Worst__c==0?1:currentOrder.RCho_Worst__c));
					}
					if(newOrder.RChoImproved>=r.impNumber)
					{
						newOrder.RChoIsImproved=true;
					}
					else{newOrder.RChoImproved=0;}					
				}
			}
			if(currentOrder.RHdl_Best__c!=null && currentOrder.RHdl_Worst__c!=null && currentOrder.RHdl_Best__c>=currentOrder.RHdl_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_HDL))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.RHdlImproved=currentOrder.RHdl_Best__c-currentOrder.RHdl_Worst__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.RHdlImproved=currentOrder.RHdl_Best__c-currentOrder.RHdl_Worst__c;
						newOrder.RHdlImproved=(newOrder.RHdlImproved/(currentOrder.RHdl_Worst__c==0?1:currentOrder.RHdl_Worst__c));
					}
					if(newOrder.RHdlImproved>=r.impNumber)
					{
						newOrder.RHdlIsImproved=true;
					}
					else{newOrder.RHdlImproved=0;}					
				}
			}
			if(currentOrder.RLdl_Best__c!=null && currentOrder.RLdl_Worst__c!=null && currentOrder.RLdl_Best__c<=currentOrder.RLdl_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_LDL))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_LDL);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.RLdlImproved=currentOrder.RLdl_Worst__c-currentOrder.RLdl_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.RLdlImproved=currentOrder.RLdl_Worst__c-currentOrder.RLdl_Best__c;
						newOrder.RLdlImproved=(newOrder.RLdlImproved/(currentOrder.RLdl_Worst__c==0?1:currentOrder.RLdl_Worst__c));
					}
					if(newOrder.RLdlImproved>=r.impNumber)
					{
						newOrder.RLdlIsImproved=true;
					}
					else{newOrder.RLdlImproved=0;}					
				}
			}
			if(currentOrder.LDL_HDL_Ratio_Best__c!=null && currentOrder.LDL_HDL_Ratio_Worst__c!=null && currentOrder.LDL_HDL_Ratio_Best__c<=currentOrder.LDL_HDL_Ratio_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_HDL_LDL))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HDL_LDL);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.LDLHDLRatioImproved=currentOrder.LDL_HDL_Ratio_Worst__c-currentOrder.LDL_HDL_Ratio_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.LDLHDLRatioImproved=currentOrder.LDL_HDL_Ratio_Worst__c-currentOrder.LDL_HDL_Ratio_Best__c;
						newOrder.LDLHDLRatioImproved=(newOrder.LDLHDLRatioImproved/(currentOrder.LDL_HDL_Ratio_Worst__c==0?1:currentOrder.LDL_HDL_Ratio_Worst__c));
					}
					if(newOrder.LDLHDLRatioImproved>=r.impNumber)
					{
						newOrder.LDLHDLRatioIsImproved=true;
					}
					else{newOrder.LDLHDLRatioImproved=0;}					
				}
			}
			if(currentOrder.Waist_Best__c!=null && currentOrder.Waist_Worst__c!=null && currentOrder.Waist_Best__c<=currentOrder.Waist_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_WAIST))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.WaistImproved=currentOrder.Waist_Worst__c-currentOrder.Waist_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.WaistImproved=currentOrder.Waist_Worst__c-currentOrder.Waist_Best__c;
						newOrder.WaistImproved=(newOrder.WaistImproved/(currentOrder.Waist_Worst__c==0?1:currentOrder.Waist_Worst__c));
						system.debug('newOrder.WaistImproved=========================='+newOrder.WaistImproved);
					}
					if(newOrder.WaistImproved>=r.impNumber)
					{
						newOrder.WaistIsImproved=true;
					}
					else{newOrder.WaistImproved=0;}					
				}
			}			
			if(currentOrder.Waist_to_Height_Ratio_Best__c!=null && currentOrder.Waist_to_Height_Ratio_Worst__c!=null && currentOrder.Waist_to_Height_Ratio_Best__c<=currentOrder.Waist_to_Height_Ratio_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.WaistToHeightRatioImproved=currentOrder.Waist_to_Height_Ratio_Worst__c-currentOrder.Waist_to_Height_Ratio_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.WaistToHeightRatioImproved=currentOrder.Waist_to_Height_Ratio_Worst__c-currentOrder.Waist_to_Height_Ratio_Best__c;
						newOrder.WaistToHeightRatioImproved=(newOrder.WaistToHeightRatioImproved/(currentOrder.Waist_to_Height_Ratio_Worst__c==0?1:currentOrder.Waist_to_Height_Ratio_Worst__c));
					}
					if(newOrder.WaistToHeightRatioImproved>=r.impNumber)
					{
						newOrder.WaistToHeightRatioIsImproved=true;
					}
					else{newOrder.WaistToHeightRatioImproved=0;}					
				}
			}
			if(currentOrder.BF_Best__c!=null && currentOrder.BF_Worst__c!=null && currentOrder.BF_Best__c<=currentOrder.BF_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_BODY_FAT)) 
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_BODY_FAT);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.BFImproved=currentOrder.BF_Worst__c-currentOrder.BF_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.BFImproved=currentOrder.BF_Worst__c-currentOrder.BF_Best__c;
						newOrder.BFImproved=(newOrder.BFImproved/(currentOrder.BF_Worst__c==0?1:currentOrder.BF_Worst__c));
					}
					if(newOrder.BFImproved>=r.impNumber)
					{
						newOrder.BFIsImproved=true;
					}
					else{newOrder.BFImproved=0;}					
				}
			}
			if(currentOrder.HR_Pulse_Best__c!=null && currentOrder.HR_Pulse_Worst__c!=null && currentOrder.HR_Pulse_Best__c<=currentOrder.HR_Pulse_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_HEART_RATE))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_HEART_RATE);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.HRPulseImproved=currentOrder.HR_Pulse_Worst__c-currentOrder.HR_Pulse_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.HRPulseImproved=currentOrder.HR_Pulse_Worst__c-currentOrder.HR_Pulse_Best__c;
						newOrder.HRPulseImproved=(newOrder.HRPulseImproved/(currentOrder.HR_Pulse_Worst__c==0?1:currentOrder.HR_Pulse_Worst__c));
					}
					if(newOrder.HRPulseImproved>=r.impNumber)
					{
						newOrder.HRPulseIsImproved=true;
					}
					else{newOrder.HRPulseImproved=0;}					
				}
			}
			if(currentOrder.TC_HDL_Ratio_Best__c!=null && currentOrder.TC_HDL_Ratio_Worst__c!=null && currentOrder.TC_HDL_Ratio_Best__c<=currentOrder.TC_HDL_Ratio_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TCH_HDL))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_HDL);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.TCHDLRatioImproved=currentOrder.TC_HDL_Ratio_Worst__c-currentOrder.TC_HDL_Ratio_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.TCHDLRatioImproved=currentOrder.TC_HDL_Ratio_Worst__c-currentOrder.TC_HDL_Ratio_Best__c;
						newOrder.TCHDLRatioImproved=(newOrder.TCHDLRatioImproved/(currentOrder.TC_HDL_Ratio_Worst__c==0?1:currentOrder.TC_HDL_Ratio_Worst__c));
					}
					if(newOrder.TCHDLRatioImproved>=r.impNumber)
					{
						newOrder.TCHDLRatioIsImproved=true;
					}
					else{newOrder.TCHDLRatioImproved=0;}					
				}
			}
			if(currentOrder.TC_LDL_Ratio_Best__c!=null && currentOrder.TC_LDL_Ratio_Worst__c!=null && currentOrder.TC_LDL_Ratio_Best__c<=currentOrder.TC_LDL_Ratio_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TCH_LDL))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TCH_LDL);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.TCLDLRatioImproved=currentOrder.TC_LDL_Ratio_Worst__c-currentOrder.TC_LDL_Ratio_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.TCLDLRatioImproved=currentOrder.TC_LDL_Ratio_Worst__c-currentOrder.TC_LDL_Ratio_Best__c;
						newOrder.TCLDLRatioImproved=(newOrder.TCLDLRatioImproved/(currentOrder.TC_LDL_Ratio_Worst__c==0?1:currentOrder.TC_LDL_Ratio_Worst__c));
					}
					if(newOrder.TCLDLRatioImproved>=r.impNumber)
					{
						newOrder.TCLDLRatioIsImproved=true;
					}
					else{newOrder.TCLDLRatioImproved=0;}					
				}
			}		
			system.debug('currentOrder.RTrig_Best__c========================='+currentOrder.RTrig_Best__c);
			system.debug('currentOrder.RTrig_Worst__c========================='+currentOrder.RTrig_Worst__c);	
			if(currentOrder.RTrig_Best__c!=null && currentOrder.RTrig_Worst__c!=null && currentOrder.RTrig_Best__c<=currentOrder.RTrig_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.RTrigImproved=currentOrder.RTrig_Worst__c-currentOrder.RTrig_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.RTrigImproved=currentOrder.RTrig_Worst__c-currentOrder.RTrig_Best__c;
						newOrder.RTrigImproved=(newOrder.RTrigImproved/(currentOrder.RTrig_Worst__c==0?1:currentOrder.RTrig_Worst__c));
						
					}
					system.debug('newOrder.RTrigImproved======================='+newOrder.RTrigImproved);
					system.debug('r.impNumber======================='+r.impNumber);
					if(newOrder.RTrigImproved>=r.impNumber)
					{
						newOrder.RTrigIsImproved=true;
					}
					else{newOrder.RTrigImproved=0;}					
				}
			}
			if(currentOrder.Weight_Best__c!=null && currentOrder.Weight_Worst__c!=null && currentOrder.Weight_Best__c<=currentOrder.Weight_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_WEIGHT))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_WEIGHT);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.WeightImproved=currentOrder.Weight_Worst__c-currentOrder.Weight_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.WeightImproved=currentOrder.Weight_Worst__c-currentOrder.Weight_Best__c;
						newOrder.WeightImproved=(newOrder.WeightImproved/(currentOrder.Weight_Worst__c==0?1:currentOrder.Weight_Worst__c));
						
					}
					system.debug('newOrder.WeightImproved======================='+newOrder.WeightImproved);
					system.debug('r.impNumber======================='+r.impNumber);
					if(newOrder.WeightImproved>=r.impNumber)
					{
						newOrder.WeightIsImproved=true;
					}
					else{newOrder.WeightImproved=0;}					
				}
			}
			if(currentOrder.A1C_Best__c!=null && currentOrder.A1C_Worst__c!=null && currentOrder.A1C_Best__c<=currentOrder.A1C_Worst__c)
			{
				if(mapRanges.containsKey(Constant.OUTCOMES_TEST_TYPE_A1C))
				{
					Range r=mapRanges.get(Constant.OUTCOMES_TEST_TYPE_A1C);
					if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_VALUE)
					{
						newOrder.A1CImproved=currentOrder.A1C_Worst__c-currentOrder.A1C_Best__c;
					}
					else if(p.Improvement_Type__c==Constant.OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE) 
					{
						newOrder.A1CImproved=currentOrder.A1C_Worst__c-currentOrder.A1C_Best__c;
						newOrder.A1CImproved=(newOrder.A1CImproved/(currentOrder.A1C_Worst__c==0?1:currentOrder.A1C_Worst__c));
						
					}
					system.debug('newOrder.A1CImproved======================='+newOrder.A1CImproved);
					system.debug('r.impNumber======================='+r.impNumber);
					if(newOrder.A1CImproved>=r.impNumber)
					{
						newOrder.A1CIsImproved=true;
					}
					else{newOrder.A1CImproved=0;}					
				}
			}			
		}  
		return newOrder;
    }        
    public static Order updateWithInRangeAndResult(Order__c o,Order newOrder,Map<String,Range> mapRanges,String testToBePerformed)
    {
		String outcomeTestTypeGlucose='';
		if(String.isBlank(o.Fasting_Y_N__c) || o.Fasting_Y_N__c=='Y')
		{
			outcomeTestTypeGlucose=Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING;
		}
		else
		{
			outcomeTestTypeGlucose=Constant.OUTCOMES_TEST_TYPE_GLUCOSE_NON_FASTING;
		}    	
    	newOrder.BPIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE);
    	//newOrder.BPDiastolicIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE);
    	//if sending seperatly 
    	if(!newOrder.BPSystolicIsIncluded)
    	newOrder.BPSystolicIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_SYSTOLIC);
    	if(!newOrder.BPDiastolicIsIncluded)
    	newOrder.BPDiastolicIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_DIASTOLIC);    	
    	
    	newOrder.BMIIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_BMI);
    	newOrder.RFpgIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_GLUCOSE);
    	newOrder.TobaccoIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_TOBACCO);
    	newOrder.RChoIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_CHOLESTEROL);
    	newOrder.RHdlIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_HDL);
    	newOrder.RLdlIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_LDL);
    	newOrder.LDLHDLRatioIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_HDL_LDL);
    	newOrder.WaistToHeightRatioIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_WTHR);
    	newOrder.WaistIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_WAIST);
    	newOrder.BFIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_BODY_FAT);
    	newOrder.HRPulseIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_HEART_RATE);
    	newOrder.TCHDLRatioIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_TCH_HDL);
    	newOrder.TCLDLRatioIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_TCH_LDL);
    	newOrder.RTrigIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_TRIGLYCERIDES);
    	newOrder.WeightIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_WEIGHT);     	
		newOrder.A1CIsIncluded=testToBePerformed.contains(Constant.OUTCOMES_TEST_INCLUDED_A1C);     	
    	
		newOrder.BPSystolicIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_SYSTOLIC,o.BP_Systolic_Best__c,mapRanges);
		newOrder.BPDiastolicIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_DIASTOLIC,o.BP_Diastolic_Best__c,mapRanges);
		newOrder.BMIIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_BMI,o.BMI_Best__c,mapRanges)	;
		newOrder.RFpgIsWithInRange=isWithInRange(outcomeTestTypeGlucose,o.RFpg_Best__c,mapRanges);
		newOrder.RChoIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL,o.RCho_Best__c,mapRanges);
		newOrder.RHdlIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_HDL,o.RHdl_Best__c,mapRanges);
		newOrder.RLdlIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_LDL,o.RLdl_Best__c,mapRanges);
		newOrder.LDLHDLRatioIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_HDL_LDL,o.LDL_HDL_Ratio_Best__c,mapRanges);
		newOrder.WaistIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_WAIST,o.Waist_Best__c,mapRanges)	;
		newOrder.WaistToHeightRatioIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT,o.Waist_to_Height_Ratio_Best__c,mapRanges);
		newOrder.BFIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_BODY_FAT,o.BF_Best__c,mapRanges);
    	newOrder.HRPulseIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_HEART_RATE,o.HR_Pulse_Best__c,mapRanges);
    	newOrder.TCHDLRatioIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_TCH_HDL,o.TC_HDL_Ratio_Best__c,mapRanges);
    	newOrder.TCLDLRatioIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_TCH_LDL,o.TC_LDL_Ratio_Best__c,mapRanges);
    	newOrder.RTrigIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES,o.RTrig_Best__c,mapRanges);
    	newOrder.TobaccoIsWithInRange=(o.Tobacco__c!=null && o.Tobacco__c=='Y')?true:false;
    	newOrder.WeightIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_WEIGHT,o.Weight_Best__c,mapRanges);
    	newOrder.A1CIsWithInRange=isWithInRange(Constant.OUTCOMES_TEST_TYPE_A1C,o.A1C_Best__c,mapRanges);
		
    	newOrder.BPResult=(newOrder.BPSystolicIsWithInRange && newOrder.BPDiastolicIsWithInRange)?'Healthy':((newOrder.BPSystolicIsImproved && newOrder.BPDiastolicIsImproved)?'Improved':'At Risk');
    	newOrder.BPSystolicResult=newOrder.BPSystolicIsWithInRange?'Healthy':(newOrder.BPSystolicIsImproved?'Improved':'At Risk');
    	newOrder.BPDiastolicResult=newOrder.BPDiastolicIsWithInRange?'Healthy':(newOrder.BPDiastolicIsImproved?'Improved':'At Risk');
    	newOrder.BMIResult=newOrder.BMIIsWithInRange?'Healthy':(newOrder.BMIIsImproved?'Improved':'At Risk');
    	newOrder.RFpgResult=newOrder.RFpgIsWithInRange?'Healthy':(newOrder.RFpgIsImproved?'Improved':'At Risk');
    	newOrder.TobaccoResult=(o.Tobacco__c!=null && o.Tobacco__c=='Y')?'Healthy':(o.Tobacco__c!=null && o.Tobacco__c=='N')?'At Risk':'';//newOrder.TobaccoIsWithInRange?'Healthy':(newOrder.TobaccoIsImproved?'Improved':'At Risk');
    	newOrder.RChoResult=newOrder.RChoIsWithInRange?'Healthy':(newOrder.RChoIsImproved?'Improved':'At Risk');
    	newOrder.RHdlResult=newOrder.RHdlIsWithInRange?'Healthy':(newOrder.RHdlIsImproved?'Improved':'At Risk');
    	newOrder.RLdlResult=newOrder.RLdlIsWithInRange?'Healthy':(newOrder.RLdlIsImproved?'Improved':'At Risk');
    	newOrder.LDLHDLRatioResult=newOrder.LDLHDLRatioIsWithInRange?'Healthy':(newOrder.LDLHDLRatioIsImproved?'Improved':'At Risk');
    	newOrder.WaistResult=newOrder.WaistIsWithInRange?'Healthy':(newOrder.WaistIsImproved?'Improved':'At Risk');
    	newOrder.WaistToHeightRatioResult=newOrder.WaistToHeightRatioIsWithInRange?'Healthy':(newOrder.WaistToHeightRatioIsImproved?'Improved':'At Risk');
    	newOrder.BFResult=newOrder.BFIsWithInRange?'Healthy':(newOrder.BFIsImproved?'Improved':'At Risk');
    	newOrder.HRPulseResult=newOrder.HRPulseIsWithInRange?'Healthy':(newOrder.HRPulseIsImproved?'Improved':'At Risk');
    	newOrder.TCHDLRatioResult=newOrder.TCHDLRatioIsWithInRange?'Healthy':(newOrder.TCHDLRatioIsImproved?'Improved':'At Risk');
    	newOrder.TCLDLRatioResult=newOrder.TCLDLRatioIsWithInRange?'Healthy':(newOrder.TCLDLRatioIsImproved?'Improved':'At Risk');
    	newOrder.RTrigResult=newOrder.RTrigIsWithInRange?'Healthy':(newOrder.RTrigIsImproved?'Improved':'At Risk');
    	newOrder.WeightResult=newOrder.WeightIsWithInRange?'Healthy':(newOrder.WeightIsImproved?'Improved':'At Risk');
		newOrder.A1CResult=newOrder.A1CIsWithInRange?'Healthy':(newOrder.A1CIsImproved?'Improved':'At Risk');
		//newOrder.physicianAlternativeAction=String.isNotBlank(o.Medically_Inadvisable__c)?o.Medically_Inadvisable__c.contains(Constant.OUTCOMES_PHYSICIAN_ALTERNATIVE_ACTION):false;
    	return newOrder;
    }    
    public class Order
    {
    	public Decimal BPSystolicImproved{get;set;}
    	public Decimal BPDiastolicImproved{get;set;}
    	public Decimal BMIImproved{get;set;}
    	public Decimal RFpgImproved{get;set;}
    	public String TobaccoImproved{get;set;}
    	public Decimal RChoImproved{get;set;}
    	public Decimal RHdlImproved{get;set;}
    	public Decimal RTrigImproved{get;set;}
    	public Decimal RLdlImproved{get;set;}
    	public Decimal LDLHDLRatioImproved{get;set;}
    	public Decimal WaistToHeightRatioImproved{get;set;}
    	public Decimal WaistImproved{get;set;}
    	public Decimal BFImproved{get;set;}
    	public Decimal HRPulseImproved{get;set;}
    	public Decimal TCHDLRatioImproved{get;set;}
    	public Decimal TCLDLRatioImproved{get;set;}    	
    	public Decimal WeightImproved{get;set;}
		public Decimal A1CImproved{get;set;}
    	
    	public Boolean BPSystolicIsImproved{get;set;}
    	public Boolean BPDiastolicIsImproved{get;set;}
    	public Boolean BMIIsImproved{get;set;}
    	public Boolean RFpgIsImproved{get;set;}
    	public Boolean TobaccoIsImproved{get;set;}
    	public Boolean RChoIsImproved{get;set;}
    	public Boolean RHdlIsImproved{get;set;}
    	public Boolean RLdlIsImproved{get;set;}
    	public Boolean LDLHDLRatioIsImproved{get;set;}
    	public Boolean WaistToHeightRatioIsImproved{get;set;}
    	public Boolean WaistIsImproved{get;set;}
    	public Boolean BFIsImproved{get;set;}
    	public Boolean HRPulseIsImproved{get;set;}
    	public Boolean TCHDLRatioIsImproved{get;set;}
    	public Boolean TCLDLRatioIsImproved{get;set;}
    	public Boolean RTrigIsImproved{get;set;}
    	public Boolean WeightIsImproved{get;set;}       	
		public Boolean A1CIsImproved{get;set;}       	
    	
    	public Boolean BPSystolicIsWithInRange{get;set;}
    	public Boolean BPDiastolicIsWithInRange{get;set;}
    	public Boolean BMIIsWithInRange{get;set;}
    	public Boolean RFpgIsWithInRange{get;set;}
    	public Boolean TobaccoIsWithInRange{get;set;}
    	public Boolean RChoIsWithInRange{get;set;}
    	public Boolean RHdlIsWithInRange{get;set;}
    	public Boolean RLdlIsWithInRange{get;set;}
    	public Boolean LDLHDLRatioIsWithInRange{get;set;}
    	public Boolean WaistToHeightRatioIsWithInRange{get;set;}
    	public Boolean WaistIsWithInRange{get;set;}
    	public Boolean BFIsWithInRange{get;set;}
    	public Boolean HRPulseIsWithInRange{get;set;}
    	public Boolean TCHDLRatioIsWithInRange{get;set;}
    	public Boolean TCLDLRatioIsWithInRange{get;set;}
    	public Boolean RTrigIsWithInRange{get;set;}
    	public Boolean WeightIsWithInRange{get;set;}         	
		public Boolean A1CIsWithInRange{get;set;}         	
    	
    	public String BPResult{get;set;}
    	public String BMIResult{get;set;}
    	public String RFpgResult{get;set;}
    	public String TobaccoResult{get;set;}
    	public String RChoResult{get;set;}
    	public String RHdlResult{get;set;}
    	public String RLdlResult{get;set;}
    	public String LDLHDLRatioResult{get;set;}
    	public String WaistToHeightRatioResult{get;set;}
    	public String WaistResult{get;set;}
    	public String BFResult{get;set;}
    	public String HRPulseResult{get;set;}
    	public String TCHDLRatioResult{get;set;}
    	public String TCLDLRatioResult{get;set;}
    	public String RTrigResult{get;set;}
    	public String BPSystolicResult{get;set;}
    	public String BPDiastolicResult{get;set;}  
    	public String MedicallyInadvisable{get;set;}
    	public Boolean PhysicianAlternativeAction{get;set;}
    	public String WeightResult{get;set;}
		public String A1CResult{get;set;}
    	
		public Boolean BPIsIncluded{get;set;}
    	public Boolean BPSystolicIsIncluded{get;set;}
    	public Boolean BPDiastolicIsIncluded{get;set;}
    	public Boolean BMIIsIncluded{get;set;}
    	public Boolean RFpgIsIncluded{get;set;}
    	public Boolean TobaccoIsIncluded{get;set;}
    	public Boolean RChoIsIncluded{get;set;}
    	public Boolean RHdlIsIncluded{get;set;}
    	public Boolean RLdlIsIncluded{get;set;}
    	public Boolean LDLHDLRatioIsIncluded{get;set;}
    	public Boolean WaistToHeightRatioIsIncluded{get;set;}
    	public Boolean WaistIsIncluded{get;set;}
    	public Boolean BFIsIncluded{get;set;}
    	public Boolean HRPulseIsIncluded{get;set;}
    	public Boolean TCHDLRatioIsIncluded{get;set;}
    	public Boolean TCLDLRatioIsIncluded{get;set;}
    	public Boolean RTrigIsIncluded{get;set;}
    	public Boolean WeightIsIncluded{get;set;}      	      	
		public Boolean A1CIsIncluded{get;set;}      	      	
    	
    	//public Boolean physicianAlternativeAction{get;set;}
    	public Order()
    	{
    		//orderIDs='';
			BPSystolicImproved=0;
			BPDiastolicImproved=0;
			BMIImproved=0;
			RFpgImproved=0;
			TobaccoImproved='No';
			RChoImproved=0;
			RHdlImproved=0;
			RLdlImproved=0;
			LDLHDLRatioImproved=0;
			WaistToHeightRatioImproved=0;
			WaistImproved=0;
			BFImproved=0;
			RTrigImproved=0;
			HRPulseImproved=0;
			TCHDLRatioImproved=0;
			TCLDLRatioImproved=0; 
			WeightImproved=0;
			A1CImproved=0;
			
			BPSystolicIsImproved=false;
			BPDiastolicIsImproved=false;
			BMIIsImproved=false;
			RFpgIsImproved=false;
			TobaccoIsImproved=false;
			RChoIsImproved=false;
			RHdlIsImproved=false;
			RLdlIsImproved=false;
			LDLHDLRatioIsImproved=false;
			WaistToHeightRatioIsImproved=false;
			WaistIsImproved=false;
			BFIsImproved=false;
			HRPulseIsImproved=false;
			TCHDLRatioIsImproved=false;
			TCLDLRatioIsImproved=false;
			RTrigIsImproved=false;
			WeightIsImproved=false;    
			A1CIsImproved=false;    
			
			BPSystolicIsWithInRange=false;
			BPDiastolicIsWithInRange=false;
			BMIIsWithInRange=false;
			RFpgIsWithInRange=false;
			TobaccoIsWithInRange=false;
			RChoIsWithInRange=false;
			RHdlIsWithInRange=false;
			RLdlIsWithInRange=false;
			LDLHDLRatioIsWithInRange=false;
			WaistToHeightRatioIsWithInRange=false;
			WaistIsWithInRange=false;
			BFIsWithInRange=false;
			HRPulseIsWithInRange=false;
			TCHDLRatioIsWithInRange=false;
			TCLDLRatioIsWithInRange=false;
			RTrigIsWithInRange=false;
			WeightIsWithInRange=false;  	
			A1CIsWithInRange=false;  	
			
			BPIsIncluded=false;
	    	BPSystolicIsIncluded=false;
	    	BPDiastolicIsIncluded=false;
	    	BMIIsIncluded=false;
	    	RFpgIsIncluded=false;
	    	TobaccoIsIncluded=false;
	    	RChoIsIncluded=false;
	    	RHdlIsIncluded=false;
	    	RLdlIsIncluded=false;
	    	LDLHDLRatioIsIncluded=false;
	    	WaistToHeightRatioIsIncluded=false;
	    	WaistIsIncluded=false;
	    	BFIsIncluded=false;
	    	HRPulseIsIncluded=false;
	    	TCHDLRatioIsIncluded=false;
	    	TCLDLRatioIsIncluded=false;
	    	RTrigIsIncluded=false;
	    	WeightIsIncluded=false;  					
			A1CIsIncluded=false;  				
			
    	}		
    }
    public class Range
    {
    	public String testType{get;set;}
    	public Decimal low{get;set;}
    	public Decimal high{get;set;}
    	public Decimal impNumber{get;set;}
    	public String improvementId{get;set;}
    	public String incentiveId{get;set;}
    	public String medicallyInadvisableId{get;set;}
    	public Boolean physicianAlternativeAction{get;set;}
    }     
}