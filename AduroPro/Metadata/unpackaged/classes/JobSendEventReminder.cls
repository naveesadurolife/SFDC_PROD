/*******************************************************************************
Author: Navees Ahmed
Email: gullwall@gmail.com
Description:  update orders to check if they exist in limeade
 
system.schedule('JobSendEventReminder1', '0 5 * * * ?', new JobSendEventReminder());
********************************************************************************/
global class JobSendEventReminder  implements Schedulable,Database.Batchable<Sobject>{
	public static EmailTemplate et=[Select e.IsActive, e.Id,e.Subject,e.Body, e.HtmlValue, e.DeveloperName From EmailTemplate e where developername='Event_Registration_Email_Reminder'];
	public static OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'noreply@adurolife.com' limit 1];	
    global void execute(SchedulableContext SC) {
        JobSendEventReminder batch = new JobSendEventReminder(); 
        Id batchId = Database.executeBatch(batch,1);   
    }    
     global Database.QueryLocator start(Database.BatchableContext info){    
         String query = 'Select WW_Event__r.Location__c, WW_Event__r.Event_Type__c, WW_Event__r.End_Time__c,WW_Event__r.Email_Text__c,';
				query +='WW_Event__r.Start_Time__c, WW_Event__r.Event_Date__c, WW_Event__r.Name, WW_Event__c, ';
				query +='Start_Date__c, Name, Last_Name__c, First_Name__c, End_Date__c, Email__c,One_Day_Reminder_Sent__c,Seven_Day_Reminder_Sent__c,One_Hour_Reminder_Sent__c,';
				query +='DOB__c, Contact__c,WW_Event__r.Event_Registration_Header__c,WW_Event__r.Time_Zone__c,WW_Event__r.Event_Address__c,WW_Event__r.Room_Location__c,WW_Event__r.Time_Frame_Per_Slot__c,'; 
				query +='WW_Event__r.Program__r.Test_Weight_Onsite__c, WW_Event__r.Program__r.Test_Waist_Onsite__c, WW_Event__r.Program__r.Test_Trig_Onsite__c, ';
				query +='WW_Event__r.Program__r.Test_TC_Onsite__c, WW_Event__r.Program__r.Test_LDL_Onsite__c, WW_Event__r.Program__r.Test_Height_Onsite__c, WW_Event__r.Program__r.Test_HR_Onsite__c,'; 
				query +='WW_Event__r.Program__r.Test_HDL_Onsite__c, WW_Event__r.Program__r.Test_Glucose_Onsite__c, WW_Event__r.Program__r.Test_Glucose_HTK__c, WW_Event__r.Program__r.Test_Cholesterol_HTK__c,'; 
				query +='WW_Event__r.Program__r.Test_BP_Onsite__c, WW_Event__r.Program__r.Test_BMI_Onsite__c,WW_Event__r.Program__r.Tobacco_Saliva__c, WW_Event__r.Program__r.Type_of_Tobacco_Testing__c';
				query +=' From Slot__c WHERE (One_Day_Reminder_Sent__c=false OR Seven_Day_Reminder_Sent__c=false) ';
				query +=' AND WW_Event__r.Event_Status__c=\'Confirmed\' ';
				query +=' AND (WW_Event__r.Event_Date__c=TODAY OR WW_Event__r.Event_Date__c=TOMORROW OR WW_Event__r.Event_Date__c=NEXT_N_DAYS:7) ';
				query +=' AND Email__c!=null AND WW_Event__r.Coaching_Event_Number__c=null';
         return Database.getQueryLocator(query); 
     }  

     global void execute(Database.BatchableContext BC, List<Sobject> scope){
     	if(scope!=null && scope.size()>0)
     	{
     		List<Slot__c> listSlots=new List<Slot__c>();
     		for(Sobject sc:scope)
     		{
     			Slot__c s=(Slot__c) sc;
				String tests='<ul>';
				if(s.WW_Event__r.Program__r.Test_TC_Onsite__c)	tests+='<li>Total Cholesterol</li>';
				if(s.WW_Event__r.Program__r.Test_LDL_Onsite__c)	tests+='<li>LDLs</li>';
				if(s.WW_Event__r.Program__r.Test_HDL_Onsite__c)	tests+='<li>HDLs</li>';
				if(s.WW_Event__r.Program__r.Test_Glucose_Onsite__c)	tests+='<li>Glucose</li>';
				if(s.WW_Event__r.Program__r.Test_BP_Onsite__c)	tests+='<li>Blood Pressure</li>';
				if(s.WW_Event__r.Program__r.Test_HR_Onsite__c)	tests+='<li>Heart Rate</li>';
				if(s.WW_Event__r.Program__r.Test_BMI_Onsite__c)	tests+='<li>BMI</li>';
				if(s.WW_Event__r.Program__r.Tobacco_Saliva__c)	tests+='<li>Tobacco Use - '+ s.WW_Event__r.Program__r.Type_of_Tobacco_Testing__c + '</li>';
				if(s.WW_Event__r.Program__r.Test_Height_Onsite__c)	tests+='<li>Height</li>';
				if(s.WW_Event__r.Program__r.Test_Waist_Onsite__c)	tests+='<li>Waist</li>';
				if(s.WW_Event__r.Program__r.Test_Weight_Onsite__c)	tests+='<li>Weight</li>';
				//if(p.Test_TC_Onsite__c)	tests+='<li>Body Fat % </li>';
				if(s.WW_Event__r.Program__r.Test_Trig_Onsite__c)	tests+='<li>Triglycerides</li>';
				tests+='</ul>';
				//EmailTemplate et=[Select e.IsActive, e.Id,e.Subject,e.Body, e.HtmlValue, e.DeveloperName From EmailTemplate e where developername='Event_Registration_Email'];
				String subject=et.Subject;
				subject=subject.replace('@@EVENTNAME@@',s.WW_Event__r.Name);
				subject=subject.replace('@@EVENTDATE@@',s.Start_Date__c.Date().format());
				String htmlValue=et.HtmlValue;
				htmlValue=htmlValue.replace('@@USERNAME@@',(s.First_Name__c+' '+s.Last_Name__c));
				htmlValue=htmlValue.replace('@@EVENTTEXT@@',(s.WW_Event__r.Email_Text__c!=null?'<b><u>Note:</b></u>&nbsp;'+s.WW_Event__r.Email_Text__c+'<br/><br/>':''));
				//htmlValue=htmlValue.replace('@@EVENTTEST@@','<b><u>To be tested at your appointment:</b></u>&nbsp;please allow '+s.WW_Event__r.Time_Frame_Per_Slot__c+' minutes for testing.'+tests+'<br/><br/>');
				htmlValue=htmlValue.replace('@@EVENTTEST@@','<b><u>Screenings will include:</b></u><br/>(please allow 15 minutes for testing)<br/>'+tests+'<br/><br/>');
				htmlValue=htmlValue.replace('@@EVENTADDRESS@@',(s.WW_Event__r.Event_Address__c!=null?s.WW_Event__r.Event_Address__c:''));
				htmlValue=htmlValue.replace('@@ROOMLOCATION@@',s.WW_Event__r.Room_Location__c!=null?s.WW_Event__r.Room_Location__c:'');
				htmlValue=htmlValue.replace('@@EMAIL@@',(s.Email__c!=null?s.Email__c:''));
				htmlValue=htmlValue.replace('@@EVENTNAME@@',s.WW_Event__r.Name);
				htmlValue=htmlValue.replace('@@DOB@@',(s.DOB__c!=null?s.DOB__c.format():''));
				htmlValue=htmlValue.replace('@@EVENTDATE@@',s.Start_Date__c.Date().format());
				htmlValue=htmlValue.replace('@@DATE@@',s.Start_Date__c.Date().format()+'-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+'-'+s.End_Date__c.format('hh:mm a','America/Los_Angeles')+' ('+s.WW_Event__r.Time_Zone__c+')');
				htmlValue=htmlValue.replace('@@URL@@',Constant.EVENT_REGISTRATION_URL.replace('@@EVENTID@@',s.WW_Event__c).replace('@@SLOTID@@',s.Id));
				if(s.WW_Event__r.Event_Type__c=='Venipuncture')
				{
					htmlValue=htmlValue.replace('@@DETAIL@@','The cholesterol/glucose test is a full blood draw (venipuncture).  Results will be available and in your wellness account 7-10 days after the event. Staying hydrated and refraining from consuming any food or beverages (other than water) eight hours prior to your test will help with collecting a sample and ensure a more accurate reading.');
				}
				else
				{
					htmlValue=htmlValue.replace('@@DETAIL@@','The cholesterol/glucose test is a simple finger-stick test that will provide you with immediate results.  Staying hydrated and refraining from consuming any food or beverages (other than water) eight hours prior to your test will help with collecting a sample and ensure a more accurate reading.');
				}				
				Messaging.reserveSingleEmailCapacity(2);
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {s.Email__c}; 
				//String[] ccAddresses = new String[] {'smith@gmail.com'}; 
				mail.setToAddresses(toAddresses);
				//mail.setCcAddresses(ccAddresses);
				mail.setReplyTo('noreply@adurolife.com');
				//mail.setSenderDisplayName('Aduro Support');
				mail.setSubject(subject);
				mail.setBccSender(false);
				mail.setUseSignature(false);
				mail.setOrgWideEmailAddressId(owea.Id);
				//mail.setPlainTextBody(et.Body);
				mail.setHtmlBody(htmlValue);
				mail.setWhatId(s.WW_Event__c);
				mail.setSaveAsActivity(true);
				
				Datetime startDateTime = DateTime.parse(s.Start_Date__c.Date().format()+' '+s.WW_Event__r.Start_Time__c);
				
				if(!s.One_Hour_Reminder_Sent__c && s.Start_Date__c.Date()==Date.today() && startDateTime<=s.Start_Date__c.addMinutes(90))
				{	
					s.One_Hour_Reminder_Sent__c=true;
					Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
					listSlots.add(s);
				}				
				if(!s.One_Day_Reminder_Sent__c && s.Start_Date__c.Date()==Date.today().addDays(1))
				{	
					s.One_Day_Reminder_Sent__c=true;
					Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
					listSlots.add(s);
				}
				if(!s.Seven_Day_Reminder_Sent__c && s.Start_Date__c.Date()==Date.today().addDays(7))
				{
					s.Seven_Day_Reminder_Sent__c=true;
					Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
					listSlots.add(s);
				}   
     		}
     		update listSlots;
     	}
     }  

     global void finish(Database.BatchableContext BC){} 
}