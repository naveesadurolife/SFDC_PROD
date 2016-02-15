global with sharing class JobCoachingSchedulerEmail implements Schedulable,Database.Batchable<Sobject>{
	/*
	system.schedule('JobCoachingSchedulerEmail1', '0 5 * * * ?', new JobCoachingSchedulerEmail());
	system.schedule('JobCoachingSchedulerEmail2', '0 20 * * * ?', new JobCoachingSchedulerEmail()); 
	system.schedule('JobCoachingSchedulerEmail3', '0 35 * * * ?', new JobCoachingSchedulerEmail());
	system.schedule('JobCoachingSchedulerEmail4', '0 50 * * * ?', new JobCoachingSchedulerEmail());	
	*/	
    global void execute(SchedulableContext SC) {
        JobCoachingSchedulerEmail batch = new JobCoachingSchedulerEmail(); 
        Id batchId = Database.executeBatch(batch,50);   
    }    
     global Database.QueryLocator start(Database.BatchableContext info){ 
		 DateTime currentDT=Datetime.now();
		 Datetime oneHourBefore=currentDT.addHours(1);
		 Date sevenDaysBefore=currentDT.addDays(7).date();
		 Date oneDayBefore=currentDT.addDays(1).date();
		 Datetime oneHourAfter=currentDT;//.addHours(1);
		 String query='Select Id,Start_Date__c,End_Date__c,WW_Event__r.Event_Date__c,One_Hour_Reminder_Sent__c,One_Day_Reminder_Sent__c,Seven_Day_Reminder_Sent__c,Followup_Email_Sent__c From Slot__c ';
		 query+='Where WW_Event__r.Event_Status__c=\'Confirmed\' AND WW_Event__r.Coaching_Event_Number__c!=null ';
		 query+=' AND Status__c=\'Active\' ';
		 query+=' AND ((Start_Date__c<=:oneHourBefore AND One_Hour_Reminder_Sent__c=false)';//one hour
		 query+=' OR (WW_Event__r.Event_Date__c=:oneDayBefore AND One_Day_Reminder_Sent__c=false)';//one day
		 query+=' OR (WW_Event__r.Event_Date__c=:sevenDaysBefore AND Seven_Day_Reminder_Sent__c=false)';//seven day
		 query+=' OR (End_Date__c<=:oneHourAfter AND Followup_Email_Sent__c=false) )';//one hour after
		// query+=' AND Id=\'a0Hn0000001KvTf\' ';
		 return Database.getQueryLocator(query); 
	 }
	 global void execute(Database.BatchableContext BC, List<Slot__c> listSlots){
		 if(listSlots!=null && listSlots.size()>0)
		 {
			 DateTime currentDT=Datetime.now();
			 Datetime oneHourBefore=currentDT.addHours(1);
			 Date sevenDaysBefore=currentDT.addDays(7).date();
			 Date oneDayBefore=currentDT.addDays(1).date();
			 Datetime oneHourAfter=currentDT.addHours(1);			 
		 	for(Slot__c s:listSlots)
			 {
			 	if(!s.One_Hour_Reminder_Sent__c && s.Start_Date__c<=oneHourBefore && s.End_Date__c>oneHourBefore)
				 {
				 	s.One_Hour_Reminder_Sent__c=true;
				 }
			 	if(!s.One_Day_Reminder_Sent__c && s.WW_Event__r.Event_Date__c==oneDayBefore)
				 {
				 	s.One_Day_Reminder_Sent__c=true;
				 }
			 	if(!s.Seven_Day_Reminder_Sent__c && s.WW_Event__r.Event_Date__c==sevenDaysBefore)
				 {
				 	s.Seven_Day_Reminder_Sent__c=true;
				 }
			 	if(!s.Followup_Email_Sent__c && s.End_Date__c<=oneHourAfter)
				 {
				 	s.Followup_Email_Sent__c=true;
				 }					 
			 }
			 update listSlots;
		 }
	 }
	global void finish(Database.BatchableContext BC){} 
}