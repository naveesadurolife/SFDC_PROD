trigger WithingsMeasuresTrigger on Withings_Measure__c (after insert) {
    
    WithingsMeasureTriggerHandler handler = new WithingsMeasureTriggerHandler();
    if(trigger.isAfter && trigger.isInsert){
        
        handler.onAfterInsert(trigger.new); 
        
    }

}