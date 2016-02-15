trigger LASI_SharePGs on PGs_SLAs__c (after insert, after update, before delete) {
	String ConnectionName = 'Limeade';

	//Map PartnerRecordId to LocalRecordId for all Record Connections
	//Map<Id, Id> recordMap = LASI_HelperClass.getRecordMap(ConnectionName);
	Map<Id, Contract> contractMap = new Map<Id, Contract>([SELECT Id, Limeade_Contract_Id__c FROM Contract WHERE Limeade_Contract_Id__c <> null]);
	List<String> fields = new String[]{
		'Fees_at_Risk'
		,'Customer_Sat_1_Survey_End_Date'
		,'Customer_Sat_1_Survey_Send_Date'
		,'Customer_Sat_2_Survey_End_Date'
		,'Customer_Sat_2_Survey_Send_Date'
		,'Member_Sat_1_Survey_End_Date'
		,'Member_Sat_2_Survey_Send_Date'
		,'Member_Sat_Survey_1_Send_Date'
		,'Member_Sat_Survey_2_End_Date'
		,'Other_Fees_at_Risk'
		,'Performance_Guarantee_SLA_Detail'
		,'PG_SLA_Metric'
		,'PG_SLA_Type'
		};
	if(!Trigger.isDelete){
		for(PGs_SLAs__c pg : Trigger.new){
			if(contractMap.containsKey(pg.Contract__c)){
				if((Trigger.isInsert && pg.Limeade_PG_Id__c == null) || 
					(Trigger.isUpdate && !(pg.Limeade_PG_Id__c != null && Trigger.oldMap.get(pg.Id).Limeade_PG_Id__c == null))){
					String endpointURL = 'callout:Limeade/services/apexrest/SharePGs/PGs';
					Map<String, String> bodyMap = new Map<String, String>();
					bodyMap.put('Action', 'upsert');
					bodyMap.put('AduroPGId', pg.Id);
					bodyMap.put('LocalContractId', contractMap.get(pg.Contract__c).Limeade_Contract_Id__c);
					for(String field : fields){
						String customField = field+'__c';
						String value = String.valueOf(pg.get(customField));
						if(value <> null)
							value = value.escapeJava();
						System.debug(value);
						bodyMap.put(field, value);
					}
					System.debug(BodyMap);
					LASI_HelperClass.callPartner(endpointURL, bodyMap);
				}
			}
		}
	} else { //Trigger.isDelete
		for(PGs_SLAs__c pg : Trigger.old){
			if(contractMap.containsKey(pg.Contract__c)){
				String endpointURL = 'callout:Limeade/services/apexrest/SharePGs/PGs';
				Map<String, String> bodyMap = new Map<String, String>();
				bodyMap.put('Action', 'delete');
				bodyMap.put('LimeadePGId', pg.Limeade_PG_Id__c);
				System.debug(BodyMap);
				LASI_HelperClass.callPartner(endpointURL, bodyMap);
			}
		}
	}
}