/*******************************************************************************
Author: Navees Ahmed
Email: gullwall@gmail.com
Description:  
 
system.schedule('JobPreventiveIncentivizer1', '0 5 * * * ?', new JobPreventiveIncentivizer());
//system.schedule('JobPreventiveIncentivizer2', '0 20 * * * ?', new JobPreventiveIncentivizer()); 
system.schedule('JobPreventiveIncentivizer3', '0 35 * * * ?', new JobPreventiveIncentivizer());
//system.schedule('JobPreventiveIncentivizer4', '0 50 * * * ?', new JobPreventiveIncentivizer());
********************************************************************************/
global class JobPreventiveIncentivizer  implements Schedulable,Database.Batchable<Sobject>, Database.AllowsCallouts {
	global void execute(SchedulableContext SC) {
	    JobPreventiveIncentivizer batch = new JobPreventiveIncentivizer(); 
	    Id batchId = Database.executeBatch(batch,1);  
	} 
	global Database.QueryLocator start(Database.BatchableContext info){
		Set<String> orderTypes=Constant.SetLimeadePreventiveScreeningOrderTypes;
	 	String query='Select Id,PatientEmailH__c,In_Limeade__c,Order_Status__c,Limeade_Participant_Code__c, ';
 			   query+=' Contact__c,ProgramID__c  ';
 			   query+=' From Order__c Where Order_Type__c=:orderTypes  AND In_Limeade__c=\'Yes\' AND Limeade_Participant_Code__c!=null  AND Order_Status__c=\'Received\' AND ';
 			   query+=' (Colorectal_Cancer_Screening__c!=null OR Colonoscopy__c!=null OR Prostate_Cancer_Screening__c!=null '; 
 			   query+=' OR Date_of_Dental_Visit__c!=null OR Mammogram__c!=null OR Pap_Smear__c!=null OR Date_of_Vision_Screening_Visit__c!=null OR Check_In_Check_Up__c!=null '; 
 			   query+=' OR Date_of_PCP_Follow_Visit__c!=null OR Pregnancy_Program_Tri_1__c!=null OR Pregnancy_Program_Tri_2__c!=null OR PCP_Follow_Up_2__c!=null OR Preventive_Tobacco_Attestation__c!=null OR Preventive_Urine_Protein_Test__c!=null OR Preventive_2nd_Hemoglobin_A1C__c!=null) ';
 			   query+=' AND ProgramID__r.Do_Not_Send_Preventive_Screening__c=false AND ProgramID__r.Limeade_E_Id__c!=null AND ProgramID__r.Limeade_E_Id__c!=\'\' AND ';
 			   query+=' ProgramID__r.Limeade_PSK_ID__c!=null AND ProgramID__r.Limeade_PSK_ID__c!=\'\' AND Preventive_Screening_Incentivized__c=false AND ProgramID__r.Program_Status__c=\'Active\'';
 			   //query+=' AND Id=\'a0SS0000003urLd\' ';		  
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
    	Program__c p;
    	Map<String,Range__c> mapRanges=new Map<String,Range__c>();
    	Set<String> setTestBeingSent=new Set<String>();
    	String individualParticipants='';
    	if(o!=null)
    	{
    		try
    		{
	    		o=[Select Id,PatientEmailH__c,In_Limeade__c,Order_Status__c,Contact__c,Limeade_Participant_Code__c,ProgramID__c,Colorectal_Cancer_Screening__c,Colonoscopy__c,Prostate_Cancer_Screening__c,Date_of_Dental_Visit__c,
	    			Mammogram__c,Pap_Smear__c,Date_of_Vision_Screening_Visit__c,Date_of_PCP_Follow_Visit__c,
	    			Pregnancy_Program_Tri_1__c,Pregnancy_Program_Tri_2__c,PCP_Follow_Up_2__c,Preventive_Tobacco_Attestation__c,
	    			Preventive_Colonoscopy_Sent__c,Preventive_Colorectal_Sent__c,Preventive_Dental_Visit_Sent__c,Preventive_Mammogram_Sent__c,
	    			Preventive_Pap_Smear_Sent__c,Preventive_PCP_Sent__c,Preventive_Prostate_Cancer_Sent__c,Preventive_Screening_Incentivized__c,
	    			Preventive_Vision_Screening_Sent__c,Preventive_Pregnancy_Program_Tri_1_Sent__c,Preventive_Pregnancy_Program_Tri_2_Sent__c,
	    			Preventive_PCP_Follow_Up_2_Sent__c,Preventive_Tobacco_Attestation_Sent__c,
	    			Preventive_2nd_Hemoglobin_A1C__c,Preventive_2nd_Hemoglobin_A1C_Sent__c,
	    			Preventive_Urine_Protein_Test__c,Preventive_Urine_Protein_Test_Sent__c,
	    			Check_In_Check_Up__c,Preventive_Check_In_Check_Up_Sent__c,PatientGender__c,PatientDOB__c
	    			From Order__c Where Id=:o.Id];
				p=[Select Limeade_E_Id__c,Limeade_PSK_ID__c,Tests_Included_in_Results_Based_Program__c,Program_Status__c,    
					(Select Id, Program__c, Test_Type__c, Start_Date__c,End_Date__c,Incentive_ID__c,
					Gender__c,Age_Min__c,Age_Max__c 
					From Ranges__r where RecordType.DeveloperName='Preventive_Ranges') 
					From Program__c 
					Where Id=:o.ProgramID__c
					AND Limeade_E_Id__c!=null AND Limeade_E_Id__c!='' 
					AND Limeade_PSK_ID__c!=null AND Limeade_PSK_ID__c!=''
					AND Program_Status__c='Active']; 		
				for(Range__c r:p.Ranges__r)
				{
					mapRanges.put(r.Test_Type__c,r);
				}		
    		}
    		catch(Exception ex){}
    		if(o!=null && p!=null)
    		{
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_COLORECTAL,mapRanges,o.Colorectal_Cancer_Screening__c,o.Preventive_Colorectal_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_COLORECTAL);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_COLORECTAL).Incentive_ID__c);
    			}
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PAP_SMEAR,mapRanges,o.Pap_Smear__c,o.Preventive_Pap_Smear_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PAP_SMEAR);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PAP_SMEAR).Incentive_ID__c);
    			}
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_MAMMOGRAM,mapRanges,o.Mammogram__c,o.Preventive_Mammogram_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_MAMMOGRAM);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_MAMMOGRAM).Incentive_ID__c);
    			}    
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PCP,mapRanges,o.Date_of_PCP_Follow_Visit__c,o.Preventive_PCP_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PCP);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PCP).Incentive_ID__c);
    			}    
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PROSTATE,mapRanges,o.Prostate_Cancer_Screening__c,o.Preventive_Prostate_Cancer_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PROSTATE);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PROSTATE).Incentive_ID__c);
    			}
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_COLONOSCOPY,mapRanges,o.Colonoscopy__c,o.Preventive_Colonoscopy_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_COLONOSCOPY);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_COLONOSCOPY).Incentive_ID__c);
    			}      		
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_DENTAL,mapRanges,o.Date_of_Dental_Visit__c,o.Preventive_Dental_Visit_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_DENTAL);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_DENTAL).Incentive_ID__c);
    			} 
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_VISION,mapRanges,o.Date_of_Vision_Screening_Visit__c,o.Preventive_Vision_Screening_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_VISION);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_VISION).Incentive_ID__c);
    			}
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI1,mapRanges,o.Pregnancy_Program_Tri_1__c,o.Preventive_Pregnancy_Program_Tri_1_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI1);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI1).Incentive_ID__c);
    			}
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI2,mapRanges,o.Pregnancy_Program_Tri_2__c,o.Preventive_Pregnancy_Program_Tri_2_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI2);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI2).Incentive_ID__c);
    			}
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PCP_FOLLOW_UP_2,mapRanges,o.PCP_Follow_Up_2__c,o.Preventive_PCP_Follow_Up_2_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PCP_FOLLOW_UP_2);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PCP_FOLLOW_UP_2).Incentive_ID__c);
    			}    
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_ATTESTATION,mapRanges,o.Preventive_Tobacco_Attestation__c,o.Preventive_Tobacco_Attestation_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_ATTESTATION);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_ATTESTATION).Incentive_ID__c);
    			}
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_CHECK_IN_CHECK_UP,mapRanges,o.Check_In_Check_Up__c,o.Preventive_Check_In_Check_Up_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_CHECK_IN_CHECK_UP);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_CHECK_IN_CHECK_UP).Incentive_ID__c);
    			} 
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_2ND_HEMOGLOBIN_A1C,mapRanges,o.Preventive_2nd_Hemoglobin_A1C__c,o.Preventive_2nd_Hemoglobin_A1C_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_2ND_HEMOGLOBIN_A1C);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_2ND_HEMOGLOBIN_A1C).Incentive_ID__c);
    			} 
    			if(isValidDate(Constant.PRVENTIVE_SCREENING_TEST_TYPE_URINE_PROTEIN_TEST,mapRanges,o.Preventive_Urine_Protein_Test__c,o.Preventive_Urine_Protein_Test_Sent__c,o))
    			{
    				setTestBeingSent.add(Constant.PRVENTIVE_SCREENING_TEST_TYPE_URINE_PROTEIN_TEST);
    				individualParticipants+=getIncentivePointParticipant(o.PatientEmailH__c, mapRanges.get(Constant.PRVENTIVE_SCREENING_TEST_TYPE_URINE_PROTEIN_TEST).Incentive_ID__c);
    			}     			    			   			      			 			     			    			      			    				    			 						    			
				if(String.isNotBlank(individualParticipants))
				{
					string Participants=getIncentivePointParticipants(individualParticipants);
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
			        		setTestBeingSent.size()==Integer.valueOf(ImportSuccessRowCount)
			        	) 
			        {
			        	o.Limeade_Response__c=limeadeResponse;
			        	o.Order_Status__c='Sent Limeade';
			        	o.Preventive_Screening_Incentivized__c=true;
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_COLORECTAL))
			        	{
			        		o.Preventive_Colorectal_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PAP_SMEAR))
			        	{
			        		o.Preventive_Pap_Smear_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_MAMMOGRAM))
			        	{
			        		o.Preventive_Mammogram_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PCP))
			        	{
			        		o.Preventive_PCP_Sent__c=DateTime.now();
			        	}	
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PROSTATE))
			        	{
			        		o.Preventive_Prostate_Cancer_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_COLONOSCOPY))
			        	{
			        		o.Preventive_Colonoscopy_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_DENTAL))
			        	{
			        		o.Preventive_Dental_Visit_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_VISION))
			        	{
			        		o.Preventive_Vision_Screening_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI1))
			        	{
			        		o.Preventive_Pregnancy_Program_Tri_1_Sent__c=DateTime.now();
			        	}			        					        			        				       
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI2))
			        	{
			        		o.Preventive_Pregnancy_Program_Tri_2_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_PCP_FOLLOW_UP_2))
			        	{
			        		o.Preventive_PCP_Follow_Up_2_Sent__c=DateTime.now();
			        	}	
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_ATTESTATION))
			        	{
			        		o.Preventive_Tobacco_Attestation_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_CHECK_IN_CHECK_UP))
			        	{
			        		o.Preventive_Check_In_Check_Up_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_2ND_HEMOGLOBIN_A1C))
			        	{
			        		o.Preventive_2nd_Hemoglobin_A1C_Sent__c=DateTime.now();
			        	}
			        	if(setTestBeingSent.contains(Constant.PRVENTIVE_SCREENING_TEST_TYPE_URINE_PROTEIN_TEST))
			        	{
			        		o.Preventive_Urine_Protein_Test_Sent__c=DateTime.now();
			        	}			        				        				        				        				        				        	 				        	
			        }	
			        update o;				
				}    			
    		}						
    	}    	
    }
	public static String getIncentivePointParticipants (String Participants) {
    	String xmlData = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Document>';
		xmlData += Participants + 
						'</Document>';
		return xmlData;
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
							'<ImportJob Status="error" Message="At least one row failed." Description="Import IncentivePointsMapping - 1/15/2014 on DEVBUILDSERVER" ReportName="IncentivePointsCSV" ProviderName="limeadeprovider" EmployerName="AduroDev" ArchiveFileSize="346" ImportTotalRowCount="13" ImportSuccessRowCount="12" ImportFailedRowCount="0" ImportSkipRowCount="0" IntegrationTotalRowCount="9" IntegrationSuccessCount="3" IntegrationFailureRowCount="6" IntegrationSkipRowCount="0" IntegrationAddRowCount="0" IntegrationUpdateRowCount="3" IntegrationDeleteRowCount="0" JobID="174904" StartTime="1/15/2014 7:48:17 PM" CompleteTime="1/15/2014 7:48:21 PM">'+
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
    public static Boolean isValidDate(String testType,Map<String,Range__c> mapRanges, Date testDate,DateTime testSent,Order__c o)
    {
    	Boolean result=false;
		if(
				String.isNotBlank(testType) && testDate!=null && testSent==null && 
				mapRanges.containsKey(testType) &&
				String.isNotBlank(mapRanges.get(testType).Incentive_ID__c) && 
				mapRanges.get(testType).Start_Date__c!=null &&
				mapRanges.get(testType).End_Date__c!=null && 
				mapRanges.get(testType).Start_Date__c<=testDate &&
				mapRanges.get(testType).End_Date__c>=testDate &&
				(String.isBlank(mapRanges.get(testType).Gender__c) || (String.isNotBlank(o.PatientGender__c) && mapRanges.get(testType).Gender__c==o.PatientGender__c)) &&
				(
					(mapRanges.get(testType).Age_Min__c==null && mapRanges.get(testType).Age_Max__c==null) || 
					(o.PatientDOB__c!=null && mapRanges.get(testType).Age_Min__c!=null  && mapRanges.get(testType).Age_Max__c==null && (o.PatientDOB__c.monthsBetween(Date.today())/12)>=mapRanges.get(testType).Age_Min__c ) || 
					(o.PatientDOB__c!=null && mapRanges.get(testType).Age_Max__c!=null  && mapRanges.get(testType).Age_Min__c==null && (o.PatientDOB__c.monthsBetween(Date.today())/12)<=mapRanges.get(testType).Age_Max__c ) ||
					(o.PatientDOB__c!=null && mapRanges.get(testType).Age_Min__c!=null  && mapRanges.get(testType).Age_Max__c!=null && (o.PatientDOB__c.monthsBetween(Date.today())/12)>=mapRanges.get(testType).Age_Min__c  && (o.PatientDOB__c.monthsBetween(Date.today())/12)<=mapRanges.get(testType).Age_Max__c ) 
				)
			)
			{
				result=true;	
			}    		
    	return result;
    }
}