trigger LASI_ShareOpportunityCompetitors on Opportunity_Competitor__c (before insert, before update, after insert, after update, before delete) {

	/*
	* We are in Aduro SFDC, when we create an opportunity competitor if the Opportunity is Shared
	* we will share the competitor.
	*/


	String ConnectionName = 'Limeade';

	//Map PartnerRecordId to LocalRecordId for all Record Connections
	Map<Id, Id> recordMap = LASI_HelperClass.getRecordMap(ConnectionName);
	
	Id ActiveConnectionId = LASI_HelperClass.getConnectionId(ConnectionName);
	List<Opportunity_Competitor__c> newCompetitors = new List<Opportunity_Competitor__c>();
		
	List<PartnerNetworkRecordConnection> newShares = new List<PartnerNetworkRecordConnection>();
	
	if(!trigger.isDelete){
		for(Opportunity_Competitor__c oc : Trigger.new){
			if(LASI_HelperClass.recordShared(oc.Opportunity__c, ConnectionName)){
				if(Trigger.isBefore){
					if(oc.Competitor__c <> null && !LASI_HelperClass.RecordShared(oc.Competitor__c, ConnectionName)){
						newShares.add(new PartnerNetworkRecordConnection(
							ConnectionId = ActiveConnectionId,
							LocalRecordId = oc.Competitor__c));
					}
				} else if(!(Trigger.isUpdate && oc.Limeade_Opportunity_Competitor_Id__c <> null && Trigger.oldMap.get(oc.Id).Limeade_Opportunity_Competitor_Id__c == null)){
					newCompetitors.add(oc);
				}
			}
		}
	} else {
		for(Opportunity_Competitor__c oc : Trigger.old){
			if(oc.Limeade_Opportunity_Competitor_Id__c <> null){
				String endpointURL = 'callout:Limeade/services/apexrest/OpportunityCompetitorsShare/Compeititors';
				Map<String, String> bodyMap = new Map<String, String>();
				bodyMap.put('Action', 'delete');
				bodyMap.put('LimeadeOpportunityCompetitorId', oc.Limeade_Opportunity_Competitor_Id__c);
				LASI_HelperClass.callPartner(endpointURL, BodyMap);
			}
		}
	}

	if(newCompetitors.size() > 0){
		LASI_ScheduleShareOppCompetitor shareCompetitors = new LASI_ScheduleShareOppCompetitor(newCompetitors);
		DateTime scheduledtime = System.Now().addSeconds(30);
		String year = String.valueOf(scheduledtime.Year());
		String Month = String.valueOf(scheduledtime.Month());
		String Day = String.valueOf(scheduledtime.Day());
		String Hour = String.valueOf(scheduledtime.Hour());
		String Min = String.valueOf(scheduledtime.Minute());
		String Sec = String.valueOf(scheduledtime.Second());
		String sch = sec+' '+min+' '+Hour+' '+Day+' '+Month+' ? '+year;
		System.schedule('LASI Share Compeititors '+UserInfo.getUserId()+' '+System.now(), sch, shareCompetitors);
	}
	system.debug(newShares);
	//if there are new records to be shared, insert the record connections.
	if(newShares.size() > 0)
		insert newShares;
}