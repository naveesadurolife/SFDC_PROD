trigger LASI_ShareLead on Lead (after update) {

	
	/*
	* We are in Aduro SFDC, when we updated a Lead and it's status is changed to 
	* Unqualified we must delete the record share.
	*/

	String ConnectionName = 'Limeade';
	
	Id ActiveConnectionId = LASI_HelperClass.getConnectionId(ConnectionName);

	//List for new shared record connections
	List<PartnerNetworkRecordConnection> delShares = new List<PartnerNetworkRecordConnection>();

	for(Lead n : Trigger.new){
		if(n.Status == 'Unqualified' && n.Reason_Unqualified__c == 'Limeade Lead' && LASI_HelperClass.recordShared(n.Id, ConnectionName)){
			delShares.add(LASI_HelperClass.getRecordConnection(n.Id, ConnectionName));
		}
	}

	if(delShares.size() > 0)
		delete delShares;
}