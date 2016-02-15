public with sharing class OnsitePeopleWithResults {
	public string eventId{get;set;}
	public string orderId{get;set;}
	public WW_Event__c objEvent{get;set;}
	public List<Order__c> listOrders{get;set;}
	public OnsitePeopleWithResults()
	{
		eventId=ApexPages.currentPage().getParameters().get('event');
		objEvent=[Select Id,Name,Program__r.Screening_HRA__c From WW_Event__c Where Id=:eventId];
		getPeopleCheckedInWithResults();
	}
	public void getPeopleCheckedInWithResults()
	{
		listOrders= [Select Id,PatientFirstName__c,PatientLastName__c,PatientEmailH__c,Onsite_Card_Code__c,Check_In_Time__c From Order__c where (Order_Status__c='Received' OR Order_Status__c='Sent Limeade') AND WW_Event__c=:eventId];
	}
    @RemoteAction
    public static List<String> getConciergeOptions()
    {
    	List<String> listConciergeOptions=new List<String>();
	   Schema.DescribeFieldResult fieldResult = Order__c.Concierge__c.getDescribe();
	   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	   for( Schema.PicklistEntry f : ple)
	   {
	      listConciergeOptions.add(f.getValue());
	   }
	   return listConciergeOptions;     	
    }	
    @RemoteAction
    public static String updateConcierge(String oid,String concierge)
    {
    	String result='';
    	try
    	{
	    	Order__c o=new Order__c(Id=oid,Concierge__c=concierge);
	    	update o;
	    	result='success';
    	}
    	catch(Exception ex)
    	{
    		result='Error Occured:'+ex.getMessage();
    	}
    	return result;
    }
}