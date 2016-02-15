public with sharing class OnsiteStaffEdit {
	public string eventId{get;set;}
	public string staffId{get;set;}
	public WW_Event__c objEvent{get;set;}
	public Event_Resource__c er{get;set;}
	public Contact con{get;set;}
    private static final String VISIBLE_STYLE = '';
	private static final String INVISIBLE_STYLE = 'display:none;';
    public String errorMessage {get; private set;}
	public String errorMessageStyle {get; private set;}	
	public Boolean ParkingCredit{get;set;}
	public OnsiteStaffEdit()
	{
		changeErrorMessageVisibility(false);
		errorMessage='';
		eventId=ApexPages.currentPage().getParameters().get('event');
		staffId=ApexPages.currentPage().getParameters().get('sid');
		objEvent=[Select Id,Name From WW_Event__c Where Id=:eventId];
		//getEventStaff();
		if(!String.isBlank(staffId))
		{
			er=[Select Id,Contact__c,Contact__r.Name,Event_Role__c,Start_Time__c,End_Time__c,Total_Miles__c,Additional_Expense_Credits__c,
					Attendance__c,Event_Staff_Rating__c,Staffing_Agency__c From Event_Resource__c where  WW_Event__c=:eventId and Id=:staffId];
			if(!String.isBlank(er.Additional_Expense_Credits__c) && er.Additional_Expense_Credits__c.contains('Onsite Parking - Event Day'))
			{
				ParkingCredit=true;
			}
			else
			{
				ParkingCredit=false;
			}	
		}
		else
		{
			Account a=[Select Id From Account Where Name='ADURO Screening Event Staff' limit 1];
			RecordType rt=[select id,sObjectType,developerName from RecordType where DeveloperName='Health_Screening_Provider'];
			con=new Contact(AccountId=a.Id,RecordTypeId=rt.Id);
			er=new Event_Resource__c(WW_Event__c=eventId,Account__c=a.Id);
		}			
	}
    private void changeErrorMessageVisibility(Boolean show) {
    	if ( show ) {
    		errorMessageStyle = VISIBLE_STYLE;
    	}else {
    		errorMessageStyle = INVISIBLE_STYLE;
    	}
    }
    public PageReference save()
    {
    	PageReference pr;
    	errorMessage='';
    	if(String.isBlank(staffId))
    	{
    		if(String.isBlank(con.FirstName))
    		{
    			errorMessage+=' First Name';
    		}
    		if(String.isBlank(con.LastName))
    		{
    			errorMessage+=' Last Name';
    		}
    		if(String.isBlank(con.Email))
    		{
    			errorMessage+=' Email';
    		} 
    		if(!String.isBlank(errorMessage))
    		{
    			errorMessage='Following fields are required: '+errorMessage;
    			changeErrorMessageVisibility(true);
    			return null;
    		}   		    		
    	}
    	if(ParkingCredit && (er.Additional_Expense_Credits__c==null || !er.Additional_Expense_Credits__c.contains('Onsite Parking - Event Day')))
    	{
    		if(er.Additional_Expense_Credits__c==null) er.Additional_Expense_Credits__c='';
    		er.Additional_Expense_Credits__c+='Onsite Parking - Event Day;';
    	}
    	else if(!String.isBlank(er.Additional_Expense_Credits__c) && er.Additional_Expense_Credits__c.contains('Onsite Parking - Event Day'))
    	{
    		er.Additional_Expense_Credits__c=er.Additional_Expense_Credits__c.replace('Onsite Parking - Event Day','');
    	}
    	try
    	{
    		if(String.isBlank(staffId))
    		{
    			insert con;
    			er.Contact__c=con.Id;
    			er.Resource_Type__c='Event Staff';
    		}
    		upsert er;
    		pr=Page.OnsiteStaff;
    		pr.setRedirect(true);
    		pr.getParameters().put('event',eventId);
    		pr.getParameters().put('m','s');
    		//errorMessage='Successfully saved';
    		//changeErrorMessageVisibility(true);
    	}
    	catch(Exception ex){
    		errorMessage='Error:'+ex.getMessage();
    		changeErrorMessageVisibility(true);    	
    	}
    	return pr;
    }	
}