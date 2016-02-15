public with sharing class FedexShipmentTriggerHandler {
	
	FedexShipmentsTriggerHelper helper = new FedexShipmentsTriggerHelper();
	
	public void onAfterInsert(list<zkfedex__Shipment__c> lstNewFedExShipments){
		
		helper.calculateTotalShippingExpense(lstNewFedExShipments);
		
	}// end of onAfterInsert
	
	public void onAfterUpdate(list<zkfedex__Shipment__c> lstNewFedExShipments, map<Id,zkfedex__Shipment__c>mapOldFedExShipments){
		
		helper.calculateTotalShippingExpense(lstNewFedExShipments, mapOldFedExShipments);
		
	}// end of onAfterUpdate

}