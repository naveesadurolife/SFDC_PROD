public with sharing class ValidateProgramContacts {
	public void ScheduleJob()
	{
		String programId=Apexpages.currentPage().getParameters().get('id');
		if(!String.isBlank(programId))
			Database.executeBatch(new JobValidateProgramContacts(programId), 10); 
	}
}