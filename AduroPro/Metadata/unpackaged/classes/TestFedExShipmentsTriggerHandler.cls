@isTest
private class TestFedExShipmentsTriggerHandler {
	
	private static Event_Series__c objEventSeries;
	private static zkfedex__Shipment__c objFedExShipment;
		
	private static void testData(){
		
		objEventSeries = new Event_Series__c(Name = 'Test Event Series');
		insert objEventSeries;
		objFedExShipment = new zkfedex__Shipment__c(
		                          Event_Series__c = objEventSeries.Id,
		                          zkfedex__TotalNetCharge__c = 100);
		insert objFedExShipment; 
		
	}
	
	static testMethod void testWWEventTriggerHandlerOnAfterInsert() {
		
		testData();
		
		objEventSeries = [SELECT Id, Total_Shipping_Expense__c FROM Event_Series__c WHERE Id = :objEventSeries.Id];
		system.assertEquals(100, objEventSeries.Total_Shipping_Expense__c);
		
	}
	
	static testMethod void testWWEventTriggerHandleronAfterUpdate() {
		
		testData();
		objFedExShipment.zkfedex__TotalNetCharge__c = 200;
		update objFedExShipment;
		
		objEventSeries = [SELECT Id, Total_Shipping_Expense__c FROM Event_Series__c WHERE Id = :objEventSeries.Id];
		system.assertEquals(200, objEventSeries.Total_Shipping_Expense__c);
		
	}
	

}