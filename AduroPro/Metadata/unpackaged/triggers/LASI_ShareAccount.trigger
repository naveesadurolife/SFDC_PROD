trigger LASI_ShareAccount on Account (before update) {

	/*
	* We are in Aduro SFDC...
	*/

	String ConnectionName = 'Limeade';
	
	Id ActiveConnectionId = LASI_HelperClass.getConnectionId(ConnectionName);

	//List for new shared record connections
	List<PartnerNetworkRecordConnection> delShares = new List<PartnerNetworkRecordConnection>();
	List<PartnerNetworkRecordConnection> newShares = new List<PartnerNetworkRecordConnection>();

	List<Opportunity> opps = [SELECT Id, StageName, AccountId, Product_Partners__c FROM Opportunity WHERE AccountId IN: Trigger.NewMap.KeySet()];

	List<Opportunity> updatedOpps = new List<Opportunity>();

	for(Account a : Trigger.new){
		Id LimeadeOwnedAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Limeade Owned Account').getRecordTypeId();
		

		//Id EmployerAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employer').getRecordTypeId();
		if(a.RecordTypeId <> LimeadeOwnedAccount && a.Employees_for_Sharing__c >= 5000 && UserInfo.getName() == 'Connection User'){
			boolean contains = false;
			for(Opportunity o : opps){
				if(o.AccountId == a.Id){
					if(o.Product_Partners__c <> null)
						contains = true;
/*
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					String Body = 'Employees_for_Sharing__c = '+a.Employees_for_Sharing__c+'\n\n';
					Body += 'Product_Partners__c = '+o.Product_Partners__c;
					Body += 'RecordTypeId = '+a.RecordTypeId;
					Body += 'LimeadeOwnedAccount = '+LimeadeOwnedAccount;
					mail.setHTMLBody(Body);
					mail.SetToAddresses(new String[] {'aflint@stratusg.com'});
					Messaging.sendEmail(new Messaging.Email[] { mail });
*/
				}
			}
			if(!contains){
				for(Opportunity o : opps){
					if(o.AccountId == a.Id){
						boolean containsOpp = false;
						boolean containsAcc = false;
						for(PartnerNetworkRecordConnection pnrc : delShares){
							if(pnrc.LocalRecordId == o.Id){
								containsOpp = true;
							}
							if(pnrc.LocalRecordId == a.Id){
								containsAcc = true;
							}
						}
						if(LASI_HelperClass.recordShared(o.Id, ConnectionName) && !containsOpp){
							delShares.add(LASI_HelperClass.getRecordConnection(o.Id, ConnectionName));
						}
						if(LASI_HelperClass.recordShared(a.Id, ConnectionName) && !containsAcc){
							delShares.add(LASI_HelperClass.getRecordConnection(a.Id, ConnectionName));
						}
						o.StageName = 'Closed-Not Valid';
						updatedOpps.add(o);
					}
				}
				a.RecordTypeId = LimeadeOwnedAccount;
			}
		}
			
	}

	System.debug('updatedOpps = '+updatedOpps);
	if(updatedOpps.Size() > 0)
		update updatedOpps;
	System.debug('delShares = '+delShares);
    if(delShares.size() > 0){
/*
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('delShares');
        String Body = 'delShares = '+delShares;
        mail.setHTMLBody(Body);
        mail.SetToAddresses(new String[] {'aflint@stratusg.com'});
        Messaging.sendEmail(new Messaging.Email[] { mail });
*/
		delete delShares;
    }
}