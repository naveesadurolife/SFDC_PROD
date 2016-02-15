trigger LASI_ShareContact on Contact (before insert, before update) {
	

	String ConnectionName = 'Limeade';

	//Map PartnerRecordId to LocalRecordId for all Record Connections
	Map<Id, Id> recordMap = LASI_HelperClass.getRecordMap(ConnectionName);
	
	for(Contact c : Trigger.new){
		if(c.Limeade_Account_Id__c <> null){
			c.AccountId = recordMap.get(c.Limeade_Account_Id__c);
		}
	}
}