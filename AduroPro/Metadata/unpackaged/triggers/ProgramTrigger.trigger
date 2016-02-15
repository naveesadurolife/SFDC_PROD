/**
    * ProgramTrigger - <description>
    * Created by BrainEngine Cloud Studio
    * @author: Navees Ahmed
    * @version: 1.0
*/

trigger ProgramTrigger on Program__c bulk (before insert,after insert,before update,after update,before delete,after delete) {
    
    ProgramTriggerHandler handler = new ProgramTriggerHandler();
    
    if(Trigger.isBefore && Trigger.isInsert)
    {
        ProgramTriggerHandler.beforeInsert(Trigger.new);
    }
    else if(Trigger.isBefore && Trigger.isUpdate)
    {
        ProgramTriggerHandler.beforeUpdate(Trigger.new);
    }
    else if (Trigger.isAfter && Trigger.isUpdate){
    
        handler.OnAfterUpdate(trigger.new, trigger.OldMap);
    }

}