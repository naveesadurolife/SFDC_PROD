public with sharing class OnsiteEventDetail {
    public string eventId{get;set;}
    public WW_Event__c objEvent{get;set;}
    public OnsiteEventDetail()
    {
        eventId=ApexPages.currentPage().getParameters().get('event');
        objEvent=[Select Id,Name,Physical_Count_from_Check_In__c,Physical_Count_from_Data_Sheets__c,Employer__r.Name,
                  Event_Date__c,Start_Time__c,End_Time__c,Event_Length__c,Scheduler_Details__c,WW_Arrival_Time__c,
                  Expected_Participation__c,Screeners_Needed__c,Coaches_Needed__c,Event_Address__c,Biometric_Contact__c,
                  Room_Location__c,Parking_Instructions__c,Event_Manager__c,
                  (Select Id,Contact__r.Name,Contact__r.Phone,Contact__r.Email,Event_Role__c,Confirmation_Call_Results__c, Attendance__c From Event_Expenses__r Where Resource_Type__c='Event Staff' AND Confirmation_Call_Results__c != 'Cancelled' AND Confirmation_Call_Results__c != 'Cancelled - Less than 24 hours notice' AND Attendance__c != 'Cancelled' AND Attendance__c != 'Removed') 
                  From WW_Event__c Where Id=:eventId];
    }
    public PageReference save()
    {
        update objEvent;
        update objEvent.Event_Expenses__r;
        return null;
    }   
}