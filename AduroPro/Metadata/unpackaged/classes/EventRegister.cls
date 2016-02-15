public with sharing class EventRegister {
	public String eventId{get;set;}
	public String slotId{get;set;}
	public Slot__c oldS{get;set;}
	public WW_Event__c e{get;set;}
	
	public String eventRegistrationHeader{get;set;}
	public String eventRegistrationLogo{get;set;}
	public Map<DateTime,List<Slot__c>> mapSlots{get;set;}
	public List<SlotsWrapper> listSlotsWrapper{get;set;}
	public Boolean alreadyRegistered{get;set;}
	public String startTimeStr{get;set;}
	public String endTimeStr{get;set;}	
	public String oldEventDateStr{get;set;}	
	public EventRegister()
	{
		alreadyRegistered=false;
		//eventLogo='';
		eventId=Apexpages.currentPage().getParameters().get('id');
		slotId=Apexpages.currentPage().getParameters().get('sid');
		String d=Apexpages.currentPage().getParameters().get('d');
		e=[Select Id,Name,Event_Logo__c,Time_Zone__c,Event_Address__c,Event_Date__c,Room_Location__c,Event_Notes__c, Event_Notes_RT__c From WW_Event__c Where Id=:eventId];
		if(!String.isBlank(e.Event_Logo__c))
		{
			eventRegistrationLogo=Constant.DOCUMENT_URL.replace('@@DOCID@@', e.Event_Logo__c);
		}
		//d=[Select d.Url, d.Type, d.SystemModstamp, d.NamespacePrefix, d.Name, d.LastModifiedDate, d.LastModifiedById, d.Keywords, d.IsPublic, d.IsInternalUseOnly, d.IsDeleted, d.IsBodySearchable, d.Id, d.FolderId, d.DeveloperName, d.Description, d.CreatedDate, d.CreatedById, d.ContentType, d.BodyLength, d.Body, d.AuthorId From Document d where keywords='a07Q0000008PB60'];
		if(!String.isBlank(slotId))
		{
			try
			{
				oldS=[Select s.WW_Event__r.Location__c, s.WW_Event__r.Event_Type__c, s.WW_Event__r.End_Time__c,s.WW_Event__r.Email_Text__c, 
					  s.WW_Event__r.Start_Time__c, s.WW_Event__r.Event_Date__c, s.WW_Event__r.Name, s.WW_Event__c,s.WW_Event__r.Event_Logo__c, 
					  s.Start_Date__c, s.Name, s.Last_Name__c, s.First_Name__c, s.End_Date__c, s.Email__c, 
					  s.DOB__c, s.Contact__c,WW_Event__r.Event_Registration_Header__c 
					  From Slot__c s Where Id=:slotId];
			  	alreadyRegistered=true;	
				startTimeStr=oldS.Start_Date__c.format('hh:mm a','America/Los_Angeles');
				endTimeStr=oldS.End_Date__c.format('hh:mm a','America/Los_Angeles');	
				oldEventDateStr=oldS.Start_Date__c.Date().format();		  				
			}
			catch(Exception ex){}
		}
		if(!String.isBlank(d) && d=='d')
		{
			alreadyRegistered=false;
		}		
	}
	public List<SlotsWrapper> getEvents()
	{
		mapSlots=new Map<DateTime,List<Slot__c>>();
		for(Slot__c s:[Select Id,Name,Contact__c,DOB__c,Email__c,End_Date__c,First_Name__c,Last_Name__c,Start_Date__c,WW_Event__c, 
						WW_Event__r.Location__c,WW_Event__r.Event_Date__c,WW_Event__r.Event_Registration_Header__c,Type__c,
						WW_Event__r.Event_Logo__c,WW_Event__r.Name,WW_Event__r.Event_Address__c
						From Slot__c Where WW_Event__c=:eventId order by Start_Date__c])
		{
			List<Slot__c> listSlots;
			if(!mapSlots.containsKey(s.Start_Date__c))
			{
				mapSlots.put(s.Start_Date__c,new List<Slot__c>());
			}
			listSlots=mapSlots.remove(s.Start_Date__c);
			listSlots.add(s);
			mapSlots.put(s.Start_Date__c,listSlots);
			//if(!String.isBlank(s.WW_Event__r.Event_Logo__c))
			//{
			//	eventRegistrationLogo=s.WW_Event__r.Event_Logo__c;
			//}
			//system.debug('eventRegistrationLogo=================='+eventRegistrationLogo);			
			eventRegistrationHeader='<b>Registration Page for Biometric Screening:</b><br/><b>'+s.WW_Event__r.Name+', '+s.Start_Date__c.Date().format()+', '+s.WW_Event__r.Event_Address__c+'</b>';
			if(String.isBlank(slotId))
				eventRegistrationHeader+='<br/>Click on the desired appointment slot to register.  A confirmation email will be emailed to you upon completion of the registration';
			//eventRegistrationHeader='<b>'+s.WW_Event__r.Name+' on '+s.WW_Event__r.Event_Date__c.format()+'</b><br/>Click on the desired appointment slot to register.  A confirmation email with be emailed to upon completion of the registration';//s.WW_Event__r.Event_Registration_Header__c;

		}
		List<DateTime> allStartTime=new List<DateTime>();
		allStartTime.addAll(mapSlots.keySet());
		allStartTime.sort();
		listSlotsWrapper=new List<SlotsWrapper>();
		for(DateTime dt:allStartTime)
		{
			SlotsWrapper sw=new SlotsWrapper();
			sw.startTime=dt;
			sw.endTime=mapSlots.get(dt)[0].End_Date__c;
			sw.strDate=dt.Date().format();
			sw.listSlots=mapSlots.get(dt);
			sw.s=new Slot__c(Start_Date__c=sw.startTime,End_Date__c=sw.endTime);
			sw.startTimeStr=sw.startTime.format('hh:mm a','America/Los_Angeles');
			sw.endTimeStr=sw.endTime.format('hh:mm a','America/Los_Angeles');
			listSlotsWrapper.add(sw);
		}
		return listSlotsWrapper;
	}
	public class SlotsWrapper
	{
		public DateTime startTime{get;set;}
		public String startTimeStr{get;set;}
		public DateTime endTime{get;set;}
		public String endTimeStr{get;set;}
		public String strDate{get;set;}
		public Slot__c s{get;set;}
		public List<Slot__c> listSlots{get;set;} 
	}
}