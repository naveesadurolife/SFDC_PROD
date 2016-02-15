@isTest
private class OnsiteParticipantSurveyTest {
	static testMethod void myUnitTest() {
        Account a=new Account(Name='Aduro');
        insert a;
        Contact con=new Contact(LastName='Placeholder',AccountId=a.Id);
        insert con;
		Program__c currentYearProgram=TestDataGenerator.getOneProgram();
        WW_Event__c e=new WW_Event__c(Employer__c=a.Id,Create_Event_Resource__c=false,Program__c=currentYearProgram.Id);
        insert e;  
		Order__c currentYearOrder = new Order__c( 
			ProgramID__c = currentYearProgram.Id, 
			Contact__c=con.Id,
			PatientFirstName__c = 'Pat_1',
			PatientLastName__c = 'SoliantBear_1',
			PatientEmailH__c = 'pb@example.com',
			PatientDOB__c = date.newinstance(1960, 2, 17),
			Order_Type__c = 'HTK',
			Order_Status__c = 'Sent Limeade',
			In_Limeade__c='Yes',
			Height_Feet__c = 6.0, Height_Inches__c = 3.0,
			Weight__c = 100.00, BMI__c = 30.00,
			RLdl__c = 100.0, RHdl__c = 100.0, RTrig__c = 100.0,
			RCho__c = 100.0, BP_Systolic__c = 100.0, BP_Diastolic__c = 100.0, RFpg__c = 40.0,
			Tobacco__c='Y',Waist__c=40,BF__c=3,HR_Pulse__c=66,
			WW_Event__c=e.Id
		);
		insert currentYearOrder;
		PageReference pageRef = Page.OnsiteParticipantSurvey;
        Test.setCurrentPage(pageRef);	
		ApexPages.currentPage().getParameters().put('event', e.Id);
		OnsiteParticipantSurvey obj=new OnsiteParticipantSurvey();
		obj.getScreeningExperience();
		obj.getPeopleCheckedInWithResults();
		OnsiteParticipantSurvey.updateSurvey(currentYearOrder.Id,'1','abc');
	}
}