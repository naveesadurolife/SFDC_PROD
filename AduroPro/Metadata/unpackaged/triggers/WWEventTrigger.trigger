trigger WWEventTrigger on WW_Event__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	if(Trigger.isBefore && Trigger.isInsert)
	{
		WWEventTriggerHandler.beforeInsert(Trigger.new);
	}
	else if(Trigger.isBefore && Trigger.isUpdate)
	{
		WWEventTriggerHandler.beforeUpdate(Trigger.new);
	}	
	else if(Trigger.isAfter && Trigger.isInsert) 
	{
		WWEventTriggerHandler.CreateEventResources(Trigger.new, Trigger.oldMap);
		WWEventTriggerHandler.calculateDrivingDistanceOnInsert(trigger.new);
	}
	else if (Trigger.isAfter &&  Trigger.isUpdate)
	{
		WWEventTriggerHandler.calculateDrivingDistanceOnUpdate(trigger.new, trigger.oldMap);
		WWEventTriggerHandler.CreateEventResources(Trigger.new, Trigger.oldMap);
		WWEventTriggerHandler.removeProjectedDrivingDistance(Trigger.new, Trigger.oldMap);
		
	}
}