public with sharing class OnsiteConsent {
	public String oId{get;set;}
	public String eventId{get;set;}
	public Order__c objOrder{get;set;}
	public Boolean ConsentNoCompleted{get;set;}
	public Boolean DisplayCheckin{get;set;}
	public Boolean DisplayCardCode{get;set;}
	public String errorMessage{get;set;}
	public String errorMessageStyle {get; private set;}
    private static final String VISIBLE_STYLE = '';
    private static final String INVISIBLE_STYLE = 'display:none;';	
	public OnsiteConsent()
	{
		oId =  ApexPages.currentPage().getParameters().get('oId');
		eventId =  ApexPages.currentPage().getParameters().get('eventId');
		objOrder=[Select 	Onsite_Card_Code__c,Consent_Agree__c,Consent_Disagree__c,Contact__c,Check_In_Time__c From Order__c Where Id=:oId];
		ConsentNoCompleted=true;
		errorMessage='';
		errorMessageStyle=INVISIBLE_STYLE;
		DisplayCheckin=false;
		DisplayCardCode=false;
	}
	public void Agree()
	{
		ConsentNoCompleted=false;
		DisplayCheckin=false;
		DisplayCardCode=true;
	}
	public void Disagree()
	{
		ConsentNoCompleted=false;
		DisplayCheckin=true;
		DisplayCardCode=false;
	     errorMessage='You have elected to not participate in today\'s event.  Please hand the iPad back to the staff.  Thank you.';
	     errorMessageStyle='';	
	     //objOrder.Consent_Disagree__c=DateTime.now();	
	     Contact c=[Select Id,Most_Recent_Onsite_Checkin__c From Contact Where Id=:objOrder.Contact__c];
	     c.Most_Recent_Onsite_Checkin__c=null;
	     update c;
	     delete objOrder;
	}
	public void SubmitCardCode()
	{
		if(String.isBlank(objOrder.Onsite_Card_Code__c))
		{
             errorMessage='Please enter Card Code.';
             errorMessageStyle='';
		}
		else
		{
		     errorMessage='You have elected to participate in today\'s event.  Please hand the iPad back to &nbsp;the staff to continue check-in.';
		     errorMessageStyle='';			
			ConsentNoCompleted=false;
			DisplayCheckin=true;
			DisplayCardCode=false;
			objOrder.Consent_Agree__c=DateTime.now();
			objOrder.Check_In_Time__c=DateTime.now();
			update objOrder;
		}		
	}
   static testMethod void testOnsiteConsent(){
    	Account acct = TestDataGenerator.getOneAccount();
    	Contact contact = TestDataGenerator.getOneContact();
    	WW_Event__c wwevent = TestDataGenerator.getOneEvent();
    	Order__c wworder = TestDataGenerator.getOneOrder();
    	wworder.WW_Event__c = wwevent.Id;
    	wworder.Limeade_Participant_Code__c='123abc';
    	update wworder;
    	Test.startTest();
    	PageReference ref = new PageReference('/apex/OnsiteConsent?oId=' + wworder.Id +'&eventId='+wwevent.Id);
    	Test.setCurrentPage(ref); 
    
    	OnsiteConsent controller = new OnsiteConsent (); 
    	controller.Agree();
    	controller.SubmitCardCode();
    	controller.objOrder.Onsite_Card_Code__c='1234';
    	controller.SubmitCardCode();
    	controller.Disagree();
    	Test.stopTest();
   }		
}