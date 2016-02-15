public with sharing class OnsiteExpenses {
	public string eventId{get;set;}
	public string orderId{get;set;}
	public WW_Event__c objEvent{get;set;}
	public List<Event_Resource__c> listER{get;set;}
	private static final String VISIBLE_STYLE = '';
	private static final String INVISIBLE_STYLE = 'display:none;';
    public String errorMessage {get; private set;}
	public String errorMessageStyle {get; private set;}		
	public OnsiteExpenses()
	{
		changeErrorMessageVisibility(false);	
		eventId=ApexPages.currentPage().getParameters().get('event');
		String message=ApexPages.currentPage().getParameters().get('m');
		objEvent=[Select Id,Name From WW_Event__c Where Id=:eventId];
		getEventOnsiteExpenses();
		if(!String.isBlank(message) && message=='s')
		{
    		errorMessage='Successfully saved';
    		changeErrorMessageVisibility(true);			
		}		
	}
	public void getEventOnsiteExpenses()
	{
		listER=[Select Id,Contact__c,Contact__r.Name,Expense_Type__c,Company__c,Expense_Details__c,Transaction_Date__c,Expected_Expense__c From Event_Resource__c where  WW_Event__c=:eventId and Expense_Type__c!=null];
	}
    public void changeErrorMessageVisibility(Boolean show) {
    	if ( show ) {
    		errorMessageStyle = VISIBLE_STYLE;
    	}else {
    		errorMessageStyle = INVISIBLE_STYLE;
    	}
    }		
}