public with sharing class CreatePackagingSlipController {
	
	private ApexPages.StandardSetController standardController; 
	private list<Event_Series__c> lstSelectedEventSeries;
	public list<EventSeriesWrapper> lstEventSeries {get; set;}
	private map<Id, list<EventWrapper>> mapEventSeriesAndEvents;
	private map<Id, list<decimal>> mapEventSeriesTotals;
	private map<Id, map<string, string>> mapEventSeriesDetails;
	
	
	
	public CreatePackagingSlipController(ApexPages.StandardSetController standardController) {
		
		this.standardController = standardController;
		lstSelectedEventSeries = [SELECT Id FROM Event_Series__c WHERE Id IN: (List<Event_Series__c>)standardController.getSelected() ];
		createMapEventSeriesAndEvents();
		createMapEventSeriesAndDetails();
		calculateEventSeriesTotals();
		populateSeriesList();
	}
	
	private void createMapEventSeriesAndEvents(){
		
		mapEventSeriesAndEvents = new map<Id, list<EventWrapper>> ();
		
		/*for(Related_Event__c objRelatedEvent : [SELECT Id, ADURO_Event__c, ADURO_Event__r.Name, ADURO_Event__r.Event_Date__c,ADURO_Event__r.Screeners_Needed__c,ADURO_Event__r.Coaches_Needed__c, Event_Series__c,
													ADURO_Event__r.Type_of_Tobacco_Testing__c, ADURO_Event__r.Event_Manager__c,ADURO_Event__r.Type_of_Scorecard__c, ADURO_Event__r.Biometric_Contact__c,
													ADURO_Event__r.Room_Location__c, ADURO_Event__r.Special_Shipping_Notes__c,ADURO_Event__r.Shipping_Address__c,ADURO_Event__r.Expected_Participation__c,
													ADURO_Event__r.Program__r.Type_of_Tobacco_Testing__c, ADURO_Event__r.Program__r.Event_Manager__c, ADURO_Event__r.Program__r.Event_Manager__r.Name, 
													ADURO_Event__r.Program__r.Type_of_Scorecard__c, ADURO_Event__r.Program__r.Enable_Concierge__c
													 	 FROM Related_Event__c WHERE Event_Series__c IN: lstSelectedEventSeries]){*/
		for(WW_Event__c objEvent :[SELECT Id, Name, Event_Date__c,Screeners_Needed__c,Coaches_Needed__c, Event_Series__c,
													Type_of_Tobacco_Testing__c, Event_Manager__c,Type_of_Scorecard__c, Biometric_Contact__c,
													Room_Location__c, Special_Shipping_Notes__c,Shipping_Address__c,Expected_Participation__c,
													Program__r.Type_of_Tobacco_Testing__c, Program__r.Event_Manager__c, Program__r.Event_Manager__r.Name, 
													Program__r.Type_of_Scorecard__c, Program__r.Enable_Concierge__c
													 	 FROM WW_Event__c WHERE Event_Series__c IN: lstSelectedEventSeries]){
			
			if(mapEventSeriesAndEvents.get(objEvent.Event_Series__c) ==  null){
				
				mapEventSeriesAndEvents.put(objEvent.Event_Series__c, new list<EventWrapper>());
				
			}
			
			mapEventSeriesAndEvents.get(objEvent.Event_Series__c).add(new EventWrapper(objEvent));
			
		}// end of for each objEvent
		
		
		system.debug('##--mapEventSeriesAndEvents: '+mapEventSeriesAndEvents);
		
	}// end of createMapEventSeriesAndEvents
	
	private void createMapEventSeriesAndDetails(){
		mapEventSeriesDetails = new map<Id, map<string, string>>();
		
	}	//	end of createMapEventSeriesAndDetails
	
	private void calculateEventSeriesTotals(){
		mapEventSeriesTotals = new map<Id, list<decimal>>();
		
		for(Id key : mapEventSeriesAndEvents.keySet()){
			decimal noOfEvents=0, countParticipation=0, countStation=0, countCoachings=0, countWeights=0, sumStations=0, sumCoachings=0;
			
			for(EventWrapper objEvent: mapEventSeriesAndEvents.get(key)){
				noOfEvents += 1;
				countParticipation += objEvent.eventProjectedParticipation==null ? 0 : objEvent.eventProjectedParticipation;
				countStation = (objEvent.eventScreeningStations!=null && objEvent.eventScreeningStations>countStation) ? objEvent.eventScreeningStations : countStation;
				countCoachings = (objEvent.eventCoaching!=null && objEvent.eventCoaching>countCoachings) ? objEvent.eventCoaching : countCoachings;
				countWeights = (objEvent.eventWeighingStations!=null && objEvent.eventWeighingStations>countWeights) ? objEvent.eventWeighingStations : countWeights;
				
				system.debug('##--Event Screening Stations: ' + objEvent.eventScreeningStations + '\tSum Stations: ' + sumStations);
				sumStations += objEvent.eventScreeningStations!=null ? objEvent.eventScreeningStations : 0;
				sumCoachings += objEvent.eventCoaching!=null ? objEvent.eventCoaching : 0;
			
			}	//	end of for-each Event in Series
			
			//	Add to the list
			mapEventSeriesTotals.put(key, new list<decimal>{noOfEvents, countParticipation, countStation, countCoachings, countWeights, sumStations, sumCoachings});
		}	//	end of for each event series
		
	}	//	end of calculateEventSeriesTotals
	
	private void populateSeriesList(){
		lstEventSeries = new list<EventSeriesWrapper>();
		
		for(Id key: mapEventSeriesAndEvents.keySet()){
			lstEventSeries.add(new EventSeriesWrapper(key, mapEventSeriesAndEvents.get(key), mapEventSeriesTotals.get(key)));
		}	//	end of for-each
		
	}	//	end of populateSeriesList
	
	
	
	public class PackagingSlipSettingsWrapper{
		
		public PackagingSlipSettingsWrapper(){}
		
		public string pssName{get;set;}
		public decimal pssQty{get;set;}
		public decimal pssAdditional{get;set;}
		public decimal pssTotalToShip{get;set;}
		public string pssQuantityPacked{get;set;}
		public string pssDoubleCheck{get;set;}
		public string pssTotal{get;set;}
		
		public PackagingSlipSettingsWrapper(String continineValue, String conciergeCoachingValue, Packaging_Slip_Settings__c cs, decimal noOfEvents, decimal countParticipation, decimal countStation, decimal countCoachings, decimal countWeights, decimal sumStations, decimal sumCoachings){
			pssName = cs.Name;
			pssQty = cs.QTY__c;
			pssAdditional = cs.Additional__c;
			pssTotalToShip = calculateWithCondition(continineValue, pssName, pssQty, pssAdditional, countParticipation);
			pssTotal = caluculateTotal(continineValue, conciergeCoachingValue, cs, noOfEvents, countParticipation, countStation, countCoachings, countWeights, sumStations, sumCoachings);
			pssQuantityPacked = cs.Quantity_Packed__c;
			pssDoubleCheck = cs.Double_Check__c;
		}	//	end of constructor
		
		private decimal calculateWithCondition(String continineValue, String cs_name, decimal cs_qty, decimal cs_additional, decimal countParticipation){
			
			if(cs_name.equalsIgnoreCase('Cotinine Lollipops') && continineValue.equalsIgnoreCase('N')){
				return null;
			}
			
			return (cs_qty == null || cs_additional == null) ? null : (cs_qty * (1+(cs_additional/100)) * countParticipation);
			
		}	//	end of calculateWithCondition
		
		private string caluculateTotal(String continineValue, String conciergeCoachingValue, Packaging_Slip_Settings__c cs, decimal noOfEvents, decimal countParticipation, decimal countStation, decimal countCoachings, decimal countWeights, decimal sumStations, decimal sumCoachings){
			if(cs.Total_to_Ship__c!=null){
				string totalStr = cs.Total_to_Ship__c.replace('Total_Weight', String.valueOf(countWeights));
				totalStr = totalStr.replace('Total_Stations', String.valueOf(countStation));
				totalStr = totalStr.replace('Sum_Stations', String.valueOf(sumStations));
				totalStr = totalStr.replace('Sum_Coachings', String.valueOf(sumCoachings));
				totalStr = totalStr.replace('Total_Participation', String.valueOf(countParticipation));
				totalStr = totalStr.replace('Total_Events', String.valueOf(noOfEvents));
				totalStr = totalStr.replace('Total_Coachings', String.valueOf(countCoachings));
				totalStr = totalStr.replace('Quantity', String.valueOf(cs.QTY__c==null?0:cs.QTY__c));
				totalStr = totalStr.replace('Additional', String.valueOf(cs.Additional__c==null?0:cs.Additional__c));
				totalStr = totalStr.replace('Continine_Testing', String.valueOf(continineValue));
				totalStr = totalStr.replace('Concierge_Coaching', String.valueOf(conciergeCoachingValue));
				return '=' + totalStr;
			}
			
			return '';
		}	//	end of caluculateTotal
		
	}	//	end of PackagingSlipSettingsWrapper
	
	public class EventWrapper{
		
		public EventWrapper(){}
		
		public string eventName {get;set;}
		public date eventDate {get;set;}
		public decimal eventProjectedParticipation {get;set;}
		public decimal eventScreeningStations {get;set;}
		public decimal eventCoaching {get;set;}
		public decimal eventWeighingStations {get;set;}
		
		public String contact {get; set;}
		public String roomLocation {get; set;}
		public String shippingAddress {get; set;}
		public String shippingNotes {get; set;}
		public String continineTesting {get; set;}
		public String conciergeCoaching {get; set;}
		public String eventManager {get; set;}
		public String scorecardType {get; set;}
		
		public EventWrapper(WW_Event__c pReleatedEvents){
			
			eventName = pReleatedEvents.Name;
			eventDate = pReleatedEvents.Event_Date__c;
			eventProjectedParticipation = pReleatedEvents.Expected_Participation__c;
			eventScreeningStations = pReleatedEvents.Screeners_Needed__c;//pReleatedEvents.Screeners_Needed__c.intValue();
			eventCoaching = pReleatedEvents.Coaches_Needed__c;//pReleatedEvents.Coaches_Needed__c.intValue();
			eventWeighingStations = Math.ceil(pReleatedEvents.Screeners_Needed__c/4) == 0 ? null : Math.ceil(pReleatedEvents.Screeners_Needed__c/4);//pReleatedEvents;
			contact = pReleatedEvents.Biometric_Contact__c;
			roomLocation = pReleatedEvents.Room_Location__c;
			shippingAddress = pReleatedEvents.Shipping_Address__c;
			shippingNotes = pReleatedEvents.Special_Shipping_Notes__c;
			
			eventManager = pReleatedEvents.Program__r.Event_Manager__r.Name;
			scorecardType = pReleatedEvents.Program__r.Type_of_Scorecard__c;
			if(pReleatedEvents.Program__r.Type_of_Tobacco_Testing__c == 'Tobacco Cotinine'){
				continineTesting = 'Y';
			}else {
				continineTesting = 'N';
			}
			if(pReleatedEvents.Program__r.Enable_Concierge__c == true){
				conciergeCoaching = 'Y';
			}else {
				conciergeCoaching = 'N';
			}
		}	//	end of EventWrapper
		
		
	}	//	end of class EventWrapper
	
	
	public class EventSeriesWrapper{
		
		public String seriesName {get; set;}
		public list<EventWrapper> lstEvents {get; set;}
		public list<decimal> lstTotals {get; set;}
		public list<PackagingSlipSettingsWrapper> lstParticipantItems {get; set;}
		public list<PackagingSlipSettingsWrapper> lstStationItems {get; set;}
		public list<PackagingSlipSettingsWrapper> lstEventItems {get; set;}
		public list<PackagingSlipSettingsWrapper> lstPaperworkItems {get; set;}
		public list<PackagingSlipSettingsWrapper> lstEquipmentItems {get; set;}
		
		
		public String contact {get; set;}
		public String roomLocation {get; set;}
		public String shippingAddress {get; set;}
		public String shippingNotes {get; set;}
		public String continineTesting {get; set;}
		public String conciergeCoaching {get; set;}
		public String eventManager {get; set;}
		public String scorecardType {get; set;}
		
		public EventSeriesWrapper(){}	//	default constructor
		
		public EventSeriesWrapper(String pName, list<EventWrapper> pLstEvents, list<decimal> pLstTotals){
			seriesName = pName;
			lstEvents = pLstEvents;
			lstTotals = pLstTotals;
			populateAdditionalDetails(lstTotals[0], lstTotals[1], lstTotals[2], lstTotals[3], lstTotals[4], lstTotals[5], lstTotals[6]);
			system.debug('##--Totals: '+ pLstTotals +'	-- lstParticipantItems:' + lstParticipantItems);
		}	//	end of constructor
		
		
		private void populateAdditionalDetails(decimal noOfEvents, decimal countParticipation, decimal countStation, decimal countCoachings, decimal countWeights, decimal sumStations, decimal sumCoachings){
			List<Packaging_Slip_Settings__c> mcs = Packaging_Slip_Settings__c.getall().values();
			map<string, list<PackagingSlipSettingsWrapper>> mapItemNameAndPackagingSlipSettings = new map<string, list<PackagingSlipSettingsWrapper>>();
			String continineValue =  (lstEvents != null && ! lstEvents.isEmpty())? lstEvents[0].continineTesting : '';
			String conciergeCoachingValue =  (lstEvents != null && ! lstEvents.isEmpty())? lstEvents[0].conciergeCoaching : '';
			
			for(Packaging_Slip_Settings__c cs :Packaging_Slip_Settings__c.getall().values()){
				system.debug('##--Custom Settings: ' + cs);
				if(mapItemNameAndPackagingSlipSettings.get(cs.Grouping_Name__c) ==  null){
					
					mapItemNameAndPackagingSlipSettings.put(cs.Grouping_Name__c, new list<PackagingSlipSettingsWrapper>());
					
				}
				
				mapItemNameAndPackagingSlipSettings.get(cs.Grouping_Name__c).add(new PackagingSlipSettingsWrapper(continineValue, conciergeCoachingValue, cs, noOfEvents, countParticipation, countStation, countCoachings, countWeights, sumStations, sumCoachings));
				system.debug('## -- Creating the Custom Settings');
			}	//	end of for-each
			
			this.lstParticipantItems = mapItemNameAndPackagingSlipSettings.get('Items per Participant');
			this.lstStationItems = mapItemNameAndPackagingSlipSettings.get('Items per Station');
			this.lstEventItems = mapItemNameAndPackagingSlipSettings.get('Items per Event');
			this.lstPaperworkItems = mapItemNameAndPackagingSlipSettings.get('Paperwork');
			this.lstEquipmentItems = mapItemNameAndPackagingSlipSettings.get('Equipment');
			system.debug('## -- Setting the Participation Items');
			
			if(lstEvents != null && ! lstEvents.isEmpty()){
				contact = lstEvents[0].contact;
				roomLocation = lstEvents[0].roomLocation;
				shippingAddress = lstEvents[0].shippingAddress;
				shippingNotes = lstEvents[0].shippingNotes;
				continineTesting = lstEvents[0].continineTesting;
				conciergeCoaching = lstEvents[0].conciergeCoaching;
				eventManager = lstEvents[0].eventManager;
				scorecardType = lstEvents[0].scorecardType;
			}
		}	//	end of populateAdditionalDetails
		
	}	//	end fo class EventSeriesWrapper
	
	

}