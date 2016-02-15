/**
    * ProgramTriggerHandler - <description>
    * Created by BrainEngine Cloud Studio
    * @author: Navees Ahmed
    * @version: 1.0
*/

public with sharing class ProgramTriggerHandler{

    ProgramTriggerHelper helper = new ProgramTriggerHelper();
    
    
    public static void beforeInsert(List<Program__c> listPrograms)
    {
        validateAndUpdateFields(listPrograms);
    }
    public static void beforeUpdate(List<Program__c> listPrograms)
    {
        validateAndUpdateFields(listPrograms);
    }
    
    public void onAfterUpdate(list<Program__c>lstNewPrograms, map<Id, Program__c> mapOldPrograms){
    
        helper.updateProgramManagerOnEventSeries(lstNewPrograms, mapOldPrograms);
    }
    
    
    public static void validateAndUpdateFields(List<Program__c> listPrograms)
    {
        if(listPrograms!=null && listPrograms.size()>0)
        {
            Map<Id, Program__c> futurePrograms = new Map<Id, Program__c>( [ SELECT Account__c, Program_Start_Date__c, Program_End_Date__c 
                                                                        , Include_HTK_Component__c, Include_Onsite_component__c
                                                                        , Include_Activity_Device_Component__c FROM Program__c 
                                                                        WHERE Program_End_Date__c >= TODAY
                                                                        AND ( Include_HTK_Component__c = true
                                                                        OR Include_Onsite_component__c = true
                                                                        OR Include_Activity_Device_Component__c = true ) ] );   
            for( Program__c program : listPrograms ){
                if(program.Id!=null)
                    program.Incentive_Program_URL__c=Constant.INCENTIVE_EVENT_URL.replace('@@PAGE@@',Constant.INCENTIVE_PROGRAM_PAGE).replace('@@ID@@',program.Id);
                if( ( program.Include_HTK_Component__c || program.Include_Onsite_component__c || program.Include_Activity_Device_Component__c )
                    && program.Program_End_Date__c != null && program.Program_Start_Date__c != null ){
                    for( Program__c existingProgram : futurePrograms.values() ){
                        if( program.Program_End_Date__c > existingProgram.Program_Start_Date__c
                            && program.Program_Start_Date__c < existingProgram.Program_End_Date__c 
                            && program.Account__c == existingProgram.Account__c 
                            && program.Id != existingProgram.Id  ){ // there's an overlap between different programs
                            
                            if( ( program.Include_HTK_Component__c && existingProgram.Include_HTK_Component__c )
                                || ( program.Include_Onsite_component__c && existingProgram.Include_Onsite_component__c )
                                || ( program.Include_Activity_Device_Component__c && existingProgram.Include_Activity_Device_Component__c )
                            ){                      
                                program.DateConflict__c = true;
                                break;
                            }
                                            
                        }
                        
                    }
                }       
            }           
        }
    }

}