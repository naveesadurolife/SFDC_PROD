trigger LASI_ShareContract on Contract (after insert, after update, after delete) {

	/*
	* We are in Aduro SFDC, when we create a Contract we will lookup 
	* the Opportunities at the Account and if one of them is shared
	* we will share the Contract.  Also when a contract is created
	* if it has lookup fields that need to be populate them.
	* we will populate those fields.
	*/


	String ConnectionName = 'Limeade';
	if(Trigger.isDelete){
		for(Contract c : Trigger.Old){
			if(c.Limeade_Contract_Id__c <> null){
				String endpointURL = 'callout:Limeade/services/apexrest/ConntractShare/newContract';
				Map<String, String> bodyMap = new Map<String, String>();
				bodyMap.put('Action', 'delete');
				bodyMap.put('LimeadeContractId', c.Limeade_Contract_Id__c);
				System.debug(BodyMap);
				LASI_HelperClass.callPartner(endpointURL, bodyMap);
			}
 		}
	} else {
		for(Contract c : Trigger.new){
			if(LASI_HelperClass.recordShared(c.AccountId, ConnectionName)){
				if((Trigger.isInsert && c.Limeade_Contract_Id__c == null) || 
					(Trigger.isUpdate && !(c.Limeade_Contract_Id__c != null && Trigger.oldMap.get(c.Id).Limeade_Contract_Id__c == null))){
					String endpointURL = 'callout:Limeade/services/apexrest/ConntractShare/newContract';
					Map<String, String> bodyMap = new Map<String, String>();
					bodyMap.put('Action', 'upsert');
					bodyMap.put('AduroContractId', c.Id);
					bodyMap.put('AccountId', c.AccountId);
					bodyMap.put('Status', c.Status);
					bodyMap.put('StartDate', String.ValueOf(c.StartDate));
					bodyMap.put('ContractTerm', String.ValueOf(c.ContractTerm));
					
					bodyMap.put('ContractType', String.ValueOf(c.Contract_Type__c));
					bodyMap.put('ContractName', String.ValueOf(c.Contract_Name__c));
					bodyMap.put('Term_for_Convenience', String.ValueOf(c.Term_for_Convenience__c));
					bodyMap.put('Renewal_Terms', String.ValueOf(c.Renewal_Terms__c));
					bodyMap.put('Customer_Signed_Date', String.ValueOf(c.CustomerSignedDate));
					bodyMap.put('Access_Launch_Date', String.ValueOf(c.Access_Date__c));
					bodyMap.put('Renewal_Date', String.ValueOf(c.Renewal_Date__c));
					bodyMap.put('Term_Notice_Days', String.ValueOf(c.Term_Notice_Days__c));
					String SpecialTerms = c.SpecialTerms;
					if(SpecialTerms <> null)
						SpecialTerms = SpecialTerms.escapeJava();
					bodyMap.put('Special_Terms', SpecialTerms);





					System.debug(BodyMap);
					LASI_HelperClass.callPartner(endpointURL, bodyMap);
				}
			}
		}
	}
}