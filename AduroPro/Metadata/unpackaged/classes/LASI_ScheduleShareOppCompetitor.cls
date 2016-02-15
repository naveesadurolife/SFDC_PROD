global class LASI_ScheduleShareOppCompetitor implements Schedulable {
	

	String ConnectionName = 'Limeade';
	List<Opportunity_Competitor__c> competitors;

	global LASI_ScheduleShareOppCompetitor(List<Opportunity_Competitor__c> competitors){
		this.competitors = competitors;
	}

	global void execute(SchedulableContext sc) {
		for(Opportunity_Competitor__c oc : competitors){
			String endpointURL = 'callout:Limeade/services/apexrest/OpportunityCompetitorsShare/Compeititors';
			Map<String, String> bodyMap = new Map<String, String>();
			bodyMap.put('Action', 'upsert');
			bodyMap.put('AduroOpportunityCompetitorId', oc.Id);
			bodyMap.put('PartnerCompetitorId', oc.Competitor__c);
			bodyMap.put('LocalOpportunityId', LASI_HelperClass.getRecordConnection(oc.Opportunity__c, ConnectionName).PartnerRecordId);
			bodyMap.put('Finalist', String.valueOf(oc.Finalist__c));
			bodyMap.put('Incumbent', String.valueOf(oc.Incumbent__c));
			bodyMap.put('Winner', String.valueOf(oc.Winner__c));
			LASI_HelperClass.callPartner(endpointURL, BodyMap);
		}
	}
}