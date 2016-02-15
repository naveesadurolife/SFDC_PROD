/**
	* IncentiveEventList - <description>
	* Created by BrainEngine Cloud Studio
	* @author: Navees Ahmed
	* @version: 1.0
*/
public with sharing class IncentiveEvent {
	public WW_Event__c objE{get;set;}
	public Boolean errorOnPage{get;set;}
	public String pageMessage{get;set;}
	public String eventRegistrationLogo{get;set;}
	public IncentiveEvent()
	{
		String eventId=ApexPages.currentPage().getParameters().get('id');
		try{
			objE=getEvent(eventId);
			if(objE.Program__c!=null && !String.isBlank(objE.Program__r.Program_Logo__c))
			{
				eventRegistrationLogo=Constant.DOCUMENT_URL.replace('@@DOCID@@', objE.Program__r.Program_Logo__c);
			}			
		}
		catch(Exception ex){}
		if(objE==null)
		{
			errorOnPage=true;
			pageMessage='Invalid Event. Please try again.';
		}
	}
	public static WW_Event__c getEvent(String eventId)
	{
		return [select Id,Name,Identifier_DOB__c,Identifier_Email__c,Identifier_Employee_ID__c,Identifier_Last_Name__c,
			  Event_Date__c,Location__c,Program__c,Program__r.Limeade_PSK_ID__c,Program__r.Limeade_E_Id__c,Incentive_ID__c,
			  Start_Time__c,End_Time__c,Program__r.Program_Logo__c,
			  Incentive_Event_Display_DOB__c,Incentive_Event_Display_Email__c,Incentive_Event_Display_Employee_ID__c,Incentive_Event_Display_First_Name__c
			  From WW_Event__c Where Id=:eventId];		
	}
    @RemoteAction
    public static String checkInUser(String eventId,String firstName,String lastName,String dateOfBirth,
									 String email,String employeeId,String validate) {
		String result='';
		Date dob;
        if(!String.isBlank(dateOfBirth))
		{
			try{
				dob=Date.parse(dateOfBirth);	
			}
			catch(Exception ex){result='Invalid Date of Birth.';}
			
		}
		if(String.isBlank(result))
		{
			WW_Event__c objE=getEvent(eventId);
			String LimeadeParticipantCode='';
			Boolean validatedAgainstLimeade=false;
			if(!String.isBlank(validate) && validate.equalsIgnoreCase('on'))
			{
				LimeadeValidator lv=new LimeadeValidator();
				lv.LimeadeEID=objE.Program__r.Limeade_E_Id__c;
				lv.LimeadePSKID=objE.Program__r.Limeade_PSK_ID__c; 
				lv.LastName=lastName;
				lv.FirstName=firstName;
				lv.DOB=dateOfBirth;
				lv.Email=email;
				lv.employeeId=employeeId;
				lv.IdentifierLastName=objE.Identifier_Last_Name__c;
				lv.IdentifierDOB=objE.Identifier_DOB__c;
				lv.IdentifierEmail=objE.Identifier_Email__c;
				lv.IdentifierEmployeeID=objE.Identifier_Employee_ID__c;
				lv.validate();
				if(String.isBlank(lv.ErrorMessage))
				{
					LimeadeParticipantCode=lv.LimeadeParticipantCode;
					lastName=lv.LastName;
					firstName=lv.FirstName;
					try{dob=Date.parse(lv.DOB);}catch(Exception ex){}
					employeeId=lv.EmployeeID;
					email=lv.Email;
					validatedAgainstLimeade=true;
				}
				else
				{
					result=lv.ErrorMessage;
				}
			}
			if(String.isBlank(result))
			{
				if(validatedAgainstLimeade)
				{
					String incentivePointXML=JobOutcomesManagementNew.getIncentivePointParticipant(email,objE.Incentive_ID__c);
					incentivePointXML=JobOutcomesManagementNew.getIncentivePointParticipants(incentivePointXML);
					HttpResponse res =JobOutcomesManagementNew.updateIncentivePoints(objE.Program__r.Limeade_E_Id__c,objE.Program__r.Limeade_PSK_ID__c, incentivePointXML);
					Dom.Document doc = res.getBodyDocument();
					Dom.XMLNode response = doc.getRootElement();
					String status = response.getAttribute('Status', null); 
					String ImportSuccessRowCount = response.getAttribute('ImportSuccessRowCount', null);
					ImportSuccessRowCount=ImportSuccessRowCount==null?'0':ImportSuccessRowCount;
					if(res.getStatusCode() == 200 && Integer.valueOf(ImportSuccessRowCount)==1)
					{
						result='';
					}
					else
					{
						result='Error occured. Please try again.';
					}
				}
				if(String.isBlank(result))
				{
					Order__c o=new Order__c();
					o.PatientFirstName__c=firstName;
					o.PatientLastName__c=lastName;
					o.PatientDOB__c=dob;
					o.PatientEmailH__c=email;
					o.EmployeeID__c=employeeId;
					o.Limeade_Participant_Code__c=LimeadeParticipantCode;
					o.WW_Event__c=eventId;
					o.ProgramID__c=objE.Program__c;
					o.Order_Type__c='Incentive Event';
					o.Order_Status__c=String.isBlank(LimeadeParticipantCode)?'Received':'Sent Limeade';
					insert o;
					result='yes';
				}
			}
		}
        return result;
    }	
}