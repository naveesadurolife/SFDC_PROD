@isTest
private class JobIndividualIncentivizerTest {
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
		currentYearProgram.Tests_Included_in_Results_Based_Program__c='';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_BMI+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_GLUCOSE+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_TOBACCO+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_CHOLESTEROL+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_HDL+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_TRIGLYCERIDES+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_LDL+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_HDL_LDL+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_WTHR+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_BODY_FAT+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_HEART_RATE+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_TCH_LDL+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_TCH_HDL+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_WAIST+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_SYSTOLIC+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_DIASTOLIC+';';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c+=Constant.OUTCOMES_TEST_INCLUDED_WEIGHT+';';
		
		currentYearProgram.Biometric_Completion_Incentive_Id__c='1234';
		currentYearProgram.Limeade_E_Id__c='12';
		currentYearProgram.Limeade_PSK_ID__c='psk';
		currentYearProgram.Incentive_When_All_Test_Complete__c=true;
		update currentYearProgram;
		/*RecordType rt=[Select Id From RecordType Where DeveloperName='Preventive_Ranges'];
		List<Range__c> listRange=new List<Range__c>();
		for(String rangeType:Constant.SetLimeadePreventiveScreeningRangeTypes)
		{
			Range__c rGeneric=new Range__c(Program__c=currentYearProgram.Id,RecordTypeId=rt.Id,Test_Type__c=rangeType,Start_Date__c=Date.today(),End_Date__c=Date.today(),Incentive_ID__c='123456');
			listRange.add(rGeneric);
		}
		insert listRange;
		*/
		currentYearOrder = new Order__c( 
			ProgramID__c = currentYearProgram.Id, 
			Contact__c=con.Id,
			PatientFirstName__c = 'Pat_1',
			PatientLastName__c = 'SoliantBear_1',
			PatientEmailH__c = 'pb@example.com',
			PatientDOB__c = date.newinstance(1960, 2, 17),
			Order_Type__c = 'Onsite Test',
			Order_Status__c = 'Sent Limeade',
			In_Limeade__c='Yes',
			Limeade_Participant_Code__c='1234',
			Biometric_Completion_Incentive_Sent__c=null,
			BP_Diastolic__c=1,
			BP_Systolic__c=1,
			RFpg__c=1,
			Tobacco__c='Yes',
			RCho__c=1,
			RHdl__c=1,
			RTrig__c=1,
			RLdl__c=1,
			BF__c=1,
			HR_Pulse__c=1,
			Waist__c=1,
			Weight__c=1
		);
		insert currentYearOrder;			
	}	
    static testMethod void testJobIndividualIncentivizer() {
        init();
        Test.startTest();
    	JobIndividualIncentivizer batch = new JobIndividualIncentivizer(); 
	    Id batchId = Database.executeBatch(batch,1);          
        Test.stopTest();
    }
}