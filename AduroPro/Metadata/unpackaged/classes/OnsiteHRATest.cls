@isTest
private class OnsiteHRATest {
	private static Account acct;
	private static Contact con;
	private static Program__c currentYearProgram;
	private static Order__c currentYearOrder;
	private static WW_Event__c e;
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
        e=new WW_Event__c(	Employer__c=acct.Id,Create_Event_Resource__c=true,Program__c=currentYearProgram.Id);
        insert e;  		
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
			Tobacco__c='Y',Waist__c=40,BF__c=3,HR_Pulse__c=66,
			WW_Event__c=e.Id
		);
		
		insert currentYearOrder;
		
		HRA__c hra=new HRA__c(Sort_Order__c=1, Order_API_Field_Name__c='PatientFirstName__c', Name='PatientFirstName', 
					Convert_Picklist_Value__c=false, Column_Header__c='PatientFirstName', Active__c=true,Description__c='abc');
		insert hra;			
		
	}	
	static testMethod void testOnsiteHRA() {
		init();
		PageReference pageRef = Page.OnsiteHRA;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('event', e.Id);
		ApexPages.currentPage().getParameters().put('oid', currentYearOrder.Id);
		OnsiteHRA ohra=new OnsiteHRA();
        ohra.saveQuick();
        ohra.ToBiometrics();
        ohra.cancel();
        ohra.getSex();
        ohra.getPregnant();
        ohra.getBloodPressure();
        ohra.getHighCholesterol();
        ohra.getGoodCholesterol();
        ohra.getBloodSugar();
        ohra.getAlcoholicDrinks();
        ohra.getMedicationForMood();
		ohra.getMedicalConditions();
        ohra.getHaveStress();
        ohra.getFeltDepressed();
        ohra.getAnxietyDepression();
        ohra.getSmoke();
        ohra.getExercise();
        ohra.getDescribeHealth();
        ohra.getBackpain();
        ohra.getHealthrisk();
        ohra.getExtraThingsAtWork();
        ohra.getMotivatedToDoJob();
        ohra.getSpentWisely();
		ohra.getAllWork();
        ohra.getAbsentFromWork();
        ohra.getOrganizationSupportHealthierLife();
		ohra.getWellBeing();        
        
		ohra.objOrder.HRA_Sex__c='abc'; 
		ohra.objOrder.HRA_Age__c='abc';
		ohra.objOrder.HRA_Pregnant__c='abc'; 
		ohra.objOrder.HRA_Know_High_Blood_Pressure__c='abc'; 
		ohra.objOrder.HRA_Know_High_Cholesterol__c='abc'; 
		ohra.objOrder.HRA_Know_Good_Cholesterol__c='abc'; 
		ohra.objOrder.HRA_Know_Blood_Sugar__c='abc'; 
		ohra.objOrder.HRA_How_many_alcoholic_drinks__c='abc'; 
		ohra.objOrder.HRA_Use_Medication_For_Mood__c='abc'; 
		ohra.objOrder.HRA_Medical_Conditions__c='abc'; 
		ohra.objOrder.HRA_You_Have_Stress__c='abc'; 
		ohra.objOrder.HRA_How_Often_Have_You_Felt_Depressed__c='abc'; 
		ohra.objOrder.HRA_Medication_For_Anxiety_or_Depression__c='abc'; 
		ohra.objOrder.HRA_Do_you_smoke__c='abc'; 
		ohra.objOrder.HRA_How_often_do_you_exercise__c='abc'; 
		ohra.objOrder.HRA_how_would_you_describe_your_health__c='abc'; 
		ohra.objOrder.HRA_recurring_back_pain__c='abc'; 
		ohra.objOrder.HRA_puts_my_health_at_risk__c='abc'; 
		ohra.objOrder.HRA_do_extra_things_at_work__c='abc'; 
		ohra.objOrder.HRA_motivated_to_do_my_job__c='abc'; 
		ohra.objOrder.HRA_time_at_work_is_spent_wisely__c='abc'; 
		ohra.objOrder.HRA_give_my_all_work__c='abc'; 
		ohra.objOrder.HRA_absent_from_work__c='abc'; 
		ohra.objOrder.HRA_organization_support_healthier_life__c='abc'; 
		ohra.objOrder.HRA_well_being_in_my_life__c='abc';
		ohra.ToBiometrics();    
		ohra.ToBiometrics();   
        ///////////////////////////////////////
		OnsiteHRASearch ohs=new OnsiteHRASearch();
		ohs.search();
		ohs.eventForDate.Event_Date__c=Date.today();
		ohs.eventForDate.Home_Test_Kit_Launch_Date__c=Date.today();
		ohs.search();
		
		PageReference pageRef1 = Page.OnsiteHRASearch;
        Test.setCurrentPage(pageRef1);
		ApexPages.currentPage().getParameters().put('e', 't');
		ApexPages.currentPage().getParameters().put('sd', Date.today().format());
		ApexPages.currentPage().getParameters().put('ed', Date.today().format());
		ApexPages.currentPage().getParameters().put('ex', 'false');
		OnsiteHRASearch ohs1=new OnsiteHRASearch();		
		ohs1.search();
        
	}
}