@isTest
private class JobTaggerTest {
	private static Account acct;
	private static Contact con;
	private static Program__c currentYearProgram;
	private static Program__c previousYearProgram;
	private static Order__c currentYearOrder;
	private static Order__c previousYearOrder;	
	private static void init()
	{
		acct=TestDataGenerator.getOneAccount();
		con=TestDataGenerator.getOneContact();
		con.Limeade_ParticipantCode__c='1234abcd';
		update con;
		currentYearProgram=TestDataGenerator.getOneProgram();
		currentYearProgram.Program_Start_Date__c=Date.newInstance(Date.today().year(), 1, 1);
		currentYearProgram.Program_End_Date__c=Date.newInstance(Date.today().year(), 12, 31);
		currentYearProgram.Program_Status__c='Active';
		currentYearProgram.Limeade_Live_Date__c=Date.today();
		currentYearProgram.Program_Manager__c=Userinfo.getUserId();
		currentYearProgram.Limeade_Identifier_Employee_ID__c=true;
		update currentYearProgram;
		List<Range__c> listRange=new List<Range__c>();
		Id riskLevelRecordTypeId=[Select Id From RecordType Where DeveloperName='Risk_Level'].Id;
		Id taggerRecordTypeId=[Select Id From RecordType Where DeveloperName='Tagger'].Id;
		Integer step=1;
		String taggerCondition='';
		for(String testType:Constant.MAPRANGETESTORDERFIELD.keySet())
		{
			if(String.isNotBlank(taggerCondition))
			{
				taggerCondition+=' OR';
			}
			taggerCondition+='@'+step+'@';
			listRange.add(new Range__c(RecordTypeId=riskLevelRecordTypeId,Step__c=step++,Program__c=currentYearProgram.Id,Test_Type__c=testType,Female_Low__c=1,Female_High__c=130,Male_Low__c=1,Male_High__c=130));		
		}
		for(Integer i=1;i<5;i++)
		{
			listRange.add(new Range__c(RecordTypeId=taggerRecordTypeId,Demographic_Tag__c='Tier'+i,Program__c=currentYearProgram.Id,Incentive_ID__c='2000',Filter_Criteria_New__c=taggerCondition,Demographic_Tag_Field__c='Status'));		
		}		
		insert listRange;
		currentYearOrder = new Order__c( 
			ProgramID__c = currentYearProgram.Id, 
			Contact__c=con.Id,
			PatientFirstName__c = 'Pat_1',
			PatientLastName__c = 'SoliantBear_1',
			PatientEmailH__c = 'pb@example.com',
			EmployeeID__c='123',
			PatientDOB__c = date.newinstance(1960, 2, 17),
			Order_Type__c = 'HTK',
			Order_Status__c = 'Sent Limeade',
			In_Limeade__c='Yes',
			Height_Feet__c = 6.0, Height_Inches__c = 3.0,
			Weight__c = 100.00, BMI__c = 30.00,
			RLdl__c = 100.0, RHdl__c = 100.0, RTrig__c = 100.0,
			RCho__c = 100.0, BP_Systolic__c = 100.0, BP_Diastolic__c = 100.0, RFpg__c = 40.0,
			Tobacco__c='Y',Waist__c=40,BF__c=3,HR_Pulse__c=66
		);	
		insert currentYearOrder;	
	}
	static testMethod void myUnitTest() {
		init();
		Test.startTest();
		    JobTagger batch = new JobTagger(); 
		    Id batchId = Database.executeBatch(batch,1);  	
		AjaxUtility.SendTagger(currentYearOrder.Id);
		Test.stopTest();
	}
}