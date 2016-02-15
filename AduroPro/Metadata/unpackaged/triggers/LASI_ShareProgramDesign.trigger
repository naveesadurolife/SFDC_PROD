trigger LASI_ShareProgramDesign on Program__c (before insert, before update, after insert, after update) {
	String ConnectionName = 'Limeade';

	//Map PartnerRecordId to LocalRecordId for all Record Connections
	Map<Id, Id> recordMap = LASI_HelperClass.getRecordMap(ConnectionName);
	
	Id ActiveConnectionId = LASI_HelperClass.getConnectionId(ConnectionName);

	List<PartnerNetworkRecordConnection> newShares = new List<PartnerNetworkRecordConnection>();

	for(Program__c program : Trigger.new){
		if(Trigger.isBefore){
			if(program.Limeade_Account_Id__c <> null){
				program.Account__c = recordMap.get(program.Limeade_Account_Id__c);
			}
		} else { //Trigger.isAfter
			if(LASI_HelperClass.recordShared(program.Account__c, ConnectionName)){
				newShares.add(new PartnerNetworkRecordConnection(
					ConnectionId = ActiveConnectionId,
					LocalRecordId = program.Id,
					ParentRecordId = program.Account__c
					));
			}
		}
	}

	//if there are new records to be shared, insert the record connections.
	if(newShares.size() > 0)
		insert newShares;
}