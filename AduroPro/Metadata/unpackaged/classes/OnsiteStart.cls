public with sharing class OnsiteStart {
	public string eventId{get;set;}
	public WW_Event__c objEvent{get;set;}
	public OnsiteStart()
	{
		eventId=ApexPages.currentPage().getParameters().get('event');
		objEvent=[Select Id,Name,Program__r.Enable_Concierge__c,Program__r.Limeade_PSK_ID__c From WW_Event__c Where Id=:eventId];
	}
}