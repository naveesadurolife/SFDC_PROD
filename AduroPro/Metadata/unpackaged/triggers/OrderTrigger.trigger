trigger OrderTrigger on Order__c (before insert, before update,after insert, after update) {
	if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) 
	{
		OrderTriggerHandler.UpdateBestWorstScore(Trigger.new);
		//Sreeni:: The code below utilizes the callout utility to send user data to bridge system
		BridgeRESTCalloutUtility.checkBridgeUserCreation(Trigger.new);
	}
	if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) 
	{
		OrderTriggerHandler.UpdateFields(Trigger.new,Trigger.oldMap);		
	}	
}