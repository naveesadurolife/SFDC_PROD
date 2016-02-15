public with sharing class OnsiteCheckedInWithNoResults {
	public string eventId{get;set;}
	public string orderId{get;set;}
	public WW_Event__c objEvent{get;set;}
	public List<Order__c> listOrders{get;set;}
	public String selectedOrderId {get;Set;}
	public String reasonText {get;Set;}

	public OnsiteCheckedInWithNoResults()
	{
		eventId=ApexPages.currentPage().getParameters().get('event');
		objEvent=[Select Id,Name From WW_Event__c Where Id=:eventId];
		getPeopleCheckedInWithNoResults();
	}
	public void getPeopleCheckedInWithNoResults()
	{
		listOrders= [Select Id,PatientFirstName__c,PatientLastName__c,PatientEmailH__c,Onsite_Card_Code__c,Check_In_Time__c 
					From Order__c where Order_Status__c='Submitted' AND (Reconciliation_Reason__c=null OR Reconciliation_Reason__c='') AND 
					WW_Event__c=:eventId];
	}
    public PageReference saveReasonApex() {
		Order__c o=new Order__c(Id=selectedOrderId,Reconciliation_Reason__c=reasonText);
		update o;
		getPeopleCheckedInWithNoResults();
        return null;
    }
	
	public PageReference cancelOrder()
	{
		if(!String.isBlank(orderId))
		{
			update new Order__c(Id=orderId,Order_Status__c='Cancelled');
		}
		getPeopleCheckedInWithNoResults();
		return null;
	}	
}