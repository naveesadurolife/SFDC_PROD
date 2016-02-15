trigger LASI_ShareOpportunityLineItem on OpportunityLineItem (before insert, before update, after insert, after update, before delete) {
	
	/*
	* We are in Aduro SFDC, when we create an opportunity product if the Product Partner is 
	* Limeade we will share the Opportunity with Limeade.
	*/


	String ConnectionName = 'Limeade';

	//Map PartnerRecordId to LocalRecordId for all Record Connections
	Map<Id, Id> recordMap = LASI_HelperClass.getRecordMap(ConnectionName);
	
	Id ActiveConnectionId = LASI_HelperClass.getConnectionId(ConnectionName);
    System.debug('ActiveConnectionId = '+ActiveConnectionId);

	List<PartnerNetworkRecordConnection> newShares = new List<PartnerNetworkRecordConnection>();
	Set<Id> pricebookEntryIds = new Set<Id>(); 
	Set<Id> oppIds = new Set<Id>();
	if(!trigger.isDelete){
		for(OpportunityLineItem oli: Trigger.new){
			oppIds.add(oli.OpportunityId);
			pricebookEntryIds.add(oli.PricebookEntryId);
		}
	} else {
		for(OpportunityLineItem oli: Trigger.old){
			oppIds.add(oli.OpportunityId);
			pricebookEntryIds.add(oli.PricebookEntryId);
		}
	}

	Map<Id, Opportunity> OppMap = new Map<Id, Opportunity>([SELECT Id, AccountId, Product_Families__c, Product_Partners__c, Owner.IsActive FROM Opportunity WHERE Id IN: oppIds]);

	Set<Id> accnIds = new Set<Id>();
	for(Id i : OppMap.keySet()){
		Opportunity o = oppMap.get(I);
		accnIds.add(o.AccountId);
	}

	Map<Id, Account> AccnMap = new Map<Id, Account>([SELECT Id FROM Account WHERE Id IN: accnIds]);
	Map<Id, PricebookEntry> PricebookEntryMap = new Map<Id, PricebookEntry>([SELECT Id, IsActive FROM PricebookEntry WHERE Id IN: PricebookEntryIds]);
	
	List<Opportunity> updatedOpps = new List<Opportunity>();

	System.debug(recordMap);
	
	//List<Account> updatedAccns = new List<Account>();

	if(!trigger.isDelete){
		for(OpportunityLineItem oli : Trigger.new){
			Id AccountId = OppMap.get(oli.OpportunityId).AccountId;
			if(Trigger.isBefore){
                System.debug(AccountId);
                System.debug(oli.Partner__c);
				if(AccountId <> null && oli.Partner__c == 'Limeade'){
					boolean contains = false;
					for(PartnerNetworkRecordConnection pnrc : newShares){
						if(pnrc.LocalRecordId == AccountId){
							contains = true;
							break;
						}
					}
                    System.debug(contains);
                    System.debug(ActiveConnectionId <> null);
                    System.debug(LASI_HelperClass.recordShared(AccountId, ConnectionName));
					if(!contains && ActiveConnectionId <> null && !LASI_HelperClass.recordShared(AccountId, ConnectionName)){
						newShares.add(new PartnerNetworkRecordConnection(
							ConnectionId = ActiveConnectionId,
							LocalRecordId = AccountId));
					}
				}
			} else { //Trigger.isAfter
                System.debug(LASI_HelperClass.recordShared(oli.OpportunityId, ConnectionName));
                System.debug(oli.Partner__c);
				if(!LASI_HelperClass.recordShared(oli.OpportunityId, ConnectionName) && oli.Partner__c == 'Limeade'){
					boolean contains = false;
					for(PartnerNetworkRecordConnection pnrc : newShares){
						if(pnrc.LocalRecordId == oli.OpportunityId){
							contains = true;
							break;
						}
					}
					if(!contains && ActiveConnectionId <> null)
						newShares.add(new PartnerNetworkRecordConnection(
							ConnectionId = ActiveConnectionId,
							LocalRecordId = oli.OpportunityId,
							//ParentRecordId = AccountId,
							RelatedRecords = 'OpportunityLineItem'));
				}
				if(LASI_HelperClass.recordShared(oli.OpportunityId, ConnectionName) && ActiveConnectionId <> null && PricebookEntryMap.ContainsKey(oli.PricebookEntryId) && PricebookEntryMap.get(oli.PricebookEntryId).IsActive){
					newShares.add(new PartnerNetworkRecordConnection(
						ConnectionId = ActiveConnectionId,
						LocalRecordId = oli.Id,
						ParentRecordId = oli.OpportunityId
						));
				}
				Opportunity o = oppMap.get(oli.OpportunityId);

				List<String> partners = new List<String>();
				List<String> families = new List<String>();

				if(o.Product_Partners__c <> null && o.Product_Partners__c.contains(';'))
					partners = o.Product_Partners__c.split(';');
				if(o.Product_Families__c <> null && o.Product_Families__c.contains(';'))
					families = o.Product_Families__c.split(';');
				
				boolean containsFamily = false;
				for(String s : families){
					if(s == oli.Product_Family_for_roll_up__c){
						containsFamily = true;
						break;
					}
				}
				if(!containsFamily){
					list<String> tempList = families;
					families = new List<String>();
					tempList.add(oli.Product_Family_for_roll_up__c);
					tempList.sort();
					for(Integer i = tempList.size()-1; i>=0;i--){
						families.add(tempList[i]);
					}
					String finalFamilies = '';
					for(String s : families){
						System.debug('oli = '+oli);
						System.debug('family = '+s);
						if(s <> null)
							finalFamilies += s+';';
					}
					o.Product_Families__c = finalFamilies;
					oppMap.put(o.Id, o);
					Boolean containsopp = false;
					for(Integer i = 0; i < updatedOpps.size(); i++){
						Opportunity uo = updatedOpps.get(i);
						if(uo.id == o.id){
							updatedOpps.set(i, o);
							containsopp = true;
							break;
						}
					}
					if(!containsopp)
						updatedOpps.add(o);
				}

				boolean containsPartner = false;
				for(String s : partners){
					if(s == oli.Product_Partner_for_roll_up__c){
						containsPartner = true;
						break;
					}
				}
				if(!containsPartner){
					partners.add(oli.Product_Partner_for_roll_up__c);
					partners.sort();
					String finalpartners = '';
					for(String s : partners){
						System.debug('oli = '+oli);
						System.debug('Partner = '+s);
						if(s <> null)
							finalpartners += s+';';
					}
					o.Product_Partners__c = finalpartners;
					oppMap.put(o.Id, o);
					Boolean containsopp = false;
					for(Integer i = 0; i < updatedOpps.size(); i++){
						Opportunity uo = updatedOpps.get(i);
						if(uo.id == o.id){
							updatedOpps.set(i, o);
							containsopp = true;
							break;
						}
					}
					if(!containsopp)
						updatedOpps.add(o);
				}
			}
		}
	} else { //Trigger.isDelete
		String lineItemIds = '';
		for(OpportunityLineItem oli : Trigger.old){
			Opportunity o = oppMap.get(oli.OpportunityId);
			if(o.Owner.IsActive){
				System.debug('******* '+LASI_HelperClass.recordShared(oli.Id, ConnectionName));
				
				List<String> partners = new List<String>();
				List<String> families = new List<String>();
	
				system.debug('Partners = '+o.Product_Partners__c);
				system.debug('Families = '+o.Product_Families__c);
	
				if(o.Product_Partners__c <> null && o.Product_Partners__c.contains(';'))
					partners = o.Product_Partners__c.split(';');
				if(o.Product_Families__c <> null && o.Product_Families__c.contains(';'))
					families = o.Product_Families__c.split(';');
	
				for(Integer i = 0; i < families.size(); i++){
					String s = families[i];
					if(s == oli.Product_Family_for_roll_up__c){
						families.remove(i);
						i--;
					}
				}
	
				String finalFamilies = '';
				for(String s : families){
					System.debug('oli = '+oli);
					System.debug('family = '+s);
					if(s <> null)
						finalFamilies += s+';';
				}
				o.Product_Families__c = finalFamilies;
	
	
	
				for(Integer i = 0; i < partners.size(); i++){
					String s = partners[i];
					if(s == oli.Product_Partner_for_roll_up__c){
						partners.remove(i);
						i--;
					}
				}
	
				String finalPartners = '';
				for(String s : partners){
					System.debug('oli = '+oli);
					System.debug('partner = '+s);
					if(s <> null)
						finalPartners += s+';';
				}
				o.Product_Partners__c = finalPartners;
	
				oppMap.put(o.Id, o);
				Boolean containsopp = false;
				for(Integer i = 0; i < updatedOpps.size(); i++){
					Opportunity uo = updatedOpps.get(i);
					if(uo.id == o.id){
						updatedOpps.set(i, o);
						containsopp = true;
						break;
					}
				}
				if(!containsopp)
					updatedOpps.add(o);
                System.debug('******* '+LASI_HelperClass.recordShared(oli.Id, ConnectionName));
				if(LASI_HelperClass.recordShared(oli.Id, ConnectionName)){
                    System.debug('*******');
					PartnerNetworkRecordConnection pnrc = LASI_HelperClass.getRecordConnection(oli.Id, ConnectionName);
					lineItemIds += pnrc.PartnerRecordId+';';
				}
			}
		}
        System.debug('LineItemIds: '+lineItemIds);
		if(lineItemIds <> ''){
			String endpointURL = 'callout:Limeade/services/apexrest/DeleteProducts/deleteLineItems';
			Map<String, String> bodyMap = new Map<String, String>();
			bodyMap.put('LineItemIds', lineItemIds);
			System.debug('***Request: '+String.valueOf(BodyMap));
			LASI_HelperClass.callPartner(endpointURL, bodyMap);
		}
	}

		
	System.debug('newShares = '+newShares);
	//if there are new records to be shared, insert the record connections.
	if(newShares.size() > 0)
		insert newShares;

	System.debug('updatedOpps = '+updatedOpps);
	if(updatedOpps.size() > 0)
		update updatedOpps;

	// update updatedAccns;
}