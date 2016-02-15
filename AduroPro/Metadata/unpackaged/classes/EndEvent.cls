public with sharing class EndEvent {
	public String result{get;set;} 
	public void UpdateContacts()
	{
		String eventId=Apexpages.currentPage().getParameters().get('id');
		//result=eventId;
		result=AjaxUtility.UpdateEventContacts(eventId);
	}
}