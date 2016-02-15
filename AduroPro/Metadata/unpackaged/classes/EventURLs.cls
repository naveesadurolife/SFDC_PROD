public with sharing class EventURLs {
	public String getEventURL()
	{
		return Constant.EVENT_PUBLISH_REGISTRATION_URL;
	}
	public List<WW_Event__c> getEvents()
	{
		List<WW_Event__c> listEvents=[Select Id,Name,Event_Date__c From WW_Event__c Where Event_Date__c>=TODAY and Id IN (Select WW_Event__c From Slot__c)];
		return listEvents;
	} 
}