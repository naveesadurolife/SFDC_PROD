@RestResource(urlMapping='/SharePGs/*')
global with sharing class LASI_SharePGs {
	@HttpPost
	global static String PGs(String Action
							 ,String LimeadePGId
							 ,String AduroPGId
							 ,String LocalContractId
							 ,String Fees_at_Risk
							 ,String Customer_Sat_1_Survey_End_Date
							 ,String Customer_Sat_1_Survey_Send_Date
							 ,String Customer_Sat_2_Survey_End_Date
							 ,String Customer_Sat_2_Survey_Send_Date
							 ,String Member_Sat_1_Survey_End_Date
							 ,String Member_Sat_2_Survey_Send_Date
							 ,String Member_Sat_Survey_1_Send_Date
							 ,String Member_Sat_Survey_2_End_Date
							 ,String Other_Fees_at_Risk
							 ,String Performance_Guarantee_SLA_Detail
							 ,String PG_SLA_Metric
							 ,String PG_SLA_Type
							 ){

//		String ConnectionName = 'Limeade';
//		Map<Id, Id> recordMap = LASI_HelperClass.getRecordMap(ConnectionName);

//		Id returnId;
		if(Action == 'upsert'){
			List<PGs_SLAs__c> PGs = [SELECT Id
											,Limeade_PG_Id__c
											,Contract__c
											,Fees_at_Risk__c
											,Customer_Sat_1_Survey_End_Date__c
											,Customer_Sat_1_Survey_Send_Date__c
											,Customer_Sat_2_Survey_End_Date__c
											,Customer_Sat_2_Survey_Send_Date__c
											,Member_Sat_1_Survey_End_Date__c
											,Member_Sat_2_Survey_Send_Date__c
											,Member_Sat_Survey_1_Send_Date__c
											,Member_Sat_Survey_2_End_Date__c
											,Other_Fees_at_Risk__c
											,Performance_Guarantee_SLA_Detail__c
											,PG_SLA_Metric__c
											,PG_SLA_Type__c
									FROM PGs_SLAs__c WHERE Limeade_PG_Id__c =: LimeadePGId];
			if(PGs.Size() == 0){
				PGs_SLAs__c pg = new PGs_SLAs__c(Contract__c = LocalContractId 
									  ,Limeade_PG_Id__c = LimeadePGId
									  );
				if(Fees_at_Risk <> 'null')
					pg.Fees_at_Risk__c = Decimal.valueOf(Fees_at_Risk);
				else
					pg.Fees_at_Risk__c = null;
				if(Customer_Sat_1_Survey_End_Date <> 'null')
					pg.Customer_Sat_1_Survey_End_Date__c = Date.valueOf(Customer_Sat_1_Survey_End_Date);
				else
					pg.Customer_Sat_1_Survey_End_Date__c = null;
				if(Customer_Sat_1_Survey_Send_Date <> 'null')
					pg.Customer_Sat_1_Survey_Send_Date__c = Date.valueOf(Customer_Sat_1_Survey_Send_Date);
				else
					pg.Customer_Sat_1_Survey_Send_Date__c = null;
				if(Customer_Sat_2_Survey_End_Date <> 'null')
					pg.Customer_Sat_2_Survey_End_Date__c = Date.valueOf(Customer_Sat_2_Survey_End_Date);
				else
					pg.Customer_Sat_2_Survey_End_Date__c = null;
				if(Customer_Sat_2_Survey_Send_Date <> 'null')
					pg.Customer_Sat_2_Survey_Send_Date__c = Date.valueOf(Customer_Sat_2_Survey_Send_Date);
				else
					pg.Customer_Sat_2_Survey_Send_Date__c = null;
				if(Member_Sat_1_Survey_End_Date <> 'null')
					pg.Member_Sat_1_Survey_End_Date__c = Date.valueOf(Member_Sat_1_Survey_End_Date);
				else
					pg.Member_Sat_1_Survey_End_Date__c = null;
				if(Member_Sat_2_Survey_Send_Date <> 'null')
					pg.Member_Sat_2_Survey_Send_Date__c = Date.valueOf(Member_Sat_2_Survey_Send_Date);
				else
					pg.Member_Sat_2_Survey_Send_Date__c = null;
				if(Member_Sat_Survey_1_Send_Date <> 'null')
					pg.Member_Sat_Survey_1_Send_Date__c = Date.valueOf(Member_Sat_Survey_1_Send_Date);
				else
					pg.Member_Sat_Survey_1_Send_Date__c = null;
				if(Member_Sat_Survey_2_End_Date <> 'null')
					pg.Member_Sat_Survey_2_End_Date__c = Date.valueOf(Member_Sat_Survey_2_End_Date);
				else
					pg.Member_Sat_Survey_2_End_Date__c = null;
				if(Other_Fees_at_Risk <> 'null')
					pg.Other_Fees_at_Risk__c = Other_Fees_at_Risk;
				else
					pg.Other_Fees_at_Risk__c = null;
				if(Performance_Guarantee_SLA_Detail <> 'null')
					pg.Performance_Guarantee_SLA_Detail__c = Performance_Guarantee_SLA_Detail;
				else
					pg.Performance_Guarantee_SLA_Detail__c = null;
				if(PG_SLA_Metric <> 'null')
					pg.PG_SLA_Metric__c = PG_SLA_Metric;
				else
					pg.PG_SLA_Metric__c = null;
				if(PG_SLA_Type <> 'null')
					pg.PG_SLA_Type__c = PG_SLA_Type;
				else
					pg.PG_SLA_Type__c = null;

				Database.SaveResult dsr = Database.insert(pg);
				if(dsr.isSuccess()){
					AduroPGId = dsr.getId();
					String returnString = 'Success;';
					returnString += LimeadePGId+';';
					returnString += 'Aduro_PG_Id__c;';
					returnString += AduroPGId;
					return returnString;
				} else {
					return String.ValueOf(dsr.getErrors().get(0));
				}
			} else {
				PGs_SLAs__c pg = PGs[0];
				if(Fees_at_Risk <> 'null')
					pg.Fees_at_Risk__c = Decimal.valueOf(Fees_at_Risk);
				else
					pg.Fees_at_Risk__c = null;
				if(Customer_Sat_1_Survey_End_Date <> 'null')
					pg.Customer_Sat_1_Survey_End_Date__c = Date.valueOf(Customer_Sat_1_Survey_End_Date);
				else
					pg.Customer_Sat_1_Survey_End_Date__c = null;
				if(Customer_Sat_1_Survey_Send_Date <> 'null')
					pg.Customer_Sat_1_Survey_Send_Date__c = Date.valueOf(Customer_Sat_1_Survey_Send_Date);
				else
					pg.Customer_Sat_1_Survey_Send_Date__c = null;
				if(Customer_Sat_2_Survey_End_Date <> 'null')
					pg.Customer_Sat_2_Survey_End_Date__c = Date.valueOf(Customer_Sat_2_Survey_End_Date);
				else
					pg.Customer_Sat_2_Survey_End_Date__c = null;
				if(Customer_Sat_2_Survey_Send_Date <> 'null')
					pg.Customer_Sat_2_Survey_Send_Date__c = Date.valueOf(Customer_Sat_2_Survey_Send_Date);
				else
					pg.Customer_Sat_2_Survey_Send_Date__c = null;
				if(Member_Sat_1_Survey_End_Date <> 'null')
					pg.Member_Sat_1_Survey_End_Date__c = Date.valueOf(Member_Sat_1_Survey_End_Date);
				else
					pg.Member_Sat_1_Survey_End_Date__c = null;
				if(Member_Sat_2_Survey_Send_Date <> 'null')
					pg.Member_Sat_2_Survey_Send_Date__c = Date.valueOf(Member_Sat_2_Survey_Send_Date);
				else
					pg.Member_Sat_2_Survey_Send_Date__c = null;
				if(Member_Sat_Survey_1_Send_Date <> 'null')
					pg.Member_Sat_Survey_1_Send_Date__c = Date.valueOf(Member_Sat_Survey_1_Send_Date);
				else
					pg.Member_Sat_Survey_1_Send_Date__c = null;
				if(Member_Sat_Survey_2_End_Date <> 'null')
					pg.Member_Sat_Survey_2_End_Date__c = Date.valueOf(Member_Sat_Survey_2_End_Date);
				else
					pg.Member_Sat_Survey_2_End_Date__c = null;
				if(Other_Fees_at_Risk <> 'null')
					pg.Other_Fees_at_Risk__c = Other_Fees_at_Risk;
				else
					pg.Other_Fees_at_Risk__c = null;
				if(Performance_Guarantee_SLA_Detail <> 'null')
					pg.Performance_Guarantee_SLA_Detail__c = Performance_Guarantee_SLA_Detail;
				else
					pg.Performance_Guarantee_SLA_Detail__c = null;
				if(PG_SLA_Metric <> 'null')
					pg.PG_SLA_Metric__c = PG_SLA_Metric;
				else
					pg.PG_SLA_Metric__c = null;
				if(PG_SLA_Type <> 'null')
					pg.PG_SLA_Type__c = PG_SLA_Type;
				else
					pg.PG_SLA_Type__c = null;
				update pg;
				return null;
			}
		} else if(Action == 'delete'){
			List<PGs_SLAs__c> PGs = [SELECT Id FROM PGs_SLAs__c WHERE Id =: AduroPGId];
			if(PGs.Size() == 1)
				delete PGs[0];
		}

		return null;
	}
}