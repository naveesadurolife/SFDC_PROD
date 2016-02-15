global class LASI_ScheduleOppUpdate implements Schedulable {

	Set<Id> opps;

	global LASI_ScheduleOppUpdate(Set<Id> opps){
		this.opps = opps;
	}

	global void execute(SchedulableContext sc) {
		System.debug(opps);
		List<Opportunity> oppList = new List<Opportunity>();
		for(Id i : opps)
			oppList.add(new Opportunity(Id = i));
		Database.SaveResult[] srList = Database.update(oppList);
		for(Database.SaveResult sr : srList){
			if(sr.IsSuccess())
				System.debug('Success Id: '+sr.getId());
			else
				System.debug('Errors: '+sr.getErrors());
		}
	}
}