trigger LASI_ShareSalesToService on Sales_To_Service__c (after update) {

	/*
	* We are in Aduro SFDC, when we create an opportunity competitor if the Opportunity is Shared
	* we will share the competitor.
	*/


	String ConnectionName = 'Limeade';

	List<String> HandoffFields =  new String[]{
	'Additional_Notes__c',
	'Additional_Products__c',
	'Biometric_Detail__c',
	'Browsers_OS__c',
	'Coaching_Detail__c',
	'Company_Culture__c',
	'Culture_Training__c',
	'Customer_Resources__c',
	'Customizations__c',
	'Demographics__c',
	'Device_Challenges__c',
	'Devices__c',
	'Employee_Designation__c',
	'Est_Launch_Date__c',
	'Existing_Program_Info__c',
	'Incentive_Design__c',
	'Integration_Needs__c',
	'International__c',
	'Key_File_Attachments_for_Review__c',
	'Key_Milestones_Agreed_To__c',
	'Limeade_Strengths__c',
	'Marketing_Assets__c',
	'Outcomes_Detail__c',
	'Pain_Points__c',
	'Program_Name__c',
	'Regulatory__c',
	'Reporting__c',
	'Risks__c',
	'SSO__c',
	'Who_is_Eligible__c'};

	String Query = 'SELECT Id,';
	for(String s : HandoffFields)
		Query+= s+',';
	Query = Query.substring(0, (Query.length()-1));
	Set<Id> s2sSet = Trigger.newMap.KeySet();
	Query += ' FROM Opportunity WHERE Id IN :s2sSet';
	List<Opportunity> opps = Database.Query(Query);
	List<Opportunity> updatedOpps = new List<Opportunity>();
	for(Sales_to_Service__c s2s : Trigger.new){
		for(Opportunity o : opps){
			if(s2s.Opportunity__c == o.Id){
				Boolean updated = false;
				for(String field : HandoffFields){
					if(o.get(field) <> s2s.get(field)){
						o.put(field, s2s.get(field));
						updated = true;
					}
				}
				if(updated)
					updatedOpps.add(o);
				Break;
			}
		}
	}
	if(updatedOpps.Size() > 0)
		update updatedOpps;
}