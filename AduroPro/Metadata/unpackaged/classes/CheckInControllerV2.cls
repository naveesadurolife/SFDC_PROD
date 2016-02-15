global class CheckInControllerV2 {

	public List<Contact> checkinList {get; private set;} 

    public String eventid {get; private set;}
    public String selectedContactId {get; set;}
    public String cardCode {get; set;}
    public String checkinMessage {get; private set;}
    private static final String VISIBLE_STYLE = '';
    private static final String INVISIBLE_STYLE = 'display:none;';
    public String errorMessageStyle {get; private set;}    
    public String searchString {get; set;}
    
    public List<string> alphabet{get;set;}
    
    private String filter = '';
    
    public WW_Event__c event {get;set;}
    
    private void changeErrorMessageVisibility(Boolean show) {
    	if ( show ) {
    		errorMessageStyle = VISIBLE_STYLE;
    	}else {
    		errorMessageStyle = INVISIBLE_STYLE;
    	}
    }    
    public CheckInControllerV2( ){
    	changeErrorMessageVisibility(false);
    	searchString = '';
    	alphabet=new string[]{'all','a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };  
    	
    	eventid = '';
    	eventid = ApexPages.currentPage().getParameters().get('event');
        getCheckInList();
    }
    
    private void getCheckInList() {
    
    	event = [ SELECT e.Id, e.Name, e.Event_Date__c, e.Start_Time__c, e.End_Time__c, e.Event_Status__c, 
    			  e.Employer__c, e.Program__c,
    				(Select Id,Contact__c From Slots__r where Contact__c!=null order by Contact__r.Name ASC)
                			  FROM WW_Event__c e 
                			  WHERE e.Id = :eventid  ];
       /* Set<Id> slotContactIDs=new Set<Id>();        				
    	if(event.Slots__r.size()>0)
    	{
    		for(Slot__c s:event.Slots__r)
    		{
    			slotContactIDs.add(s.Contact__c);
    		}
    	}*/
    	checkinList = new List<Contact>();
		//Set<Contact> allContacts=new Set<Contact>();
    	 checkinList =[SELECT c.Id, c.Name, c.FirstName, c.LastName, c.AccountId, c.Email, c.Birthdate, c.Employee_ID__c,
    						Appointment_Time__c,Event__c
                			FROM Contact c 
                			WHERE  ((c.AccountId = :event.Employer__c AND c.Most_Recent_Onsite_Checkin__c != :eventid AND Event__c=null) OR 
                			(Event__c=:eventid AND Most_Recent_Onsite_Checkin__c != :eventid)) AND RecordType.DeveloperName='Participants' order by Appointment_Time__c asc NULLS LAST LIMIT 200];
   		/*for(Id conId:slotContactIDs)
   		{
   			if(checkinMap.containsKey(conId))
   			{
   				allContacts.add(checkinMap.remove(conId));
   			}
   		}
   		allContacts.addAll(checkinMap.values());
    	checkinList.addAll(allContacts);*/
    }
    
    public PageReference filterList() {
    	
    	filter =  ApexPages.currentPage().getParameters().get('filter');
    	
    	if (null == filter || filter == 'all' || filter == '') {
    		getCheckInList();
    	}else {
    		getCheckInListFiltered();
    	}
    	
    	return null;
    }
    
    private void getCheckInListFiltered(){
    	String filterAndWildcard = filter + '%';
    		
		checkinList = [   SELECT c.Id, c.Name, c.FirstName, c.LastName, c.AccountId, c.Email, c.Birthdate, c.Employee_ID__c,Appointment_Time__c,Event__c
            			FROM Contact c 
            			WHERE  c.AccountId = :event.Employer__c  AND RecordType.DeveloperName='Participants'
            			    AND c.Most_Recent_Onsite_Checkin__c != :eventid
            				AND c.Name LIKE :filterAndWildcard AND ((c.AccountId = :event.Employer__c AND c.Most_Recent_Onsite_Checkin__c != :eventid AND Event__c=null) OR 
            				(Event__c=:eventid AND Most_Recent_Onsite_Checkin__c != :eventid) ) order by Appointment_Time__c asc NULLS LAST LIMIT 200];
    }
    
    public PageReference searchForEmployee() {
    	
    	filter =  ApexPages.currentPage().getParameters().get('filter');
    	
    	if (null == searchString ||  searchString == '') {
    		getCheckInList();
    	}else {
    		String filterAndWildcard = '%' + searchString + '%';
    		
    		checkinList = [   SELECT c.Id, c.Name, c.FirstName, c.LastName, c.AccountId, c.Email, c.Birthdate, c.Employee_ID__c,Appointment_Time__c,Event__c
                			FROM Contact c 
                			WHERE  c.AccountId = :event.Employer__c  AND RecordType.DeveloperName='Participants'
                			    AND c.Most_Recent_Onsite_Checkin__c != :eventid
                				AND c.Name LIKE :filterAndWildcard LIMIT 200];
    	}
    	
    	return null;
    }
    
        
    public PageReference checkInNow(){
        changeErrorMessageVisibility(false);
        eventid = ApexPages.currentPage().getParameters().get('event');
   		Program__c prog = [ SELECT 	p.Id, p.Name, p.Program_End_Date__c, p.Limeade_E_Id__c,
							p.Limeade_Identifier_Employee_ID__c, p.Limeade_Identifier_DOB__c,
							p.Limeade_Identifier_Email__c, p.Limeade_Identifier_LastName__c,
							p.Program_Start_Date__c, p.Enable__c, p.Limeade_PSK_ID__c,
							p.Activity_Device_Note_to_User__c, p.Disable_Limeade_SFDC_Validations__c,
							p.Special_Order_Instructions__c, FitBit_Show_Employee_Info_Field__c 
						   FROM Program__c p
						   WHERE p.Id  = :event.Program__c LIMIT 1];             
    	checkinMessage = '';
    	Order__c tempOrder;
    	try
    	{
    		tempOrder=[select id from order__c where ProgramID__c=:prog.Id and Onsite_Card_Code__c=: cardCode and EmployeeID__c!=:selectedContactId AND WW_Event__c=:event.Id limit 1];
    	}
    	catch(Exception ex)
    	{
    	}
    	if(tempOrder!=null)
    	{
    		changeErrorMessageVisibility(true);
    		checkinMessage='Please enter unique Card Code.';
    		return null;
    	}
    	//String contactid =  ApexPages.currentPage().getParameters().get('contactid');
    	//String cardcode =  ApexPages.currentPage().getParameters().get('cardcode');
    	
    	if (selectedContactId != null && selectedContactId != '') {
    		
    		//get reference to the contact:
    		Contact sourceContact = [    SELECT c.Id, c.Name, c.FirstName, c.LastName, c.AccountId, c.Email, c.Birthdate, c.Employee_ID__c, c.Sex__c, c.Phone,Appointment_Time__c,Event__c
                			FROM Contact c 
                			WHERE  c.Id = :selectedContactId LIMIT 1 ];
                			
            //verify that this person has not checked in before: 
            Order__c[] priorOrders = [    SELECT o.Id,  o.WW_Event__c, o.PatientEmailH__c, o.PatientFirstName__c,
            									 o.PatientLastName__c,  o.Order_Status__c, o.Onsite_Card_Code__c
                			FROM Order__c o 
                			WHERE (o.WW_Event__c = :event.Id AND
                				  o.PatientEmailH__c = :sourceContact.Email) LIMIT 1];
                			 
            if ( priorOrders.size() > 0) {
            	checkinMessage =  sourceContact.Name + ' has already checked in.';
            	changeErrorMessageVisibility(true);
            	return null;
            }
            
    		
    		Order__c newOrder = new Order__c();
    		newOrder.PatientFirstName__c = sourceContact.FirstName;
    		newOrder.PatientLastName__c = sourceContact.LastName;
    		newOrder.PatientEmailH__c = sourceContact.Email;
    		newOrder.PatientPrimaryPhone__c = sourceContact.Phone;
    		newOrder.PatientDOB__c = sourceContact.Birthdate;
    		newOrder.PatientGender__c = sourceContact.Sex__c;
    		newOrder.EmployeeID__c = sourceContact.Employee_ID__c;
    		newOrder.WW_Event__c = event.Id;
    		newOrder.ProgramID__c = event.Program__c;
    		newOrder.Order_Type__c = 'Onsite Test';
    		newOrder.Order_Status__c = 'Submitted';
    		newOrder.Onsite_Card_Code__c = cardCode;
    		newOrder.Contact__c = sourceContact.Id;
    		//because we used a contact to create the order, we don't want a contact created this time
    		newOrder.Dont_Create_Contact__c = true;
    		newOrder.Appointment_Time__c=sourceContact.Appointment_Time__c;
    		sourceContact.Most_Recent_Onsite_Checkin__c = eventid;
    		newOrder.Check_In_Time__c=DateTime.now();
////////////////////
	     		String errors='';
	 			//Program__c prog=new Program__c(Limeade_Identifier_Employee_ID__c=o.ProgramID__r.Limeade_Identifier_Employee_ID__c,Limeade_E_Id__c=o.ProgramID__r.Limeade_E_Id__c,Limeade_PSK_ID__c=o.ProgramID__r.Limeade_PSK_ID__c,Limeade_Identifier_LastName__c=o.ProgramID__r.Limeade_Identifier_LastName__c,Limeade_Identifier_DOB__c=o.ProgramID__r.Limeade_Identifier_DOB__c,Limeade_Identifier_Email__c=o.ProgramID__r.Limeade_Identifier_Email__c);													
				errors = LimeadeOrderValidator.validateLimeadeSecondaryCredentials(newOrder, prog);
				//if(Test.isRunningTest())
				//{
				//	errors='';
				//}
				if(String.isBlank(errors))
				{
		    		try {
		    			insert newOrder;
		    			update sourceContact;
		    			//PageReference pr=Page.OnsiteConsent;
		    			//pr.setRedirect(true);
		    			//pr.getParameters().put('oId',newOrder.Id);
		    			//pr.getParameters().put('eventId',eventid);
		    			checkinMessage= sourceContact.Name+' was successfully checked in';
		    			changeErrorMessageVisibility(true);
		    			 getCheckInList();
		    			return null;
		    			
		    			/*checkinMessage = 'You have successfully Checked In ' + sourceContact.Name;
						
						if (filter == '' || filter == null) {
							getCheckInList();
						}else {
							getCheckInListFiltered();
						}*/
		    			
		    		} catch (Exception e){
		    			checkinMessage = 'Could not Check In ' + sourceContact.Name + ' Please quote this error:\n\n' + e;
		    			changeErrorMessageVisibility(true);
		    		}					
				}
				else
				{
					PageReference pr=Page.OnsiteNewOrder;
					pr.setRedirect(true);
					pr.getParameters().put('cId',sourceContact.Id);
					pr.getParameters().put('cc',cardCode);
					pr.getParameters().put('event',eventid);
					pr.getParameters().put('program',event.Program__c);
					return pr;
				}  
///////////////////////////    		   
	
    		
    	} else {
    		checkinMessage = 'Could not perform the Check In. Please quote this error:\n\n' + 'contact parameter not supplied';
    		changeErrorMessageVisibility(true);
    	}
		return null;
    }
    
    
    
    public PageReference newOrder(){
    	return new PageReference('/apex/OnsiteNewOrder?event=' + event.Id + '&program=' + event.Program__c);
    }
    
    /*static testMethod void testCheckInController(){
    	Account acct = TestDataGenerator.getOneAccount();
    	Contact contact = TestDataGenerator.getOneContact();
    	WW_Event__c wwevent = TestDataGenerator.getOneEvent();
    	System.debug('wwevent.Id=========='+wwevent.Id);
    	PageReference ref = new PageReference('/apex/CheckIn?event=' + wwevent.Id );
    	Test.setCurrentPage(ref); 
    
    	CheckInControllerV2 controller = new CheckInControllerV2 (); 
    	
    	ref = new PageReference('/apex/CheckIn?event='+wwevent.Id+'&contactid=' + contact.Id );
    	Test.setCurrentPage(ref); 
    	controller.selectedContactId=contact.Id;
    	controller.checkInNow();
    	controller.checkInNow(); //test a dupe checkin
    	
    	//finds nothing
    	controller.searchForEmployee();
    	controller.searchString = 'casp';
    	controller.searchForEmployee();
   	
    	ref = new PageReference('/apex/CheckIn?event='+wwevent.Id+'&contactid=' );
    	Test.setCurrentPage(ref); 
    	controller.selectedContactId=contact.Id;
    	controller.checkInNow();
    	
    	ref = new PageReference('/apex/CheckIn?event='+wwevent.Id+'&filter=all' );
    	Test.setCurrentPage(ref); 
    	controller.filterList();
    	
    	ref = new PageReference('/apex/CheckIn?event='+wwevent.Id+'&filter=b' );
    	Test.setCurrentPage(ref); 
    	controller.filterList();
    	
    	controller.newOrder();
    	
    }*/

}