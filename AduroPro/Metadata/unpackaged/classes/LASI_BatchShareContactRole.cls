global class LASI_BatchShareContactRole implements  Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

	String query;
	String ConnectionName = 'Limeade';
	Map<Id, Id> recordMap =  LASI_HelperClass.getRecordMap(ConnectionName);
	Set<Id> LocalRecordIds = LASI_HelperClass.getLocalSharedIds(ConnectionName);
	List<Opportunity> updatedOpps = new List<Opportunity>();

	global LASI_BatchShareContactRole() {
		query = 'SELECT Id, Opportunity_Contact_Roles_for_Sharing__c FROM Opportunity WHERE Id IN: LocalRecordIds';
		if(Test.isRunningTest())
			query += ' LIMIT 200';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		//System.debug('Query = '+query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
  		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
   		for(sObject s : scope){
   			Opportunity o = (Opportunity) s;
   			oppMap.put(o.Id, o);
   		}

   		List<OpportunityContactRole> roleScope = [SELECT Id, ContactId, OpportunityId, Role FROM OpportunityContactRole WHERE OpportunityId IN: oppMap.KeySet()];
   		Set<Id> contactIds = new Set<Id>();
   		Map<Id, Set<Id>> roleMap = new Map<Id, Set<Id>>();
   		for(OpportunityContactRole ocr : roleScope){
   			contactIds.add(ocr.ContactId);
   			if(roleMap.containsKey(ocr.OpportunityId)){
   				Set<Id> tempSet = roleMap.get(ocr.OpportunityId);
   				tempSet.add(ocr.Id);
   				roleMap.put(ocr.OpportunityId, tempSet);
   			} else {
   				Set<Id> tempSet = new Set<Id>();
   				tempSet.add(ocr.Id);
   				roleMap.put(ocr.OpportunityId, tempSet);
   			}
   		}

		Map<Id, Contact> CurrentContactMap = new Map<Id, Contact>([SELECT Id, AccountId FROM Contact WHERE Id IN: contactIds]);
		String endpointURL = 'callout:Limeade/services/apexrest/ContactRoleShare/ContactRoles';

		Map<String, String> bodyMap = new Map<String, String>();
		String contactMap = '';
		
		Set<Id> oppIds = new Set<Id>();

		List<OpportunityContactRole> insertRoles = new list<OpportunityContactRole>();
		List<OpportunityContactRole> updateRoles = new list<OpportunityContactRole>();
		List<String> deleteRoles = new List<String>();

		for(OpportunityContactRole ocr : roleScope){
			boolean contains = false;
			List<String> ocrStrings = new List<String>();
			for(Integer i = 0; i < updatedOpps.Size(); i++){
				Opportunity uo = updatedOpps[i];
				boolean updated = false;
				if(uo.Id == ocr.OpportunityId){
					contains = true;
					if(uo.Opportunity_Contact_Roles_for_Sharing__c <> null && uo.Opportunity_Contact_Roles_for_Sharing__c.contains(';')){
						ocrStrings = uo.Opportunity_Contact_Roles_for_Sharing__c.split(';');
						boolean containsOCR = false;
						for(Integer j = 0; j < ocrStrings.Size(); j++){
							String s = ocrStrings[j];
							if(s.contains(':')){
								List<String> split = s.split(':');
								String ocrId = split[0];
								String OppId = split[1];
								String ContactId = split[2];
								String Role = split[3];
								if(ocr.Id == ocrId){
									containsOCR = true;
									if(ocr.OpportunityId <> OppId || ocr.ContactId <> ContactId || ocr.Role <> Role){
										updateRoles.add(ocr);
										ocrStrings.set(j, ocr.Id+':'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role);
										updated = true;
										break;
									}
								}
							}
						}
						if(!containsOCR){
							System.debug(ocr);
							insertRoles.add(ocr);
							ocrStrings.add(ocr.Id+':'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role);
							updated = true;
						}
					} else {
						System.debug(ocr);
						insertRoles.add(ocr);
						ocrStrings.add(ocr.Id+':'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role);
						updated = true;
					}
					System.debug(updated);
					if(updated){
						String finalOcrRoles = '';
						for(String s : ocrStrings){
							finalOcrRoles += s+';';
						}
						System.debug(finalOcrRoles);
						uo.Opportunity_Contact_Roles_for_Sharing__c = finalOcrRoles;
						updatedOpps.set(i, uo);
						oppMap.put(uo.Id, uo);
					}
					break;
				}
			}
			if(!contains){
				Opportunity o = oppMap.get(ocr.opportunityId);
				boolean updated = false;
				if(o.Opportunity_Contact_Roles_for_Sharing__c <> null && o.Opportunity_Contact_Roles_for_Sharing__c.contains(';')){
					ocrStrings = o.Opportunity_Contact_Roles_for_Sharing__c.split(';');
					boolean containsOCR = false;
					for(Integer j = 0; j < ocrStrings.Size(); j++){
						String s = ocrStrings[j];
						if(s.contains(':')){
							List<String> split = s.split(':');
							String ocrId = split[0];
							String OppId = split[1];
							String ContactId = split[2];
							String Role = split[3];
							if(ocr.Id == ocrId){
								containsOCR = true;
								if(ocr.Role <> Role && (ocr.Role <> null && Role <>'')){
									updateRoles.add(ocr);
									ocrStrings.set(j, ocr.Id+':'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role);
									updated = true;
									break;
								}
							}
						}
					}
					if(!containsOCR){
						System.debug(ocr);
						insertRoles.add(ocr);
						ocrStrings.add(ocr.Id+':'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role);
						updated = true;
					}
				} else {
					System.debug(ocr);
					insertRoles.add(ocr);
					ocrStrings.add(ocr.Id+':'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role);
					updated = true;
				}
				System.debug(updated);
				if(updated){
					String finalOcrRoles = '';
					for(String s : ocrStrings){
						finalOcrRoles += s+';';
					}
					System.debug(finalOcrRoles);
					o.Opportunity_Contact_Roles_for_Sharing__c = finalOcrRoles;
					updatedOpps.add(o);
					oppMap.put(o.Id, o);
				}
			}
		}

		for(Id OppId : OppMap.Keyset()){
			Opportunity o = oppMap.get(OppId);
			Boolean updated = false;
			List<String> ocrStrings = new List<String>();
			if(o.Opportunity_Contact_Roles_for_Sharing__c <> null && o.Opportunity_Contact_Roles_for_Sharing__c.contains(';')){
				ocrStrings = o.Opportunity_Contact_Roles_for_Sharing__c.split(';');
				for(Integer i = 0; i < ocrStrings.Size(); i++){
					String s = ocrStrings[i];
					if(s.contains(':')){
						List<String> split = s.Split(':');
						String ocrId = split[0];
						String OppString = split[1];
						String ContactId = split[2];
						String Role = split[3];
						if(roleMap.containsKey(o.Id)){
							Set<Id> ocrIds = roleMap.get(o.Id);
							if(!ocrIds.contains(ocrId)){
								deleteRoles.add(OppString+':'+ContactId);
								ocrStrings.remove(i);
								i--;
								updated = true;
							}
						}
					}
				}
			}
			if(updated){
				String finalOcrRoles = '';
				for(String s : ocrStrings){
					finalOcrRoles += s+';';
				}
				o.Opportunity_Contact_Roles_for_Sharing__c = finalOcrRoles;
				updatedOpps.add(o);
				oppMap.put(o.Id, o);
			}
		}
		System.debug(insertRoles);
		for(OpportunityContactRole ocr : insertRoles){
			PartnerNetworkRecordConnection pnrc = LASI_HelperClass.getRecordConnection(ocr.ContactId, ConnectionName); 
			if(pnrc <> null){
				Id partnerContactId = pnrc.PartnerRecordId;
				contactMap += 'insert:'+ocr.OpportunityId+':'+partnerContactId+':'+ocr.Role+';';
			}
		}
		System.debug(updateRoles);

		for(OpportunityContactRole ocr : updateRoles){
			contactMap += 'update:'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role+';';
		}
		System.debug(deleteRoles);

		for(String ocr : deleteRoles){
			contactMap += 'delete:'+ocr+';';
		}

		if(contactMap <> ''){
			bodyMap.put('ContactRoles', contactMap);
			System.debug(BodyMap);
			callPartner(endpointURL, bodyMap);
		}

	}
	
	global void finish(Database.BatchableContext BC) {
		if(!Test.isRunningTest())
			update updatedOpps;
	}

	Public static void callPartner(String endpointURL, Map<String, String> BodyMap){
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();

		Http http = new Http();

		req.setEndpoint(endpointURL);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		String Body = '{';
		Integer i = 0;
		for(String key : bodyMap.keySet()){
			body += '"'+key+'": '+'"'+bodyMap.get(key)+'"';
			i++;
			if(i < bodyMap.keySet().size())
				body += ', ';
		}
		body+='}';
		req.setBody(body);

		System.debug(req.toString());
		System.debug(req.getBody());
		if(!Test.isRunningTest()){
			try {
				res = Http.send(Req);
			} catch(System.CalloutException e){
				System.debug('Callout error: ' + e);
				System.debug(res.toString());
			}
		}
		String responseBody = res.getBody();
		System.debug(responseBody);
	}
}