public with sharing class EventRegisterDeleteEmail {
	public String searchEmail{get;set;}
	public Boolean emailSent{get;set;}
	public PageReference SearchEmail()
	{
		emailSent=false;
		if(String.isBlank(searchEmail))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Email');
			ApexPages.addMessage(myMsg);
		}
		else{
			String eid=Apexpages.currentPage().getParameters().get('eid');
			Slot__c s;
			try
			{
				s=[Select WW_Event__r.Location__c, WW_Event__r.Event_Type__c, WW_Event__r.End_Time__c,WW_Event__r.Email_Text__c,
				WW_Event__r.Start_Time__c, WW_Event__r.Event_Date__c, WW_Event__r.Name, WW_Event__c, 
				Start_Date__c, Name, Last_Name__c, First_Name__c, End_Date__c, Email__c,
				DOB__c, Contact__c,WW_Event__r.Event_Registration_Header__c,WW_Event__r.Time_Zone__c,WW_Event__r.Event_Address__c,WW_Event__r.Room_Location__c,WW_Event__r.Time_Frame_Per_Slot__c, 
				WW_Event__r.Program__r.Test_Weight_Onsite__c, WW_Event__r.Program__r.Test_Waist_Onsite__c, WW_Event__r.Program__r.Test_Trig_Onsite__c, 
				WW_Event__r.Program__r.Test_TC_Onsite__c, WW_Event__r.Program__r.Test_LDL_Onsite__c, WW_Event__r.Program__r.Test_Height_Onsite__c, WW_Event__r.Program__r.Test_HR_Onsite__c, 
				WW_Event__r.Program__r.Test_HDL_Onsite__c, WW_Event__r.Program__r.Test_Glucose_Onsite__c, WW_Event__r.Program__r.Test_Glucose_HTK__c, WW_Event__r.Program__r.Test_Cholesterol_HTK__c, 
				WW_Event__r.Program__r.Test_BP_Onsite__c, WW_Event__r.Program__r.Test_BMI_Onsite__c,WW_Event__r.Program__r.Tobacco_Saliva__c,WW_Event__r.Program__r.Body_Fat__c
				From Slot__c where WW_Event__r.Event_Status__c!='Cancelled' AND Email__c=:searchEmail AND WW_Event__c=:eid];
			}
			catch(Exception ex){}
			if(s!=null)
			{
				/*EmailTemplate et=[Select e.IsActive, e.Id,e.Subject,e.Body, e.HtmlValue, e.DeveloperName From EmailTemplate e where developername='Event_Registration_Delete_Email'];
				OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'noreply@adurolife.com' limit 1];
				String subject=et.Subject;
				subject=subject.replace('@@EVENTNAME@@',s.WW_Event__r.Name);
				subject=subject.replace('@@EVENTDATE@@',s.Start_Date__c.Date().format()+'-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles'));
				String htmlValue=et.HtmlValue;
				htmlValue=htmlValue.replace('@@USERNAME@@',(s.First_Name__c+' '+s.Last_Name__c));
				//htmlValue=htmlValue.replace('@@EVENTTEXT@@',(s.WW_Event__r.Email_Text__c!=null?'<b><u>Note:</b></u>&nbsp;'+s.WW_Event__r.Email_Text__c+'<br/><br/>':''));
				//htmlValue=htmlValue.replace('@@EVENTTEST@@','<b><u>To be tested at your appointment:</b></u>&nbsp;please allow '+s.WW_Event__r.Time_Frame_Per_Slot__c+' minutes for testing.'+tests+'<br/><br/>');
				//htmlValue=htmlValue.replace('@@EVENTADDRESS@@',(s.WW_Event__r.Event_Address__c!=null?s.WW_Event__r.Event_Address__c:''));
				//htmlValue=htmlValue.replace('@@ROOMLOCATION@@',s.WW_Event__r.Room_Location__c!=null?s.WW_Event__r.Room_Location__c:'');
				//htmlValue=htmlValue.replace('@@EMAIL@@',(s.Email__c!=null?s.Email__c:''));
				htmlValue=htmlValue.replace('@@EVENTNAME@@',s.WW_Event__r.Name);
				//htmlValue=htmlValue.replace('@@DOB@@',(s.DOB__c!=null?s.DOB__c.format():''));//'+s.End_Date__c.format('hh:mm a','America/Los_Angeles')+'
				htmlValue=htmlValue.replace('@@DATE@@',s.Start_Date__c.Date().format()+'-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+'- ('+s.WW_Event__r.Time_Zone__c+')');
				htmlValue=htmlValue.replace('@@URL@@',Constant.EVENT_REGISTRATION_URL.replace('@@EVENTID@@',s.WW_Event__c).replace('@@SLOTID@@',''));
				Messaging.reserveSingleEmailCapacity(2);
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {s.Email__c}; 
				mail.setToAddresses(toAddresses);
				mail.setReplyTo('noreply@adurolife.com');
				mail.setSubject(subject);
				mail.setBccSender(false);
				mail.setUseSignature(false);
				mail.setOrgWideEmailAddressId(owea.Id);
				mail.setHtmlBody(htmlValue);
				mail.setWhatId(s.WW_Event__c);
				mail.setSaveAsActivity(true);
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });		*/			
				emailSent=true;
				delete s;
			}
			else
			{
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'No appointment with this email was found in our system for this event.');
				ApexPages.addMessage(myMsg);				
			}
		}		
		return null;
	}	
}