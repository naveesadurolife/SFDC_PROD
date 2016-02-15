trigger EmailMessageTrigger on EmailMessage (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) { 
	if(Trigger.isAfter && Trigger.isInsert)
	{
		EmailMessageTriggerHandler.UpdateFirstResponse(Trigger.new);
	}

}