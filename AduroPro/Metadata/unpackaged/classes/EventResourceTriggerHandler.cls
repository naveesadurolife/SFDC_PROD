public with sharing class EventResourceTriggerHandler {
	
	public void onAfterInsert(list<Event_Resource__c> lstEventResources){
		
		set<Id> setEventResourceIds = new set<Id>();
		for(Event_Resource__c objEventResource :lstEventResources){
			
			if(objEventResource.Event_Address_ER__c != null){
				
				setEventResourceIds.add(objEventResource.Id);
			}
		}
		
		if(setEventResourceIds.size() > 0){
			GMapsDistanceCallouts.updateDistances(setEventResourceIds);
		}
	}// end of onAfterInsert


}