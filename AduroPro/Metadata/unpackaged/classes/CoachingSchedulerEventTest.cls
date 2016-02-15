@isTest
private class CoachingSchedulerEventTest {
	static void init()
	{
		Account a=new Account(Name='Ignite Your Life Coaching');
		insert a;
		Account emp= new Account(Name='ABC Test');
		insert emp;
		Contact mentor=new Contact(LastName='Mentor',AccountId=emp.Id);
		insert mentor;
	}
	static testMethod void myUnitTest() {
		init();
		CoachingSchedulerEvent cs=new CoachingSchedulerEvent();
		cs.cancel();
		cs.save();
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
		String tempDates=Date.today().format()+','+Date.today().addDays(1).format();
		CoachingSchedulerEvent.addDate(tempDates);
		CoachingSchedulerEvent.getDates(CoachingSchedulerEvent.OCCURRENCE_ONE_TIME,Date.today().format(),Date.today().format());
		CoachingSchedulerEvent.getDates(CoachingSchedulerEvent.OCCURRENCE_WEEKLY,Date.today().format(),Date.today().format());
		CoachingSchedulerEvent.getDates(CoachingSchedulerEvent.OCCURRENCE_BIMONTHLY,Date.today().format(),Date.today().format());
		CoachingSchedulerEvent.getDates(CoachingSchedulerEvent.OCCURRENCE_MONTHLY,Date.today().format(),Date.today().format());
		cs.getEventTypes();
		cs.getEventOccurrences();
		cs.getCoachingProgramNames();
		cs.getTimeZone();
		cs.saveEventTemplate();
		CoachingSchedulerEvent.getDocument('');
		CoachingSchedulerEvent.getDocuments('aaa');
	}
}