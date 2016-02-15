public with sharing class CoachingEventCheckin{
	public static String IGNITEYOURLIFE='Ignite Your Life';
	public String firstEvent{get;Set;}
	public String eventNotes{get;Set;}
	public Boolean doNotRender{get;set;}
	public Boolean dataSaved{get;Set;}
	public Program__c program{get;set;}
	public List<WW_Event__c> listEvents{get;Set;}
	public String eventType{get;set;}
	public String coachingProgramName{get;set;}
	public String occurrences{get;set;}
	public String selectedEventId{get;set;}
	public String psk{get;set;}
	public String eventId{get;set;}
	public String firstname{get;set;}
	public String lastname{get;set;}
	public String email{get;set;}
	public String dob{get;set;}
	public String empId{get;set;}
	public List<String> listDates{get;Set;}
	public String programLogo{get;Set;}
	public Boolean renderProgramLogo{get;Set;}	
	public Boolean overrideValidation{get;Set;}
		public Boolean renderProgramLogoText{get;Set;}	
	public String oid{get;Set;}
	public String eid{get;Set;}
	public String cname{get;Set;}	
	
	public String returnURL{get;Set;}
	public List<SelectOption> listEventsOpt{get;Set;}
	public CoachingEventCheckin()
	{
		renderProgramLogoText=false;
		selectedEventId='';
		firstEvent=IGNITEYOURLIFE;
		psk=Apexpages.currentPage().getParameters().get('p');
		eventId=Apexpages.currentPage().getParameters().get('e');
		oid=Apexpages.currentPage().getParameters().get('oid');
		eid=Apexpages.currentPage().getParameters().get('eid');
		empid=Apexpages.currentPage().getParameters().get('emid');
		dob=Apexpages.currentPage().getParameters().get('dob');
		cname=Apexpages.currentPage().getParameters().get('cname');
		firstname=Apexpages.currentPage().getParameters().get('fname');
		lastname=Apexpages.currentPage().getParameters().get('lname');
		email=Apexpages.currentPage().getParameters().get('em');		
		doNotRender=false;
		renderProgramLogo=false;
		overrideValidation=false;
		dataSaved=false;
		listDates=new List<String>();
		if(String.isNotBlank(psk) && String.isNotBlank(eventId))
		{
			Date olddt=Date.today().addDays(-14);
			Date dtFuture=Date.today().addDays(42);			
			listEventsOpt=new List<SelectOption>();
			listEventsOpt.add(new SelectOption('','None'));			
			WW_Event__c e=[Select Id,Name,Event_Group_Id__c,Event_Type__c,Coaching_Program_Name__c,Coaching_Event_Occurance__c From WW_Event__c Where Id=:eventId];
			eventType=e.Event_Type__c;
			coachingProgramName=e.Coaching_Program_Name__c;
			occurrences=e.Coaching_Event_Occurance__c;
			listEvents=[Select Id,Name,Coaching_Event_Number__c,Coaching_Program_Name__c,Event_Group_Id__c,Event_Type__c,Occurrences__c,Coaching_Event_Notes__c,
						Event_Date__c,Start_Time__c,End_Time__c,Preferred_Day__c,Coaching_Event_Occurance__c,Time_Zone__c,X6_Week_Engagement_Goal_Type__c,X6_Week_Engagement_Modality__c  
						From WW_Event__c 
						where 
						Employer__r.Name='Ignite Your Life Coaching' AND Coaching_Event_Number__c=1 AND Event_Date__c>=:olddt AND Event_Date__c<=:dtFuture
						AND Event_Type__c=:e.Event_Type__c
						AND Coaching_Program_Name__c=:e.Coaching_Program_Name__c
						Order by Event_Date__c ASC];
			for(WW_Event__c ev:listEvents)
			{
				
				Datetime dt = Datetime.newInstance(ev.Event_Date__c,System.now().time());
				String dtFormat=dt.format('EEE, MMM d yyyy')+' ('+ev.Start_Time__c+'-'+ev.End_Time__c+' '+ev.Time_Zone__c+')';
				listDates.add(dtFormat);
				listEventsOpt.add(new SelectOption(ev.Id,dtFormat));
				eventNotes=ev.Coaching_Event_Notes__c;
			}
			List<Program__c> listP=[Select Id,Name,Calendar_Name__c,Coaching_Event_Type__c,Coaching_Program_Name__c,Account__c,Account__r.Name,Coaching_Calendar_Logo__c,
					Validate_Coaching_Scheduler_Slot__c,Limeade_PSK_ID__c,Limeade_E_Id__c,Coaching_Identifier_LastName__c,Coaching_Identifier_DOB__c,
					Coaching_Identifier_Email__c,Coaching_Identifier_Employee_ID__c,Account__r.Domain_Name__c,	Branded_URL__c
					From Program__c 
					Where Limeade_E_Id__c=:psk AND Program_Status__c='Active' AND Program_Start_Date__c<=TODAY AND Program_End_Date__c>=TODAY 
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
			}
		}
		if(program==null)
		{
			doNotRender=true;
		}
	}
	public void register()
	{
		returnURL='If you have not received an email containing program details within one day of registering for an Ignite Your Life program, please check your Spam or Clutter folder. Please add noreply@adurolife.com to your list of Contacts, if it is not already listed, so you don’t miss out on any important program details<br/>';
		//PageReference pr;
		Boolean errorOnPage=false;
		
	
		
		if(String.isBlank(selectedEventId))
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select time.');
			ApexPages.addMessage(myMsg);
			errorOnPage=true;				
		}		
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
		Date d;
		if(program.Validate_Coaching_Scheduler_Slot__c)
		{
			if(program.Coaching_Identifier_DOB__c)
			{
				try
				{
					d=Date.parse(dob);
				}
				catch(Exception ex){}
				if(d==null)
				{
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Date of birth');
					ApexPages.addMessage(myMsg);
					errorOnPage=true;						
				}
			}
			if(program.Coaching_Identifier_Employee_ID__c && program.Validate_Coaching_Scheduler_Slot__c && String.isBlank(empId))
			{
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Employee Id');
				ApexPages.addMessage(myMsg);
				errorOnPage=true;					
			}
		}
		if(!errorOnPage)
		{
			WW_Event__c e1=[Select Id,Name,Event_Group_Id__c,Event_Type__c,Coaching_Program_Name__c,Coaching_Event_Occurance__c From WW_Event__c Where Id=:selectedEventId];
			List<WW_Event__c> listEventsTemp=[Select Id,Name,Coaching_Event_Number__c,Coaching_Program_Name__c,Event_Group_Id__c,Event_Type__c,Occurrences__c,
						Event_Date__c,Start_Time__c,End_Time__c,Preferred_Day__c,Coaching_Event_Occurance__c,Time_Zone__c,X6_Week_Engagement_Goal_Type__c,X6_Week_Engagement_Modality__c  
						From WW_Event__c where Event_Group_Id__c=:e1.Event_Group_Id__c Order by Event_Date__c ASC];				
			List<Slot__c> exuistingSlots=[Select Id from Slot__c where Email__c=:email AND Program__c=:program.Id AND WW_Event__c=:listEventsTemp AND Status__c!='Cancelled'];
			if(exuistingSlots!=null && exuistingSlots.size()>0)
			{
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'You are already registered for this event. Please select different event.');
				ApexPages.addMessage(myMsg);
				errorOnPage=true;					
			}
		
		LimeadeValidator lv;
		/*System.debug('program.Id==========='+program.Id);
		System.debug('firstname==========='+firstname);
		System.debug('lastname==========='+lastname);
		System.debug('email==========='+email);
		System.debug('d==========='+d);
		System.debug('empId==========='+empId);
		System.debug('eid==========='+eid);
		System.debug('overrideValidation==========='+overrideValidation);*/
		Slot__c s=new Slot__c(Program__c=program.Id,First_Name__c=firstname,Last_Name__c=lastname,Email__c=email,Type__c='Regular',DOB__c=d,Employee_ID__c=empId,Status__c='Active',ADURO_Event__c=(String.isBlank(eid)?null:eid),Override_Validation__c=overrideValidation);
		if(!errorOnPage && program.Validate_Coaching_Scheduler_Slot__c && !overrideValidation)
		{
			lv=validateContactInLimeade (s);
			if(!String.isBlank(lv.ErrorMessage))
			{
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, lv.ErrorMessage);
				ApexPages.addMessage(myMsg);
				errorOnPage=true;					
			}
			else
			{
				s.Limeade_Participant_Code__c=lv.LimeadeParticipantCode;
			}
		}
		if(!errorOnPage)
		{
			//////////////////////
			Contact c;
			if(lv!=null && String.isBlank(lv.ErrorMessage) && String.isNotBlank(lv.LimeadeParticipantCode))
			{
				try{
					c=[Select Id From Contact Where Limeade_ParticipantCode__c=:lv.LimeadeParticipantCode];
				}
				catch(Exception ex){}
			}
			if(c==null)
			{
				
				List<Contact> listC=[Select Id,Limeade_ParticipantCode__c,CreatedDate,(Select Id,OrderDate__c From Orders__r order by OrderDate__c desc limit 1) From Contact Where LastName=:s.Last_Name__c AND Email=:s.Email__c AND Birthdate=:s.DOB__c];
				if(listC.size()>0)
				{
					if(listC.size()==1)
					{
						c=listC[0];
					}
					else
					{
						Date orderDate=null;
						Contact latestContact;
						Contact latestContactWithOrder;
						Contact latestContactWithParticipantCode;
						for(Contact cT:listC)
						{
							if(latestContact==null)
							{
								latestContact=cT;
							}
							else if(latestContact.CreatedDate<cT.CreatedDate)
							{
								latestContact=cT;
							}
							if(latestContactWithParticipantCode==null && !String.isBlank(cT.Limeade_ParticipantCode__c))
							{
								latestContactWithParticipantCode=cT;
							}
							else if(latestContactWithParticipantCode!=null && latestContactWithParticipantCode.CreatedDate<cT.CreatedDate && !String.isBlank(cT.Limeade_ParticipantCode__c))
							{
								latestContactWithParticipantCode=cT;
							}									
							if(cT.Orders__r.size()>0 && cT.Orders__r[0].OrderDate__c!=null &&
								(orderDate==null || orderDate<cT.Orders__r[0].OrderDate__c)
							  )
							{
								latestContactWithOrder=cT;
							}
						}
						if(latestContactWithOrder!=null)
						{
							c=latestContactWithOrder;
						}
						else if(latestContactWithParticipantCode!=null)
						{
							c=latestContactWithParticipantCode;
						}
						else if(latestContact!=null)
						{
							c=latestContact;
						}																
					}
				}
			}
			//catch(Exception ex){}
			if(c!=null)
			{
				s.Contact__c=c.Id;
			}
			else
			{
				RecordType rt=[Select Id From RecordType Where DeveloperName='Participants' limit 1];
				c=new Contact();
				c.RecordTypeId=rt.Id;
				c.FirstName=s.First_Name__c;
				c.LastName=s.Last_Name__c;
				c.Email=s.Email__c;
				c.Birthdate=s.DOB__c;
				c.AccountID=program.Account__c;
				c.Employee_ID__c=s.Employee_ID__c;
				c.Limeade_ParticipantCode__c=lv!=null?lv.LimeadeParticipantCode:'';
				insert c;
				s.Contact__c=c.Id;
			}
			//c.Event__c=s.WW_Event__c;
			//c.Appointment_Time__c=s.Start_Date__c;
			//s.One_Day_Reminder_Sent__c=false;
			//s.Seven_Day_Reminder_Sent__c=false;
			//update s;
			update c;			
			////////////			
			List<Slot__c> listSlot=new List<Slot__c>();
			//Map<Id,Goal__c> mapGoals=new Map<Id,Goal__c>();
			//for(WW_Event__c e:listEvents)
		//	{
				Goal__c g=new Goal__c();
				g.Program__c=program.Id;
				g.Contact__c=s.Contact__c;
				g.Goal_Name__c=listEvents[0].Name;
				g.X6_Week_Engagement_Modality__c='Group Coaching (Webinar Series)';
				g.Overall_Goal_Status__c='Registration Phase';
				g.Created_Date__c=listEvents[0].Event_Date__c;
				g.X6_Week_Engagement_Goal_Type__c=listEvents[0].X6_Week_Engagement_Goal_Type__c;
			g.X6_Week_Engagement_Modality__c=listEvents[0].X6_Week_Engagement_Modality__c;
			//	mapGoals.put(e.Id,g);
		//	}
			insert g;//mapGoals.values();
			for(WW_Event__c e:listEventsTemp)
			{
				Datetime startDateTime = DateTime.parse(e.Event_Date__c.format()+' '+e.Start_Time__c);
				Datetime endDateTime = DateTime.parse(e.Event_Date__c.format()+' '+e.End_Time__c);					
				//Goal__c g=mapGoals.get(e.Id);
				Slot__c s1=s.clone();
				s1.Goal__c=g.Id;
				s1.WW_Event__c=e.Id;
				s1.Start_Date__c=startDateTime;
				s1.End_Date__c=endDateTime;
				listSlot.add(s1);
				//listSlot.add(new Slot__c(WW_Event__c=e.Id,First_Name__c=firstname,Last_Name__c=lastname,Email__c=email,Type__c='Regular',DOB__c=d,Employee_ID__c=empId));
			}
			insert listSlot;
			dataSaved=true;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'You are successfully registered.');
			ApexPages.addMessage(myMsg);	
			if(String.isNotBlank(eid))
			{
		    	try
		    	{
			    	Order__c o=new Order__c(Id=oid);
					o.Concierge_Interested__c='Yes';
			    	update o;
		    	}
		    	catch(Exception ex)
				{
					System.debug('================='+ex.getMessage());
				}				
				returnURL+='<a href="/apex/OnsiteConcierge?event='+eid+'" class="btn">Return to Concierge Checkin</a>';
			}
			else 
			{
				String url='https://aduro.mywellmetrics.com/BrandedLogin.aspx?e='+program.Limeade_E_Id__c;
				if(String.isNotBlank(program.Branded_URL__c))
				{
					url=program.Branded_URL__c;
					if(!program.Branded_URL__c.startsWithIgnoreCase('http'))
						url='http://'+program.Branded_URL__c;
				}
				returnURL+='<a onclick="window.location=\''+url+'\';"><button type="button" class="btn">Back to Wellness Platform</button></a>';
			}
		}
		//return pr;
		}
	}
	public LimeadeValidator validateContactInLimeade (Slot__c s) {
		
		LimeadeValidator lv=new LimeadeValidator();
		if(program.Validate_Coaching_Scheduler_Slot__c)
		{
			lv.LimeadeEID=program.Limeade_E_Id__c;
			lv.LimeadePSKID=program.Limeade_PSK_ID__c; 
			lv.LastName=s.Last_Name__c;
			lv.DOB=s.DOB__c==null?'':s.DOB__c.format();
			lv.Email=s.Email__c;
			lv.employeeId=s.Employee_ID__c;
			lv.IdentifierLastName=program.Coaching_Identifier_LastName__c;
			lv.IdentifierDOB=program.Coaching_Identifier_DOB__c;
			lv.IdentifierEmail=program.Coaching_Identifier_Email__c;
			lv.IdentifierEmployeeID=program.Coaching_Identifier_Employee_ID__c;
			lv.validate();	
		}
		return lv;
	}
}