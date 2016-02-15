global class AjaxUtility {
	webService static String SendTagger(String OrderId)
	{
		String result='';
		if(!String.isBlank(OrderId)) 
		{
			Set<String> orderTypes=Constant.SetLimeadePreventiveScreeningOrderTypes;
			List<Order__c> listOrder=[Select Id,PatientEmailH__c,In_Limeade__c,Order_Status__c,Limeade_Participant_Code__c, 
 			   							Contact__c,ProgramID__c 
 			   							From Order__c Where In_Limeade__c='Yes' AND Limeade_Participant_Code__c!=null
										AND Range_Tier__c!=null AND Demographic_Tag_Sent__c=null
 			   							AND ProgramID__r.Limeade_E_Id__c!=null AND ProgramID__r.Limeade_E_Id__c!='' AND 
 			   							ProgramID__r.Limeade_PSK_ID__c!=null AND ProgramID__r.Limeade_PSK_ID__c!='' AND ProgramID__r.Program_Status__c='Active'
 			   							AND Id=:OrderId ];
			if(listOrder.size()==1)
			{
				Order__c o=listOrder[0];
				JobTagger.ProcessOrder(o);
				result='Successfully sent.';
			}
			else
			{
				result='Invalid Order or does not meet the criteria.';
			}
	
		}
		else
		{
			result='Error occured, please try again or contact administrator.';
		}
		return result;		
	}		
	webService static String SendPreventiveIncentive(String OrderId)
	{
		String result='';
		if(!String.isBlank(OrderId)) 
		{
			Set<String> orderTypes=Constant.SetLimeadePreventiveScreeningOrderTypes;
			List<Order__c> listOrder=[Select Id,PatientEmailH__c,In_Limeade__c,Order_Status__c,Limeade_Participant_Code__c, 
 			   							Contact__c,ProgramID__c 
 			   							From Order__c Where Order_Type__c=:orderTypes  AND In_Limeade__c='Yes' AND Limeade_Participant_Code__c!=null  AND Order_Status__c='Received' AND 
 			   							(Colorectal_Cancer_Screening__c!=null OR Colonoscopy__c!=null OR Prostate_Cancer_Screening__c!=null 
 			   							OR Date_of_Dental_Visit__c!=null OR Mammogram__c!=null OR Pap_Smear__c!=null 
 			   							OR Date_of_Vision_Screening_Visit__c!=null OR Date_of_PCP_Follow_Visit__c!=null OR Check_In_Check_Up__c!=null
 			   							OR Pregnancy_Program_Tri_1__c!=null OR Pregnancy_Program_Tri_2__c!=null OR PCP_Follow_Up_2__c!=null
 			   							OR Preventive_Tobacco_Attestation__c!=null  OR Preventive_Urine_Protein_Test__c!=null OR Preventive_2nd_Hemoglobin_A1C__c!=null) 
 			   							AND ProgramID__r.Limeade_E_Id__c!=null AND ProgramID__r.Limeade_E_Id__c!='' AND 
 			   							ProgramID__r.Do_Not_Send_Preventive_Screening__c=false AND
 			   							ProgramID__r.Limeade_PSK_ID__c!=null AND ProgramID__r.Limeade_PSK_ID__c!='' AND Preventive_Screening_Incentivized__c=false AND ProgramID__r.Program_Status__c='Active'
 			   							AND Id=:OrderId ];
			if(listOrder.size()==1)
			{
				Order__c o=listOrder[0];
				JobPreventiveIncentivizer.ProcessOrder(o);
				result='Successfully sent.';
			}
			else
			{
				result='Invalid Order or does not meet the criteria.';
			}
	
		}
		else
		{
			result='Error occured, please try again or contact administrator.';
		}
		return result;		
	}	
	webService static String SendEventIncentive(String OrderId)
	{
		String result='';
		if(!String.isBlank(OrderId))
		{
			List<Order__c> listOrder=[Select Id,PatientFirstName__c,PatientLastName__c,PatientDOB__c,PatientEmailH__c,EmployeeID__c,ProgramID__c,
						ProgramID__r.Limeade_PSK_ID__c,ProgramID__r.Limeade_E_Id__c,WW_Event__c,WW_Event__r.Incentive_ID__c,
						WW_Event__r.Identifier_Last_Name__c,WW_Event__r.Identifier_DOB__c,WW_Event__r.Identifier_Email__c,WW_Event__r.Identifier_Employee_ID__c
						From Order__c Where Id=:OrderId AND Order_Type__c='Incentive Event' AND Order_Status__c='Received' AND WW_Event__r.Incentive_ID__c!=null];
			if(listOrder.size()==1)
			{
				Order__c o=listOrder[0];
				String LimeadeParticipantCode='';
				Boolean validatedAgainstLimeade=false;
				LimeadeValidator lv=new LimeadeValidator();
				lv.LimeadeEID=o.ProgramId__r.Limeade_E_Id__c;
				lv.LimeadePSKID=o.ProgramId__r.Limeade_PSK_ID__c; 
				lv.LastName=o.PatientLastName__c;
				lv.DOB=o.PatientDOB__c.format();
				lv.Email=o.PatientEmailH__c;
				lv.employeeId=o.EmployeeID__c;
				lv.IdentifierLastName=o.WW_Event__r.Identifier_Last_Name__c;
				lv.IdentifierDOB=o.WW_Event__r.Identifier_DOB__c;
				lv.IdentifierEmail=o.WW_Event__r.Identifier_Email__c;
				lv.IdentifierEmployeeID=o.WW_Event__r.Identifier_Employee_ID__c;
				lv.validate();
				if(String.isBlank(lv.ErrorMessage))
				{
					LimeadeParticipantCode=lv.LimeadeParticipantCode;
					validatedAgainstLimeade=true;
					String incentivePointXML=JobOutcomesManagementNew.getIncentivePointParticipant(o.WW_Event__r.Identifier_Email__c,o.PatientEmailH__c,o.WW_Event__r.Identifier_Employee_ID__c,o.EmployeeID__c, o.WW_Event__r.Incentive_ID__c);
					//String incentivePointXML=JobOutcomesManagementNew.getIncentivePointParticipant(o.PatientEmailH__c,o.WW_Event__r.Incentive_ID__c);
					incentivePointXML=JobOutcomesManagementNew.getIncentivePointParticipants(incentivePointXML);
					HttpResponse res =JobOutcomesManagementNew.updateIncentivePoints(o.ProgramId__r.Limeade_E_Id__c,o.ProgramId__r.Limeade_PSK_ID__c, incentivePointXML);
					Dom.Document doc = res.getBodyDocument();
					Dom.XMLNode response = doc.getRootElement();
					String status = response.getAttribute('Status', null); 
					String ImportSuccessRowCount = response.getAttribute('ImportSuccessRowCount', null);
					ImportSuccessRowCount=ImportSuccessRowCount==null?'0':ImportSuccessRowCount;
					if(res.getStatusCode() == 200 && Integer.valueOf(ImportSuccessRowCount)==1)
					{
						o.Order_Status__c=String.isBlank(LimeadeParticipantCode)?'Received':'Sent Limeade';
						update o;						
						result='Successfully sent.';
					}
					else
					{
						result='Error occured. Please try again.';
					}					
				}
				else
				{
					result=lv.ErrorMessage;
				}				
			}
			else
			{
				result='Invalid Order or does not meet the criteria.';
			}
	
		}
		else
		{
			result='Error occured, please try again or contact administrator.';
		}
		return result;		
	}	
	webService static String MergeContacts(String AccountId)
	{
		String result='';
		User u=[Select Id,Profile.Name From User Where Id=:Userinfo.getUserId()];
		if(!u.Profile.Name.equalsIgnoreCase('System Administrator') && !u.Profile.Name.equalsIgnoreCase('Aduro-System Admin'))
		{
			result='You do not have permissions to merge contacts.\nContact System Administrator';
			return result;
		}
		if(!String.isBlank(AccountId))
		{
			Account a=[Select Id From Account Where Id=:AccountId];
	        JobMergeContact batch = new JobMergeContact(a.Id); 
	        Id batchId = Database.executeBatch(batch,1);  
	        result='Job is scheduled to merge contacts. It will take few minutes to complete.';			
		}
		else
		{
			result='Error occured, please try again or contact administrator.';
		}
		return result;		
	}
	webService static String SendOrderBestScore(String OrderId)
	{
		String result='';
		if(!String.isBlank(OrderId))
		{
	   		String query = '';
	   		String transferClause = ' AND ProgramID__r.Prevent_Automatic_Results_Transfer__c != true ';
			Set<String> SetLimeadeSendOrderTypes=Constant.SetLimeadeSendOrderTypes;
			query = 'SELECT PatientEmailH__c, Order_Status__c, Limeade_E__c, Limeade_PSK__c, EmployeeID__c,' +
							' ProgramID__r.Limeade_Live_Date__c, Limeade_Transfer_Complete__c, BF__c, ' + 
							' ProgramID__r.Limeade_Identifier_DOB__c,ProgramID__r.Limeade_Identifier_Email__c,ProgramID__r.Limeade_Identifier_Employee_ID__c,ProgramID__r.Limeade_Identifier_LastName__c,'+
							' Height_Feet__c, Height_Inches__c, Weight__c, BMI__c, RLdl__c, RHdl__c, ' +
							' RTrig__c, RCho__c,RFpg__c, BP_Systolic__c, BP_Diastolic__c , Limeade_Transfer_First_Failed__c, '  +
							' PatientFirstName__c, PatientLastName__c , PatientDOB__c, PatientGender__c ,Date_of_Test__c,Limeade_Biometric_Date__c,' +		
							' BP_Systolic_Best__c,BP_Diastolic_Best__c,BMI_Best__c,RFpg_Best__c,RCho_Best__c,RHdl_Best__c,'+
							'RLdl_Best__c,LDL_HDL_Ratio_Best__c,Waist_to_Height_Ratio_Best__c,BF_Best__c,HR_Pulse_Best__c,'+
							'TC_HDL_Ratio_Best__c,RTrig_Best__c,Tobacco_Free_Best__c,Height_Inches_Best__c,Height_Feet_Best__c,Weight_Best__c,Weight_Worst__c,Limeade_Participant_Code__c, '+							
							'A1C__c,A1C_Best__c,A1C_Worst__c,Points_A1C__c,Results_A1C__c,A1C_Sent__c '	+
					' FROM Order__c' + 
					' WHERE Order_Status__c=\'Received\'' +
						  ' AND ( ProgramID__r.Program_Status__c != \'Draft\' AND ProgramID__r.Program_Status__c != \'Cancelled\' )' +
						  ' AND ProgramID__r.Limeade_Live_Date__c < TOMORROW '  +
					      //' AND Limeade_E__c = \''+ employer + '\'' +
					      ' AND Order_Type__c IN :SetLimeadeSendOrderTypes '+
					      ' AND In_Limeade__c=\'Yes\' '+
					      //' AND ( Order_Type__c = \'HTK\' OR Order_Type__c = \'Onsite Test\'  OR Order_Type__c = \'Physician Form\' )' +
					      ' AND Order__c.Prevent_Limeade_Transfer__c != true AND Id=:OrderId ' +
							transferClause ;
			LimeadeOrderSender ls=new LimeadeOrderSender();
			List<Order__c> scope=Database.query(query);
			if(scope.size()>0)
			{
				ls.executeHelper(scope);	
				result='Successfully sent.';
			}
			else
			{
				result='Error occured. Please make sure Order meet all dependencies.';
			}		
		}
		else
		{
			result='Error occured, please try again or contact administrator.';
		}
		return result;		
	}	
	webService static String SendOrderIncentive(String OrderId)
	{
		String result='';
		if(!String.isBlank(OrderId))
		{
			Order__c o=[Select Weight_Sent__c, Waist_to_Height_Ratio_Sent__c,  
    							Waist_Sent__c, Tobacco_Free_Sent__c, TC_HDL_Ratio_Sent__c,  
    							RTrig_Sent__c, RLdl_Sent__c,RHdl_Sent__c, RFpg_Sent__c, RCho_Sent__c, 
   								LDL_HDL_Ratio_Sent__c,RTrig_Best__c,RTrig_Worst__c,  
    							Height_Total_Inches_Sent__c, Height_Inches_Sent__c, 
    							Height_Ft_Sent__c, Heart_Rate_Sent__c, Contact__c, 
    							Body_Fat_Sent__c, BP_Systolic_Sent__c, BP_Diastolic_Sent__c,  
								A1C__c,A1C_Best__c,A1C_Worst__c,Points_A1C__c,Results_A1C__c,A1C_Sent__c,	
    							BMI_Sent__c, Incentive_Sent__c,Orders_Compared_Best__c,Orders_Compared_Worst__c
    							,BP_Systolic_Best__c,BP_Diastolic_Best__c,BMI_Best__c,RFpg_Best__c,RCho_Best__c,RHdl_Best__c,
								RLdl_Best__c,LDL_HDL_Ratio_Best__c,Waist_to_Height_Ratio_Best__c,BF_Best__c,HR_Pulse_Best__c,TC_HDL_Ratio_Best__c
								,BP_Systolic_Worst__c,BP_Diastolic_Worst__c,BMI_Worst__c,RFpg_Worst__c,RCho_Worst__c,RHdl_Worst__c,
								RLdl_Worst__c,LDL_HDL_Ratio_Worst__c,Waist_to_Height_Ratio_Worst__c,BF_Worst__c,HR_Pulse_Worst__c,TC_HDL_Ratio_Worst__c,
								Results_HDL_LDL__c,Results_BMI__c,Results_Body_Fat__c,Results_BP__c,Results_Glucose__c,Results_HDL__c,Results_Heart_Rate__c,
								Results_LDL__c,Results_TCH_HDL__c,Results_Tobacco_Free__c,Results_Waist_Height__c,Results_TChol__c,Results_Trig__c,
								Points_BMI__c,Points_Body_Fat__c,Points_BP__c,Points_Glucose__c,Points_HDL__c,Points_Heart_Rate__c,
								Points_LDL__c,Points_TChol__c,Points_Tobacco_Free__c,Points_Trig__c,Points_Wst_Ht__c,Tests_Met_The_Criteria__c,
								TC_LDL_Ratio_Sent__c,Results_TCH_LDL__c	,Results_Waist__c,Points_Wst__c	,Tests_Not_Met_The_Criteria__c,
								Results_Systolic__c,Results_Diastolic__c,Points_Systolic__c,Points_Diastolic__c						
   								From Order__c Where id=:OrderId];
   			o.Tests_Met_The_Criteria__c=null;
   			o.Tests_Not_Met_The_Criteria__c=null;
			o.Weight_Sent__c=null; 
			o.Waist_to_Height_Ratio_Sent__c=null;  
			o.Waist_Sent__c=null;
			o.Tobacco_Free_Sent__c=null; 
			o.TC_HDL_Ratio_Sent__c=null;
			o.TC_LDL_Ratio_Sent__c=null;   
			o.RTrig_Sent__c=null; 
			o.RLdl_Sent__c=null;
			o.RHdl_Sent__c=null; 
			o.RFpg_Sent__c=null; 
			o.RCho_Sent__c=null; 
			o.LDL_HDL_Ratio_Sent__c=null;  
			o.Height_Total_Inches_Sent__c=null; 
			o.Height_Inches_Sent__c=null; 
			o.Height_Ft_Sent__c=null; 
			o.Heart_Rate_Sent__c=null; 
			o.Body_Fat_Sent__c=null; 
			o.BP_Systolic_Sent__c=null; 
			o.BP_Diastolic_Sent__c=null;  
			o.BMI_Sent__c=null; 
			o.RTrig_Sent__c=null;
			o.A1C_Sent__c=null;
			o.Incentive_Sent__c=false;

			o.Results_HDL_LDL__c=null;
			o.Results_BMI__c=null;
			o.Results_Body_Fat__c=null;
			o.Results_BP__c=null;
			o.Results_Glucose__c=null;
			o.Results_HDL__c=null;
			o.Results_Heart_Rate__c=null;
			o.Results_LDL__c=null;
			o.Results_TCH_HDL__c=null;
			o.Results_Tobacco_Free__c=null;
			o.Results_Trig__c=null;
			o.Results_Waist_Height__c=null;
			o.Results_Waist__c=null;
			o.Results_TCH_LDL__c=null ;
			o.Results_TChol__c=null;	
			o.Results_Systolic__c=null;
			o.Results_Diastolic__c=null;		
			o.Results_A1C__c=null;	


			o.Points_BMI__c=null;
			o.Points_Body_Fat__c=null;
			o.Points_BP__c=null;
			o.Points_Glucose__c=null;
			o.Points_HDL__c=null;
			o.Points_Heart_Rate__c=null;
			o.Points_LDL__c=null;
			o.Points_TChol__c=null;
			o.Points_Tobacco_Free__c=null;
			o.Points_Trig__c=null;
			o.Points_Wst_Ht__c=null;
			o.Points_Wst__c=null;
			o.Points_Systolic__c=null;
			o.Points_Diastolic__c=null;	
			o.Points_A1C__c=null;	

							
			update o;
			result='Job is scheduled to send Incentive. Please wait for couple of minutes and then refresh Order page.';
			if(!System.isBatch() && !System.isFuture() && !System.isScheduled())
			{
				if(Limits.getFutureCalls() < Limits.getLimitFutureCalls()){
					SendIndividualOrder(OrderId);
				}
			}
		}
		else
		{
			result='Error occured, please try again or contact administrator.';
		}
		return result;
	}
	@future(callout=true)
	public static void SendIndividualOrder(String OrderId)
	{
		if(!String.isBlank(OrderId))
		{
			Order__c o=[Select Id,Contact__c,Limeade_Participant_Code__c,ProgramID__r.Outcomes_Mg_Type__c,Incentivizer_Message__c From Order__c Where Id=:OrderId];
			JobOutcomesManagementNew.ProcessOrder(o);
		}
	}
	webService static String UpdateEventContacts(String eventId)
	{
		String result='Event ended successfully';
		if(!String.isBlank(eventId))
		{
			try
			{
				List<Order__c> listNoShowOrders=new List<Order__c>();
				List<Contact> listContacts=[  SELECT c.Id, c.Name, c.FirstName, c.LastName, c.AccountId, c.Email, c.Birthdate, 
												c.Employee_ID__c, c.Sex__c, c.Phone,Appointment_Time__c,Event__c,Event__r.Program__c,
												(Select id From Orders__r Where WW_Event__c=:eventId)
	                							FROM Contact c where Event__c=:eventId];
				for(Contact sourceContact:listContacts)
				{
					if(sourceContact.Orders__r==null || sourceContact.Orders__r.size()==0)
					{
			    		Order__c newOrder = new Order__c();
			    		newOrder.PatientFirstName__c = sourceContact.FirstName;
			    		newOrder.PatientLastName__c = sourceContact.LastName;
			    		newOrder.PatientEmailH__c = sourceContact.Email;
			    		newOrder.PatientPrimaryPhone__c = sourceContact.Phone;
			    		newOrder.PatientDOB__c = sourceContact.Birthdate;
			    		newOrder.PatientGender__c = sourceContact.Sex__c;
			    		newOrder.EmployeeID__c = sourceContact.Employee_ID__c;
			    		newOrder.WW_Event__c = sourceContact.Event__c;
			    		newOrder.ProgramID__c = sourceContact.Event__r.Program__c;
			    		newOrder.Order_Type__c = 'Onsite Test';
			    		newOrder.Order_Status__c = 'No Show';
			    		//newOrder.Onsite_Card_Code__c = cardcode;
			    		newOrder.Contact__c = sourceContact.Id;
			    		//because we used a contact to create the order, we don't want a contact created this time
			    		newOrder.Dont_Create_Contact__c = true;
			    		newOrder.Appointment_Time__c=sourceContact.Appointment_Time__c;
			    		listNoShowOrders.add(newOrder);					
					}
					sourceContact.Event__c=null;
					sourceContact.Appointment_Time__c=null;
				}
				update listContacts;
				upsert listNoShowOrders;
			}
			catch(Exception ex)
			{
				result='Error occured. Please contact administrator.\n'+ex.getMessage();
			}
		}
		else
		{
			result='Please select valid event';
		}
		return result;
	}
	webService static String sendEngagementEmail(String engagementId,String templateId)
	{
		String result='';
		String template='';
		
		if(templateId.equalsIgnoreCase('1'))
		{
			template='Ignite_Coaching_Weekly_Engagement_Email';
		}
		else if(templateId.equalsIgnoreCase('2'))
		{
			template='Ignite_Coaching_Webinar_Weekly_Engagement_Email';
		}
		else if(templateId.equalsIgnoreCase('3'))
		{
			template='Ignite_Coaching_Welcome_Email';
		}
		EmailTemplate et=[Select Id,Subject,Body From EmailTemplate Where DeveloperName=:template];
		Report_Cards__c rc=[Select Id,Contact__c,Contact__r.Name,Contact__r.FirstName, Contact__r.Email,Weekly_Action_Items__c,
							Report_Cards__c,Report_Cards__r.Name,Report_Cards__r.Id,Report_Cards__r.Coach_Mentor__c,
							Report_Cards__r.Program_Name__c,X6_Week_Engagement_Goal_Type__c
							From Report_Cards__c Where Id=:engagementId];
		String subject=et.Subject;
		String body=et.Body;
		String actionItems=rc.Weekly_Action_Items__c!=null?rc.Weekly_Action_Items__c:'';
		String programName=rc.Report_Cards__r.Program_Name__c!=null?rc.Report_Cards__r.Program_Name__c:'';
		if(!String.isBlank(actionItems))
		{
			String[] actionItemsA=actionItems.split('\n');
			actionItems='';
			Integer i=1;
			for(String a:actionItemsA)
			{
				actionItems+=i+'. '+a+'\n';
				i=i+1;
			}
		}
		String mentor=rc.Report_Cards__r.Coach_Mentor__c!=null?rc.Report_Cards__r.Coach_Mentor__c:'';
		body=body.replace('{!Contact.FirstName}',rc.Contact__r.FirstName);
		body=body.replace('{!Report_Cards__c.Weekly_Action_Items__c}',actionItems);
		body=body.replace('{!Contact.Id}',rc.Contact__c);
		body=body.replace('{!Report_Cards__c.Name}',rc.Report_Cards__r.Name);
		body=body.replace('{!Goal__c.Coach_Mentor__c}',mentor);
		body=body.replace('{!Goal__c.Program_Name__c}',programName);
		
		body=body.replace('{!Report_Cards__c.Report_Cards__c}',rc.Report_Cards__c);
		body=body.replace('{!Report_Cards__c.Id}',rc.Id);
		body=body.replace('{!Report_Cards__c.X6_Week_Engagement_Goal_Type__c}',rc.X6_Week_Engagement_Goal_Type__c!=null?rc.X6_Week_Engagement_Goal_Type__c:'');
		
		OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'noreply@adurolife.com' limit 1];
		Messaging.reserveSingleEmailCapacity(2);
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {rc.Contact__r.Email}; 
		//String[] ccAddresses = new String[] {'smith@gmail.com'}; 
		mail.setToAddresses(toAddresses);
		//mail.setCcAddresses(ccAddresses);
		mail.setReplyTo('noreply@adurolife.com');
		//mail.setSenderDisplayName('Aduro Support');
		mail.setSubject(subject);
		mail.setBccSender(false);
		mail.setUseSignature(false);
		mail.setOrgWideEmailAddressId(owea.Id);
		mail.setPlainTextBody(body);
		//mail.setHtmlBody(htmlValue);
		mail.setWhatId(rc.Id);
		mail.setSaveAsActivity(true);		
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });	
		result='Sent Successfully';
		return result;
	}
	webService static String validateOrder(String OrderId)
	{
		String result='';
		JobValidateOrders jvo=new JobValidateOrders();
		if(!String.isBlank(orderId))
		{
			Set<String> SetLimeadeValidateOrderTypes=Constant.SetLimeadeValidateOrderTypes; 
			jvo.query += ' AND Order_Type__c IN :SetLimeadeValidateOrderTypes ';			
			jvo.query+=' AND Id=:orderId';
			List<Sobject> scope=Database.query(jvo.query);
			jvo.execute(null,scope);
			result='Validated Successfully';
		}
		else
		{
			result='Invalid Id, Please try again.';
		}
		return result;
	}
}