trigger LASI_ShareOpportunity on Opportunity (before insert, before update, after insert, after update) {
	
	/*
	* We are in Aduro SFDC, when we create an opportunity we will lookup 
	* Limeade_Account_Id__c against the PartnerNetworkRecordConnection and 
	* update "AccountId" to the LocalRecordId.
	*/

	String ConnectionName = 'Limeade';

	List<String> HandoffFields =  new String[]{
	'Additional_Notes__c',
	'Additional_Products__c',
	'Biometric_Detail__c',
	'Browsers_OS__c',
	'Coaching_Detail__c',
	'Company_Culture__c',
	'Culture_Training__c',
	'Customer_Resources__c',
	'Customizations__c',
	'Demographics__c',
	'Device_Challenges__c',
	'Devices__c',
	'Employee_Designation__c',
	'Est_Launch_Date__c',
	'Existing_Program_Info__c',
	'Incentive_Design__c',
	'Integration_Needs__c',
	'International__c',
	'Key_File_Attachments_for_Review__c',
	'Key_Milestones_Agreed_To__c',
	'Limeade_Strengths__c',
	'Marketing_Assets__c',
	'Outcomes_Detail__c',
	'Pain_Points__c',
	'Program_Name__c',
	'Regulatory__c',
	'Reporting__c',
	'Risks__c',
	'SSO__c',
	'Who_is_Eligible__c'};
	
	List<Sales_to_Service__c> ExistingSales2Services = new List<Sales_to_Service__c>();
	
	if(trigger.isAfter){
		String Query = 'SELECT Id,Account__c,Opportunity__c,';

		for(String field : HandoffFields){
			Query += field+',';
		}

		Query = Query.substring(0, (Query.length()-1));
		Set<Id> oppset = Trigger.newMap.KeySet();
		Query += ' FROM Sales_to_Service__c WHERE Opportunity__c IN :oppset';		
		System.debug(Query);
		ExistingSales2Services = Database.Query(Query);
	}
	Map<Id, Sales_to_Service__c> s2sMap = new Map<Id, Sales_to_Service__c>();

	for(Sales_to_Service__c s2s : ExistingSales2Services){
		s2sMap.put(s2s.Opportunity__c, s2s);
	}

	List<Sales_to_Service__c> newSales2Services = new List<Sales_to_Service__c>();
	
	List<Sales_to_Service__c> updatedSales2Services = new List<Sales_to_Service__c>();

	//Map PartnerRecordId to LocalRecordId for all Record Connections
	Map<Id, Id> recordMap = LASI_HelperClass.getRecordMap(ConnectionName);
	
	Id ActiveConnectionId = LASI_HelperClass.getConnectionId(ConnectionName);
	
	Id standardPricebookId = [SELECT Id from Pricebook2 WHERE IsStandard = True LIMIT 1].Id;
	List<Account> updatedAccounts = new List<Account>();
	Set<Id> oppsToUpdate = new Set<Id>();
	for(Opportunity n : trigger.new){
		if(trigger.isBefore){
/*
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String Body = 'AccountId = '+n.AccountId+'\n\n';
				Body += 'Limeade_Account_Id__c = '+n.Limeade_Account_Id__c;
				mail.setHTMLBody(Body);
				mail.SetToAddresses(new String[] {'aflint@stratusg.com'});
				Messaging.sendEmail(new Messaging.Email[] { mail });
*/
			if(trigger.isInsert && n.Limeade_Account_Id__c <> null && n.Pricebook2Id == null)
				n.Pricebook2Id = standardPricebookId;
				
			if(n.Limeade_Account_Id__c <> null && recordMap <> null && recordMap.containsKey(n.Limeade_Account_Id__c)){
				n.AccountId = recordMap.get(n.Limeade_Account_Id__c);
			} else if(n.Limeade_Account_Id__c <> null && recordMap <> null && !recordMap.containsKey(n.Limeade_Account_Id__c)){
				oppsToUpdate.add(n.Id);
			}
		} else  { //Trigger.isAfter
			if(s2sMap.containsKey(n.Id)){
				Sales_to_Service__c s2s = s2sMap.get(n.Id);
				boolean updated = false;
				for(String field : HandoffFields){
					if(s2s.get(field) <> n.get(field)){
						s2s.put(field, n.get(field));
						updated = true;
					}
				}
				if(updated)
					updatedSales2Services.add(s2s);
			} else {
				Boolean Sales2Service = false;
				for(String field : HandoffFields){
					Sales2Service = (n.get(field) != null);
					if(Sales2Service)
						break;
				}
				if(Sales2Service){
					Sales_to_Service__c s2s = new Sales_to_Service__c();
					for(String field : HandoffFields){
						s2s.put(field, n.get(field));
					}
					s2s.Opportunity__c = n.Id;
					s2s.Account__c = n.AccountId;
					newSales2Services.add(s2s);
				}
			}
		}
	}

	if(newSales2Services.Size() > 0)
		insert newSales2Services;

	if(updatedSales2Services.Size() > 0)
		update updatedSales2Services;
/*
	if(oppsToUpdate.size() > 0){
		LASI_ScheduleOppUpdate opps = new LASI_ScheduleOppUpdate(oppsToUpdate);
		DateTime scheduledtime = System.Now().addSeconds(30);
		String year = String.valueOf(scheduledtime.Year());
		String Month = String.valueOf(scheduledtime.Month());
		String Day = String.valueOf(scheduledtime.Day());
		String Hour = String.valueOf(scheduledtime.Hour());
		String Min = String.valueOf(scheduledtime.Minute());
		String Sec = String.valueOf(scheduledtime.Second());
		String sch = sec+' '+min+' '+Hour+' '+Day+' '+Month+' ? '+year;
		String JobName = 'LASI Opp Update '+UserInfo.getUserId()+' '+System.now()+' ';
		Integer i = [SELECT Count() FROM CronJobDetail WHERE Name like: JobName+'%'];
		JobName += (i+1);
		System.schedule(JobName, sch, opps);
	}
*/
}