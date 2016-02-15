public class ProgramTriggerHelper{

    public void updateProgramManagerOnEventSeries(list<Program__c> lstNewPrograms, map<Id, Program__c> mapOldPrograms){
        
        map<Id, Id> mapManagerChangeProgramIdsAndEventManager = new map<Id, Id>();
        map<Id, Id> mapEventSeriesAndEventManager = new map<Id, Id>();
        list<Event_Series__c> lstEventSeries = new list<Event_Series__c>();
        for(Program__c objProgram :lstNewPrograms){
        
            if(objProgram.Event_Manager__c != null
                && objProgram.Event_Manager__c != mapOldPrograms.get(objProgram.Id).Event_Manager__c){
                
                mapManagerChangeProgramIdsAndEventManager.put(objProgram.Id, objProgram.Event_Manager__c);
                
             }
        }// end of for-each
        
        if(mapManagerChangeProgramIdsAndEventManager.Keyset().size() == 0){
            return;
        }
        
        for(WW_Event__c objEvent : [SELECT Id, Program__c, Event_Series__c FROM WW_Event__c WHERE Program__c IN :mapManagerChangeProgramIdsAndEventManager.keyset()]){
        
            mapEventSeriesAndEventManager.put(objEvent.Event_Series__c, mapManagerChangeProgramIdsAndEventManager.get(objEvent.Program__c));
        }
        
        if(mapEventSeriesAndEventManager.Keyset().size() == 0){
            return;
        }
        
        for(Event_Series__c objEventSeries :[SELECT Id, Event_Manager__c FROM Event_Series__c WHERE Id IN : mapEventSeriesAndEventManager.KeySet()]){
            
            objEventSeries.Event_Manager__c = mapEventSeriesAndEventManager.get(objEventSeries.Id);
            lstEventSeries.add(objEventSeries);
        }
        
        if(lstEventSeries.size() > 0){
            update lstEventSeries;
        }
    
    }// end of updateProgramManagerOnEventSeries
}// end of ProgramTriggerHelper