@RestResource(urlMapping='/OpportunityCompetitorsShare/*')
global with sharing class LASI_ShareOpportunityCompetitors {
	@HttpPost
	global static String Compeititors(String Action,
									 String LimeadeOpportunityCompetitorId,
									 String AduroOpportunityCompetitorId,
									 String PartnerCompetitorId,
									 String LocalOpportunityId,
									 String Finalist,
									 String Incumbent,
									 String Winner){

//		String ConnectionName = 'Limeade';
//		Map<Id, Id> recordMap = LASI_HelperClass.getRecordMap(ConnectionName);

		Id returnId;
		if(Action == 'upsert'){
			Id LocalCompetitorId = [SELECT Id FROM Account WHERE Limeade_Account_Id__c =: PartnerCompetitorId].Id;
			List<Opportunity_Competitor__c> OpportunityCompetitors = [SELECT Id, Competitor__C, Opportunity__c, Finalist__c, Incumbent__c, Winner__c FROM Opportunity_Competitor__c WHERE Limeade_Opportunity_Competitor_Id__c =: LimeadeOpportunityCompetitorId];
			if(OpportunityCompetitors.Size() == 0){
				Opportunity_Competitor__c oc = new Opportunity_Competitor__c(Limeade_Opportunity_Competitor_Id__c = LimeadeOpportunityCompetitorId,
									  Competitor__c = LocalCompetitorId, 
									  Opportunity__c = LocalOpportunityId,
									  Finalist__c = Boolean.valueOf(Finalist),
									  Incumbent__c = Boolean.valueOf(Incumbent),
									  Winner__c = Boolean.valueOf(Winner));
				Database.SaveResult dsr = Database.insert(oc);
				if(dsr.isSuccess()){
					AduroOpportunityCompetitorId = dsr.getId();
					String returnString = 'Success;';
					returnString += LimeadeOpportunityCompetitorId+';';
					returnString += 'Aduro_Opportunity_Competitor_Id__c;';
					returnString += AduroOpportunityCompetitorId;
					return returnString;
				} else {
					return String.ValueOf(dsr.getErrors().get(0));
				}
			} else {
				Opportunity_Competitor__c oc = OpportunityCompetitors[0];
				oc.Competitor__c = LocalCompetitorId;
				//oc.Opportunity__c = LocalOpportunityId;
				oc.Finalist__c = Boolean.valueOf(Finalist);
				oc.Incumbent__c = Boolean.valueOf(Incumbent);
				oc.Winner__c = Boolean.valueOf(Winner);
				update oc;
				return null;
			}
		} else if(Action == 'delete'){
			List<Opportunity_Competitor__c> OpportunityCompetitors = [SELECT Id FROM Opportunity_Competitor__c WHERE Id =: AduroOpportunityCompetitorId];
			if(OpportunityCompetitors.Size() == 1)
				delete OpportunityCompetitors[0];
		}

		return null;
	}
}