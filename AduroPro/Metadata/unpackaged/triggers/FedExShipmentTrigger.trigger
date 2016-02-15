trigger FedExShipmentTrigger on zkfedex__Shipment__c (after insert, after update) {
	
	FedexShipmentTriggerHandler handler = new FedexShipmentTriggerHandler ();
	
	if(trigger.isAfter && trigger.isInsert){
		
		handler.onAfterInsert(trigger.new);
		
	}else if(trigger.isAfter && trigger.isUpdate){
		
		handler.onAfterUpdate(trigger.new, trigger.oldmap);
		
	}

}