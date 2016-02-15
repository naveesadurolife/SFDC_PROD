@isTest
private class CoachingEventTest {
	public static Program__c currentYearProgram;
	static void init()
	{
		Account a=new Account(Name='Ignite Your Life Coaching');
		insert a;
		Account emp= new Account(Name='ABC Test');
		insert emp;
		Contact mentor=new Contact(LastName='Mentor',AccountId=emp.Id);
		insert mentor;
		currentYearProgram=TestDataGenerator.getOneProgram();
		currentYearProgram.Program_Start_Date__c=Date.newInstance(Date.today().year(), 1, 1);
		currentYearProgram.Program_End_Date__c=Date.newInstance(Date.today().year(), 12, 31);
		currentYearProgram.Program_Status__c='Active';
		currentYearProgram.Limeade_Live_Date__c=Date.today();
		currentYearProgram.Program_Manager__c=Userinfo.getUserId();
		currentYearProgram.Biometric_Completion_Incentive_Id__c='1234';
		currentYearProgram.Limeade_E_Id__c='psk';
		currentYearProgram.Limeade_PSK_ID__c='psk';
		currentYearProgram.Coaching_Program_Name__c='Mission Nutrition';
		currentYearProgram.Coaching_Event_Type__c='Hot Topics';
		update currentYearProgram;
	}
	static testMethod void myUnitTest() {
		init();
		CoachingSchedulerEvent cs=new CoachingSchedulerEvent();
		cs.selectedTimeZone='PST';
		cs.selectedCoachingProgramName='Mission Nutrition';
		cs.selectedEventType='Hot Topics';
		cs.selectedOccurrence='One Time';
		cs.eventStart.Event_Date__c=Date.today();
		cs.eventEnd.Event_Date__c=Date.today();
		cs.eventStart.Start_Time__c='7:00 AM';
		cs.eventStart.End_Time__c='8:00 AM';
		cs.selectedEventDates=Date.today().format();
		cs.eventStart.Coaching_Welcome_Email__c='welcome';
		cs.eventStart.Access_Code__c='123';
		cs.eventPhoneNumber='1234567890';
		cs.eventURL='adurolife.com';
		cs.eventStart.Post_Event_Survey_Link__c='adurolife.com';
		cs.eventStart.X6_Week_Engagement_Goal_Type__c='aaaa';
		cs.eventStart.X6_Week_Engagement_Modality__c='ddddd';		
		cs.save();
		////////////////
		CoachingEvent ce=new CoachingEvent();
    	pageReference pageRef = new pageReference('/apex/CoachingEvent');
    	Test.setCurrentPage(pageRef);
    	ApexPages.currentPage().getParameters().put('p', 'psk');
		ce=new CoachingEvent();
		ce.getEvents();
		ce.cancelRegistration();
		ce.cancelSelected();
		/////////////////////////
		CoachingEventCheckin cec=new CoachingEventCheckin();
    	pageReference pageRef1 = new pageReference('/apex/CoachingEventCheckin');
    	Test.setCurrentPage(pageRef1);
    	ApexPages.currentPage().getParameters().put('p', 'psk');
		ApexPages.currentPage().getParameters().put('e', ce.listEventTypeWrapper[0].listCoachingProgramWrapper[0].eventId);
		cec=new CoachingEventCheckin();		
		cec.register();
		cec.firstname='firstname';
		cec.lastname='lastname';
		cec.email='noemail@example.com';
		cec.register();
		
		currentYearProgram.Validate_Coaching_Scheduler_Slot__c=true;
		currentYearProgram.Limeade_Identifier_DOB__c=true;
		currentYearProgram.Limeade_Identifier_Employee_ID__c=true;
		update currentYearProgram;
		cec=new CoachingEventCheckin();	
		cec.register();
		cec.firstname='firstname';
		cec.lastname='lastname';
		cec.email='noemail@example.com';		
		cec.dob=Date.today().format();
		cec.empId='123';
		cec.register();
	}
}