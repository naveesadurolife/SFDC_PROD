public with sharing class OnsiteParticipantSurvey{
	public string eventId{get;set;}
	public string orderId{get;set;}
	public string selectedScreeningExperience{get;set;}
	public WW_Event__c objEvent{get;set;}
	public List<Order__c> listOrders{get;set;}
	public OnsiteParticipantSurvey()
	{
		eventId=ApexPages.currentPage().getParameters().get('event');
		objEvent=[Select Id,Name,Program__r.Screening_HRA__c From WW_Event__c Where Id=:eventId];
		getPeopleCheckedInWithResults();
	}
	public void getPeopleCheckedInWithResults()
	{
		listOrders= [Select Id,PatientFirstName__c,PatientLastName__c,PatientEmailH__c,Onsite_Card_Code__c,Check_In_Time__c,EmployeeID__c,ProgramID__r.Account__r.Name,Screening_Experience__c,Screening_Experience_Comment__c From Order__c where (Order_Status__c='Received' OR Order_Status__c='Sent Limeade') AND WW_Event__c=:eventId AND Screening_Experience__c=null];
	}
    @RemoteAction
    public static String updateSurvey(String oid,String survey,String comment)
    {
    	String result='';
    	try
    	{
	    	Order__c o=new Order__c(Id=oid,Screening_Experience__c=survey,Screening_Experience_Comment__c=comment);
	    	update o;
	    	result='success';
    	}
    	catch(Exception ex)
    	{
    		result='Error Occured:'+ex.getMessage();
    	}
    	return result;
    }
    public List<SelectOption> getScreeningExperience() {
        List<SelectOption> options = new List<SelectOption>(); 
		options.add(new SelectOption('','Please Select')); 
        options.add(new SelectOption('1','1 Worst')); 
        options.add(new SelectOption('2','2')); 
        options.add(new SelectOption('3','3')); 
		options.add(new SelectOption('4','4')); 
        options.add(new SelectOption('5','5 Best')); 
		return options; 
    }	
}