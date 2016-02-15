public with sharing class CoachingSchedulerEvent{
	public String selectedEventType{get;Set;}
	public String selectedEventDates{get;Set;}
	public String selectedOccurrence{get;Set;}
	public String selectedCoachingProgramName{get;Set;}
	public String selectedTimeZone{get;Set;}
	public String eventURL{get;Set;}
	public String eventPhoneNumber{get;Set;}
	public String coachingProgramName{get;Set;}
	
	public Boolean dataSaved{get;Set;}
	public Boolean templateSaved{get;Set;}
	public static final String OCCURRENCE_ONE_TIME='One Time';
	public static final String OCCURRENCE_WEEKLY='Weekly';
	public static final String OCCURRENCE_BIMONTHLY='Biweekly';
	public static final String OCCURRENCE_MONTHLY='Monthly';
	
	public Document  eventTile{get;Set;}
	
	public WW_Event__c eventStart{get;Set;}
	public WW_Event__c eventEnd{get;Set;}
	
	public List<WW_Event__c> listEvents{get;Set;}
	//public List<EmailTemplate> emailTemplates{get;Set;}
	
	public CoachingSchedulerEvent()
	{
		dataSaved=false;
		templateSaved=false;
		eventStart=new WW_Event__c();
		eventEnd=new WW_Event__c();
		//emailTemplates=new List<EmailTemplate>();
		/*for(Integer i=0;i<50;i++)
		{
			emailTemplates.add(new EmailTemplate());
		}*/
		initEventTile();
	}
	public void initEventTile()
	{
		eventTile=new Document(IsPublic=true);
		eventTile.FolderId=[Select Id From Folder Where DeveloperName='Coaching_Scheduler' limit 1].Id;		
	}
	public PageReference save()
	{
		Boolean errorOnPage=false;
		if(String.isBlank(selectedTimeZone))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Time Zone');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}		
		if(String.isBlank(selectedEventType))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Event Type');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(String.isBlank(eventStart.Access_Code__c))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Access Code');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(String.isBlank(eventPhoneNumber))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Phone Number');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}	
		if(String.isBlank(eventURL))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Goto Training URL');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}	
		if(String.isBlank(eventStart.Post_Event_Survey_Link__c))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Post Event Survey Link');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(String.isBlank(eventStart.X6_Week_Engagement_Goal_Type__c))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select 6 Week Engagement Goal Type');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(String.isBlank(eventStart.X6_Week_Engagement_Modality__c))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select 6 Week Engagement Modality');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}			
		if(String.isBlank(selectedCoachingProgramName))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Coaching Program Name');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(String.isBlank(selectedOccurrence))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Occurrence');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(eventStart.Event_Date__c==null)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Start Date');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(eventEnd.Event_Date__c==null)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter End Date');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(String.isBlank(eventStart.Start_Time__c))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Start Time');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}	
		if(String.isBlank(eventStart.End_Time__c))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select End Time');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(String.isBlank(selectedEventDates))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Dates');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}		
		if(String.isBlank(eventStart.Coaching_Welcome_Email__c))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Welcome Email.');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(errorOnPage && (String.isNotBlank(eventTile.Name) || eventTile.Type!='jpg'))
		{
			initEventTile();
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please reattach Event Tile Image. You can only update jpg images');
			ApexPages.addMessage(myMsg);			
		}
		if(!errorOnPage)
		{
			String guid=GuidUtil.NewGuid();		//http://salesforce.stackexchange.com/questions/4073/how-to-generate-a-guid-uuid	
			Account a=[Select Id From Account Where Name='Ignite Your Life Coaching' ];
			WW_Event__c mainEvent=new WW_Event__c(Employer__c=a.Id,Name=selectedEventType+' '+selectedCoachingProgramName,Event_Group_Id__c=guid,
													Start_Time__c=eventStart.Start_Time__c,End_Time__c=eventStart.End_Time__c,
													Coaching_Event_Occurance__c=selectedOccurrence,Time_Zone__c=selectedTimeZone,
													Event_Type__c=selectedEventType,Coaching_Program_Name__c=selectedCoachingProgramName,
													Coaching_Event_URL__c=eventURL,Coaching_Event_Phone_Number__c=eventPhoneNumber,
													Coaching_Event_Notes__c=eventStart.Coaching_Event_Notes__c,
													Post_Event_Survey_Link__c=eventStart.Post_Event_Survey_Link__c,
													Access_Code__c=eventStart.Access_Code__c,
													X6_Week_Engagement_Goal_Type__c=eventStart.X6_Week_Engagement_Goal_Type__c,
													X6_Week_Engagement_Modality__c=eventStart.X6_Week_Engagement_Modality__c,
													Coaching_Mentor__c=eventStart.Coaching_Mentor__c,Event_Logo__c=eventStart.Event_Logo__c);
			if(String.isNotBlank(eventTile.Name))
			{
				insert eventTile;
				mainEvent.Event_Tile__c=eventTile.Id;
				initEventTile();
			}
			List<Date> listdate=new List<Date>();
			List<String> listStrDates=selectedEventDates.split(',');
			for(String dt:listStrDates)
			{
				listdate.add(Date.parse(dt));
			}
			listdate.sort();
			listEvents=new List<WW_Event__c>();
			for(Integer i=0;i<listdate.size();i++)
			{
				Datetime dt = Datetime.newInstance(listdate[i],System.now().time());
				String dayOfWeek = dt.format('EEEE');				
				WW_Event__c event=mainEvent.clone();
				event.Name+=' '+dt.format('EEE, MMM d yyyy');
				event.Event_Date__c=listdate[i];
				event.Preferred_Day__c=dayOfWeek;
				event.Coaching_Event_Number__c=i+1;
				if(event.Coaching_Event_Number__c==1)
				{
					event.Coaching_Welcome_Email__c=eventStart.Coaching_Welcome_Email__c;
				}
				event.Event_Status__c='Confirmed';
				listEvents.add(event);
			}
			insert listEvents;
			coachingProgramName=selectedCoachingProgramName;
			listEvents=[Select Id,Coaching_Event_Number__c,Name,Coaching_After_Email__c,Coaching_Before_Email__c From WW_Event__c Where Id=:listEvents Order by Coaching_Event_Number__c];
			dataSaved=true;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Total '+listEvents.size()+' events are created.');
			ApexPages.addMessage(myMsg);			
		}
		return null;
	}
	public void saveEventTemplate()
	{
		update listEvents;
		templateSaved=true;
		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Email template saved successfully.');
		ApexPages.addMessage(myMsg);		
	}
	public PageReference cancel()
	{
		PageReference pr=Page.CoachingSchedulerEvent;
		pr.setRedirect(true);
		return pr;
	}
    @RemoteAction
    public static List<DateWrapper> addDate(String strDates)
	{
		List<DateWrapper> listDates=new List<DateWrapper>();
		if(String.isNotBlank(strDates))
		{
			List<Date> listdate=new List<Date>();
			List<String> listStrDates=strDates.split(',');
			for(String dt:listStrDates)
			{
				listdate.add(Date.parse(dt));
			}
			listdate.sort();
			for(Integer i=0;i<listdate.size();i++)
			{
				//listDates.add(listdate[i].format());
				DateWrapper dw=new DateWrapper(listDates.size()+1,listdate[i]);
				listDates.add(dw);
			}			
		}
		return listDates;
	}
	@RemoteAction
	public static String getDocument(String documentId)
	{
		String  docBody='';
		if(String.isNotBlank(documentId))
		{
			Document d=[Select Id,Body From Document Where Id=:documentId];
			Blob dBlob = d.Body;
			//docBody = EncodingUtil.base64Encode(dBlob);
			//dBlob = EncodingUtil.base64Decode(docBody);
			docBody=dBlob.toString();
		}
		return docBody;
	}	
	@RemoteAction
	public static List<Document> getDocuments(String programName)
	{
		List<Document> listDocs=new List<Document>();
		if(String.isNotBlank(programName))
		{
			programName=programName+'%';
			listDocs=[Select Id,Name From Document Where Name like :programName AND Folder.DeveloperName='Coaching_Scheduler' AND (Type='html' OR Type='htm')];
		}
		return listDocs;
	}
    @RemoteAction
    public static List<DateWrapper> getDates(String cccurrence,String startDate,String endDate)
	{
		List<DateWrapper> listDates=new List<DateWrapper>();
		if(String.isNotBlank(startDate) && String.isNotBlank(endDate))
		{
			List<Date> listdate=new List<Date>();
			Date originalSDate=Date.parse(startDate);
			Date sDate=Date.parse(startDate);
			Date eDate=Date.parse(endDate);
			Integer num=0;
			while(sDate<=eDate)
			{
				if(cccurrence==OCCURRENCE_ONE_TIME)
				{
					listdate.add(sDate);
					break;
				}
				else if(cccurrence==OCCURRENCE_WEEKLY)
				{
					listdate.add(originalSDate.addDays(7*num));
					sDate=originalSDate.addDays(7*(num+1));
				}
				else if(cccurrence==OCCURRENCE_BIMONTHLY)
				{
					listdate.add(originalSDate.addDays(14*num));
					sDate=originalSDate.addDays(14*(num+1));
				}
				else if(cccurrence==OCCURRENCE_MONTHLY)
				{
					listdate.add(originalSDate.addMonths(1*num));
					sDate=originalSDate.addMonths(1*(num+1));
				}	
				num++;
			}
			listdate.sort();
			for(Integer i=0;i<listdate.size();i++)
			{
				//listDates.add(listdate[i].format());
				DateWrapper dw=new DateWrapper(listDates.size()+1,listdate[i]);
				listDates.add(dw);
			}
		}
		return listDates;
	}
	public List<SelectOption> getEventTypes()
	{
		List<SelectOption> listEventTypes=new List<SelectOption>();
		listEventTypes.add(new SelectOption('','None'));
		listEventTypes.add(new SelectOption('Hot Topics','Hot Topics'));
		listEventTypes.add(new SelectOption('Ignite Your Life','Ignite Your Life'));
		listEventTypes.add(new SelectOption('Transform Your Life','Transform Your Life'));
		return listEventTypes;
	}
	public List<SelectOption> getEventOccurrences()
	{
		List<SelectOption> listOccurrences=new List<SelectOption>();
		listOccurrences.add(new SelectOption('','None'));
		listOccurrences.add(new SelectOption(OCCURRENCE_ONE_TIME,OCCURRENCE_ONE_TIME));
		listOccurrences.add(new SelectOption(OCCURRENCE_WEEKLY,OCCURRENCE_WEEKLY));
		listOccurrences.add(new SelectOption(OCCURRENCE_BIMONTHLY,OCCURRENCE_BIMONTHLY));
		listOccurrences.add(new SelectOption(OCCURRENCE_MONTHLY,OCCURRENCE_MONTHLY));
		return listOccurrences;
	}
	public List<SelectOption> getCoachingProgramNames()
	{
		List<SelectOption> listCoachingProgramNames=new List<SelectOption>();
		listCoachingProgramNames.add(new SelectOption('','None'));
   		Schema.DescribeFieldResult fieldResult = WW_Event__c.Coaching_Program_Name__c.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	    for( Schema.PicklistEntry f : ple)
   		{
      		listCoachingProgramNames.add(new SelectOption(f.getLabel(), f.getValue()));
   		}   		
		return listCoachingProgramNames;
	}
	public List<SelectOption> getTimeZone()
	{
		List<SelectOption> listTimeZones=new List<SelectOption>();
		listTimeZones.add(new SelectOption('','None'));
   		Schema.DescribeFieldResult fieldResult = WW_Event__c.Time_Zone__c.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	    for( Schema.PicklistEntry f : ple)
   		{
      		listTimeZones.add(new SelectOption(f.getLabel(), f.getValue()));
   		}   		
		return listTimeZones;
	}	
	public class DateWrapper
	{
		public String rowNumber{get;Set;}
		public String formattedDate{get;Set;}
		public String actualDate{get;Set;}
		public DateWrapper(Integer rowNumber,Date dt)
		{
			this.rowNumber=''+rowNumber;
			actualDate=dt.format();	
			Time myTime = Time.newInstance(0, 0, 0, 0);
			formattedDate=Datetime.newInstance(dt,myTime).format('EEE, MMM d yyyy');
		}
	}
	public class EmailTemplate
	{
		public String formattedDate{get;Set;}
		public String emailTemp{get;Set;}
	}
}