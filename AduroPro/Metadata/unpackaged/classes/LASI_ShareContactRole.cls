@RestResource(urlMapping='/ContactRoleShare/*')
global with sharing class LASI_ShareContactRole {
	@HttpPost
	global static String ContactRoles(String ContactRoles){
		String ConnectionName = 'Limeade';
		Map<Id, Id> recordMap = LASI_HelperClass.getRecordMap(ConnectionName);
		Set<Id> LocalSharedIds = LASI_HelperClass.getLocalSharedIds(ConnectionName);

		List<OpportunityContactRole> updatedContactRoles = new List<OpportunityContactRole>();
		List<OpportunityContactRole> newContactRoles = new List<OpportunityContactRole>();
		List<OpportunityContactRole> delContactRoles = new List<OpportunityContactRole>();

		List<OpportunityContactRole> LocalContactRoleList = [SELECT Id, ContactId, OpportunityId, Role FROM OpportunityContactRole WHERE OpportunityId IN: LocalSharedIds];
		List<String> ContactRoleList = ContactRoles.Split(';');

		Map<Id, List<OpportunityContactRole>> localRoleMap = new Map<Id, List<OpportunityContactRole>>();

		for(OpportunityContactRole ocr : LocalContactRoleList){

			if(localRoleMap.containsKey(ocr.OpportunityId)){
				List<OpportunityContactRole> tempList = localRoleMap.get(ocr.OpportunityId);
				tempList.add(ocr);
				localRoleMap.put(ocr.OpportunityId, tempList);
			} else {
				List<OpportunityContactRole> tempList = new List<OpportunityContactRole>();
				tempList.add(ocr);
				localRoleMap.put(ocr.OpportunityId, tempList);
			}

		}

		Map<Id, Opportunity> localOppMap = new Map<Id, Opportunity>([SELECT Id, Opportunity_Contact_Roles_for_Sharing__c FROM Opportunity WHERE Id IN: LocalSharedIds]);
		List<Opportunity> updatedOpps = new List<Opportunity>();

		//Map<String, String> contactRoleMap = new Map<String, String>();
		
		for(String s: ContactRoleList){
			list<String> details = s.split(':');
			String action = details[0];
			if(action == 'insert'){
				String PartnerOpportunityId = details[1];
				Id LocalOpportunityId = recordMap.get((Id) PartnerOpportunityId);
				Id LocalContactId = details[2];
				String Role = details[3];
				newContactRoles.add(new OpportunityContactRole(
					OpportunityId = LocalOpportunityId,
					ContactId = LocalContactId,
					Role = Role));
			} else if(action == 'update'){
				String PartnerOpportunityId = details[1];
				Id LocalOpportunityId = recordMap.get((Id) PartnerOpportunityId);
				String PartnerContactId = details[2];
				Id LocalContactId = recordMap.get((Id) PartnerContactId);
				String Role = details[3];
				List<OpportunityContactRole> roles = localRoleMap.get(LocalOpportunityId);
				for(OpportunityContactRole ocr : roles){
					if(ocr.ContactId == LocalContactId){
						ocr.Role = Role;
						updatedContactRoles.add(ocr);
						break;
					}
				}
			} else if(action == 'delete'){
				String PartnerOpportunityId = details[1];
				Id LocalOpportunityId = recordMap.get((Id) PartnerOpportunityId);
				String PartnerContactId = details[2];
				Id LocalContactId = recordMap.get((Id) PartnerContactId);
				List<OpportunityContactRole> roles = localRoleMap.get(LocalOpportunityId);
				for(OpportunityContactRole ocr : roles){
					if(ocr.ContactId == LocalContactId){
						delContactRoles.add(ocr);
						break;
					}
				}
			}
		}

		String returnBody = '';

		System.debug(updatedContactRoles);

		try {
			Database.SaveResult[] lsr = Database.update(updatedContactRoles);
			for(Integer i = 0; i < lsr.Size(); i++){
				Database.SaveResult sr = lsr[i];
				OpportunityContactRole ocr = updatedContactRoles[i];
				Id ocrId = sr.Id;
				Id OppId = ocr.OpportunityId;
				Id ContactId = ocr.ContactId;
				String Role = ocr.Role;
				returnBody += 'UPDATE:';
				returnBody += sr.Id+'=>';
				returnBody += sr.isSuccess()+'=>';
				returnBody += sr.getErrors()+';';
				boolean contains = false;
				List<String> ocrStrings = new List<String>();
				for(Integer j = 0; j < updatedOpps.Size(); j++){
					Opportunity uo = updatedOpps[j];
					if(uo.Id == OppId){
						contains = true;
						if(uo.Opportunity_Contact_Roles_for_Sharing__c <> null && uo.Opportunity_Contact_Roles_for_Sharing__c.contains(';')){
							ocrStrings = uo.Opportunity_Contact_Roles_for_Sharing__c.split(';');
							ocrStrings.add(ocr.Id+':'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role);
							String finalOcrRoles = '';
							for(String s : ocrStrings){
								finalOcrRoles += s+';';
							}
							uo.Opportunity_Contact_Roles_for_Sharing__c = finalOcrRoles;
							updatedOpps.set(j, uo);
						}
						break;
					}
				}
				if(!contains){
					Opportunity o = localOppMap.get(OppId);
					if(o.Opportunity_Contact_Roles_for_Sharing__c <> null && o.Opportunity_Contact_Roles_for_Sharing__c.contains(';')){
						ocrStrings = o.Opportunity_Contact_Roles_for_Sharing__c.split(';');
						ocrStrings.add(ocr.Id+':'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role);
						String finalOcrRoles = '';
						for(String s : ocrStrings){
							finalOcrRoles += s+';';
						}
						o.Opportunity_Contact_Roles_for_Sharing__c = finalOcrRoles;
						updatedOpps.add(o);
					}
				}
			}
		} catch (DmlException e ){
			ReturnBody = 'Error: '+e.getMessage();
		}

		System.debug(newContactRoles);

		try {
			Database.SaveResult[] lsr = Database.insert(newContactRoles);
			for(Integer i = 0; i < lsr.Size(); i++){
				Database.SaveResult sr = lsr[i];
				OpportunityContactRole ocr = newContactRoles[i];
				Id ocrId = sr.Id;
				Id OppId = ocr.OpportunityId;
				Id ContactId = ocr.ContactId;
				String Role = ocr.Role;
				returnBody += 'INSERT:';
				returnBody += sr.Id+'=>';
				returnBody += sr.isSuccess()+'=>';
				returnBody += sr.getErrors()+';';

				boolean contains = false;
				List<String> ocrStrings = new List<String>();
				for(Integer j = 0; j < updatedOpps.Size(); j++){
					Opportunity uo = updatedOpps[j];
					if(uo.Id == OppId){
						contains = true;
						if(uo.Opportunity_Contact_Roles_for_Sharing__c <> null && uo.Opportunity_Contact_Roles_for_Sharing__c.contains(';')){
							ocrStrings = uo.Opportunity_Contact_Roles_for_Sharing__c.split(';');
						}
						ocrStrings.add(ocr.Id+':'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role);
						String finalOcrRoles = '';
						for(String s : ocrStrings){
							finalOcrRoles += s+';';
						}
						uo.Opportunity_Contact_Roles_for_Sharing__c = finalOcrRoles;
						updatedOpps.set(j, uo);
						break;
					}
				}
				if(!contains){
					Opportunity o = localOppMap.get(OppId);
					if(o.Opportunity_Contact_Roles_for_Sharing__c <> null && o.Opportunity_Contact_Roles_for_Sharing__c.contains(';')){
						ocrStrings = o.Opportunity_Contact_Roles_for_Sharing__c.split(';');
					}
					ocrStrings.add(ocr.Id+':'+ocr.OpportunityId+':'+ocr.ContactId+':'+ocr.Role);
					String finalOcrRoles = '';
					for(String s : ocrStrings){
						finalOcrRoles += s+';';
					}
					o.Opportunity_Contact_Roles_for_Sharing__c = finalOcrRoles;
					updatedOpps.add(o);
				}
			}
		} catch (DmlException e ){
			ReturnBody = 'Error: '+e.getMessage();
		}

		System.debug(delContactRoles);

		try {
			Database.DeleteResult[] dsr = Database.delete(delContactRoles);
			for(Integer i = 0; i < dsr.Size(); i++){
				Database.DeleteResult dr = dsr[i];
				OpportunityContactRole ocr = delContactRoles[i];
				returnBody += 'DELETE:';
				returnBody += dr.Id+'=>';
				returnBody += dr.isSuccess()+'=>';
				returnBody += dr.getErrors()+';';
				Id OppId = ocr.OpportunityId;

				boolean contains = false;
				List<String> ocrStrings = new List<String>();
				for(Integer j = 0; j < updatedOpps.Size(); j++){
					Opportunity uo = updatedOpps[j];
					if(uo.Id == OppId){
						contains = true;
						if(uo.Opportunity_Contact_Roles_for_Sharing__c <> null && uo.Opportunity_Contact_Roles_for_Sharing__c.contains(';')){
							ocrStrings = uo.Opportunity_Contact_Roles_for_Sharing__c.split(';');
							for(integer k = 0; k < ocrStrings.size(); k++){
								String ocrString = ocrStrings[k];
								if(ocrString.contains(':')){
									List<String> details = ocrString.split(':');
									if(details[0] == dr.Id){
										ocrStrings.remove(k);
										String finalOcrRoles = '';
										for(String s : ocrStrings){
											finalOcrRoles += s+';';
										}
										uo.Opportunity_Contact_Roles_for_Sharing__c = finalOcrRoles;
										updatedOpps.set(j, uo);
										break;
									}
								}
							}
						}
						break;
					}
				}
				if(!contains){
					Opportunity o = localOppMap.get(ocr.OpportunityId);
					if(o.Opportunity_Contact_Roles_for_Sharing__c <> null && o.Opportunity_Contact_Roles_for_Sharing__c.contains(';')){
						ocrStrings = o.Opportunity_Contact_Roles_for_Sharing__c.split(';');
						for(integer j = 0; j < ocrStrings.size(); j++){
							String ocrString = ocrStrings[j];
							if(ocrString.contains(':')){
								List<String> details = ocrString.split(':');
								if(details[0] == dr.Id){
									ocrStrings.remove(j);
									String finalOcrRoles = '';
									for(String s : ocrStrings){
										finalOcrRoles += s+';';
									}
									o.Opportunity_Contact_Roles_for_Sharing__c = finalOcrRoles;
									updatedOpps.add(o);
									break;
								}
							}
						}
					}
				}
			}
		} catch (DmlException e ){
			ReturnBody = 'Error: '+e.getMessage();
		}

		update updatedOpps;

		return returnBody;
	}
}