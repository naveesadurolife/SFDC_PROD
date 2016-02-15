/**
	* GoalTrigger - <description>
	* Created by BrainEngine Cloud Studio
	* @author: Navees Ahmed
	* @version: 1.0
*/

trigger GoalTrigger on Goal__c bulk (before insert,after insert,before update,after update,before delete,after delete,after undelete) {
	if(Trigger.isAfter && Trigger.isInsert)
	{
		GoalTriggerHandler.AfterInsert(Trigger.new);
	}
	else if(Trigger.isAfter && Trigger.isUpdate && !GoalTriggerHandler.AfterUpdateExecuted)
	{
		GoalTriggerHandler.AfterUpdate(Trigger.new);
	}
	else if(Trigger.isAfter && Trigger.isDelete)
	{
		GoalTriggerHandler.AfterInsert(Trigger.old);
	}
	else if(Trigger.isUndelete)
	{
		GoalTriggerHandler.AfterUnDelete(Trigger.new);
	}	
}