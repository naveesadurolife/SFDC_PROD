public with sharing class CreateEventSeriesController {
    
    public Event_Series__c objEventSeries {get;set;}
    private ApexPages.StandardSetController standardController; 
    private list<WW_Event__c> lstAduroEvents;
    
    public CreateEventSeriesController(ApexPages.StandardSetController standardController) {
        
        this.standardController = standardController;
        objEventSeries = new Event_Series__c();
        lstAduroEvents = [SELECT Id, Name, Number_Of_Participants_Screened__c, Event_Address__c, Parking_Instructions__c,
                                Event_Date__c, Event_Series__c, Event_Manager__c, Biometric_Contact__c,
                                 Screeners_Needed__c, Coaches_Needed__c, Event_Type__c,
                                Room_Location__c, Special_Shipping_Notes__c, Shipping_Address__c, Expected_Participation__c,Supply_Projected_Cost__c,
                                Program__r.Type_of_Tobacco_Testing__c, Program__r.Event_Manager__c, Program__r.Event_Manager__r.Name, 
                                Program__r.Type_of_Scorecard__c, Program__r.Enable_Concierge__c, Program__r.Biometric_Price_Per_Participant__c, 
                                Total_Mileage_Reimbursement__c, Total_Expenses__c , (SELECT Id, zkfedex__TotalNetCharge__c FROM FedEx_Shipments__r)
                            FROM WW_Event__c WHERE Id IN : (List<WW_Event__c>)standardController.getSelected() ORDER BY Event_Date__c];
                            
        objEventSeries.Name = 'SERIES: ' + lstAduroEvents[0].Name;
        
    }   //  end of controller
    
    public pageReference save(){
        
        createEventSeries();
        createRelatedEvents();
        
        PageReference page = new PageReference('/'+objEventSeries.Id);
        return page;
    
    }
    
    private void createEventSeries(){
        integer totalEvents = lstAduroEvents.size();
        
        calculateTotals();
        
        objEventSeries.Number_of_Events_in_the_Series__c = totalEvents;
        objEventSeries.Biometric_Contact__c = lstAduroEvents[0].Biometric_Contact__c;
        objEventSeries.Event_Address__c = lstAduroEvents[0].Event_Address__c;
        objEventSeries.Shipping_Address__c = lstAduroEvents[0].Shipping_Address__c;
        objEventSeries.Room_Location__c = lstAduroEvents[0].Room_Location__c;
        objEventSeries.Parking_Instructions__c = lstAduroEvents[0].Parking_Instructions__c;
        objEventSeries.Series_Start_Date__c = lstAduroEvents[0].Event_Date__c;
        objEventSeries.Event_Manager__c = lstAduroEvents[0].Program__r.Event_Manager__c;
        objEventSeries.Event_Type__c = lstAduroEvents[0].Event_Type__c;
        objEventSeries.Series_End_Date__c = lstAduroEvents[totalEvents - 1].Event_Date__c;
        
        insert objEventSeries;
        
    }
    
    private void createRelatedEvents(){
        
        //list<Related_Event__c> lstRelatedEvents = new list<Related_Event__c>();
        
        for(WW_Event__c objEvent :lstAduroEvents){
            
            objEvent.Event_Series__c = objEventSeries.Id;
            /*Related_Event__c objRelatedEvent = new Related_Event__c(
                                                    ADURO_Event__c = objEvent.Id,
                                                    Event_Series__c = objEventSeries.Id);   */
            //lstRelatedEvents.add(objRelatedEvent);
            
        }
        
        if(lstAduroEvents.size() > 0){
            update lstAduroEvents;
        }
        
    }
    
    private void calculateTotals(){
        decimal totalParticipation=0, totalScreened=0, totalExpenses=0, totalMileage=0, totalShippingExpense = 0, totalBioPricePerPart = 0,  totalSupplyProjectedCost=0;
        boolean conciergeEnabled=false;
        decimal maxScreenersNeeded=0, maxCoachesNeeded=0;
        
        for(WW_Event__c objEvent : lstAduroEvents){
            
            totalParticipation += objEvent.Expected_Participation__c==null ? 0 : objEvent.Expected_Participation__c;
            totalScreened += objEvent.Number_Of_Participants_Screened__c==null ? 0 : objEvent.Number_Of_Participants_Screened__c;
            totalSupplyProjectedCost += objEvent.Supply_Projected_Cost__c==null ? 0 : objEvent.Supply_Projected_Cost__c;
            totalBioPricePerPart += objEvent.Program__r.Biometric_Price_Per_Participant__c ==null ? 0 : objEvent.Program__r.Biometric_Price_Per_Participant__c;
            if(objEvent.Screeners_Needed__c != null && objEvent.Screeners_Needed__c > maxScreenersNeeded){
                maxScreenersNeeded = objEvent.Screeners_Needed__c;
                conciergeEnabled = objEvent.Program__r.Enable_Concierge__c;
            }
            if(objEvent.Coaches_Needed__c != null && objEvent.Coaches_Needed__c > maxScreenersNeeded){
                maxCoachesNeeded = objEvent.Coaches_Needed__c;
            }
            totalExpenses += objEvent.Total_Expenses__c==null ? 0 : objEvent.Total_Expenses__c;
            totalMileage += objEvent.Total_Mileage_Reimbursement__c==null ? 0 : objEvent.Total_Mileage_Reimbursement__c;
            
            for(zkfedex__Shipment__c objFedExShipments : objEvent.FedEx_Shipments__r){
                
                totalShippingExpense += objFedExShipments.zkfedex__TotalNetCharge__c==null ? 0 : objFedExShipments.zkfedex__TotalNetCharge__c;
                
            }
            
        }   //  end of for-each Events
        
        objEventSeries.Total_Expected_Participation__c = totalParticipation;
        objEventSeries.Total_Participants_Screened__c = totalScreened;
        objEventSeries.Total_Tablets_Needed__c = maxScreenersNeeded + (conciergeEnabled ? maxCoachesNeeded : 0);
        objEventSeries.Total_Series_Mileage_Reimbursement__c = totalMileage;
        objEventSeries.Total_Series__c = totalExpenses;
        objEventSeries.Total_Shipping_Expense__c = totalShippingExpense;
        objEventSeries.Total_Biometric_Price_Per_Participant__c = totalBioPricePerPart;
        objEventSeries.Total_Supply_Projected_Cost__c = totalSupplyProjectedCost;
        objEventSeries.Total_LDX_Machines_Needed__c = maxScreenersNeeded +1;
        
    }   //  end of calculateTotals
    
    private String getSeriesManager(){
        for(WW_Event__c objEvent : lstAduroEvents){
            if(objEvent.Program__r.Event_Manager__c != null){
                return objEvent.Program__r.Event_Manager__c;
            }
        }
        return null;
    }

}