public with sharing class CreateSlots {
	public String eventId{get;set;}
	public Boolean canCreateSlots{get;set;}
	public Integer totalSlots{get;set;}
	public ApexPages.StandardController controller{get;set;}
	public WW_Event__c e{get;set;}
	//public Map<DateTime,List>
    public CreateSlots(ApexPages.StandardController stdController) {
    	controller=stdController;
        this.e = (WW_Event__c)stdController.getRecord();
        init();
    }	
	/*public CreateSlots()
	{
		eventId=Apexpages.currentPage().getParameters().get('id');
		init();
	}*/
	public void init()
	{
		canCreateSlots=true;
		e=[Select Id,Name,Event_Date__c,End_Time__c,Start_Time__c,Program__c,Program__r.Name,Program__r.Account__r.Name,
			Time_Frame_Per_Slot__c,Appt_Per_Slot__c,Event_Status__c,Room_Location__c,Event_Address__c,Online_Scheduler_Link__c,
			Program__r.Test_Weight_Onsite__c, Program__r.Test_Waist_Onsite__c, Program__r.Test_Trig_Onsite__c,Program__r.Body_Fat__c, 
			Program__r.Test_TC_Onsite__c, Program__r.Test_LDL_Onsite__c, Program__r.Test_Height_Onsite__c, Program__r.Test_HR_Onsite__c, 
			Program__r.Test_HDL_Onsite__c, Program__r.Test_Glucose_Onsite__c, Program__r.Test_Glucose_HTK__c, Program__r.Test_Cholesterol_HTK__c, 
			Program__r.Test_BP_Onsite__c, Program__r.Test_BMI_Onsite__c,Program__r.Tobacco_Saliva__c,			
			(Select Id From Slots__r Where Contact__c!=null) 
			From WW_Event__c Where Id=:e.Id];
		if(e.Slots__r.size()>0)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot overwrite existing slots because people are already registered.');
			ApexPages.addMessage(myMsg);
			canCreateSlots=false;				
		}
		if(
			e.Event_Date__c==null || 
			String.isBlank(e.Start_Time__c) ||
			String.isBlank(e.Event_Status__c) ||
			String.isBlank(e.Room_Location__c) ||
			String.isBlank(e.Event_Address__c) ||  
			String.isBlank(e.End_Time__c) || 
			String.isBlank(e.Time_Frame_Per_Slot__c) || 
			e.Appt_Per_Slot__c==null || 
			e.Appt_Per_Slot__c==0 ||
			e.Program__c==null ||
			(
				e.Program__r.Test_Weight_Onsite__c==false &&  
				e.Program__r.Test_Waist_Onsite__c==false &&  
				e.Program__r.Test_Trig_Onsite__c==false && 
				e.Program__r.Body_Fat__c==false &&  
				e.Program__r.Test_TC_Onsite__c==false &&  
				e.Program__r.Test_LDL_Onsite__c==false &&  
				e.Program__r.Test_Height_Onsite__c==false &&  
				e.Program__r.Test_HR_Onsite__c==false &&  
				e.Program__r.Test_HDL_Onsite__c==false &&  
				e.Program__r.Test_Glucose_Onsite__c==false &&  
				e.Program__r.Test_Glucose_HTK__c==false &&  
				e.Program__r.Test_BP_Onsite__c==false &&  
				e.Program__r.Test_BMI_Onsite__c==false && 
				e.Program__r.Tobacco_Saliva__c==false 
			)					 
			)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Event Status, Event Date, Room Location, Start Time, End Time, Event Address, Program, and at least one of the fields from the Know Your Numbers Section on  the program page, before creating slots.');
			ApexPages.addMessage(myMsg);
			canCreateSlots=false;			
		}
		else
		{
			//Datetime startDateTime = Datetime.newInstance(e.Event_Date__c.year(), e.Event_Date__c.month(), e.Event_Date__c.day(), 12, 30, 0);
			Datetime startDateTime = DateTime.parse(e.Event_Date__c.format()+' '+e.Start_Time__c);
			Datetime endDateTime = DateTime.parse(e.Event_Date__c.format()+' '+e.End_Time__c);	
			if(e.Start_Time__c.contains('PM') && e.End_Time__c.contains('AM'))
			{
				endDateTime=endDateTime.addDays(1);
			}
			totalSlots=Integer.valueOf((endDateTime.getTime()-startDateTime.getTime())/60000);
			Integer timePerSlot=Integer.valueOf(e.Time_Frame_Per_Slot__c.replace('minutes','').trim());	
			totalSlots=Integer.valueOf((totalSlots/timePerSlot)*e.Appt_Per_Slot__c);	
		}
	}
	public void save()
	{
		if(e.Slots__r.size()==0 && e.Event_Date__c!=null || !String.isBlank(e.Start_Time__c) || !String.isBlank(e.End_Time__c) && totalSlots>0 && e.Appt_Per_Slot__c!=null && e.Appt_Per_Slot__c>0 && !String.isBlank(e.Time_Frame_Per_Slot__c))
		{
			SlotTriggerHandler.RecreateSlot=false;
			delete [Select Id From Slot__c Where WW_Event__c=:e.Id];  
			Datetime startDateTime = DateTime.parse(e.Event_Date__c.format()+' '+e.Start_Time__c);
			Datetime endDateTime = DateTime.parse(e.Event_Date__c.format()+' '+e.End_Time__c);	
			if(e.Start_Time__c.contains('PM') && e.End_Time__c.contains('AM'))
			{
				endDateTime=endDateTime.addDays(1);
			}			
			totalSlots=Integer.valueOf((endDateTime.getTime()-startDateTime.getTime())/60000);
			Integer timePerSlot=Integer.valueOf(e.Time_Frame_Per_Slot__c.replace('minutes','').trim());	
			totalSlots=Integer.valueOf((totalSlots/timePerSlot));
			List<Slot__c> listSlots=new List<Slot__c>();
			for(Integer i=0;i<totalSlots;i++)
			{
				for(Integer j=0;j<e.Appt_Per_Slot__c;j++)
				{
					Slot__c s=new Slot__c(WW_Event__c=e.Id,Start_Date__c=startDateTime,End_Date__c=startDateTime.addMinutes(timePerSlot),Type__c='Regular');
					listSlots.add(s);
				}
				startDateTime=startDateTime.addMinutes(timePerSlot);
			}
			insert listSlots;
			e.Online_Scheduler_Link__c=Constant.EVENT_PUBLISH_REGISTRATION_URL+e.id;
			update e;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'New slots are created successfully. Please go back to Event');
			ApexPages.addMessage(myMsg);
			canCreateSlots=false;				
		}
	}
	/*public void cancel()
	{
		controller.cancel();
	}*/
}