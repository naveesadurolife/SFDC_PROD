global class JobUpdateLimeadeInfo  implements Schedulable,Database.Batchable<Sobject>, Database.AllowsCallouts  {

/*
system.schedule('JobUpdateLimeadeInfo1', '0 8 * * * ?', new JobUpdateLimeadeInfo());
system.schedule('JobUpdateLimeadeInfo2', '0 23 * * * ?', new JobUpdateLimeadeInfo()); 
system.schedule('JobUpdateLimeadeInfo3', '0 38 * * * ?', new JobUpdateLimeadeInfo());
system.schedule('JobUpdateLimeadeInfo4', '0 53 * * * ?', new JobUpdateLimeadeInfo());
*/
    global void execute(SchedulableContext SC) {
        JobUpdateLimeadeInfo batch = new JobUpdateLimeadeInfo(); 
        Id batchId = Database.executeBatch(batch,1);  
    }    
     global Database.QueryLocator start(Database.BatchableContext info){     
         String query = 'Select Id,Limeade_Validation_Attempts__c,Limeade_Response__c,Contact__c,Limeade_Participant_Code__c,Contact__r.Limeade_ParticipantCode__c,Limeade_E__c,Limeade_PSK__c,PatientEmailH__c,PatientLastName__c,EmployeeID__c,ProgramID__r.Limeade_Identifier_Employee_ID__c,ProgramID__r.Limeade_Identifier_Email__c,ProgramID__r.Limeade_Identifier_LastName__c From Order__c where (Limeade_Participant_Code__c=null OR Limeade_Participant_Code__c=\'\') and ProgramID__c!=null and In_Limeade__c=\'Yes\'  AND ProgramID__r.Program_Status__c=\'Active\' and (Limeade_Validation_Attempts__c=null OR Limeade_Validation_Attempts__c<3)  ';//and Out_of_Limeade_Ranges__c=false
         return Database.getQueryLocator(query); 
     }  

     global void execute(Database.BatchableContext BC, List<Sobject> scope){ 
     	//List<Contact> listContact=new List<Contact>();
     	Set<Id> orderIDs=new Set<Id>();
     	for(Sobject s:scope)
     	{
     		Order__c o=(Order__c)s;
     		if(o.Limeade_Validation_Attempts__c==null)
     		{
     			o.Limeade_Validation_Attempts__c=0;
     		}
     		o.Limeade_Validation_Attempts__c=o.Limeade_Validation_Attempts__c+1;
     		orderIDs.add(o.Id);
     		String email=o.ProgramID__r.Limeade_Identifier_Email__c?'email="'+o.PatientEmailH__c+'"':'';
     		String employeeId=o.ProgramID__r.Limeade_Identifier_Employee_ID__c?' employeeid="'+o.EmployeeID__c+'"':'';
     		String lastname=o.ProgramID__r.Limeade_Identifier_LastName__c?' lastname="'+o.PatientLastName__c+'"':'';
			string xmlData='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Document><Participant '+email+employeeId+lastname+' incentiveevent="11111111"/></Document>';
			Http h = new Http();
        	String url = Constant.LIMEMADE_API+'Upload.ashx?' ;
			String body = 	'e=' +    EncodingUtil.urlEncode(o.Limeade_E__c, 'UTF-8') + 
				        	'&psk=' +  EncodingUtil.urlEncode(o.Limeade_PSK__c, 'UTF-8') +
				        	'&response=XML' +
				        	'&format=XML' + 
				        	'&type=IncentivePoints' + 
				        	'&data=' +  xmlData ;	
        	system.debug('xmlData==============='+xmlData);        
	        HttpRequest req = new HttpRequest();
	        HttpResponse res = new HttpResponse();
	        
	        req.setTimeout(59000);

			req.setEndpoint(url);
			req.setMethod('POST');
			req.setHeader('Content-Length', body.length().format());
			req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
			req.setBody(body);       
			res = h.send(req);
	        System.debug( 'RES:================ ' + res.getBody()  );    
	        try
	        {
			string r=res.getBody();
			//r=r.substring(r.indexOf('Response=')+9);
         	Dom.Document doc =new  Dom.Document();
			doc.load(r);
         	Dom.XMLNode response = doc.getRootElement();
			String limeadeParticipantCodeO=response.getChildElement('EmployeeFailureRows',null).getChildElement('FailureRow',null).getAttribute('Name', null); 
			system.debug('limeadeParticipantCodeO===================='+limeadeParticipantCodeO);
			system.debug('Id===================='+o.Id);
		    o.Limeade_Participant_Code__c=limeadeParticipantCodeO;
	        }
	        catch(Exception ex){}	         		
     		/*if(!String.isBlank(o.Limeade_Response__c))
     		{
				try
				{
					string r=o.Limeade_Response__c;
					r=r.substring(r.indexOf('Response=')+9);
		         	Dom.Document doc =new  Dom.Document();
					doc.load(r);
		         	Dom.XMLNode response = doc.getRootElement();
					String limeadeParticipantCodeO=response.getChildElement('EmployeeUpdateRows',null).getChildElement('UpdateRow',null).getAttribute('Name', null); 
					system.debug('limeadeParticipantCodeO===================='+limeadeParticipantCodeO);
					system.debug('Id===================='+o.Id);
				    o.Limeade_Participant_Code__c=limeadeParticipantCodeO;
				    if(String.isBlank(o.Contact__r.Limeade_ParticipantCode__c))
				    {
				    	listContact.add(new Contact(Id=o.Contact__c,Limeade_ParticipantCode__c=o.Limeade_Participant_Code__c));
				    }
				}
				catch(Exception ex){}   			
     		} */ 
     	}
     	update scope;
     	OrderTriggerHandler.UpdateBestWorstScoreNow(orderIDs);
     	//update listContact;
     }
     global void finish(Database.BatchableContext BC){} 
}