public with sharing class WWEventTriggerHandler {
    public static void beforeInsert(List<WW_Event__c> listWWEvents)
    {
        validateAndUpdateFields(listWWEvents);
    }
    public static void beforeUpdate(List<WW_Event__c> listWWEvents)
    {
        validateAndUpdateFields(listWWEvents);
    }
    public static void validateAndUpdateFields(List<WW_Event__c> listWWEvents)
    {
        if(listWWEvents!=null && listWWEvents.size()>0)
        {
            for(WW_Event__c e:listWWEvents)
            {
                if(e.Id!=null && e.Event_Type__c.equalsIgnoreCase('Incentive Event'))
                    e.Incentive_Event_URL__c=Constant.INCENTIVE_EVENT_URL.replace('@@PAGE@@',Constant.INCENTIVE_EVENT_PAGE).replace('@@ID@@',e.Id);
            }
        }
    }
    public static void CreateEventResources(List<WW_Event__c> listWWEvents,Map<Id,WW_Event__c> mapWWEvents)
    {
        if(listWWEvents!=null && listWWEvents.size()>0)
        {
            try{
                if(Test.isRunningTest())
                {
                    
                    Account a=new Account(Name='Aduro event supplies');
                    insert a;
                    Contact kit=new Contact(LastName='Kit Placeholder',AccountId=a.Id);
                    insert kit;
                    Contact bin=new Contact(LastName='Bin Placeholder',AccountId=a.Id);
                    insert bin;
                }
                List<Event_Resource__c> listEventResources=new List<Event_Resource__c>();
                Account a=[Select Id From Account Where Name='ADURO Event Supplies' limit 1];
                Contact kit=[Select Id From Contact Where Name='Kit Placeholder' limit 1];
                Contact bin=[Select Id From Contact Where Name='Bin Placeholder' limit 1];
                Set<Id> eventIDs=new Set<Id>();
                set<Id> setEventSeriesIDs = new set<Id>();
                for(WW_Event__c e:listWWEvents)
                {
                    if(e.Create_Event_Resource__c && (mapWWEvents==null || !mapWWEvents.get(e.Id).Create_Event_Resource__c))
                    {
                        listEventResources.add(new Event_Resource__c(WW_Event__c=e.Id,Expense_Type__c='Supplies',Account__c=a.Id,Kit_or_Bin__c=kit.Id));
                        listEventResources.add(new Event_Resource__c(WW_Event__c=e.Id,Expense_Type__c='Supplies',Account__c=a.Id,Kit_or_Bin__c=bin.Id));
                    }
                    eventIDs.add(e.id);
                    if(e.Event_Series__c != null){
                        setEventSeriesIDs.add(e.Event_Series__c);
                    }
                }
                insert listEventResources;
                if(!System.isBatch() && !System.isFuture() && !System.isScheduled()  && ((Limits.getLimitFutureCalls()-Limits.getFutureCalls())>0))
                {
                    UpdateRollupFields(eventIDs);
                }
                if(setEventSeriesIDs.size() > 0){
                    UpdateEventSeries(setEventSeriesIDs);
                }
            } catch(Exception e){
                
            }
        }
    }
    @future
    public static void UpdateRollupFields(Set<Id> eventIDs)
    {
        if(eventIDs!=null && eventIDs.size()>0)
        {
            List<WW_Event__c> listEvents=[Select Id,Number_Of_Participants_Scheduled__c,Number_Of_Participants_Screened__c,Number_Of_Test_Transferred__c,
                                          Number_Of_Test_Unresolved__c,Average_Time_To_Transfer__c,Total_Incentive_Sent__c,Number_of_Unique_Transferred__c,
                                          Number_of_People_on_Coaching_Station__c,Checked_in_at_Concierge__c,Registered_for_Program__c,
                                          (Select Id, Contact__c, Type__c From Slots__r Where Type__c='Regular' AND Contact__c!=null), 
                                          (Select Id, Order_Status__c, Order_Type__c,Time_to_Transfer__c,Incentive_Sent__c,Limeade_Participant_code__c,Concierge__c, 
                                            Visited_Concierge_Station__c,Concierge_Interested__c From Orders__r)
                                          From WW_Event__c Where Id In :eventIDs];
            for(WW_Event__c e:listEvents)
             {
                Decimal NumberOfParticipantsScreened=0;
                Decimal NumberOfTestTransferred=0;
                Decimal NumberOfTestUnresolved=0;
                Decimal NumberOfConcierge=0;
                //Decimal NumberOfUniqueTransferred=0;
                Decimal AverageTimeToTransfer=0;
                Decimal TimeToTransfer=0;
                Decimal TotalIncentiveSent=0;   
                 
                Decimal NumberOfCheckedInAtConcierge=0;
                Decimal NumberOfRegisteredForProgram=0;
                 
                Set<String> setUniqueParticipantCodes=new Set<String>();
                for(Order__c o:e.Orders__r)
                {
                    if(!String.isBlank(o.Order_Status__c) && (o.Order_Status__c=='Sent Limeade' || o.Order_Status__c=='Received'))
                    {
                        NumberOfParticipantsScreened=NumberOfParticipantsScreened+1;
                    }
                    if(!String.isBlank(o.Order_Status__c) && !String.isBlank(o.Limeade_Participant_code__c) && o.Order_Status__c=='Sent Limeade')
                    {
                        setUniqueParticipantCodes.add(o.Limeade_Participant_code__c);
                    }                   
                    if(!String.isBlank(o.Order_Status__c) && o.Order_Status__c=='Sent Limeade')
                    {
                        NumberOfTestTransferred=NumberOfTestTransferred+1;
                        if(o.Time_to_Transfer__c!=null && o.Time_to_Transfer__c>0 && o.Order_Type__c=='Onsite Test')
                        {
                            TimeToTransfer+=o.Time_to_Transfer__c;
                        }
                    }
                    if(!String.isBlank(o.Order_Status__c) && o.Order_Status__c=='Received')
                    {
                        NumberOfTestUnresolved=NumberOfTestUnresolved+1;
                    }
                    if(o.Incentive_Sent__c)
                    {
                        TotalIncentiveSent=TotalIncentiveSent+1;
                    }
                    if(String.isNotBlank(o.Concierge__c))
                    {
                        NumberOfConcierge=NumberOfConcierge+1;
                    }   
                    if(o.Visited_Concierge_Station__c)
                    {
                        NumberOfCheckedInAtConcierge=NumberOfCheckedInAtConcierge+1;
                    }
                    if(String.isNotBlank(o.Concierge_Interested__c) && o.Concierge_Interested__c.equalsIgnoreCase('Yes'))
                    {
                        NumberOfRegisteredForProgram=NumberOfRegisteredForProgram+1;
                    }                   
                }
                AverageTimeToTransfer=(TimeToTransfer/(e.Orders__r.size()==0?1:e.Orders__r.size()));            
                e.Number_Of_Participants_Scheduled__c=e.Slots__r.size();
                e.Number_Of_Participants_Screened__c=NumberOfParticipantsScreened;
                e.Number_Of_Test_Transferred__c=NumberOfTestTransferred;
                e.Number_Of_Test_Unresolved__c=NumberOfTestUnresolved;
                e.Number_of_Unique_Transferred__c=setUniqueParticipantCodes.size();
                e.Average_Time_To_Transfer__c=AverageTimeToTransfer;
                e.Number_of_People_on_Coaching_Station__c=NumberOfConcierge;
                e.Total_Incentive_Sent__c=TotalIncentiveSent;
                e.Checked_in_at_Concierge__c=NumberOfCheckedInAtConcierge;
                e.Registered_for_Program__c=NumberOfRegisteredForProgram;
             }
             update listEvents;
        }
    }
    
    
    public static void UpdateEventSeries(set<Id> setEventSeriesIDs){
        list<Event_Series__c> lstEventSeries = new list<Event_Series__c>();
        decimal totalParticipation=0, totalScreened=0, totalExpenses=0, totalMileage=0, totalBioPricePerPart = 0;
        boolean conciergeEnabled=false;
        decimal maxScreenersNeeded=0, maxCoachesNeeded=0;
        
        for(Event_Series__c objSeries : [SELECT Id,Total_Expected_Participation__c, Total_Tablets_Needed__c, Total_Series__c, 
                                            Total_Series_Mileage_Reimbursement__c, Total_Participants_Screened__c,
                                                (SELECT Id, Expected_Participation__c,Program__r.Biometric_Price_Per_Participant__c, 
                                                Program__r.Enable_Concierge__c, Coaches_Needed__c, Screeners_Needed__c, 
                                                Biometric_Contact__c,Program__r.Event_Manager__c,Event_Type__c,
                                                Total_Expenses__c, Total_Mileage_Reimbursement__c, Number_Of_Participants_Screened__c 
                                                FROM ADURO_Events__r)
                                        FROM Event_Series__c
                                       WHERE id IN :setEventSeriesIDs]){
                                        
            totalScreened=0;
            totalExpenses=0;
            totalMileage=0;
            totalParticipation=0;
            conciergeEnabled=false;
            maxScreenersNeeded=0;
            maxCoachesNeeded=0;
            totalBioPricePerPart = 0;
            for(WW_Event__c objEvent : objSeries.ADURO_Events__r){
                totalParticipation += objEvent.Expected_Participation__c==null ? 0 : objEvent.Expected_Participation__c;
                totalScreened += objEvent.Number_Of_Participants_Screened__c==null ? 0 : objEvent.Number_Of_Participants_Screened__c;
                totalExpenses += objEvent.Total_Expenses__c==null ? 0 : objEvent.Total_Expenses__c;
                totalMileage += objEvent.Total_Mileage_Reimbursement__c==null ? 0 : objEvent.Total_Mileage_Reimbursement__c;
                totalBioPricePerPart +=objEvent.Program__r.Biometric_Price_Per_Participant__c==null ? 0 : objEvent.Total_Mileage_Reimbursement__c;
                if(objEvent.Screeners_Needed__c != null && objEvent.Screeners_Needed__c > maxScreenersNeeded){
                    maxScreenersNeeded = objEvent.Screeners_Needed__c;
                    conciergeEnabled = objEvent.Program__r.Enable_Concierge__c;
                }
                if(objEvent.Coaches_Needed__c != null && objEvent.Coaches_Needed__c > maxScreenersNeeded){
                    maxCoachesNeeded = objEvent.Coaches_Needed__c;
                }
            }   //  end of for-each event for a series
            
            objSeries.Total_Expected_Participation__c = totalParticipation;
            objSeries.Total_Series__c = totalExpenses;
            objSeries.Total_Series_Mileage_Reimbursement__c = totalMileage;
            objSeries.Total_Participants_Screened__c = totalScreened;
            objSeries.Total_Tablets_Needed__c = maxScreenersNeeded + (conciergeEnabled ? maxCoachesNeeded : 0);
            if(objSeries.ADURO_Events__r.size() > 0 ){
            
                objSeries.Biometric_Contact__c = objSeries.ADURO_Events__r[0].Biometric_Contact__c;
                objSeries.Event_Manager__c = objSeries.ADURO_Events__r[0].Program__r.Event_Manager__c;
                objSeries.Event_Type__c = objSeries.ADURO_Events__r[0].Event_Type__c;
            
            }
            if(maxScreenersNeeded > 0){
                objSeries.Total_LDX_Machines_Needed__c = maxScreenersNeeded +1;
            }else{
                
                objSeries.Total_LDX_Machines_Needed__c = null;
            
            }
           
            
            lstEventSeries.add(objSeries);
        }   //  end of for-each Event Series
        
        if(lstEventSeries.size() > 0){
            update lstEventSeries;
        }
    }   //  end of UpdateEventSeries
    
    public static void calculateDrivingDistanceOnInsert(list<WW_Event__c> lstEvents){
        
        set<Id> setEventIds = new set<Id>();
        set<Id> setEventResourceIds = new set<Id>();
        for(WW_Event__c objEvents : lstEvents){
            
            if(objEvents.Event_Address__c != null 
                && objEvents.Event_Address__c != '')    {
                
                setEventIds.add(objEvents.Id);  
            }
        }// end of for-each
        
        if(setEventIds.size() > 0){
            
            calculateProjectedDrivingDistance(setEventIds);
            
        }
        
    }// end of calculateDrivingDistanceOnInsert
    
    public static void calculateDrivingDistanceOnUpdate(list<WW_Event__c> lstEvents, map<Id, WW_Event__c> mapOldEvents){
        
        set<Id> setEventIds = new set<Id>();
        system.debug('##--invoking calculateDrivingDistanceOnUpdate');
        for(WW_Event__c objEvents : lstEvents){
            
            system.debug('##-- new event address: '+ objEvents.Event_Address__c);
            system.debug('##-- old event address: '+ mapOldEvents.get(objEvents.Id).Event_Address__c);
            if(objEvents.Event_Address__c != null 
                && objEvents.Event_Address__c != ''
                && objEvents.Event_Address__c != mapOldEvents.get(objEvents.Id).Event_Address__c)   {
                
                setEventIds.add(objEvents.Id);  
            }
        }// end of for-each
        
        if(setEventIds.size() > 0){
            system.debug('##--calling calculateProjectedDrivingDistance');
            calculateProjectedDrivingDistance(setEventIds);
            
        }
        
    }// end of calculateDrivingDistanceOnUpdate
    
    public static void calculateProjectedDrivingDistance(set<Id> setEventIds){
        
        set<Id> setEventResourceIds = new set<Id>();
        for(Event_Resource__c objEventResource : [Select Id FROM Event_Resource__c WHERE WW_Event__c  IN :setEventIds]){
                
                setEventResourceIds.add(objEventResource.Id);
        }
        
        if(setEventResourceIds.size() > 0){
            
            GMapsDistanceCallouts.updateDistances(setEventResourceIds);
            
        }
        
    }// end of calculateProjectedDrivingDistance 
    
    public static void removeProjectedDrivingDistance(list<WW_Event__c> lstEvents, map<Id, WW_Event__c> mapOldEvents){
        
        set<Id>setEventIds = new set<Id>();
        for(WW_Event__c objEvents : lstEvents){
            system.debug('##--removeProjectedDrivingDistance.objEvents.Event_Address__c: '+ objEvents.Event_Address__c);
            if(objEvents.Event_Address__c == null
                && mapOldEvents.get(objEvents.Id).Event_Address__c != ''){
                    
                setEventIds.add(objEvents.Id);
            }
        }// end of for-each
        
        if(setEventIds.size() > 0){
            WWEventTriggerHandler.removeProjectedDistanceOnRelatedEvents(setEventIds);
        }
        
    }// end of for-each removeProjectedDrivingDistance
    
    private static void removeProjectedDistanceOnRelatedEvents(set<Id> setEventIds){
        
        list<Event_Resource__c> lstEventResources = new list<Event_Resource__c>();
        for(Event_Resource__c objEventResource :[SELECT Id, Projected_Driving_Distance__c 
                                                            FROM Event_Resource__c 
                                                            WHERE WW_Event__c IN :setEventIds]){
              
              if(objEventResource.Projected_Driving_Distance__c != null){
                objEventResource.Projected_Driving_Distance__c = null;
                lstEventResources.add(objEventResource);
              }
        }// end of for-each event resource
        if(lstEventResources.size() > 0){
            
            update lstEventResources;
        }
    
    }// end of for-each removeProjectedDistanceOnRelatedEvents
}