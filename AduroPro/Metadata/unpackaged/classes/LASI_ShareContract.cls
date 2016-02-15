@RestResource(urlMapping='/ConntractShare/*')
global with sharing class LASI_ShareContract {
	@HttpPost
	global static String newContract(String Action,
									 String LimeadeContractId,
									 String AduroContractId,
									 String AccountId, 
									 String Status,
									 String StartDate,
									 String ContractTerm,
									 String ContractType,
									 String ContractName,
									 String Term_for_Convenience,
									 String Renewal_Terms,
									 String Customer_Signed_Date,
									 String Access_Launch_Date,
									 String Renewal_Date,
									 String Term_Notice_Days,
									 String Special_Terms){

		String ConnectionName = 'Limeade';
		Map<Id, Id> recordMap = LASI_HelperClass.getRecordMap(ConnectionName);

		Id returnId;
		if(Action == 'upsert'){
			List<Contract> contract = [SELECT Id, AccountId, Status, StartDate, ContractTerm FROM Contract WHERE Limeade_Contract_Id__c =: LimeadeContractId];
			if(contract.Size() == 0){
				Contract c = new Contract(Limeade_Contract_Id__c = LimeadeContractId,
									  AccountId = recordMap.get(AccountId), 
									  Status = Status
									  );
				if(Customer_Signed_Date <> 'null' && Customer_Signed_Date <> null)
					c.CustomerSignedDate = Date.valueOf(Customer_Signed_Date);
				if(StartDate <> 'null' && StartDate <> null)
					c.StartDate = Date.valueOf(StartDate);
				if(ContractTerm <> 'null' && ContractTerm <> null)
					c.ContractTerm = Integer.valueOf(ContractTerm);
				if(ContractType <> 'null' && ContractType <> null)
					c.Contract_Type__c = ContractType;
				if(ContractName <> 'null' && ContractName <> null)
					c.Contract_Name__c = ContractName;
				if(Term_for_Convenience <> 'null' && Term_for_Convenience <> null)
					c.Term_for_Convenience__c = Term_for_Convenience;
				if(Renewal_Terms <> 'null' && Renewal_Terms <> null)
					c.Renewal_Terms__c = Renewal_Terms;
				if(Access_Launch_Date <> 'null' && Access_Launch_Date <> null)
					c.Access_Date__c = Date.valueOf(Access_Launch_Date);
				if(Renewal_Date <> 'null' && Renewal_Date <> null)
					c.Renewal_Date__c = Date.ValueOf(Renewal_Date);
				if(Term_Notice_Days <> 'null' && Term_Notice_Days <> null)
					c.Term_Notice_Days__c = Integer.valueOf(Term_Notice_Days);
				if(Special_Terms <> 'null' && Special_Terms <> null)
					c.SpecialTerms = Special_Terms;



				Database.SaveResult dsr = Database.insert(c);
				if(dsr.isSuccess()){
					AduroContractId = dsr.getId();
					String returnString = 'Success;';
					returnString += LimeadeContractId+';';
					returnString += 'Aduro_Contract_Id__c;';
					returnString += AduroContractId;
					return returnString;
				} else {
					return String.ValueOf(dsr.getErrors().get(0));
				}
			} else {
				Contract c = contract[0];
				c.AccountId = recordMap.get(AccountId);
				c.Status = Status;
				if(StartDate == 'null' || StartDate == null)
					c.StartDate = null;
				else
					c.StartDate = Date.valueOf(StartDate);
				if(ContractTerm == 'null' || ContractTerm == null)
					c.ContractTerm = null;
				else
					c.ContractTerm = Integer.valueOf(ContractTerm);


				if(ContractType == 'null' || ContractType == null)
					c.Contract_Type__c = null;
				else
					c.Contract_Type__c = ContractType;
				if(ContractName == 'null' || ContractName == null)
					c.Contract_Name__c = null;
				else
					c.Contract_Name__c = ContractName;
				if(Term_for_Convenience == 'null' || Term_for_Convenience == null)
					c.Term_for_Convenience__c = null;
				else
					c.Term_for_Convenience__c = Term_for_Convenience;
				if(Renewal_Terms == 'null' || Renewal_Terms == null)
					c.Renewal_Terms__c = null;
				else
					c.Renewal_Terms__c = Renewal_Terms;
				if(Access_Launch_Date == 'null' || Access_Launch_Date == null)
					c.Access_Date__c = null;
				else
					c.Access_Date__c = Date.valueOf(Access_Launch_Date);
				if(Renewal_Date == 'null' || Renewal_Date == null)
					c.Renewal_Date__c = null;
				else
					c.Renewal_Date__c = Date.ValueOf(Renewal_Date);
				if(Term_Notice_Days == 'null' || Term_Notice_Days == null)
					c.Term_Notice_Days__c = null;
				else
					c.Term_Notice_Days__c = Integer.valueOf(Term_Notice_Days);
				if(Special_Terms == 'null' || Special_Terms == null)
					c.SpecialTerms = null;
				else
					c.SpecialTerms = Special_Terms;

				update c;
				return null;
			}
		} else if(Action == 'delete'){
			List<Contract> contract = [SELECT Id FROM Contract WHERE Id =: AduroContractId];
			if(contract.Size() == 1)
				delete contract[0];
		}

		return null;
	}
}