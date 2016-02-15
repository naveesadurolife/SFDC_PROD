global class LASI_BatchShareContacts implements Database.Stateful, Database.Batchable<sObject>, Schedulable {
	
/*
LASI_BatchShareContacts m = new LASI_BatchShareContacts();
String sch = '0 0 * * * ?';
System.Schedule('LASI_BatchShareContacts', sch, m);
*/

	global void execute(SchedulableContext sc){
		Database.ExecuteBatch(new LASI_BatchShareContactRole());
	}

	String query;
	
	String ConnectionName = 'Limeade';
	Map<Id, Id> recordMap =  LASI_HelperClass.getRecordMap(ConnectionName);
	Set<Id> LocalRecordIds = LASI_HelperClass.getLocalSharedIds(ConnectionName);
	List<CronTrigger> triggers =  [SELECT PreviousFireTime FROM CronTrigger WHERE CronJobDetailId IN (SELECT Id FROM CronJobDetail WHERE Name = 'LASI_BatchShareContacts')];
	DateTime lastFire;
	
	global LASI_BatchShareContacts() {
		query = 'SELECT Id, ContactId, OpportunityId, Role FROM OpportunityContactRole WHERE OpportunityId IN: LocalRecordIds';
		if(triggers.size() == 1 && triggers[0].PreviousFireTime <> null){
			lastFire = triggers[0].PreviousFireTime;
			query += ' AND SystemModStamp >=: lastFire';
		}
		if(Test.isRunningTest())
			query += ' LIMIT 200';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('Query = '+query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		
		List<PartnerNetworkRecordConnection> newAccShares = new List<PartnerNetworkRecordConnection>();
		List<PartnerNetworkRecordConnection> newConShares = new List<PartnerNetworkRecordConnection>();


		Set<Id> contactIds = new Set<Id>();
		for(sObject o : scope){
			OpportunityContactRole ocr = (OpportunityContactRole) o;
			contactIds.add(ocr.ContactId);
		}
		
		Map<Id, Contact> CurrentContactMap = new Map<Id, Contact>([SELECT Id, AccountId FROM Contact WHERE Id IN: contactIds]);

		Id ActiveConnectionId = LASI_HelperClass.getConnectionId(ConnectionName);

		for(sObject o : scope){
			OpportunityContactRole ocr = (OpportunityContactRole) o;
			Id AccountId = CurrentContactMap.get(ocr.ContactId).AccountId;
			System.debug(ocr.ContactId);
			System.debug(AccountId);
			if(AccountId <> null && !LASI_HelperClass.recordShared(AccountId, ConnectionName)){
				newAccShares.add(new PartnerNetworkRecordConnection(
					ConnectionId = ActiveConnectionId,
					LocalRecordId = AccountId));
			}
			if(!LASI_HelperClass.recordShared(ocr.ContactId, ConnectionName)){
				newConShares.add(new PartnerNetworkRecordConnection(
					ConnectionId = ActiveConnectionId,
					LocalRecordId = ocr.ContactId
					//,ParentRecordId = AccountId
					));
			}
		}

		system.debug(newAccShares);
		if(newAccShares.Size() > 0)
			insert newAccShares;

		system.debug(newConShares);
		if(newConShares.Size() > 0)
			insert newConShares;
	}
	
	global void finish(Database.BatchableContext BC) {
		if(!Test.isRunningTest())
			Database.ExecuteBatch(new LASI_BatchShareContactRole());
	}
	
}