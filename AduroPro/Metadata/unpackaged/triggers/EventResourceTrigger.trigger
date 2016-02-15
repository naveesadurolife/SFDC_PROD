trigger EventResourceTrigger on Event_Resource__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	
	EventResourceTriggerHandler handler = new EventResourceTriggerHandler();
	
	if(trigger.isInsert && trigger.isAfter){
		
		handler.onAfterInsert(trigger.new);
		
	}

}