/*******************************************************************************
Author: Navees Ahmed
Email: gullwall@gmail.com
Description:  
 
system.schedule('JobTagger', '0 7 * * * ?', new JobTagger());
system.schedule('JobTagger', '0 22 * * * ?', new JobTagger()); 
system.schedule('JobTagger', '0 37 * * * ?', new JobTagger());
system.schedule('JobTagger', '0 52 * * * ?', new JobTagger());
********************************************************************************/
global class JobTagger  implements Schedulable,Database.Batchable<Sobject>, Database.AllowsCallouts {
	global void execute(SchedulableContext SC) {
		//check if there are 5 active batch jobs
		//In some cases, might need to add "Status='Queued' " to the criteria
		List<AsyncApexJob> listAsyncApexJob=[SELECT Id FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')];
		if (listAsyncApexJob.size()< 5){ 
		    JobTagger batch = new JobTagger(); 
		    Id batchId = Database.executeBatch(batch,1);  
		} 
	} 
	global Database.QueryLocator start(Database.BatchableContext info){  
		Set<String> SetLimeadeSendOrderTypes=Constant.SetLimeadeSendOrderTypes;
	 	String query='Select Id,ProgramID__r.Biometric_Completion_Incentive_Id__c,PatientEmailH__c,In_Limeade__c,Order_Status__c,Limeade_Participant_Code__c, ';
 			   query+=' Range_Tier__c,Range_Tier__r.Tier__c, Range_Tier__r.Demographic_Tag__c,Range_Tier__r.Incentive_ID__c,Range_Tier__r.Demographic_Tag_Field__c ';
 			   query+=' From Order__c Where In_Limeade__c=\'Yes\' AND Range_Tier__c!=null AND Demographic_Tag_Sent__c=null AND  Limeade_Participant_Code__c!=null  ';
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
    		//Set<String> SetLimeadeSendOrderTypes=Constant.SetLimeadeSendOrderTypes;
    		//try{
		 		o=[Select Id,
		 			PatientEmailH__c,In_Limeade__c,
		 			EmployeeID__c,
		 			Limeade_Response__c,
		 			Range_Tier__c,
					Demographic_Tag_Sent__c,
					Range_Tier__r.Tier__c, 
					Range_Tier__r.Demographic_Tag__c,
					Range_Tier__r.Incentive_ID__c,
					Range_Tier__r.Demographic_Tag_Field__c ,
	 			    ProgramID__r.Tests_Included_in_Results_Based_Program__c,
	 			    ProgramID__r.Biometric_Completion_Incentive_Id__c,
	 			    ProgramID__r.Limeade_E_Id__c,
	 			    ProgramID__r.Limeade_PSK_ID__c,
	 			    ProgramId__r.Limeade_Identifier_Email__c,
	 			    ProgramId__r.Limeade_Identifier_Employee_ID__c
	 			   From Order__c 
	 			   Where In_Limeade__c='Yes' AND Order_Status__c='Sent Limeade' AND  Limeade_Participant_Code__c!=null AND
	 			         Range_Tier__c!=null AND Demographic_Tag_Sent__c=null AND 
	 			         ProgramID__r.Limeade_E_Id__c!=null AND ProgramID__r.Limeade_E_Id__c!='' AND 
	 			   		 ProgramID__r.Limeade_PSK_ID__c!=null AND ProgramID__r.Limeade_PSK_ID__c!='' 
	 			   		 AND ProgramID__r.Program_Status__c='Active' 
	 			   		 AND Id=:o.Id ];
				if(o!=null)
				{
    				String participantXML = '';
					String participantXMLTagger = '';
					String participantXMLIncentive = '';
					participantXML += '<Participant ';
					if(o.ProgramId__r.Limeade_Identifier_Email__c)
						participantXML += 'email="' + EncodingUtil.urlEncode(o.PatientEmailH__c, 'UTF-8')  + '"';
					if(o.ProgramId__r.Limeade_Identifier_Employee_ID__c)
						participantXML += 'employeeid="' + EncodingUtil.urlEncode(o.EmployeeID__c, 'UTF-8')  + '"';		
					if(String.isNotBlank(o.Range_Tier__r.Incentive_ID__c))
					{
						participantXMLIncentive=participantXML + ' incentiveevent="' + o.Range_Tier__r.Incentive_ID__c  + '"' ;
						participantXMLIncentive += '/>';
					}
					if(String.isNotBlank(o.Range_Tier__r.Demographic_Tag__c) && String.isNotBlank(o.Range_Tier__r.Demographic_Tag_Field__c))
					{
						participantXMLTagger=participantXML + ' '+o.Range_Tier__r.Demographic_Tag_Field__c+'="' + o.Range_Tier__r.Demographic_Tag__c  + '"' ;
						participantXMLTagger += '/>';
					}
							
					String limeadeResponse='';	
					if(String.isNotBlank(participantXMLTagger))
					{
						string Participants=JobOutcomesManagementNew.getIncentivePointParticipants(participantXMLTagger);
						system.debug('Participants====================='+Participants);
						HttpResponse res = JobTagger.updatePoints(o.ProgramID__r.Limeade_E_Id__c, o.ProgramID__r.Limeade_PSK_ID__c,Participants,'identity');
						limeadeResponse+='Sent='+Participants+',Response='+res.getBody();
						Dom.Document doc = res.getBodyDocument();
						Dom.XMLNode response = doc.getRootElement();
						String status = response.getAttribute('Status', null); 
						String ImportSuccessRowCount = response.getAttribute('ImportSuccessRowCount', null);
						String IntegrationFailureRowCount = response.getAttribute('IntegrationFailureRowCount', null);
						ImportSuccessRowCount=ImportSuccessRowCount==null?'0':ImportSuccessRowCount;
						system.debug('res.getStatusCode()====================='+res.getStatusCode());
						system.debug('ImportSuccessRowCount====================='+ImportSuccessRowCount);
						system.debug('IntegrationFailureRowCount====================='+IntegrationFailureRowCount);
						if ( 
			        		res.getStatusCode() == 200  && 
		        			Integer.valueOf(ImportSuccessRowCount)==1
		        			&& Integer.valueOf(IntegrationFailureRowCount)==0
			        	) 
						{
			        		o.Demographic_Tag_Sent__c=Datetime.Now();
						}	
					}
					if(String.isNotBlank(participantXMLIncentive))
					{
						string Participants=JobOutcomesManagementNew.getIncentivePointParticipants(participantXMLIncentive);
						system.debug('Participants====================='+Participants);
						HttpResponse res = JobTagger.updatePoints(o.ProgramID__r.Limeade_E_Id__c, o.ProgramID__r.Limeade_PSK_ID__c,Participants,'IncentivePoints');
						limeadeResponse+='Sent='+Participants+',Response='+res.getBody();
						Dom.Document doc = res.getBodyDocument();
						Dom.XMLNode response = doc.getRootElement();
						String status = response.getAttribute('Status', null); 
						String ImportSuccessRowCount = response.getAttribute('ImportSuccessRowCount', null);
						String IntegrationFailureRowCount = response.getAttribute('IntegrationFailureRowCount', null);
						ImportSuccessRowCount=ImportSuccessRowCount==null?'0':ImportSuccessRowCount;
						system.debug('res.getStatusCode()====================='+res.getStatusCode());
						system.debug('ImportSuccessRowCount====================='+ImportSuccessRowCount);
						system.debug('IntegrationFailureRowCount====================='+IntegrationFailureRowCount);
						if ( 
			        		res.getStatusCode() == 200  && 
		        			Integer.valueOf(ImportSuccessRowCount)==1
		        			&& Integer.valueOf(IntegrationFailureRowCount)==0
			        	) 
						{
			        		o.Demographic_Incentive_Sent__c=Datetime.Now();
						}	
					}					
			        o.Limeade_Response__c=limeadeResponse;
			        update o;				 
				}			   		 
    		//}
    		//catch(Exception ex){} 		
    	}	
    }
	public static HttpResponse updatePoints(String e,String psk,String xmlData,String type) {

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
				        	'&type='+type + 
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
							'<ImportJob Status="error" Message="At least one row failed." Description="Import IncentivePointsMapping - 1/15/2014 on DEVBUILDSERVER" ReportName="IncentivePointsCSV" ProviderName="limeadeprovider" EmployerName="AduroDev" ArchiveFileSize="346" ImportTotalRowCount="9" ImportSuccessRowCount="1" ImportFailedRowCount="0" ImportSkipRowCount="0" IntegrationTotalRowCount="9" IntegrationSuccessCount="3" IntegrationFailureRowCount="0" IntegrationSkipRowCount="0" IntegrationAddRowCount="0" IntegrationUpdateRowCount="3" IntegrationDeleteRowCount="0" JobID="174904" StartTime="1/15/2014 7:48:17 PM" CompleteTime="1/15/2014 7:48:21 PM">'+
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
    global void finish(Database.BatchableContext BC){}   
}