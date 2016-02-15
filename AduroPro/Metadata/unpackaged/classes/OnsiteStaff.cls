public with sharing class OnsiteStaff {
    public string eventId{get;set;}
    public string orderId{get;set;}
    public WW_Event__c objEvent{get;set;}
    public List<EventResource> listER{get;set;}
    private static final String VISIBLE_STYLE = '';
    private static final String INVISIBLE_STYLE = 'display:none;';
    public String errorMessage {get; private set;}
    public String errorMessageStyle {get; private set;} 
    public OnsiteStaff()
    {
        changeErrorMessageVisibility(false);
        eventId=ApexPages.currentPage().getParameters().get('event');
        String message=ApexPages.currentPage().getParameters().get('m');
        objEvent=[Select Id,Name From WW_Event__c Where Id=:eventId];
        getEventStaff();
        if(!String.isBlank(message) && message=='s')
        {
            errorMessage='Successfully saved';
            changeErrorMessageVisibility(true);         
        }
    }
    public void getEventStaff()
    {
        changeErrorMessageVisibility(false);    
        listER=new List<EventResource>();
        for(Event_Resource__c er:[Select Id,Contact__c,Contact__r.Name,Contact__r.Email,Event_Role__c,Start_Time__c,End_Time__c,Total_Miles__c,Additional_Expense_Credits__c,Signed_Off_Date__c,
                Attendance__c,Event_Staff_Rating__c,Staffing_Agency__c From Event_Resource__c where  WW_Event__c=:eventId and Resource_Type__c='Event Staff' and Attendance__c != 'Cancelled' and Attendance__c != 'Removed' and Attendance__c != 'No-Show'])
        {
            EventResource ers=new EventResource();
            ers.er=er;
            ers.contactName=er.Contact__r.Name;
            ers.contactEmail=er.Contact__r.Email;
            if(!String.isBlank(er.Additional_Expense_Credits__c) && er.Additional_Expense_Credits__c.contains('Onsite Parking - Event Day'))
            {
                ers.ParkingCredit=true;
            }
            else
            {
                ers.ParkingCredit=true;
            }
            listER.add(ers);
        }
    }
    @RemoteAction
    public static String isValidUser(String code)
    {
        String result='no';
        Custom_Configuration__c iPADPassword = Custom_Configuration__c.getValues('iPADPassword');
        if(iPADPassword!=null && String.isNotBlank(iPADPassword.Value__c) && iPADPassword.Value__c==code)
        {
            result='yes';
        }       
        return result;
    }
    private void changeErrorMessageVisibility(Boolean show) {
        if ( show ) {
            errorMessageStyle = VISIBLE_STYLE;
        }else {
            errorMessageStyle = INVISIBLE_STYLE;
        }
    }   
    public class EventResource
    {
        public Event_Resource__c er{get;set;}
        public Boolean ParkingCredit{get;set;} 
        public String contactName{get;set;}
        public String contactEmail{get;set;}
    }
}