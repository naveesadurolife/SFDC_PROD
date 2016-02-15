public with sharing class OrderTriggerHandler {
	public static void UpdateFields(List<Order__c> listOrders,Map<Id,Order__c> mapOldOrders)
	{
		if(listOrders!=null && listOrders.size()>0)
		{
			Set<Id> eventIds=new Set<Id>();
			Set<Id> contactIds=new Set<Id>();
			Set<String> limeadeParticipantCodes=new Set<String>();
			Set<Id> ProgramIds = new Set<Id>();
			Set<String> orderKeys = new Set<String>();
			for(Order__c o:listOrders)
			{
				if(!String.isBlank(o.WW_Event__c))
				{
					eventIds.add(o.WW_Event__c);
				}
				if(!String.isBlank(o.Contact__c))
				{
					contactIds.add(o.Contact__c);
				}
				else if(String.isBlank(o.Contact__c) && !String.isBlank(o.Limeade_Participant_Code__c))
				{
					limeadeParticipantCodes.add(o.Limeade_Participant_Code__c.toLowerCase());
				}
				if(!String.isBlank(o.ProgramID__c))
				{
					ProgramIds.add( o.ProgramID__c );
				}
				if( o.PatientDOB__c != null ) {
		        	String key = getOrderKey(o);
		        	orderKeys.add( key.toLowerCase() );
				}
				if(o.BP_Systolic__c!=null && o.BP_Systolic__c==0) o.BP_Systolic__c=null;
				if(o.BP_Diastolic__c!=null && o.BP_Diastolic__c==0) o.BP_Diastolic__c=null;
				//if(o.BMI_Calculated__c!=null && o.BMI_Calculated__c==0) o.BMI_Calculated__c=null;
				if(o.RFpg__c!=null && o.RFpg__c==0) o.RFpg__c=null;
				if(o.RCho__c!=null && o.RCho__c==0) o.RCho__c=null;
				if(o.RHdl__c!=null && o.RHdl__c==0) o.RHdl__c=null;
				if(o.RLdl__c!=null && o.RLdl__c==0) o.RLdl__c=null;
				//if(o.LDL_HDL_Ratio__c!=null && o.LDL_HDL_Ratio__c==0) o.LDL_HDL_Ratio__c;
				//if(o.Waist_to_Height_Ratio__c!=null && o.Waist_to_Height_Ratio__c==0) o.Waist_to_Height_Ratio__c=null;
				if(o.Waist__c!=null && o.Waist__c==0) o.Waist__c=null;
				if(o.BF__c!=null && o.BF__c==0) o.BF__c=null;
				if(o.HR_Pulse__c!=null && o.HR_Pulse__c==0) o.HR_Pulse__c=null;
				//if(o.TC_HDL_Ratio__c!=null && o.TC_HDL_Ratio__c==0) o.TC_HDL_Ratio__c=null;
				//if(o.TC_LDL_Ratio__c!=null && o.TC_LDL_Ratio__c==0) o.TC_LDL_Ratio__c=null; 
				if(o.RTrig__c!=null && o.RTrig__c==0) o.RTrig__c=null;
				if(o.Weight__c!=null && o.Weight__c==0) o.Weight__c=null;
				if(o.A1C__c!=null && o.A1C__c==0) o.A1C__c=null;
				if(mapOldOrders!=null && mapOldOrders.containsKey(o.Id) && o.Preventive_Screening_Incentivized__c)
				{
					if(o.Colorectal_Cancer_Screening__c!=null && mapOldOrders.get(o.Id).Colorectal_Cancer_Screening__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Pap_Smear__c!=null && mapOldOrders.get(o.Id).Pap_Smear__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Mammogram__c!=null && mapOldOrders.get(o.Id).Mammogram__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Date_of_PCP_Follow_Visit__c!=null && mapOldOrders.get(o.Id).Date_of_PCP_Follow_Visit__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Prostate_Cancer_Screening__c!=null && mapOldOrders.get(o.Id).Prostate_Cancer_Screening__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Colonoscopy__c!=null && mapOldOrders.get(o.Id).Colonoscopy__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Date_of_Dental_Visit__c!=null && mapOldOrders.get(o.Id).Date_of_Dental_Visit__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Date_of_Vision_Screening_Visit__c!=null && mapOldOrders.get(o.Id).Date_of_Vision_Screening_Visit__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Pregnancy_Program_Tri_1__c!=null && mapOldOrders.get(o.Id).Pregnancy_Program_Tri_1__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Pregnancy_Program_Tri_2__c!=null && mapOldOrders.get(o.Id).Pregnancy_Program_Tri_2__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.PCP_Follow_Up_2__c!=null && mapOldOrders.get(o.Id).PCP_Follow_Up_2__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Preventive_Tobacco_Attestation__c!=null && mapOldOrders.get(o.Id).Preventive_Tobacco_Attestation__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}	
					if(o.Check_In_Check_Up__c!=null && mapOldOrders.get(o.Id).Check_In_Check_Up__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}		 	
					if(o.Preventive_2nd_Hemoglobin_A1C__c!=null && mapOldOrders.get(o.Id).Preventive_2nd_Hemoglobin_A1C__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}
					if(o.Preventive_Urine_Protein_Test__c!=null && mapOldOrders.get(o.Id).Preventive_Urine_Protein_Test__c==null)
					{
						o.Preventive_Screening_Incentivized__c=false;
						o.Order_Status__c='Received';
					}																																																				
				}
								
			}
			Map<Id, Program__c> relatedPrograms = new Map<Id, Program__c>([ SELECT Id, Account__c,Non_Limeade_Client__c FROM Program__c WHERE Id IN :ProgramIds ]);	
			///Risk Level Ranges
			Map<String,List<Range__c>> mapProgramTestRanges=new Map<String,List<Range__c>>();
			Map<String,Map<Integer,Id>> mapProgramTestStepRanges=new Map<String,Map<Integer,Id>>();
			Map<String,List<Range__c>> mapProgramTaggerRanges=new Map<String,List<Range__c>>();
			Map<String,Integer> mapRangeSteps=new Map<String,Integer>();
			//Map<Integer,String> mapStepRange=new Map<Integer,String>();
			for(Range__c r:[Select Female_High__c, Female_Low__c, Gender__c, Male_High__c, Male_Low__c, Program__c, Id, Risk_Level__c, Step__c,Test_Type__c,RecordType.DeveloperName,Filter_Criteria_New__c,Tier__c from Range__c WHERE  Program__c=:ProgramIds AND ((RecordType.DeveloperName='Tagger') OR (RecordType.DeveloperName='Risk_Level' AND Test_Type__c!=null AND Test_Type__c!='' AND Step__c!=null)) order by Program__c ASC,Test_Type__c ASC,Step__c ASC,Tier__c ASC])
			{
				
				if(r.RecordType.DeveloperName=='Risk_Level')
				{
					mapRangeSteps.put(r.Id,Integer.valueOf(r.Step__c));
					String key=r.Program__c+r.Test_Type__c;
					if(!mapProgramTestRanges.containsKey(key))
					{
						mapProgramTestRanges.put(key,new List<Range__c>());
						
					}
					if(!mapProgramTestStepRanges.containsKey(r.Program__c))
					{
						mapProgramTestStepRanges.put(r.Program__c,new Map<Integer,Id>());
					}
					mapProgramTestRanges.get(key).add(r);
					System.debug('Integer.valueOf(r.Step__c)===================='+Integer.valueOf(r.Step__c));
					mapProgramTestStepRanges.get(r.Program__c).put(Integer.valueOf(r.Step__c),r.Id);
				}
				else if(r.RecordType.DeveloperName=='Tagger' && String.isNotBlank(r.Filter_Criteria_New__c))
				{
					String key=r.Program__c;
					if(!mapProgramTaggerRanges.containsKey(key))
					{
						mapProgramTaggerRanges.put(key,new List<Range__c>());
					}
					mapProgramTaggerRanges.get(key).add(r);					
				}
			}
			System.debug('mapProgramTestStepRanges================'+mapProgramTestStepRanges);
			///Risk Level Ranges
			Set<Id>  accIDs=new Set<Id>();
			for(Program__c p:relatedPrograms.values())
			{
				if(!String.isBlank(p.Account__c))
				{
					accIDs.add(p.Account__c);
				}
			}
  			Contact[] relatedListOfContacts = [ SELECT Concat_Unique_Key__c, Id FROM Contact WHERE Concat_Unique_Key__c IN :orderKeys ];	
  			system.debug('accIDs====================='+accIDs);
  			system.debug('contactIds====================='+contactIds);
  			system.debug('limeadeParticipantCodes====================='+limeadeParticipantCodes);		
			Map<Id,Contact> mapContacts=new Map<Id,Contact>([Select Id,Limeade_ParticipantCode__c From Contact Where AccountId=:accIDs AND (Id=:contactIds OR (Limeade_ParticipantCode__c!=null AND Limeade_ParticipantCode__c!='' AND Limeade_ParticipantCode__c=:limeadeParticipantCodes))]);
			Map<String,Contact> mapContactsLimeadeParticipantCode=new Map<String,Contact>();
			for(Contact c:mapContacts.values())
			{
				if(!String.isBlank(c.Limeade_ParticipantCode__c))
				{
					mapContactsLimeadeParticipantCode.put(c.Limeade_ParticipantCode__c.toLowerCase(),c);
				}
			}
		  	Map<String, Contact> relatedContacts = new Map<String, Contact>();	
		  	for( Contact theCon : relatedListOfContacts ) {
		  		relatedContacts.put( theCon.Concat_Unique_Key__c.toLowerCase(), theCon );
		  	}			
  			
    		List<RecordType> recType = [Select SobjectType, Name, IsActive, Id  From RecordType WHERE IsActive = true AND SobjectType = 'Contact' AND Name = 'Participants' LIMIT 1];
			Id recordTypeId = recType[0].Id;  					
			List<Contact> updateParticipantCode=new List<Contact>();
			//Contact[] contactsToInsert = new List<Contact>();
			Map<String,Contact> contactsBeingCreatedForParticipantCode=new Map<String,Contact>();
			Map<String,Contact> ordersThatNeedContacts=new Map<String,Contact>();
			for(Order__c o:listOrders)
			{
				//set range fields
				calculateRangeFields(mapProgramTestRanges,o);
				calculateTier(mapRangeSteps,mapProgramTestStepRanges,mapProgramTaggerRanges,o);
				if(!String.isBlank(o.Contact__c) && mapContacts.containsKey(o.Contact__c) && String.isBlank(mapContacts.get(o.Contact__c).Limeade_ParticipantCode__c) && !String.isBlank(o.Limeade_Participant_Code__c))
				{
					Contact c=mapContacts.get(o.Contact__c);
					c.Limeade_ParticipantCode__c=o.Limeade_Participant_Code__c;
					updateParticipantCode.add(c);
				}
				else if(String.isBlank(o.Contact__c) && !String.isBlank(o.Limeade_Participant_Code__c) && mapContactsLimeadeParticipantCode.containsKey(o.Limeade_Participant_Code__c.toLowerCase()))
				{
					o.Contact__c=mapContactsLimeadeParticipantCode.get(o.Limeade_Participant_Code__c.toLowerCase()).Id;
				}
				else if(String.isBlank(o.Contact__c) && !String.isBlank(o.ProgramID__c) && !String.isBlank(o.Limeade_Participant_Code__c) && !mapContactsLimeadeParticipantCode.containsKey(o.Limeade_Participant_Code__c.toLowerCase()) && !contactsBeingCreatedForParticipantCode.containsKey(o.Limeade_Participant_Code__c.toLowerCase()))
				{

		    		//contactsToInsert.add( newContact );		
		    		Contact newContact=getNewOrder(relatedPrograms,o, recordTypeId);
		    		contactsBeingCreatedForParticipantCode.put(o.Limeade_Participant_Code__c.toLowerCase(),newContact);			
				}
				else if(String.isBlank(o.Limeade_Participant_Code__c) && !String.isBlank(o.Contact__c) && mapContacts.containsKey(o.Contact__c) && !String.isBlank(mapContacts.get(o.Contact__c).Limeade_ParticipantCode__c))
				{
					o.Limeade_Participant_Code__c=mapContacts.get(o.Contact__c).Limeade_ParticipantCode__c;
				}
				else if(String.isBlank(o.Limeade_Participant_Code__c) && String.isBlank(o.Contact__c) && relatedPrograms.containsKey(o.ProgramID__c) && relatedPrograms.get(o.ProgramID__c).Non_Limeade_Client__c)
				{
			        String key = '';
			        if( o.PatientDOB__c != null ) {
				        key = getOrderKey(o);
			        }
			
			        if( relatedContacts.containsKey( key.toLowerCase() ) ) {
				   		o.Contact__c = relatedContacts.get( key.toLowerCase() ).Id;
				   	} else if( o.PatientDOB__c != null && o.Dont_Create_Contact__c == false ) {
				   		Contact newContact=getNewOrder(relatedPrograms,o, recordTypeId);
				   		ordersThatNeedContacts.put(key.toLowerCase(), newContact );
				    }					
				}
				
			}
			if(contactsBeingCreatedForParticipantCode!=null && contactsBeingCreatedForParticipantCode.size()>0)
			{
				insert contactsBeingCreatedForParticipantCode.values();
			}
			update updateParticipantCode;
			insert ordersThatNeedContacts.values();			
			Map<Id,WW_Event__c> eventsMap=new Map<Id,WW_Event__c>([Select Id,Overwrite_Order_Type__c From WW_Event__c Where Overwrite_Order_Type__c!=null AND Overwrite_Order_Type__c!='' and Id IN :eventIds]);			
			for(Order__c o:listOrders)
			{
		        String key = '';
		        if( o.PatientDOB__c != null ) {
			        key = getOrderKey(o);
		        }				
				if(String.isBlank(o.Contact__c) && !String.isBlank(o.Limeade_Participant_Code__c) && contactsBeingCreatedForParticipantCode.containsKey(o.Limeade_Participant_Code__c.toLowerCase()))
				{
					o.Contact__c=contactsBeingCreatedForParticipantCode.get(o.Limeade_Participant_Code__c.toLowerCase()).Id;
				}	
				if(String.isBlank(o.Limeade_Participant_Code__c) && String.isBlank(o.Contact__c) && relatedPrograms.containsKey(o.ProgramID__c) && relatedPrograms.get(o.ProgramID__c).Non_Limeade_Client__c && ordersThatNeedContacts.containsKey(key))
				{
					if( o.PatientDOB__c != null && o.Dont_Create_Contact__c == false ) {
				   		o.Contact__c=ordersThatNeedContacts.get(key.toLowerCase()).Id;
				    }					
				}							
				if(
					!String.isBlank(o.WW_Event__c) && eventsMap.containsKey(o.WW_Event__c) && !String.isBlank(eventsMap.get(o.WW_Event__c).Overwrite_Order_Type__c) &&
					(String.isBlank(o.Order_Type__c) || o.Order_Type__c!=eventsMap.get(o.WW_Event__c).Overwrite_Order_Type__c)
				  )
				{
					o.Order_Type__c=eventsMap.get(o.WW_Event__c).Overwrite_Order_Type__c;
				}
				if(o.Order_Status__c=='Received')
				{
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
					o.Incentive_Sent__c=false;
					o.A1C_Sent__c=null;
		
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
				}				
			}
		}
	}
	public static void calculateRangeFields(Map<String,List<Range__c>> mapProgramTestRanges,Order__c o)
	{
		if(o!=null && o.Demographic_Tag_Sent__c==null && mapProgramTestRanges!=null && mapProgramTestRanges.size()>0)
		{
			String programId=o.ProgramId__c;
			Boolean fasting=(String.isNotBlank(o.Fasting_Y_N__c) && o.Fasting_Y_N__c=='N')?false:true;
			System.debug('o.Fasting_Y_N__c===='+o.Fasting_Y_N__c);
			System.debug('fasting===='+fasting);
			Set<String> testFields=new Set<String>();
			if(String.isNotBlank(programId))
			{
				for(String testName:Constant.MAPRANGETESTORDERFIELD.keySet())
				{
					if(!testFields.contains(Constant.MAPRANGETESTORDERFIELD.get(testName)))
					{
						o.put(Constant.MAPRANGETESTORDERFIELD.get(testName),null);
						testFields.add(Constant.MAPRANGETESTORDERFIELD.get(testName));
					}
					String key=programId+testName;
					System.debug('key=============='+key);
					if(mapProgramTestRanges.containsKey(key))
					{
						List<Range__c> listProgramTestRanges=mapProgramTestRanges.get(key);
						if(listProgramTestRanges!=null && listProgramTestRanges.size()>0)
						{
							for(Range__c r:listProgramTestRanges)
							{
								
								if(o.get(Constant.MAPTESTORDERFIELD.get(testName))!=null)
								{
									Decimal lowValue=0;
									Decimal highValue=0;
									if(String.isNotBlank(o.PatientGender__c) && o.PatientGender__c=='Female')
									{
										lowValue=r.Female_Low__c;
										highValue=r.Female_High__c;
									}
									else
									{
										lowValue=r.Male_Low__c;
										highValue=r.Male_High__c;									
									}
									System.debug('lowValue=============='+lowValue);
									System.debug('highValue=============='+highValue);
									if(testName=='Tobacco')
									{
										String testValue=String.valueOf(o.get(Constant.MAPTESTORDERFIELD.get(testName)));
										if(String.isNotBlank(testValue) && testValue.equalsIgnoreCase('N') && lowValue==0)
										{
											o.put(Constant.MAPRANGETESTORDERFIELD.get(testName),String.valueOf(r.Id));
										}
										else if(lowValue==1)
										{
											o.put(Constant.MAPRANGETESTORDERFIELD.get(testName),String.valueOf(r.Id));
										}
									}
									else if(fasting && testName=='Glucose Fasting')
									{
										Decimal testValue=Decimal.valueOf(String.valueOf(o.get(Constant.MAPTESTORDERFIELD.get(testName))));
										System.debug('testValue============='+testValue);
										if(testValue>=lowValue && testValue<=highValue)
										{
											o.put(Constant.MAPRANGETESTORDERFIELD.get(testName),String.valueOf(r.Id));
											break;
										}
									}	
									else if(!fasting && testName=='Glucose Non Fasting')
									{
										Decimal testValue=Decimal.valueOf(String.valueOf(o.get(Constant.MAPTESTORDERFIELD.get(testName))));
										System.debug('testValue============='+testValue);
										if(testValue>=lowValue && testValue<=highValue)
										{
											o.put(Constant.MAPRANGETESTORDERFIELD.get(testName),String.valueOf(r.Id));
											break;
										}
									}									
									else if(!testName.contains('Fasting'))
									{
										Decimal testValue=Decimal.valueOf(String.valueOf(o.get(Constant.MAPTESTORDERFIELD.get(testName))));
										System.debug('testValue============='+testValue);
										if(testValue>=lowValue && testValue<=highValue)
										{
											o.put(Constant.MAPRANGETESTORDERFIELD.get(testName),String.valueOf(r.Id));
											break;
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	public static void calculateTier(Map<String,Integer> mapRangeSteps,Map<String,Map<Integer,Id>> mapProgramTestStepRanges,Map<String,List<Range__c>> mapProgramTaggerRanges,Order__c o)
	{
		//Range_Tier__c	
		if(o!=null && o.Demographic_Tag_Sent__c==null && mapProgramTaggerRanges!=null && mapProgramTaggerRanges.size()>0)
		{
			o.Range_Tier__c=null;
			String programId=o.ProgramId__c;
			if(String.isNotBlank(programId) && mapProgramTestStepRanges.containsKey(programId) && mapProgramTaggerRanges.containsKey(programId))
			{
				List<Range__c> listRangeInOrder=mapProgramTaggerRanges.get(programId);
				Map<Integer,Id> mapStepRanges=mapProgramTestStepRanges.get(programId);
				List<Integer> programRangeSteps=new List<Integer>();
				programRangeSteps.addAll(mapStepRanges.keySet());
				System.debug('mapStepRanges.keySet()==============='+mapStepRanges.keySet());
				programRangeSteps.sort();
				if(listRangeInOrder!=null && listRangeInOrder.size()>0 && mapStepRanges!=null && mapStepRanges.size()>0)
				{
					List<Integer> trueSteps=new List<Integer>();
					for(String fieldName:Constant.MAPRANGETESTORDERFIELD.values())
					{
						String rangeId=String.valueOf(o.get(fieldName));
						if(String.isNotBlank(rangeId))
							trueSteps.add(mapRangeSteps.get(rangeId));
					}
					trueSteps.sort();
					System.debug('trueSteps================'+trueSteps);
					for(Range__c r:listRangeInOrder)
					{
						String filterCriteria=r.Filter_Criteria_New__c;
						filterCriteria=filterCriteria.tolowercase().replace(' ','');
						System.debug('filterCriteria before before=================='+filterCriteria);
						/*for(Integer i=programRangeSteps.size()-1;i>=0;i--)
						{
							System.debug('String.valueOf(programRangeSteps[i])==============='+String.valueOf(programRangeSteps[i]));
							filterCriteria=filterCriteria.replace(String.valueOf(programRangeSteps[i]),'@'+String.valueOf(programRangeSteps[i])+'@');
						}	*/	
						System.debug('filterCriteria before before@=================='+filterCriteria);
						for(Integer i=trueSteps.size()-1;i>=0;i--)
						{
							filterCriteria=filterCriteria.replace('@'+String.valueOf(trueSteps[i])+'@','true');
						}
						for(Integer i=programRangeSteps.size()-1;i>=0;i--)
						{
							System.debug('String.valueOf(programRangeSteps[i])==============='+String.valueOf(programRangeSteps[i]));
							filterCriteria=filterCriteria.replace('@'+String.valueOf(programRangeSteps[i])+'@','false');
						}			
						System.debug('filterCriteria before=================='+filterCriteria);
						String result=parseEXP(filterCriteria,0);
						System.debug('filterCriteria after=================='+filterCriteria);
						System.debug('result=================='+result);
						if(result=='true')
						{
							o.Range_Tier__c=r.Id;
							break;
						}
					}
				}
				//List<Integer> listAllSteps=new List<Integer>();
				//listAllSteps.addAll(mapRangeSteps.values());
				//listAllSteps.sort();
				/*if(listAllSteps!=null)
				{   
					for(Integer i=listAllSteps.size()-1;i>=0;i--)
					{
						Integer step=listAllSteps[i];
						Range__c r=mapRangeInOrder.get(step);
						String filterCriteria=r.Filter_Criteria_New__c;
						filterCriteria=filterCriteria.tolowercase().replace(' ','');
						for(String testName:Constant.MAPRANGETESTORDERFIELD.keySet())
						{
							//String rangeId=o.get(Constant.MAPRANGETESTORDERFIELD.get(testName));
						}
					}
				}*/
			}
		}
	}
    public static String parseEXP(String str,Integer counter) {
		if(counter==null)
		{
			counter=0;
		}
		counter++;
		System.debug('str====================='+str);
        str=str.replace(' ','');
        str=str.replace('trueandtrue','true');
        str=str.replace('trueandfalse','false');
        str=str.replace('falseandtrue','false');
        str=str.replace('falseandfalse','false');
        str=str.replace('trueortrue','true');
        str=str.replace('trueorfalse','true');
        str=str.replace('falseortrue','true');
        str=str.replace('falseorfalse','false');
        str=str.replace('(true)','true');
        str=str.replace('(false)','false');
		System.debug('str====================='+str);
        if(str == 'true' || str=='false') {
            return str;
        }
		else if(counter>40)
		{
			return 'false';
		}
        return parseEXP(str,counter);
    } 	
	public static Contact getNewOrder(Map<Id, Program__c> relatedPrograms,Order__c o,Id recordTypeId)
	{
		Contact newContact = new Contact();
		newContact.AccountId = relatedPrograms.get( o.ProgramID__c ).Account__c;
		newContact.FirstName = o.PatientFirstName__c;
		newContact.LastName = o.PatientLastName__c;
		newContact.Email = o.PatientEmailH__c;
		newContact.Birthdate = o.PatientDOB__c != null ? o.PatientDOB__c : null;
		newContact.Limeade_Identifier_Last_Name__c = o.PatientLastName__c;
		newContact.Limeade_Identifier_EmployeeID__c = o.EmployeeID__c != null ? o.EmployeeID__c : null;
		newContact.Limeade_Identifier_Email__c = o.PatientEmailH__c;
		newContact.Limeade_ParticipantCode__c=o.Limeade_Participant_Code__c;
		newContact.Type_of_Contact__c = 'employee';
		newContact.RecordTypeId = recordTypeId;
		newContact.Most_Recent_Onsite_Checkin__c = o.WW_Event__c;
		newContact.Medical_History__c = 'Not Known';	
		return newContact;	
	}
    public static String getOrderKey(Order__c theOrder)  {
    	String key = '';
    		
    	if( theOrder.PatientDOB__c != null ) {
    		key = theOrder.PatientLastName__c  +'_'+ theOrder.PatientEmailH__c +'_'
		        			+ theOrder.PatientDOB__c.year() + theOrder.PatientDOB__c.month() + theOrder.PatientDOB__c.day();
		    key = key.toUpperCase();
    	}
    	return key.toLowerCase(); 
    }	
	public static void UpdateBestWorstScore(List<Order__c> listOrders)
	{
		if(listOrders!=null && listOrders.size()>0)
		{
			Set<Id> orderIDs=new Set<Id>();
			Set<Id> eventIds=new Set<Id>();
			Set<Id> contactIds=new Set<Id>();
			for(Order__c o:listOrders)
			{
				orderIDs.add(o.Id);
				eventIds.add(o.WW_Event__c);
				if(o.Contact__c!=null)
					contactIds.add(o.Contact__c);
			}
			if(orderIDs!=null && orderIDs.size()>0 && !System.isBatch() && !System.isFuture() && !System.isScheduled()  && ((Limits.getLimitFutureCalls()-Limits.getFutureCalls())>0) )
			{
				UpdateBestWorstScoreFuture(orderIDs);
			}
			if(!System.isBatch() && !System.isFuture() && !System.isScheduled() && ((Limits.getLimitFutureCalls()-Limits.getFutureCalls())>0) )
			{
				WWEventTriggerHandler.UpdateRollupFields(eventIDs);
			}
			if(!System.isBatch() && !System.isFuture() && !System.isScheduled() && ((Limits.getLimitFutureCalls()-Limits.getFutureCalls())>0) )
			{
				UpdatePrimary(contactIds);
			}			
		}
	}
	@future
	public static void UpdatePrimary(Set<Id> contactIds)
	{
		if(contactIds!=null && contactIds.size()>0)
		{
			Set<String> orderStatus=new Set<String>();
			orderStatus.add('Received');
			orderStatus.add('Sent Limeade');
			Set<String> orderTypes=new Set<String>();
			orderTypes.add('Onsite Test');
			orderTypes.add('Physician Form');
			orderTypes.add('Lab Test');
			orderTypes.add('External Data');
			orderTypes.add('Wellness Center');
			orderTypes.add('PFF-Late');
			orderTypes.add('Lab Test-Late');
			Map<String,List<Order__c>> mapOrderGroup=new Map<String,List<Order__c>>();
			for(Order__c o:[Select Id,Primary__c,CreatedDate,ProgramID__c,Order_Type__c,Contact__c From Order__c 
							Where Contact__c=:contactIds AND Order_Status__c=:orderStatus 
							AND Order_Type__c=:orderTypes AND ProgramID__c!=null
							Order by CreatedDate DESC])
			{
				String key=o.Contact__c+'_'+o.ProgramID__c+'_'+o.Order_Type__c;
				key=key.toLowerCase();
				List<Order__c> listOrders;
				if(!mapOrderGroup.containsKey(key))
				{
					listOrders=new List<Order__c>();
					mapOrderGroup.put(key,listOrders);
				}
				mapOrderGroup.get(key).add(o);
			}
			List<Order__c> listOrdersToUpdate=new List<Order__c>();
			for(List<Order__c> listOrders:mapOrderGroup.values())
			{
				Datetime dt;
				Order__c primaryOrder;
				for(Order__c o:listOrders)
				{
					if(o.Primary__c)
					{
						primaryOrder=null;
						break;
					}
					else if(primaryOrder==null || o.CreatedDate>primaryOrder.CreatedDate)
					{
						primaryOrder=o;
					}
				}
				if(primaryOrder!=null)
				{
					primaryOrder.Primary__c=true;
					listOrdersToUpdate.add(primaryOrder);
				}
			}
			update listOrdersToUpdate;
		}
	}
	@future
	public static void UpdateBestWorstScoreFuture(Set<Id> orderIDs)
	{
		UpdateBestWorstScoreNow(orderIDs);
	}
	
	public static void UpdateBestWorstScoreNow(Set<Id> orderIDs)
	{
		Set<String> setOrderStatus=new Set<String>();
		setOrderStatus.add('Cancelled');
		setOrderStatus.add('Error');
		setOrderStatus.add('Duplicate');
		if(orderIDs!=null && orderIDs.size()>0)
		{
			List<Order__c> listOrders=[Select Id,Contact__c,ProgramID__c,ProgramID__r.Program_Start_Date__c From Order__c Where Id In :orderIDs];
			Set<Id> contactIDs=new Set<Id>();
			for(Order__c o:listOrders)
			{
				if(o.Contact__c!=null)
				{
					contactIDs.add(o.Contact__c);
				}
			}
			if(contactIDs.size()>0)
			{
				Set<String> SetLimeadeSendOrderTypes=Constant.SetLimeadeSendOrderTypes; 
				Map<String,List<Order__c>> mapContactOrders=new Map<String,List<Order__c>>();
				Map<Id,Order__c> mapOrders=new Map<Id,Order__c>([Select Weight__c, Weight_Sent__c, Waist_to_Height_Ratio__c, Waist_to_Height_Ratio_Sent__c, Waist__c, 
    								Waist_Sent__c, Tobacco__c, Tobacco_Free_Sent__c, TC_HDL_Ratio__c, TC_HDL_Ratio_Sent__c, RTrig__c, 
    								RTrig_Sent__c, RLdl__c, RLdl_Sent__c, RHdl__c, RHdl_Sent__c, RFpg__c, RFpg_Sent__c, RCho__c, RCho_Sent__c, 
    								ProgramID__r.Name, ProgramID__r.Id, ProgramID__c, Prevent_Limeade_Transfer__c, Order_Type__c, 
    								Order_Status__c, OrderDate__c, LDL_HDL_Ratio__c, LDL_HDL_Ratio_Sent__c, In_Limeade__c, 
    								Height_Total_Inches__c, Height_Total_Inches_Sent__c, Height_Inches__c, Height_Inches_Sent__c, 
    								Height_Inches_Best__c,Height_Feet_Best__c,Weight_Best__c,Weight_Worst__c,
    								Height_Ft_Sent__c, Height_Feet__c, Heart_Rate_Sent__c, HR_Pulse__c, Fasting_Y_N__c, Contact__c, 
    								Body_Fat_Sent__c, BP_Systolic__c, BP_Systolic_Sent__c, BP_Diastolic__c, BP_Diastolic_Sent__c, BMI_Calculated__c, 
    								BMI_Sent__c, BF__c, Account__c,PatientEmailH__c,PatientGender__c,Limeade_Response__c,Incentive_Sent__c,
    								ProgramID__r.Program_Start_Date__c,ProgramID__r.Program_End_Date__c,ProgramID__r.Program_Status__c,
    								Orders_Compared_Best__c,Orders_Compared_Worst__c,Tobacco_Free_Best__c
	    							,BP_Systolic_Best__c,BP_Diastolic_Best__c,BMI_Best__c,RFpg_Best__c,RCho_Best__c,RHdl_Best__c,RTrig_Best__c,
									RLdl_Best__c,LDL_HDL_Ratio_Best__c,Waist_to_Height_Ratio_Best__c,BF_Best__c,HR_Pulse_Best__c,TC_HDL_Ratio_Best__c
									,BP_Systolic_Worst__c,BP_Diastolic_Worst__c,BMI_Worst__c,RFpg_Worst__c,RCho_Worst__c,RHdl_Worst__c,RTrig_Worst__c,
									RLdl_Worst__c,LDL_HDL_Ratio_Worst__c,Waist_to_Height_Ratio_Worst__c,BF_Worst__c,HR_Pulse_Worst__c,TC_HDL_Ratio_Worst__c,
									Results_HDL_LDL__c,Results_BMI__c,Results_Body_Fat__c,Results_BP__c,Results_Glucose__c,Results_HDL__c,Results_Heart_Rate__c,
									Results_LDL__c,Results_TCH_HDL__c,Results_Tobacco_Free__c,Results_Waist_Height__c,Results_TChol__c,Results_Trig__c,
									Points_BMI__c,Points_Body_Fat__c,Points_BP__c,Points_Glucose__c,Points_HDL__c,Points_Heart_Rate__c,
									Points_LDL__c,Points_TChol__c,Points_Tobacco_Free__c,Points_Trig__c,Points_Wst_Ht__c,
									TC_LDL_Ratio_Sent__c,Results_TCH_LDL__c,TC_LDL_Ratio_Best__c,TC_LDL_Ratio_Worst__c,TC_LDL_Ratio__c,
									Waist_Best__c,Waist_Worst__c,
									A1C__c,A1C_Best__c,A1C_Worst__c,Points_A1C__c,Results_A1C__c,A1C_Sent__c
    								From Order__c 
    								Where Contact__c=:contactIDs 
    								AND Order_Status__c NOT IN :setOrderStatus 
    								AND Order_Type__c IN :SetLimeadeSendOrderTypes
    								order by ProgramID__r.Program_Start_Date__c desc]);
				for(Order__c o:mapOrders.values())
				{
					List<Order__c> listContactOrders;
					if(!mapContactOrders.containsKey(o.Contact__c))
					{
						listContactOrders=new List<Order__c>();
						mapContactOrders.put(o.Contact__c,listContactOrders);
					}
					listContactOrders=mapContactOrders.get(o.Contact__c);
					listContactOrders.add(o);
				}
				for(Order__c o:listOrders)
				{
					if(o.Contact__c!=null)
					{
						String key=o.Contact__c;
						List<Order__c> listOrder=mapContactOrders.get(key);
						Order newOrder;
						Order oldOrder;
						List<Order> listOrd=findOrdersToCompare(newOrder,oldOrder,o,listOrder);
						newOrder=listOrd[0];	
						oldOrder=listOrd[1];	
						
			        	o.Orders_Compared_Best__c=null;
						o.BP_Systolic_Best__c=null;
						o.BP_Diastolic_Best__c=null;
						o.BMI_Best__c=null;
						o.RFpg_Best__c=null;
						//o.Tobacco_Best__c=newOrder.Tobacco;
						o.RCho_Best__c=null;
						o.RHdl_Best__c=null;
						o.RLdl_Best__c=null;
						o.LDL_HDL_Ratio_Best__c=null;
						o.Waist_to_Height_Ratio_Best__c=null;
						o.Waist_Best__c=null;
						o.BF_Best__c=null;
						o.HR_Pulse_Best__c=null;
						o.TC_HDL_Ratio_Best__c=null;
						o.TC_LDL_Ratio_Best__c=null;
						o.RTrig_Best__c=null;	
						o.Tobacco_Free_Best__c=null;
						o.Height_Inches_Best__c=null;
						o.Height_Feet_Best__c=null;
						o.Weight_Best__c=null;							
						o.A1C_Best__c=null;
						if(newOrder!=null)
						{
				        	o.Orders_Compared_Best__c=newOrder.orderIDs;
							o.BP_Systolic_Best__c=newOrder.BPSystolic;
							o.BP_Diastolic_Best__c=newOrder.BPDiastolic;
							//o.BMI_Best__c=newOrder.BMI!=null?newOrder.BMI.round(System.RoundingMode.DOWN):null;
							o.BMI_Best__c=newOrder.BMI!=null?newOrder.BMI:null;
							o.RFpg_Best__c=newOrder.RFpg;
							//o.Tobacco_Best__c=newOrder.Tobacco;
							o.RCho_Best__c=newOrder.RCho;
							o.RHdl_Best__c=newOrder.RHdl;
							o.RLdl_Best__c=newOrder.RLdl;
							o.LDL_HDL_Ratio_Best__c=newOrder.LDLHDLRatio;
							o.Waist_to_Height_Ratio_Best__c=newOrder.WaistToHeightRatio;
							o.BF_Best__c=newOrder.BF;
							o.HR_Pulse_Best__c=newOrder.HRPulse;
							o.TC_HDL_Ratio_Best__c=newOrder.TCHDLRatio;
							o.TC_LDL_Ratio_Best__c=newOrder.TCLDLRatio;
							o.RTrig_Best__c=newOrder.RTrig;	
							o.Tobacco_Free_Best__c=newOrder.Tobacco;
							o.Height_Inches_Best__c=newOrder.HeightInches;
							o.Height_Feet_Best__c=newOrder.HeightFeet;
							o.Weight_Best__c=newOrder.Weight;	
							o.Waist_Best__c=newOrder.Waist;						
							o.A1C_Best__c=newOrder.A1C;

						}
						o.Orders_Compared_Worst__c=null;
						o.BP_Systolic_Worst__c=null;
						o.BP_Diastolic_Worst__c=null;
						o.BMI_Worst__c=null;
						o.RFpg_Worst__c=null;
						//o.Tobacco_Worst__c=oldOrder.Tobacco;
						o.RCho_Worst__c=null;
						o.RHdl_Worst__c=null;
						o.RLdl_Worst__c=null;
						o.LDL_HDL_Ratio_Worst__c=null;
						o.Waist_to_Height_Ratio_Worst__c=null;
						o.Waist_Worst__c=null;
						o.BF_Worst__c=null;
						o.HR_Pulse_Worst__c=null;
						o.TC_HDL_Ratio_Worst__c=null;
						o.TC_LDL_Ratio_Worst__c=null; 
						o.RTrig_Worst__c=null;		
						o.Weight_Worst__c=null;		
						o.A1C_Worst__c=null;
						if(oldOrder!=null)
						{	
							o.Orders_Compared_Worst__c=oldOrder.orderIDs;
							o.BP_Systolic_Worst__c=oldOrder.BPSystolic;
							o.BP_Diastolic_Worst__c=oldOrder.BPDiastolic;
							o.BMI_Worst__c=oldOrder.BMI;
							o.RFpg_Worst__c=oldOrder.RFpg;
							//o.Tobacco_Worst__c=oldOrder.Tobacco;
							o.RCho_Worst__c=oldOrder.RCho;
							o.RHdl_Worst__c=oldOrder.RHdl;
							o.RLdl_Worst__c=oldOrder.RLdl;
							o.LDL_HDL_Ratio_Worst__c=oldOrder.LDLHDLRatio;
							o.Waist_to_Height_Ratio_Worst__c=oldOrder.WaistToHeightRatio;
							o.BF_Worst__c=oldOrder.BF;
							o.HR_Pulse_Worst__c=oldOrder.HRPulse;
							o.TC_HDL_Ratio_Worst__c=oldOrder.TCHDLRatio;
							o.TC_LDL_Ratio_Worst__c=oldOrder.TCHDLRatio;
							o.RTrig_Worst__c=oldOrder.RTrig;	
							o.Waist_Worst__c=oldOrder.Waist;
							o.Weight_Worst__c=oldOrder.Weight;
							o.A1C_Worst__c=oldOrder.A1C;
						}									
					}
				}
				update listOrders;
			}			
		}
	}
    public static List<Order> findOrdersToCompare(Order newOrder,Order oldOrder,Order__c currentOrder, List<Order__c> listOrd)
    {
    	List<Order> listOrder=new List<Order>();
    	if(currentOrder!=null && listOrd!=null && listOrd.size()>0)
    	{
    		Map<Date,List<Order__c>> mapProgramOrders=new Map<Date,List<Order__c>>();
    		for(Order__c o:listOrd)
    		{
    			system.debug('o.Id=================='+o.Id);
    			if(o.ProgramID__c==currentOrder.ProgramID__c || o.ProgramID__r.Program_Start_Date__c<currentOrder.ProgramID__r.Program_Start_Date__c)
    			{
	    			List<Order__c> listOrders=new List<Order__c>();
	    			if(!mapProgramOrders.containsKey(o.ProgramID__r.Program_Start_Date__c))
	    			{
	    				mapProgramOrders.put(o.ProgramID__r.Program_Start_Date__c,listOrders);
	    			}
	    			listOrders=mapProgramOrders.remove(o.ProgramID__r.Program_Start_Date__c);
	    			listOrders.add(o);
	    			mapProgramOrders.put(o.ProgramID__r.Program_Start_Date__c,listOrders);
    			}
    		}
    		//if(mapProgramOrders.size()>1)
    		{
    			List<Order__c> listOrdersCurrent=mapProgramOrders.remove(currentOrder.ProgramID__r.Program_Start_Date__c);
    			List<Date> allProgramsDate=new List<Date>();
    			for(Date dt:mapProgramOrders.keySet())
    			{
    				allProgramsDate.add(dt);
    			}
    			allProgramsDate.sort();
    			system.debug('allProgramsDate==============='+allProgramsDate);
    			List<Order__c> listOrdersOld;
    			if(allProgramsDate.size()>0)
    			{
    				if(allProgramsDate[allProgramsDate.size()-1]<currentOrder.ProgramID__r.Program_Start_Date__c)
    					listOrdersOld=mapProgramOrders.remove(allProgramsDate[allProgramsDate.size()-1]);
    			}
    			newOrder=new Order();
				if(listOrdersCurrent!=null)
				{
					for(Order__c o:listOrdersCurrent)
					{
    				system.debug('o.Tobacco__c================'+o.Tobacco__c); 
    				newOrder.orderIDs+=o.Id+',';
    				if(o.BP_Systolic__c!=null && (newOrder.BPSystolic==null || o.BP_Systolic__c<newOrder.BPSystolic)) newOrder.BPSystolic=o.BP_Systolic__c;
    				if(o.BP_Diastolic__c!=null && (newOrder.BPDiastolic==null || o.BP_Diastolic__c<newOrder.BPDiastolic)) newOrder.BPDiastolic=o.BP_Diastolic__c;
    				if(o.BMI_Calculated__c!=null && (newOrder.BMI==null || o.BMI_Calculated__c<newOrder.BMI)) newOrder.BMI=o.BMI_Calculated__c;
    				if(o.RFpg__c!=null && (newOrder.RFpg==null || o.RFpg__c<newOrder.RFpg)) newOrder.RFpg=o.RFpg__c;
    				if(o.Tobacco__c!=null && (newOrder.Tobacco==null || o.Tobacco__c=='Y')) newOrder.Tobacco=o.Tobacco__c;
    				if(o.RCho__c!=null && (newOrder.RCho==null || o.RCho__c<newOrder.RCho)) newOrder.RCho=o.RCho__c;
    				if(o.RHdl__c!=null && (newOrder.RHdl==null || o.RHdl__c>newOrder.RHdl)) newOrder.RHdl=o.RHdl__c;
    				if(o.RLdl__c!=null && (newOrder.RLdl==null || o.RLdl__c<newOrder.RLdl)) newOrder.RLdl=o.RLdl__c;
    				if(o.LDL_HDL_Ratio__c!=null && (newOrder.LDLHDLRatio==null || o.LDL_HDL_Ratio__c<newOrder.LDLHDLRatio)) newOrder.LDLHDLRatio=o.LDL_HDL_Ratio__c;
    				if(o.Waist_to_Height_Ratio__c!=null && (newOrder.WaistToHeightRatio==null || o.Waist_to_Height_Ratio__c<newOrder.WaistToHeightRatio)) newOrder.WaistToHeightRatio=o.Waist_to_Height_Ratio__c;
    				if(o.Waist__c!=null && (newOrder.Waist==null || o.Waist__c<newOrder.Waist)) newOrder.Waist=o.Waist__c;
    				if(o.BF__c!=null && (newOrder.BF==null || o.BF__c<newOrder.BF)) newOrder.BF=o.BF__c;
    				if(o.HR_Pulse__c!=null && (newOrder.HRPulse==null || o.HR_Pulse__c<newOrder.HRPulse)) newOrder.HRPulse=o.HR_Pulse__c;
    				if(o.TC_HDL_Ratio__c!=null && (newOrder.TCHDLRatio==null || o.TC_HDL_Ratio__c<newOrder.TCHDLRatio)) newOrder.TCHDLRatio=o.TC_HDL_Ratio__c;
    				if(o.TC_LDL_Ratio__c!=null && (newOrder.TCLDLRatio==null || o.TC_LDL_Ratio__c<newOrder.TCLDLRatio)) newOrder.TCLDLRatio=o.TC_LDL_Ratio__c;
    				if(o.RTrig__c!=null && (newOrder.RTrig==null || o.RTrig__c<newOrder.RTrig)) newOrder.RTrig=o.RTrig__c;
    				
    				if(o.Weight__c!=null && (newOrder.Weight==null || o.Weight__c<newOrder.Weight)) newOrder.Weight=o.Weight__c;
    				if(o.Height_Inches__c!=null && (newOrder.HeightInches==null || o.Height_Inches__c>newOrder.HeightInches)) newOrder.HeightInches=o.Height_Inches__c;
    				if(o.Height_Feet__c!=null && (newOrder.HeightFeet==null || o.Height_Feet__c>newOrder.HeightFeet)) newOrder.HeightFeet=o.Height_Feet__c;
					if(o.A1C__c!=null && (newOrder.A1C==null || o.A1C__c<newOrder.A1C)) newOrder.A1C=o.A1C__c;
					}
				}
    			if(listOrdersOld!=null)
    			{
	    			oldOrder=new Order();
	    			for(Order__c o:listOrdersOld)
	    			{
	    				oldOrder.orderIDs+=o.Id+',';
	    				if(o.BP_Systolic__c!=null && (oldOrder.BPSystolic==null || o.BP_Systolic__c>oldOrder.BPSystolic)) oldOrder.BPSystolic=o.BP_Systolic__c;
	    				if(o.BP_Diastolic__c!=null && (oldOrder.BPDiastolic==null || o.BP_Diastolic__c>oldOrder.BPDiastolic)) oldOrder.BPDiastolic=o.BP_Diastolic__c;
	    				if(o.BMI_Calculated__c!=null && (oldOrder.BMI==null || o.BMI_Calculated__c>oldOrder.BMI)) oldOrder.BMI=o.BMI_Calculated__c;
	    				if(o.RFpg__c!=null && (oldOrder.RFpg==null || o.RFpg__c>oldOrder.RFpg)) oldOrder.RFpg=o.RFpg__c;
	    				if(o.Tobacco__c!=null && (oldOrder.Tobacco==null || o.Tobacco__c=='Y')) oldOrder.Tobacco=o.Tobacco__c;
	    				if(o.RCho__c!=null && (oldOrder.RCho==null || o.RCho__c>oldOrder.RCho)) oldOrder.RCho=o.RCho__c;
	    				if(o.RHdl__c!=null && (oldOrder.RHdl==null || o.RHdl__c<oldOrder.RHdl)) oldOrder.RHdl=o.RHdl__c;
	    				if(o.RLdl__c!=null && (oldOrder.RLdl==null || o.RLdl__c>oldOrder.RLdl)) oldOrder.RLdl=o.RLdl__c;
	    				if(o.LDL_HDL_Ratio__c!=null && (oldOrder.LDLHDLRatio==null || o.LDL_HDL_Ratio__c>oldOrder.LDLHDLRatio)) oldOrder.LDLHDLRatio=o.LDL_HDL_Ratio__c;
	    				if(o.Waist_to_Height_Ratio__c!=null && (oldOrder.WaistToHeightRatio==null || o.Waist_to_Height_Ratio__c>oldOrder.WaistToHeightRatio)) oldOrder.WaistToHeightRatio=o.Waist_to_Height_Ratio__c;
	    				if(o.BF__c!=null && (oldOrder.BF==null || o.BF__c>oldOrder.BF)) oldOrder.BF=o.BF__c;
	    				if(o.Waist__c!=null && (oldOrder.Waist==null || o.Waist__c>oldOrder.Waist)) oldOrder.Waist=o.Waist__c;
	    				if(o.HR_Pulse__c!=null && (oldOrder.HRPulse==null || o.HR_Pulse__c>oldOrder.HRPulse)) oldOrder.HRPulse=o.HR_Pulse__c;
	    				if(o.TC_HDL_Ratio__c!=null && (oldOrder.TCHDLRatio==null || o.TC_HDL_Ratio__c>oldOrder.TCHDLRatio)) oldOrder.TCHDLRatio=o.TC_HDL_Ratio__c;
	    				if(o.TC_LDL_Ratio__c!=null && (oldOrder.TCLDLRatio==null || o.TC_LDL_Ratio__c>oldOrder.TCLDLRatio)) oldOrder.TCLDLRatio=o.TC_LDL_Ratio__c;
	    				if(o.RTrig__c!=null && (oldOrder.RTrig==null || o.RTrig__c>oldOrder.RTrig)) oldOrder.RTrig=o.RTrig__c;
	    				if(o.Weight__c!=null && (oldOrder.Weight==null || o.Weight__c>oldOrder.Weight)) oldOrder.Weight=o.Weight__c;
						if(o.A1C__c!=null && (oldOrder.A1C==null || o.A1C__c<oldOrder.A1C)) oldOrder.A1C=o.A1C__c;
	    			}
    			}    			
    		}
    	}
		system.debug('newOrder============================'+newOrder);
		system.debug('oldOrder============================'+oldOrder);
		/*if(newOrder!=null)
			newOrder.setNullToZero();
		if(oldOrder!=null)
			oldOrder.setNullToZero();	*/
		listOrder.add(newOrder);
		listOrder.add(oldOrder);	
		return listOrder;	
    }
   	public class Order
    {
    	public Decimal BPSystolic{get;set;}
    	public Decimal BPDiastolic{get;set;}
    	public Decimal BMI{get;set;}
    	public Decimal RFpg{get;set;}
    	public String Tobacco{get;set;}
    	public Decimal RCho{get;set;}
    	public Decimal RHdl{get;set;}
    	public Decimal RTrig{get;set;}
    	public Decimal RLdl{get;set;}
    	public Decimal LDLHDLRatio{get;set;}
    	public Decimal WaistToHeightRatio{get;set;}
    	public Decimal Waist{get;set;}
    	public Decimal BF{get;set;}
    	public Decimal HRPulse{get;set;}
    	public Decimal TCHDLRatio{get;set;}
    	public Decimal TCLDLRatio{get;set;}
		public Decimal HeightInches{get;set;}
		public Decimal HeightFeet{get;set;}
		public Decimal Weight{get;set;}	    	
		public Decimal A1C{get;set;}
    	public String orderIDs{get;set;}  
    	public Order()
    	{
    		orderIDs='';
    	}
    	/*public void setNullToZero()
    	{
    		BPSystolic=BPSystolic==null?0:BPSystolic;
    		BPDiastolic=BPDiastolic==null?0:BPDiastolic;
    		BMI=BMI==null?0:BMI;
    		RFpg=RFpg==null?0:RFpg;
    		Tobacco=Tobacco==null?'Y':Tobacco;
    		RCho=RCho==null?0:RCho;
    		RHdl=RHdl==null?0:RHdl;
    		RLdl=RLdl==null?0:RLdl;
    		LDLHDLRatio=LDLHDLRatio==null?0:LDLHDLRatio;
    		WaistToHeightRatio=WaistToHeightRatio==null?0:WaistToHeightRatio;
    		BF=BF==null?0:BF;
    		HRPulse=HRPulse==null?0:HRPulse;
    		TCHDLRatio=TCHDLRatio==null?0:TCHDLRatio;
    		TCLDLRatio=TCLDLRatio==null?0:TCLDLRatio;
    		RTrig=RTrig==null?0:RTrig;
			HeightInches=HeightInches==null?0:HeightInches;
			HeightFeet=HeightFeet==null?0:HeightFeet;
			Weight=Weight==null?0:Weight;    
			Waist=Waist==null?0:Waist;		
    	}     */	
    }
}