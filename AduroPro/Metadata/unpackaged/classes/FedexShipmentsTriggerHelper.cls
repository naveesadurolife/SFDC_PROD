public with sharing class FedexShipmentsTriggerHelper {
	
	public void calculateTotalShippingExpense(list<zkfedex__Shipment__c> lstFedExShipments){
		
		set<Id> setEventSeriesIds = new set<Id>();
		for(zkfedex__Shipment__c objFedExShipment : lstFedExShipments){
			
			if(objFedExShipment.Event_Series__c != null){
				setEventSeriesIds.add(objFedExShipment.Event_Series__c);
			}
		}
		
		if(setEventSeriesIds.size() > 0){
			
			calculateTotalShippingExpense(setEventSeriesIds);
			
		}
	}// end of calculateTotalShippingExpense
	
	public void calculateTotalShippingExpense(list<zkfedex__Shipment__c> lstFedExShipments, map<Id, zkfedex__Shipment__c> mapOldFedExShipments){
		
		set<Id> setEventSeriesIds = new set<Id>();
		for(zkfedex__Shipment__c objFedExShipment : lstFedExShipments){
			
			if(objFedExShipment.Event_Series__c != null
				&& (objFedExShipment.Event_Series__c != mapOldFedExShipments.get(objFedExShipment.Id).Event_Series__c)
				|| (objFedExShipment.zkfedex__TotalNetCharge__c !=  mapOldFedExShipments.get(objFedExShipment.Id).zkfedex__TotalNetCharge__c)){
				setEventSeriesIds.add(objFedExShipment.Event_Series__c);
			}
		}
		
		if(setEventSeriesIds.size() > 0){
			
			system.debug('##--setEventSeriesIds: '+ setEventSeriesIds);
			calculateTotalShippingExpense(setEventSeriesIds);
		}
		
	}// end of calculateTotalShippingExpense
	
	private void calculateTotalShippingExpense(set<Id> setEventSeriesIds){
		
		map<Id, decimal> mapEventSeriesIdAndTotalShipmentsTotal = new map<Id, decimal>();
		list<Event_Series__c> lstEventSeries = new list<Event_Series__c>();
		
		
		for(zkfedex__Shipment__c objFedexShipment : [SELECT Id, Event_Series__c, zkfedex__TotalNetCharge__c
														FROM  zkfedex__Shipment__c WHERE Event_Series__c IN :setEventSeriesIds]){
															
			if(mapEventSeriesIdAndTotalShipmentsTotal.keyset().contains(objFedexShipment.Event_Series__c)
			    && objFedexShipment.zkfedex__TotalNetCharge__c != null)	{
				decimal totalShippingExpense = 0;
				totalShippingExpense = mapEventSeriesIdAndTotalShipmentsTotal.get(objFedexShipment.Event_Series__c)+objFedexShipment.zkfedex__TotalNetCharge__c;
				mapEventSeriesIdAndTotalShipmentsTotal.put(objFedexShipment.Event_Series__c,
			   		totalShippingExpense);
									
									
			}	else{
				mapEventSeriesIdAndTotalShipmentsTotal.put(objFedexShipment.Event_Series__c, objFedexShipment.zkfedex__TotalNetCharge__c==null ? 0 : objFedexShipment.zkfedex__TotalNetCharge__c);
			}										
			 
			
		}// end of for-each
		
		for(Event_Series__c objEventSeries :[SELECT Id, Total_Shipping_Expense__c FROM Event_Series__c WHERE Id IN: setEventSeriesIds]){
			
			if( mapEventSeriesIdAndTotalShipmentsTotal.get(objEventSeries.Id) != null){
				
				objEventSeries.Total_Shipping_Expense__c= mapEventSeriesIdAndTotalShipmentsTotal.get(objEventSeries.Id);
				lstEventSeries.add(objEventSeries);
			}
			
		}// end of for-each
		
		if(lstEventSeries.size() > 0){
			update lstEventSeries;
		}
		
	}
}