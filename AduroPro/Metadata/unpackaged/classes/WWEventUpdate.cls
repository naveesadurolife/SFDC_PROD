public with sharing class WWEventUpdate{
	public WW_Event__c e{get;Set;}
	public List<EventWrapper> listEW{get;Set;}
	public List<String> selectedFields{get;Set;}
	public Boolean renderPage{get;Set;}
	public String cancelButtonText{get;Set;}
	public WWEventUpdate(ApexPages.StandardController stdController)
	{
		renderPage=true;
		cancelButtonText='Cancel';
		selectedFields=new List<String>();
		this.e = (WW_Event__c)stdController.getRecord();
		this.e=[Select Id,Event_Group_Id__c,Coaching_Event_Number__c,Name,Event_Date__c,Coaching_Event_Occurance__c,Access_Code__c,Post_Event_Survey_Link__c,Coaching_Mentor__c,Start_Time__c,End_Time__c,X6_Week_Engagement_Goal_Type__c,X6_Week_Engagement_Modality__c,Coaching_Event_Notes__c,Coaching_Welcome_Email__c,Coaching_Event_Phone_Number__c,Coaching_Event_URL__c,Event_Tile__c From WW_Event__c Where Id=:e.id];
		initRelatedEvents();
		if(listEW.size()==0)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'No related events found.');
			ApexPages.addMessage(myMsg);	
			renderPage=false;
			cancelButtonText='Go Back';
		}
	}
	public PageReference synchEvents()
	{
		Set<String> setFields=new Set<String>();
		setFields.addAll(selectedFields);
		List<WW_Event__c> listEventsToUpdate=new List<WW_Event__c>();
		for(EventWrapper ew:listEW)
		{
			if(ew.selected)
			{
				for(String fieldName:selectedFields)
				{
					ew.e.put(fieldName,e.get(fieldName));
				}
				listEventsToUpdate.add(ew.e);
			}
		}
		update listEventsToUpdate;
		List<Slot__c> listSlots=[Select Id,WW_Event__r.Event_Date__c,WW_Event__r.Start_Time__c,WW_Event__r.End_Time__c,Start_Date__c,End_Date__c From Slot__c Where WW_Event__c=:listEventsToUpdate OR WW_Event__c=:e.Id];
		for(Slot__c s:listSlots)
		{
			Datetime startDateTime = DateTime.parse(s.WW_Event__r.Event_Date__c.format()+' '+s.WW_Event__r.Start_Time__c);
			Datetime endDateTime = DateTime.parse(s.WW_Event__r.Event_Date__c.format()+' '+s.WW_Event__r.End_Time__c);	
			s.Start_Date__c=startDateTime;
			s.End_Date__c=endDateTime;			
		}
		update listSlots;
		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'All selected events are updated successfully.');
		ApexPages.addMessage(myMsg);	
		renderPage=false;		
		cancelButtonText='Go Back';
		return null;
	}
	public List<SelectOption> getFields() 
	{
		List<SelectOption> listSO=new List<SelectOption>();
		listSO.add(new SelectOption('Access_Code__c','Access Code'));
		listSO.add(new SelectOption('Coaching_Event_Phone_Number__c','Event Phone Number'));
		listSO.add(new SelectOption('Coaching_Mentor__c','Coaching Mentor'));
		listSO.add(new SelectOption('Coaching_Event_URL__c','Goto Training URL'));
		listSO.add(new SelectOption('Post_Event_Survey_Link__c','Post Event Survey Link'));
		listSO.add(new SelectOption('X6_Week_Engagement_Modality__c','6 Week Engagement Modality'));
		listSO.add(new SelectOption('Start_Time__c','Start Time'));
		listSO.add(new SelectOption('End_Time__c','End Time'));
		listSO.add(new SelectOption('X6_Week_Engagement_Goal_Type__c','6 Week Engagement Goal Type'));
		listSO.add(new SelectOption('Event_Tile__c','Event Tile Image'));
		listSO.add(new SelectOption('Coaching_Event_Notes__c','Notes'));
		listSO.add(new SelectOption('Coaching_Welcome_Email__c','Welcome Email'));
		selectedFields.add('Access_Code__c');
		selectedFields.add('Post_Event_Survey_Link__c');
		selectedFields.add('Coaching_Mentor__c');
		selectedFields.add('Start_Time__c');
		selectedFields.add('End_Time__c');
		selectedFields.add('X6_Week_Engagement_Goal_Type__c');
		selectedFields.add('X6_Week_Engagement_Modality__c');
		selectedFields.add('Coaching_Event_Notes__c');
		selectedFields.add('Coaching_Welcome_Email__c');
		selectedFields.add('Coaching_Event_Phone_Number__c');
		selectedFields.add('Coaching_Event_URL__c');
		selectedFields.add('Event_Tile__c');
		return listSO;
	}
	public void initRelatedEvents()
	{
		listEW=new List<EventWrapper>();
		for(WW_Event__c e:[Select Id,Event_Group_Id__c,Coaching_Event_Number__c,Name,Event_Date__c,Coaching_Event_Occurance__c,Access_Code__c,Post_Event_Survey_Link__c,Coaching_Mentor__c,Start_Time__c,End_Time__c,X6_Week_Engagement_Goal_Type__c,X6_Week_Engagement_Modality__c,Coaching_Event_Notes__c,Coaching_Welcome_Email__c,Coaching_Event_Phone_Number__c,Coaching_Event_URL__c,Event_Tile__c From WW_Event__c Where Id!=:e.id AND Event_Group_Id__c=:e.Event_Group_Id__c AND Event_Group_Id__c!=null AND Coaching_Event_Number__c!=null Order by Coaching_Event_Number__c ASC])
		{
			listEW.add(new EventWrapper(e));
		}
	}
	public class EventWrapper
	{
		public WW_Event__c e{get;Set;}
		public Boolean selected{get;Set;}
		public EventWrapper(WW_Event__c e)
		{
			this.e=e;
			selected=false;
		}
	}

}