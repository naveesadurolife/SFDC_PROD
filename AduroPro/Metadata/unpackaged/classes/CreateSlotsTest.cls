@isTest
private class CreateSlotsTest {

    static testMethod void testCreateSlots() {
    	Account acct = TestDataGenerator.getOneAccount();
    	Contact contact = TestDataGenerator.getOneContact();
    	WW_Event__c wwevent = TestDataGenerator.getOneEvent();
    	wwevent.Start_Time__c='6:30 AM';
    	wwevent.End_Time__c='12:30 PM';
    	wwevent.Appt_Per_Slot__c=4;
    	wwevent.Time_Frame_Per_Slot__c='15';
    	wwevent.Event_Date__c=null;
    	wwevent.Validate_Contacts_Against_Limeade__c=true;
    	update wwevent;
    	Test.setCurrentPage(Page.CreateSlots);
    	ApexPages.StandardController sc = new ApexPages.standardController(wwevent);
    	CreateSlots cs = new CreateSlots(sc);
    	cs.init();
    	wwevent.Event_Date__c=Date.today().addDays(1);
    	wwevent.Event_Status__c='Confirmed';
    	update wwevent;
    	cs.init();
    	cs.save();
    	///////////////
    	EventURLs eu=new EventURLs();
    	eu.getEvents();
    	eu.getEventURL();
    	//////
    	Test.setCurrentPage(Page.EventRegister);
    	Apexpages.currentPage().getParameters().put('id',wwevent.Id);
    	EventRegister er=new EventRegister();
    	List<EventRegister.SlotsWrapper> sw=er.getEvents();
    	///////////////
    	Test.setCurrentPage(Page.EventRegisterStep2);
    	Apexpages.currentPage().getParameters().put('eid',wwevent.Id);
    	Apexpages.currentPage().getParameters().put('sid',sw[0].listSlots[0].Id);
    	String sid=sw[0].listSlots[0].Id;
    	EventRegisterStep2 ers=new EventRegisterStep2();   
    	ers.save();
    	ers.s.First_Name__c='fname';
    	ers.s.Last_Name__c='lname';
    	ers.dateOfBirth='10/10/1990';
    	ers.s.Email__c='test@adurolife.com';
    	ers.agreement=true;
    	ers.save(); 
    	//////
    	Test.setCurrentPage(Page.EventRegisterForgotEmail);
    	Apexpages.currentPage().getParameters().put('eid',wwevent.Id);
    	EventRegisterForgotEmail erfe=new EventRegisterForgotEmail();
    	erfe.SearchEmail();
    	erfe.searchEmail='test@adurolife.com';
    	erfe.SearchEmail();
    	///////////////    	
    	Test.setCurrentPage(Page.EventRegister);
    	Apexpages.currentPage().getParameters().put('id',wwevent.Id);
    	Apexpages.currentPage().getParameters().put('sid',sid);
    	EventRegister er1=new EventRegister();
    	List<EventRegister.SlotsWrapper> sw1=er1.getEvents();
    	///////////////   
    	Test.setCurrentPage(Page.EventRegisterStep2);
    	Apexpages.currentPage().getParameters().put('eid',wwevent.Id);
    	Apexpages.currentPage().getParameters().put('osid',sw[0].listSlots[0].Id);
    	Apexpages.currentPage().getParameters().put('sid',sw[0].listSlots[1].Id);
    	String sid1=sw[0].listSlots[1].Id;
    	EventRegisterStep2 ers1=new EventRegisterStep2();   
    	ers1.save();
    	ers1.s.First_Name__c='fname'; 
    	ers1.s.Last_Name__c='lname';
    	ers1.dateOfBirth='10/10/1990';
    	ers1.s.Email__c='test1@adurolife.com';
    	ers1.agreement=true;
    	ers1.save();
    	 
        JobSendEventReminder batch = new JobSendEventReminder(); 
        Id batchId = Database.executeBatch(batch,1); 
            	
    	Slot__c s=[Select Id,Email__c From Slot__c Where Id=:ers1.s.Id];
    	System.debug('s.Email__c===================='+s.Email__c);
    	////////////////////////////////
    	EventSendEmail ese=new EventSendEmail();
    	Test.setCurrentPage(Page.EventSendEmail);
    	Apexpages.currentPage().getParameters().put('id',wwevent.Id);    	
    	ese=new EventSendEmail();
		ese.sendEmail(); 
		ese.wwEvent.Event_Email_Subject__c='test';
		ese.wwEvent.Event_Email_Body__c='test';   
		for(Slot__c s1:ese.wwEvent.Slots__r)
		{
			s1.Slot_Selected__c=true;
		}
		ese.sendEmail(); 
		ese.cancel();	
		EventRegisterDeleteEmail erd=new EventRegisterDeleteEmail();
		erd.searchEmail();
		erd.searchEmail='test1@adurolife.com';
		erd.searchEmail();
		
    	/////////////////////////////////////////
    	SlotTriggerHandler.RecreateSlot=true;
    	//JobSendEventReminder jser=new JobSendEventReminder();
    	//List<sObject> scope=new List<sObject>();
    	//scope.add(s);
    	//jser.execute(null, scope);
      	
    	delete s;
    	//////  
     	  	 		
    	
    }
}