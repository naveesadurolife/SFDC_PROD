@isTest (SeeAllData=True)
private class LASI_TestClass {

	@isTest static void test_method_one() {
		String ConnectionId = LASI_HelperClass.getConnectionId('Limeade');

		Test.StartTest();
		Lead l = new Lead(LastName = 'Test', Status = 'Partner Assigned', Company = 'Test Company');
		insert l;


		Set<Id> localSharedIds = LASI_HelperClass.getLocalSharedIds('Limeade');
		l = [SELECT Id, Status, Reason_Unqualified__c FROM Lead WHERE Id IN: localSharedIds LIMIT 1];
		l.Status = 'Unqualified';
		l.Reason_Unqualified__c = 'Limeade Lead';
		update l;

		
		Product2 p = new Product2(Name = 'Test', Partner__c = 'Limeade', Family = 'Test');
		insert p;
		Id standardPricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
		PricebookEntry pbe;
		List<PricebookEntry> pricebooks = [SELECT Id FROM PricebookEntry WHERE Product2Id =: p.Id];
		if(pricebooks.size() > 0)
			pbe = pricebooks[0];
		if(pbe == null){
			pbe = new PricebookEntry(Product2Id = p.Id, Pricebook2Id = standardPricebookId, unitprice = 0, IsActive = true);
			insert pbe;
		}

		Account a = new Account(Name = 'Test Account', NumberofEmployees = 5000);
		insert a;

		Opportunity o = new Opportunity(Name = 'Test Opp', AccountId = a.Id, StageName = '-1 Qualifying', CloseDate = System.Today(), Est_Launch_Date__c = System.Today());
		Insert o;

		a.NumberOfEmployees = 2500;
		update a;

		PartnerNetworkRecordConnection pnrc = new PartnerNetworkRecordConnection(LocalRecordId = o.Id, ConnectionId = ConnectionId);
		insert pnrc;

		a.NumberOfEmployees = 5000;
		update a;

		o.Additional_Notes__c = 'Test';
		update o;

		OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = o.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 1.00);
		insert oli;

		oli.UnitPrice = 2.00;
		update oli;

		delete oli;

		Test.StopTest();
	}

	@isTest static void test_method_two() {
		//LASI_HelperClass.isTest = true;
		Set<Id> localSharedIds = LASI_HelperClass.getLocalSharedIds('Limeade');
		Opportunity o = [SELECT Id, AccountId FROM Opportunity WHERE Id IN: localSharedIds AND Product_Partners__c = null LIMIT 1];
		Account a = [SELECT Id, NumberofEmployees FROM Account WHERE Id =: o.AccountId];
		a.NumberOfEmployees = 7500;
		update a;
		update o;
	}

	@isTest static void test_method_three() {
		//LASI_HelperClass.isTest = true;
		Set<Id> localSharedIds = LASI_HelperClass.getLocalSharedIds('Limeade');
		Opportunity o = [SELECT Id, AccountId FROM Opportunity WHERE Id IN: localSharedIds AND Product_Partners__c = null LIMIT 1];
		Account c = new Account(name='Competitor');
		insert c;
		Opportunity_Competitor__c oc = new Opportunity_Competitor__c(Opportunity__c = o.Id, Competitor__c = c.Id);
		insert oc;
		oc.Limeade_Opportunity_Competitor_Id__c = 'fakeId';
		update oc;
		delete oc;
	}

	@isTest static void test_method_four() {
		//LASI_HelperClass.isTest = true;
		Set<Id> localSharedIds = LASI_HelperClass.getLocalSharedIds('Limeade');
		Account a = [SELECT Id FROM Account WHERE Id IN: localSharedIds LIMIT 1];
		Contract c = new Contract(AccountId = a.Id, Status = 'Draft');
		insert c;
		c.Limeade_Contract_Id__c = 'FakeId';
		update c;
		PGs_SLAs__c pg = new PGs_SLAs__c(Contract__c = c.Id);
		insert pg;
		Attachment att = new Attachment(ParentId = c.Id, Name = 'Test.txt', Body = Blob.valueOf('Some Text'));
		insert att;
		att.Name = 'New Name';
		update att;
		delete att;
	}
	@isTest static void test_method_five() {
		Contract c = [SELECT Id FROM Contract LIMIT 1];
		RestRequest req = new RestRequest();
 		RestResponse res = new RestResponse();
 		req.requestURI = '/services/apexrest/SharePGs/PGs';  //Request URL
		req.httpMethod = 'POST'; //HTTP Request Type
		RestContext.request = req;
		RestContext.response= res;
		String dateString = String.valueOf(Date.newInstance(1900, 1, 1));
		String body = LASI_SharePGs.PGs('upsert'
							 ,'001Abos30984'
							 ,null
							 ,c.Id
							 ,'15'
							 ,dateString
							 ,dateString
							 ,dateString
							 ,dateString
							 ,dateString
							 ,dateString
							 ,dateString
							 ,dateString
							 ,'None'
							 ,'Test'
							 ,'Test'
							 ,'Test');
		 body = LASI_SharePGs.PGs('upsert'
							 ,'987'
							 ,null
							 ,c.Id
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null');
		 PGs_SLAs__c pg = new PGs_SLAs__c(Limeade_PG_Id__c = '123', Contract__c = c.Id);
		 insert pg;
		body = LASI_SharePGs.PGs('upsert'
							 ,'123'
							 ,null
							 ,c.Id
							 ,'15'
							 ,dateString
							 ,dateString
							 ,dateString
							 ,dateString
							 ,dateString
							 ,dateString
							 ,dateString
							 ,dateString
							 ,'None'
							 ,'Test'
							 ,'Test'
							 ,'Test');
		 body = LASI_SharePGs.PGs('upsert'
							 ,'123'
							 ,null
							 ,c.Id
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null');
		 body = LASI_SharePGs.PGs('delete'
							 ,'null'
							 ,pg.Id
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null'
							 ,'null');

		//system.assert(body);//Similarly assert rest as well
	}
	@isTest static void test_method_six() {
		Opportunity o = [SELECT Id FROM Opportunity LIMIT 1];
		Account a = [SELECT Id FROM Account LIMIT 1];
		a.Limeade_Account_Id__c = '123';
		update a;

		RestRequest req = new RestRequest();
 		RestResponse res = new RestResponse();
 		req.requestURI = '/services/apexrest/OpportunityCompetitorsShare/';  //Request URL
		req.httpMethod = 'POST'; //HTTP Request Type
		RestContext.request = req;
		RestContext.response= res;
		String dateString = String.valueOf(Date.newInstance(1900, 1, 1));
		String body = LASI_ShareOpportunityCompetitors.Compeititors('upsert',
									null,
									'abc',
									'123',
									o.Id,
									'True',
									'True',
									'True');
		Opportunity_Competitor__c oc = new Opportunity_Competitor__c(Opportunity__c=o.Id, Competitor__c=a.Id);
		insert oc;

		body = LASI_ShareOpportunityCompetitors.Compeititors('upsert',
									oc.Id,
									null,
									'123',
									o.Id,
									'True',
									'True',
									'True');




		body = LASI_ShareOpportunityCompetitors.Compeititors('delete',
									oc.Id,
									null,
									'123',
									o.Id,
									'True',
									'True',
									'True');
	}
	@isTest static void test_method_seven() {

		//LASI_HelperClass.isTest = true;
		Set<Id> localSharedIds = LASI_HelperClass.getLocalSharedIds('Limeade');

		Account a = [SELECT Id FROM Account WHERE Id IN: localSharedIds LIMIT 1];
		PartnerNetworkRecordConnection pnrc = LASI_HelperClass.getRecordConnection(a.Id, 'Limeade');


		a.Limeade_Account_Id__c = '123';
		update a;

		RestRequest req = new RestRequest();
 		RestResponse res = new RestResponse();
 		req.requestURI = '/services/apexrest/OpportunityCompetitorsShare/';  //Request URL
		req.httpMethod = 'POST'; //HTTP Request Type
		RestContext.request = req;
		RestContext.response= res;
		String dateString = String.valueOf(Date.newInstance(1900, 1, 1));
		String body = LASI_ShareContract.newContract('upsert',
									'null',
									'123',
									String.valueOf(pnrc.PartnerRecordId), 
									'Draft',
									String.valueOf(Date.newInstance(1900, 1, 1)),
									'12',
									'Something',
									'Name',
									'sometemr',
									String.valueOf(Date.newInstance(1900, 1, 1)),
									String.valueOf(Date.newInstance(1900, 1, 1)),
									String.valueOf(Date.newInstance(1900, 1, 1)),
									String.valueOf(Date.newInstance(1900, 1, 1)),
									'90',
									'none');
		Contract c = new Contract(AccountId = a.Id, Name = 'Test', Limeade_Contract_Id__c = 'abc');
		insert c;


		body = LASI_ShareContract.newContract('upsert',
									'null',
									'123',
									String.valueOf(pnrc.PartnerRecordId), 
									'Draft',
									String.valueOf(Date.newInstance(1900, 1, 1)),
									'12',
									'Something',
									'Name',
									'sometemr',
									String.valueOf(Date.newInstance(1900, 1, 1)),
									String.valueOf(Date.newInstance(1900, 1, 1)),
									String.valueOf(Date.newInstance(1900, 1, 1)),
									String.valueOf(Date.newInstance(1900, 1, 1)),
									'90',
									'none');


		body = LASI_ShareContract.newContract('delete',
									c.Id,
									'123',
									pnrc.PartnerRecordId, 
									'Something',
									'Name',
									'12',
									'sometemr',
									null,
									'Draft',
									'12',
									String.valueOf(Date.newInstance(1900, 1, 1)),
									String.valueOf(Date.newInstance(1900, 1, 1)),
									String.valueOf(Date.newInstance(1900, 1, 1)),
									'',
									'none');

	}

	@isTest static void test_method_eight() {
		//LASI_HelperClass.isTest = true;
		Set<Id> localSharedIds = LASI_HelperClass.getLocalSharedIds('Limeade');

		Opportunity o = [SELECT Id FROM Opportunity WHERE Id IN: localSharedIds AND Owner.IsActive = True LIMIT 1];
		Contact c1 = [SELECT Id FROM Contact WHERE Id IN: localSharedIds AND Owner.IsActive = True LIMIT 1];
		Contact c2 = [SELECT Id FROM Contact WHERE Id <>: c1.Id AND Id IN: localSharedIds AND Owner.IsActive = True LIMIT 1];

		insert new OpportunityContactRole(OpportunityId = o.Id, ContactId = c1.Id, Role = 'Test');
		insert new OpportunityContactRole(OpportunityId = o.Id, ContactId = c2.Id, Role = 'Test');

		PartnerNetworkRecordConnection pnrc1 = LASI_HelperClass.getRecordConnection(o.Id, 'Limeade');
		PartnerNetworkRecordConnection pnrc2 = LASI_HelperClass.getRecordConnection(c1.Id, 'Limeade');
		PartnerNetworkRecordConnection pnrc3 = LASI_HelperClass.getRecordConnection(c2.Id, 'Limeade');
		
		String contactRole = 'insert:'+pnrc1.PartnerRecordId+':'+pnrc2.PartnerRecordId+':'+'Some Role';
		String body = LASI_ShareContactRole.ContactRoles(contactRole);
		contactRole = 'update:'+pnrc1.PartnerRecordId+':'+pnrc2.PartnerRecordId+':'+'Some Role';
		contactRole += ';';
		contactRole += 'update:'+pnrc1.PartnerRecordId+':'+pnrc3.PartnerRecordId+':'+'Some Role';
		 body = LASI_ShareContactRole.ContactRoles(contactRole);

		LASI_BatchShareContacts bsc = new LASI_BatchShareContacts();
		Database.executeBatch(bsc);

		contactRole = 'delete:'+pnrc1.PartnerRecordId+':'+pnrc2.PartnerRecordId;
		contactRole += ';';
		contactRole += 'delete:'+pnrc1.PartnerRecordId+':'+pnrc3.PartnerRecordId;
		body = LASI_ShareContactRole.ContactRoles(contactRole);


	}

	@isTest static void test_method_nine() {
		//LASI_HelperClass.isTest = true;
		Set<Id> localSharedIds = LASI_HelperClass.getLocalSharedIds('Limeade');
		Account a = new Account(Name = 'Test');
		insert a;
		Contract c = new Contract(AccountId = a.Id, Name = 'Test', Limeade_Contract_Id__c = '123');
		insert c;
		String Body = LASI_ShareAttachments.newAttachment('new', 'Some Text', null, 'Text.txt', 'txt','123');
		//Attachment att = new Attachment(Name = 'Text.txt', ParentId = c.Id, Body = Blob.ValueOf('Some Text'));
		//insert att;
		Body = LASI_ShareAttachments.newAttachment('update', null, 'Text.txt', 'new Name', null, '123');
		Body = LASI_ShareAttachments.newAttachment('Delete', null, 'New Name', 'New Name', null, '123');

	}

	@isTest static void test_method_ten() {
		//LASI_HelperClass.isTest = true;
		Set<Id> localSharedIds = LASI_HelperClass.getLocalSharedIds('Limeade');

		Opportunity o = [SELECT Id FROM Opportunity WHERE Id IN: localSharedIds LIMIT 1];
		Contact c1 = [SELECT Id FROM Contact WHERE Id IN: localSharedIds LIMIT 1];
		Contact c2 = [SELECT Id FROM Contact WHERE Id <>: c1.Id AND Id IN: localSharedIds LIMIT 1];

		insert new OpportunityContactRole(OpportunityId = o.Id, ContactId = c1.Id, Role = 'Test');
		insert new OpportunityContactRole(OpportunityId = o.Id, ContactId = c2.Id, Role = 'Test');

		PartnerNetworkRecordConnection pnrc1 = LASI_HelperClass.getRecordConnection(o.Id, 'Limeade');
		PartnerNetworkRecordConnection pnrc2 = LASI_HelperClass.getRecordConnection(c1.Id, 'Limeade');
		PartnerNetworkRecordConnection pnrc3 = LASI_HelperClass.getRecordConnection(c2.Id, 'Limeade');
		
		String contactRole = 'insert:'+pnrc1.PartnerRecordId+':'+pnrc2.PartnerRecordId+':'+'Some Role';
		contactRole += ';';
		contactRole += 'update:'+pnrc1.PartnerRecordId+':'+pnrc2.PartnerRecordId+':'+'Some Role';
		contactRole += ';';
		contactRole += 'update:'+pnrc1.PartnerRecordId+':'+pnrc3.PartnerRecordId+':'+'Some Role';
		String body = LASI_ShareContactRole.ContactRoles(contactRole);

		LASI_BatchShareContactRole bsc = new LASI_BatchShareContactRole();
		Database.executeBatch(bsc);

		contactRole = 'delete:'+pnrc1.PartnerRecordId+':'+pnrc2.PartnerRecordId;
		contactRole += ';';
		contactRole += 'delete:'+pnrc1.PartnerRecordId+':'+pnrc3.PartnerRecordId;
		body = LASI_ShareContactRole.ContactRoles(contactRole);

	}
}