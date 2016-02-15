@isTest
private class JobOutcomesManagementNewTest {
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
		currentYearProgram.Outcomes_Mg_Type__c='Individual';
		currentYearProgram.Tests_Included_in_Results_Based_Program__c=Constant.OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE+';';
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
		
		currentYearProgram.Group_XX_ID__c='234';
		currentYearProgram.Individual_BMI_ID__c='123';
		currentYearProgram.Individual_Body_Fat_ID__c='123';
		currentYearProgram.Individual_BP_ID__c='123';
		currentYearProgram.Individual_Glucose_ID__c='123';
		currentYearProgram.Individual_HDL_ID__c='123';
		currentYearProgram.Individual_HDL_LDL_ID__c='123';
		currentYearProgram.Individual_Heart_Rate_ID__c='123';
		currentYearProgram.Individual_LDL_ID__c='123';
		currentYearProgram.Individual_TCH_HDL__c='123';
		currentYearProgram.Individual_TCH_LDL__c='123';
		currentYearProgram.Individual_TChol_ID__c='123';
		currentYearProgram.Individual_Tobacco_Free_ID__c='123';
		currentYearProgram.Individual_Waist_Height_ID__c='123';
		currentYearProgram.Individual_Waist_ID__c='123';
		
		update currentYearProgram;
		List<Range__c> listRange=new List<Range__c>();
		Range__c rSystolic=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_SYSTOLIC,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rDiastolic=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_DIASTOLIC,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rCholesterol=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rTriglycerides=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rBMI=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_BMI,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rGlucoseFasting=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_GLUCOSE_FASTING,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rHDL=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_HDL,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rTCHHDL=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_TCH_HDL,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rLDL=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_LDL,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rHeartRate=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_HEART_RATE,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rBodyFat=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_BODY_FAT,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rWaistHeight=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_WAIST_HEIGHT,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rHDLLDL=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_HDL_LDL,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rTCHLDL=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_TCH_LDL,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rWaist=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_WAIST,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		Range__c rGlucoseNonFasting=new Range__c(Program__c=currentYearProgram.Id,Test_Type__c=Constant.OUTCOMES_TEST_TYPE_GLUCOSE_NON_FASTING,Female_Low__c=1,Female_High__c=130,Female_Number__c=.5,Male_Low__c=1,Male_High__c=130,Male_Number__c=.5);
		listRange.addAll(new Range__c[]{rSystolic,rDiastolic,rCholesterol,rTriglycerides,rBMI,rGlucoseFasting,rHDL,rTCHHDL,rLDL,rHeartRate,rBodyFat,rWaistHeight,rHDLLDL,rTCHLDL,rWaist,rGlucoseNonFasting});
		insert listRange;
				
		previousYearProgram=currentYearProgram.clone();
		previousYearProgram.Program_Start_Date__c=Date.newInstance(Date.today().year()-1, 1, 1);
		previousYearProgram.Program_End_Date__c=Date.newInstance(Date.today().year()-1, 12, 31);	
		previousYearProgram.Program_Status__c='Complete';
		insert previousYearProgram;	
		
		currentYearOrder = new Order__c( 
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
			Tobacco__c='Y',Waist__c=40,BF__c=3,HR_Pulse__c=66
		);
		
		previousYearOrder = new Order__c( 
			ProgramID__c = previousYearProgram.Id, 
			Contact__c=con.Id,
			PatientFirstName__c = 'Pat_1',
			PatientLastName__c = 'SoliantBear_1',
			PatientEmailH__c = 'pb@example.com',
			PatientDOB__c = date.newinstance(1960, 2, 17),
			Order_Type__c = 'HTK',
			Order_Status__c = 'Sent Limeade',
			In_Limeade__c='Yes', 
			Height_Feet__c = 7.0, Height_Inches__c = 3.0,
			Weight__c = 101.00, BMI__c = 31.00,
			RLdl__c = 101.0, RHdl__c = 88.0, RTrig__c = 101.0,
			RCho__c = 101.0, BP_Systolic__c = 101.0, BP_Diastolic__c = 101.0, RFpg__c = 41.0,
			Waist__c=45,BF__c=4,HR_Pulse__c=77
			);
		insert previousYearOrder;	
		
		insert currentYearOrder;			
		
	}
    static testMethod void myUnitTest() {
        init();
        Test.startTest();
        AjaxUtility.SendOrderIncentive(currentYearOrder.Id);
        AjaxUtility.SendOrderBestScore(currentYearOrder.Id);
        currentYearProgram.Outcomes_Mg_Type__c='Group + Individual';
        currentYearProgram.Improvement_Type__c='Value';
        currentYearProgram.Number_of_Passes_Needed__c=1;
        update currentYearProgram;
        AjaxUtility.SendOrderIncentive(currentYearOrder.Id);
        
        currentYearProgram.Improvement_Type__c='Percentage';
        update currentYearProgram;
		try{
			AjaxUtility.SendOrderIncentive(currentYearOrder.Id);
		}
		catch(Exception ex){}
                
    	JobOutcomesManagementNew batch = new JobOutcomesManagementNew(); 
	    Id batchId = Database.executeBatch(batch,1);  
	    
 	    
	           
        Test.stopTest();
    }
}