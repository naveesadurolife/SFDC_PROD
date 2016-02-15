public with sharing class OnsiteExpenseAddEdit {
	public string eventId{get;set;}
	public string expId{get;set;}
	public string contact{get;set;}
	public string contactId{get;set;}
	public WW_Event__c objEvent{get;set;}
	public Event_Resource__c er{get;set;}
    private static final String VISIBLE_STYLE = '';
	private static final String INVISIBLE_STYLE = 'display:none;';
    public String errorMessage {get; private set;}
	public String errorMessageStyle {get; private set;}	
	public OnsiteExpenseAddEdit()
	{
		changeErrorMessageVisibility(false);
		errorMessage='';
		eventId=ApexPages.currentPage().getParameters().get('event');
		expId=ApexPages.currentPage().getParameters().get('eid');
		objEvent=[Select Id,Name,Event_Lead__c,Event_Lead__r.Name,(Select Id,Contact__c,Contact__r.Name From Event_Resources__r where Event_Lead__c=true and Contact__c!=null limit 1) From WW_Event__c Where Id=:eventId];
		//if(objEvent.Event_Resources__r.size()==1)
		{
			contact=objEvent.Event_Lead__r.Name;
			contactId=objEvent.Event_Lead__c;
		}
		if(!String.isBlank(expId))
		{
			er=[Select Id,Contact__c,Contact__r.Name,Expense_Type__c,Company__c,Expense_Details__c,Transaction_Date__c,Expected_Expense__c 
			From Event_Resource__c where  WW_Event__c=:eventId and Id=:expId];
			if(er.Contact__c!=null)
			{
				contact=er.Contact__r.Name;
				contactId=er.Contact__c;
			}			
		}
		else
		{
			er=new Event_Resource__c(Contact__c=contactId,WW_Event__c=eventId);
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
    	try
    	{
    		upsert er;
    		pr=Page.OnsiteExpenses;
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