@isTest
private class JobPreventiveIncentivizerTest {
	private static Account acct;
	private static Contact con;
	private static Program__c currentYearProgram;
	private static Order__c currentYearOrder;
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
		update currentYearProgram;
		RecordType rt=[Select Id From RecordType Where DeveloperName='Preventive_Ranges'];
		List<Range__c> listRange=new List<Range__c>();
		for(String rangeType:Constant.SetLimeadePreventiveScreeningRangeTypes)
		{
			Range__c rGeneric=new Range__c(Program__c=currentYearProgram.Id,RecordTypeId=rt.Id,Test_Type__c=rangeType,Start_Date__c=Date.today(),End_Date__c=Date.today(),Incentive_ID__c='123456');
			listRange.add(rGeneric);
		}
		insert listRange;
		
		currentYearOrder = new Order__c( 
			ProgramID__c = currentYearProgram.Id, 
			Contact__c=con.Id,
			PatientFirstName__c = 'Pat_1',
			PatientLastName__c = 'SoliantBear_1',
			PatientEmailH__c = 'pb@example.com',
			PatientDOB__c = date.newinstance(1960, 2, 17),
			Order_Type__c = 'Preventative Screening',
			Order_Status__c = 'Received',
			In_Limeade__c='Yes',
			Colorectal_Cancer_Screening__c=Date.today(),  
			Colonoscopy__c=Date.today(),  
			Prostate_Cancer_Screening__c=Date.today(), 
 			Date_of_Dental_Visit__c=Date.today(),  
 			Mammogram__c=Date.today(),  
 			Pap_Smear__c=Date.today(), 
 			Date_of_Vision_Screening_Visit__c=Date.today(),  
 			Date_of_PCP_Follow_Visit__c=Date.today(),
 			Pregnancy_Program_Tri_1__c=Date.today(),  
 			Pregnancy_Program_Tri_2__c=Date.today(),  
 			PCP_Follow_Up_2__c=Date.today()				
		);
		insert currentYearOrder;			
	}	
    static testMethod void testJobPreventiveIncentivizer() {
        init();
        Test.startTest();
        AjaxUtility.SendPreventiveIncentive(currentYearOrder.Id);
        currentYearOrder.Order_Status__c = 'Received';
        currentYearOrder.Preventive_Screening_Incentivized__c=false;
        currentYearOrder.Preventive_Colorectal_Sent__c=null;
        update currentYearOrder;
    	JobPreventiveIncentivizer batch = new JobPreventiveIncentivizer(); 
	    Id batchId = Database.executeBatch(batch,1);          
        Test.stopTest();
    }
}