trigger SlotTrigger on Slot__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	if(Trigger.isDelete && Trigger.isAfter && SlotTriggerHandler.RecreateSlot)
    {  
    	SlotTriggerHandler.AfterDelete(Trigger.old); 
    }
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
    {
    	SlotTriggerHandler.UpdateEvent(Trigger.new);
    }
}