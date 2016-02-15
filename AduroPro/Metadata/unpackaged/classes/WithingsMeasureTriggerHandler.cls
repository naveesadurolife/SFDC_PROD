public with sharing class WithingsMeasureTriggerHandler {
	
	WithingsMeasureTriggerHelper helper = new WithingsMeasureTriggerHelper();
	
	public void onAfterInsert(list<Withings_Measure__c> lstNewWithingsMeasures){
		
		helper.populateWeightFirstTakenAndWeightLastTaken(lstNewWithingsMeasures);
		
	}

}