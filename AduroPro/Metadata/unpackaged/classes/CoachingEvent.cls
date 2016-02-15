public with sharing class CoachingEvent{
	public static String TILE_IMAGE_HEALTH='health.jpg';
	public static String TILE_IMAGE_NUTRITION='nutrition.png';
	public static String TILE_IMAGE_SMOKING='smoking.png';
	public static String TILE_IMAGE_STRESS='stress.png';
	public static String TILE_IMAGE_WEIGHT='weight.png';
	public static String IGNITEYOURLIFE='Ignite Your Life';
	
	public String programLogo{get;Set;}
	public Boolean renderProgramLogo{get;Set;}
	public Boolean renderProgramLogoText{get;Set;}
	public List<EventTypeWrapper> listEventTypeWrapper{get;Set;}
	public String psk{get;set;}
	public Boolean doNotRender{get;set;}
	public Program__c program{get;set;}
	
	public String firstEvent{get;Set;}
	public String firstname{get;Set;}
	public String lastname{get;Set;}
	public String email{get;Set;}
	public List<Slot__c> listRegisteredSlots{get;set;}
	public Boolean registrationFound{get;Set;}
	public Boolean renderGoBackButton{get;Set;}
	
	public String oid{get;Set;}
	public String eid{get;Set;}
	public String empid{get;Set;}
	public String cname{get;Set;}
	public String dob{get;Set;}
	public CoachingEvent()
	{
		renderProgramLogoText=false;
		firstEvent=IGNITEYOURLIFE;
		listRegisteredSlots=new List<Slot__c>();
		registrationFound=false;
		psk=Apexpages.currentPage().getParameters().get('p');
		oid=Apexpages.currentPage().getParameters().get('oid');
		eid=Apexpages.currentPage().getParameters().get('eid');
		empid=Apexpages.currentPage().getParameters().get('emid');
		dob=Apexpages.currentPage().getParameters().get('dob');
		cname=Apexpages.currentPage().getParameters().get('cname');
		firstname=Apexpages.currentPage().getParameters().get('fname');
		lastname=Apexpages.currentPage().getParameters().get('lname');
		email=Apexpages.currentPage().getParameters().get('em');
		renderGoBackButton=String.isNotBlank(eid)?true:false;
		doNotRender=false;
		renderProgramLogo=false;
		if(String.isNotBlank(psk))
		{
			List<Program__c> listP=[Select Id,Name,Calendar_Name__c,Coaching_Event_Type__c,Coaching_Program_Name__c,Display_on_Concierge_Only__c,Account__c,Account__r.Name,Coaching_Calendar_Logo__c 
					From Program__c 
					Where Coaching_Program_Name__c!=null AND Limeade_E_Id__c=:psk AND Program_Status__c='Active' AND Program_Start_Date__c<=TODAY AND Program_End_Date__c>=TODAY 
					Order by Program_Start_Date__c Asc limit 1];
			if(listP.isEmpty()==false)
			{
				program=listP[0];

				if(program!=null && String.isNotBlank(program.Calendar_Name__c))// !String.isBlank(program.Coaching_Calendar_Logo__c)
				{
					//programLogo=Constant.DOCUMENT_URL.replace('@@DOCID@@', program.Coaching_Calendar_Logo__c);
					renderProgramLogoText=true;
				}
				/*if(String.isBlank(program.Calendar_Name__c))
				{
					program.Calendar_Name__c='Ignite Your Life';
				}	*/			
				getEvents();
			}
		}
		if(program==null)
		{
			doNotRender=true;
		}
		

	}
	public void getEvents()
	{
		Date dt=Date.today().addDays(-14);
		Date dtFuture=Date.today().addDays(42);
		listEventTypeWrapper=new List<EventTypeWrapper>();
		Map<String,EventTypeWrapper> mapETW=new Map<String,EventTypeWrapper>();
		List<WW_Event__c> listEvents=[Select Id,Name,Coaching_Event_Number__c,Coaching_Program_Name__c,Event_Group_Id__c,Event_Type__c,Occurrences__c,
									  Event_Date__c,Start_Time__c,End_Time__c,Preferred_Day__c,Coaching_Event_Occurance__c,Time_Zone__c,Event_Tile__c
									  From WW_Event__c 
									  Where Employer__r.Name='Ignite Your Life Coaching' AND Coaching_Event_Number__c=1 AND Event_Date__c>=:dt AND Event_Date__c<=:dtFuture 
									  Order By Event_Type__c ASC,Event_Date__c ASC];
		List<String> coachingProgramNames=program.Coaching_Program_Name__c.split(';');
		//List<String> displayOnConciergeOnly=program.Display_on_Concierge_Only__c.split(';');
		for(WW_Event__c e:listEvents)
		{
			Boolean includeEvent=false;
			for(String s:coachingProgramNames)
			{
				if(String.isNotBlank(e.Coaching_Program_Name__c) && e.Coaching_Program_Name__c.equalsIgnoreCase(s) &&
						(
							String.isBlank(program.Display_on_Concierge_Only__c) || 
							(!program.Display_on_Concierge_Only__c.contains(s) && String.isBlank(oid)) || 
							( String.isNotBlank(oid)))
					)
				{
					includeEvent=true;
					break;
				}
			}
			if(includeEvent && String.isNotBlank(program.Coaching_Program_Name__c) && String.isNotBlank(e.Coaching_Program_Name__c) && program.Coaching_Program_Name__c.contains(e.Coaching_Program_Name__c) && String.isNotBlank(program.Coaching_Event_Type__c) && String.isNotBlank(e.Event_Type__c) && program.Coaching_Event_Type__c.contains(e.Event_Type__c))
			{
				if(!mapETW.containsKey(e.Event_Type__c))
				{
					EventTypeWrapper etw=new EventTypeWrapper(e.Event_Type__c); 
					mapETW.put(e.Event_Type__c,etw);
				}
				EventTypeWrapper etw=mapETW.get(e.Event_Type__c);
				if(!etw.setCoachingProgram.contains(e.Coaching_Program_Name__c))
				{
				String imageURL='';
				if(String.isNotBlank(e.Event_Tile__c))
				{
					imageURL=Constant.DOCUMENT_URL.replace('@@DOCID@@', e.Event_Tile__c);
				}
				etw.setCoachingProgram.add(e.Coaching_Program_Name__c);
				CoachingProgramWrapper cpw=new CoachingProgramWrapper(e.Id,e.Coaching_Program_Name__c,e.Event_Date__c,e.Start_Time__c,e.End_Time__c,e.Coaching_Event_Occurance__c,e.Time_Zone__c,imageURL);
				etw.listCoachingProgramWrapper.add(cpw);
				}
			}
			
		}
		if(mapETW.containsKey(IGNITEYOURLIFE))
		{
			listEventTypeWrapper.add(mapETW.get(IGNITEYOURLIFE));
			mapETW.remove('Ignite Your Life');
		}
		listEventTypeWrapper.addAll(mapETW.values());
	}
	public void cancelRegistration()
	{
		Boolean errorOnPage=false;
		registrationFound=false;
		if(String.isBlank(firstname))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter first name');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(String.isBlank(lastname))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter last name');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(String.isBlank(email))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter email');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}
		if(!errorOnPage)
		{
			listRegisteredSlots=[Select Id,Name,First_Name__c,Last_Name__c,Email__c,Status__c,Start_Date__c,Slot_Selected__c,WW_Event__c,WW_Event__r.Event_Group_Id__c,WW_Event__r.Name From Slot__c Where First_Name__c=:firstname AND Last_Name__c=:lastname AND Email__c=:email and Status__c!='Cancelled' and WW_Event__r.Coaching_Event_Number__c=1 Order by Start_Date__c];
			registrationFound=true;
			/*if(listSlots!=null)
			{
				for(Slot__c s:listSlots)
				{
					s.Status__c='Cancelled';
				}
				update listSlots;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Your registration has been cancelled.');
				ApexPages.addMessage(myMsg);
			}
			else*/
			if(listRegisteredSlots==null || listRegisteredSlots.size()==0)
			{
				registrationFound=false;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'No registration found. Please try again or contact support.');
				ApexPages.addMessage(myMsg);
				errorOnPage=true;					
			}
		}
	}
	public void cancelSelected()
	{
		Boolean errorOnPage=true;
		Set<String> selectedEvents=new Set<String>();
		for(Slot__c s:listRegisteredSlots)
		{
			if(s.Slot_Selected__c)
			{
				errorOnPage=false;
				selectedEvents.add(s.WW_Event__r.Event_Group_Id__c);
			}
		}
		if(errorOnPage)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select registration to cancel.');
			ApexPages.addMessage(myMsg);
		}
		else
		{
			listRegisteredSlots=[Select Id,Name,First_Name__c,Last_Name__c,Email__c,Status__c,Start_Date__c,Slot_Selected__c,WW_Event__c,WW_Event__r.Name From Slot__c Where First_Name__c=:firstname AND Last_Name__c=:lastname AND Email__c=:email and Status__c!='Cancelled' and WW_Event__r.Event_Group_Id__c=:selectedEvents];
			for(Slot__c s:listRegisteredSlots)
			{
				s.Status__c='Cancelled';
			}
			update listRegisteredSlots;
			listRegisteredSlots.clear();
			registrationFound=false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Registration is cancelled successfully.');
			ApexPages.addMessage(myMsg);			
		}
	}
	public class EventTypeWrapper
	{
		public String eventType{get;Set;}
		public Set<String> setCoachingProgram{get;Set;}
		public List<CoachingProgramWrapper> listCoachingProgramWrapper{get;Set;}
		public EventTypeWrapper(String eventType)
		{
			this.eventType=eventType;
			listCoachingProgramWrapper=new List<CoachingProgramWrapper>();
			setCoachingProgram=new Set<String>();
		}
	}
	public class CoachingProgramWrapper
	{
		public String coachingProgramName{get;Set;}
		public String image{get;Set;}
		public Boolean customImage{get;Set;}
		public String occurance{get;Set;}
		public String formattedDate{get;Set;}
		public String eventId{get;Set;}
		public CoachingProgramWrapper(String eventId,String coachingProgramName,Date eventDate,String startTime,String endTime,String occurance,String timeZone,String imageURLTemp)
		{
			this.customImage=false;
			this.eventId=eventId;
			this.occurance=occurance;
			Datetime dt = Datetime.newInstance(eventDate,System.now().time());
			formattedDate=dt.format('EEE., MMM. d, yyyy')+' ('+startTime+'-'+endTime+' '+timeZone+')';		
			if(String.isNotBlank(formattedDate))
			{
				if(formattedDate.startsWith('Tue'))
				{
					formattedDate=formattedDate.replace('Tue','Tues');
				}
				else if(formattedDate.startsWith('Thu'))
				{
					formattedDate=formattedDate.replace('Thu','Thurs');
				}
				if(formattedDate.contains('Jun'))
				{
					formattedDate=formattedDate.replace('Jun','June');
				}
				else if(formattedDate.contains('Jul'))
				{
					formattedDate=formattedDate.replace('Jul','July');
				}
				else if(formattedDate.contains('Sep'))
				{
					formattedDate=formattedDate.replace('Sep','Sept');
				}				
			}
			this.coachingProgramName=coachingProgramName;
			if(coachingProgramName=='Address the Stress')
			{
				image=CoachingEvent.TILE_IMAGE_STRESS;
			}
			else if(coachingProgramName=='Mission Nutrition')
			{
				image=CoachingEvent.TILE_IMAGE_NUTRITION;
			}	
			else if(coachingProgramName=='Weight Loss Program')
			{
				image=CoachingEvent.TILE_IMAGE_WEIGHT;
			}
			else if(coachingProgramName=='Health Recovery')
			{
				image=CoachingEvent.TILE_IMAGE_HEALTH;
			}
			else if(coachingProgramName=='Metabolic Syndrome')
			{
				image=CoachingEvent.TILE_IMAGE_STRESS;
			}
			else
			{
				image=CoachingEvent.TILE_IMAGE_HEALTH;
			}
			if(String.isNotBlank(imageURLTemp))
			{
				this.customImage=true;
				image=imageURLTemp;
			}
		}
	}
}