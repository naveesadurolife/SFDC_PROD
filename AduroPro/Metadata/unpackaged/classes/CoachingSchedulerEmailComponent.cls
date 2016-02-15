global with sharing class CoachingSchedulerEmailComponent{
	public String slotIdNew{get;Set;}
	public String emailSubject{get;Set;}
	public CoachingSchedulerEmailComponent()
	{
		//slotIdNew=slotIdNew+'aaaaaaaaaaaaa';
	}
	public String getData()
	{
		String result='';
		if(slotIdNew!=null)
		{
			String templateName='';
			Slot__c s=[Select Id,WW_Event__c,WW_Event__r.Event_Type__c,WW_Event__r.Coaching_Program_Name__c,
					Coaching_Scheduler_Welcome_Email_Sent__c,WW_Event__r.Coaching_Event_Number__c,
					WW_Event__r.Event_Date__c,Start_Date__c,End_Date__c,CreatedDate,
					WW_Event__r.Post_Event_Survey_Link__c,Goal__c,WW_Event__r.Access_Code__c,
					WW_Event__r.Coaching_Welcome_Email__c,WW_Event__r.Coaching_After_Email__c,WW_Event__r.Coaching_Before_Email__c,
					First_Name__c,WW_Event__r.Coaching_Event_Phone_Number__c,WW_Event__r.Start_Time__c,WW_Event__r.Coaching_Event_URL__c,
					Contact__c,WW_Event__r.Time_Zone__c
					From Slot__c Where Id=:slotIdNew];
			if(s.Coaching_Scheduler_Welcome_Email_Sent__c==false && s.WW_Event__r.Coaching_Event_Number__c==1 && s.CreatedDate<=Datetime.now().addMinutes(10))
			{
				/*templateName=s.WW_Event__r.Event_Type__c.replace(' ','_')+'_'+s.WW_Event__r.Coaching_Program_Name__c.replace(' ','_')+'_Welcome';
				System.debug('templateName======================='+templateName);
				List<EmailTemplate> etList=[Select Id,HtmlValue,Subject From EmailTemplate Where DeveloperName=:templateName];
				if(etList!=null && etList.size()==1)
				{
					emailSubject=etList[0].Subject;
					result=etList[0].HtmlValue;
				}
				//result='Send welcome';*/
				result=s.WW_Event__r.Coaching_Welcome_Email__c;
			}
			else if(s.End_Date__c<Datetime.now())
			{
				/*templateName=s.WW_Event__r.Event_Type__c.replace(' ','_')+'_'+s.WW_Event__r.Coaching_Program_Name__c.replace(' ','_')+'_Week'+s.WW_Event__r.Coaching_Event_Number__c+'_follow_up_email';
				System.debug('templateName======================='+templateName);
				List<EmailTemplate> etList=[Select Id,HtmlValue,Subject From EmailTemplate Where DeveloperName=:templateName];
				if(etList!=null && etList.size()==1)
				{
					emailSubject=etList[0].Subject;
					result=etList[0].HtmlValue;
				}*/
				if(s.WW_Event__c!=null && s.WW_Event__r.Coaching_After_Email__c!=null )
				{
					result=s.WW_Event__r.Coaching_After_Email__c.replace('@@SURVEYURL@@',(s.WW_Event__r.Post_Event_Survey_Link__c!=null?s.WW_Event__r.Post_Event_Survey_Link__c.replace('https://',''):'').replace('http://','').replace('http:/','')).replace('@@GOALID@@',s.Goal__c).replace('@@CONTACTID@@',s.Contact__c);
				}
			}			
			else
			{
				//templateName=s.WW_Event__r.Event_Type__c.replace(' ','_')+'_'+s.WW_Event__r.Coaching_Program_Name__c.replace(' ','_')+'_Week'+s.WW_Event__r.Coaching_Event_Number__c;
				//System.debug('templateName======================='+templateName);
				List<EmailTemplate> etList=[Select Id,HtmlValue,Subject From EmailTemplate Where DeveloperName='Coaching_Scheduler_Default_Before_Email'];
				if(etList!=null && etList.size()==1)
				{
					//emailSubject=etList[0].Subject;
					result=etList[0].HtmlValue;
				}
				if(String.isBlank(s.WW_Event__r.Coaching_Before_Email__c))
				{
					String TimeZone='';
					if(String.isNotBlank(s.WW_Event__r.Time_Zone__c) && s.Start_Date__c!=null)
					{
						TimeZone+='('+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+' PST'+') ';
						TimeZone+='('+s.Start_Date__c.addHours(1).format('hh:mm a','America/Los_Angeles')+' MST'+') ';
						TimeZone+='('+s.Start_Date__c.addHours(2).format('hh:mm a','America/Los_Angeles')+' CST'+') ';
						TimeZone+='('+s.Start_Date__c.addHours(3).format('hh:mm a','America/Los_Angeles')+' EST'+') ';
						TimeZone+='('+s.Start_Date__c.addHours(-1).format('hh:mm a','America/Los_Angeles')+' AKST'+') ';
						/*TimeZone=s.WW_Event__r.Time_Zone__c;
						if(TimeZone=='EST')
						{
							TimeZone=TimeZone+'(CST:'+s.Start_Date__c.addHours(1)+',MST:'+s.Start_Date__c.addHours(2)+',PST:'+s.Start_Date__c.addHours(3)+',AKST:'+s.Start_Date__c.addHours(4)+')';
						}
						else if(TimeZone=='CST')
						{
							TimeZone=TimeZone+'(EST:'+s.Start_Date__c.addHours(-1)+',MST:'+s.Start_Date__c.addHours(1)+',PST:'+s.Start_Date__c.addHours(2)+',AKST:'+s.Start_Date__c.addHours(3)+')';
						}
						else if(TimeZone=='MST')
						{
							TimeZone=TimeZone+'(EST:'+s.Start_Date__c.addHours(-2)+',CST:'+s.Start_Date__c.addHours(-1)+',PST:'+s.Start_Date__c.addHours(1)+',AKST:'+s.Start_Date__c.addHours(2)+')';
						}
						else if(TimeZone=='PST')
						{
							TimeZone=TimeZone+'(EST:'+s.Start_Date__c.addHours(-3)+',CST:'+s.Start_Date__c.addHours(-2)+',MST:'+s.Start_Date__c.addHours(-1)+',AKST:'+s.Start_Date__c.addHours(1)+')';
						}	
						else if(TimeZone=='AKST')
						{
							TimeZone=TimeZone+'(EST:'+s.Start_Date__c.addHours(-4)+',CST:'+s.Start_Date__c.addHours(-3)+',MST:'+s.Start_Date__c.addHours(-2)+',PST:'+s.Start_Date__c.addHours(-1)+')';
						}	*/					
					}
					result=String.isNotBlank(s.First_Name__c)?result.replace('@@FIRSTNAME@@',s.First_Name__c):result;
					result=s.WW_Event__r.Event_Date__c!=null?result.replace('@@EVENTDATE@@',s.WW_Event__r.Event_Date__c.format()):result;
					result=String.isNotBlank(s.WW_Event__r.Start_Time__c)?result.replace('@@STARTTIME@@',TimeZone):result;
					
					result=result.replace('@@GOTOTRAININGURL@@',s.WW_Event__r.Coaching_Event_URL__c);
					result=String.isNotBlank(s.WW_Event__r.Coaching_Event_Phone_Number__c)?result.replace('@@EVENTPHONE@@',s.WW_Event__r.Coaching_Event_Phone_Number__c):result;
					result=result.replace('@@ACCESSCODE@@',s.WW_Event__r.Access_Code__c);					
				}
				else
				{
					result=s.WW_Event__r.Coaching_Before_Email__c;
				}
			}
		}
		return result;
	}
}