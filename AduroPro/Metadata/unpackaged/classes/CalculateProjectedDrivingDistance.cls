global class CalculateProjectedDrivingDistance {
	
	webservice static void populateProjectedDrivingDistance(id eventResourceId){
		
		set<Id> setEventResouceIds = new set<Id>();
		setEventResouceIds.add(eventResourceId);
		GMapsDistanceCallouts.updateDistances(setEventResouceIds);
		
	}

}