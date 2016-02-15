public with sharing class Constant {
	//public static final String LIMEMADE_API= ((UserInfo.getOrganizationId()=='00D700000009I07EAE')?'https://limeade.com/api/':(UserInfo.getOrganizationId()=='00DQ000000GJi1GMAT'?'https://staging.limeade.com/api/':'https://limeade.info/api/'));
	public static final String DOCUMENT_URL= ((UserInfo.getOrganizationId()=='00D700000009I07EAE')?'https://wellmetrics--c.na33.content.force.com/servlet/servlet.ImageServer?oid=00D700000009I07&id=@@DOCID@@':(UserInfo.getOrganizationId()=='00DQ000000GJi1GMAT'?'https://wellmetrics--staging--c.cs3.content.force.com/servlet/servlet.ImageServer?oid=00DQ000000GJi1GMAT&id=@@DOCID@@':'https://wellmetrics--dev1--c.cs23.content.force.com/servlet/servlet.ImageServer?oid=00D180000004aLk&id=@@DOCID@@'));
	public static final String EVENT_REGISTRATION_URL= ((UserInfo.getOrganizationId()=='00D700000009I07EAE')?'https://wellmetricssurveys.secure.force.com/Event?id=@@EVENTID@@&sid=@@SLOTID@@':(UserInfo.getOrganizationId()=='00DQ000000GJi1GMAT'?'https://wellmetricssurveys.staging.cs3.force.com/Event?id=@@EVENTID@@&sid=@@SLOTID@@':'https://wellmetricssurveys.dev.cs3.force.com/Event?id=@@EVENTID@@&sid=@@SLOTID@@'));
	public static final String EVENT_PUBLISH_REGISTRATION_URL= ((UserInfo.getOrganizationId()=='00D700000009I07EAE')?'https://wellmetricssurveys.secure.force.com/Event?id=':(UserInfo.getOrganizationId()=='00DQ000000GJi1GMAT'?'https://wellmetricssurveys.staging.cs3.force.com/Event?id=':'https://wellmetricssurveys.dev.cs3.force.com/Event?id='));
//https://limeade.info/api/
	public static final String LIMEMADE_API= ((UserInfo.getOrganizationId()=='00D700000009I07EAE')?'https://limeade.com/api/':'https://staging.limeade.com/api/');
	//public static final String DOCUMENT_URL= ((UserInfo.getOrganizationId()=='00D700000009I07EAE')?'https://wellmetrics--c.na5.content.force.com/servlet/servlet.ImageServer?oid=00D700000009I07&id=@@DOCID@@':'https://wellmetrics--dev1--c.cs30.content.force.com/servlet/servlet.ImageServer?oid=00Dn0000000CvJl&id=@@DOCID@@');
	//public static final String EVENT_REGISTRATION_URL= ((UserInfo.getOrganizationId()=='00D700000009I07EAE')?'https://wellmetricssurveys.secure.force.com/Event?id=@@EVENTID@@&sid=@@SLOTID@@':'https://wellmetricssurveys.dev1.cs30.force.com/Event?id=@@EVENTID@@&sid=@@SLOTID@@');
	//public static final String EVENT_PUBLISH_REGISTRATION_URL= ((UserInfo.getOrganizationId()=='00D700000009I07EAE')?'https://wellmetricssurveys.secure.force.com/Event?id=':'https://wellmetricssurveys.dev1.cs30.force.com/Event?id=');	
	public static final String INCENTIVE_EVENT_URL= ((UserInfo.getOrganizationId()=='00D700000009I07EAE')?'https://wellmetricssurveys.secure.force.com/Incentive/@@PAGE@@?id=@@ID@@':(UserInfo.getOrganizationId()=='00DQ000000GJi1GMAT'?'https://wellmetricssurveys.staging.cs3.force.com/Incentive/@@PAGE@@?id=@@ID@@':'https://wellmetricssurveys.dev.cs3.force.com/Incentive/@@PAGE@@?id=@@ID@@'));
	
	public static final String INCENTIVE_PROGRAM_PAGE='IncentiveEventList';
	public static final String INCENTIVE_EVENT_PAGE='IncentiveEvent';
	public static final String OUTCOMES_TEST_INCLUDED_BLOOD_PRESSURE='Blood Pressure'; 
	public static final String OUTCOMES_TEST_INCLUDED_BMI='BMI';
	public static final String OUTCOMES_TEST_INCLUDED_GLUCOSE='Glucose';
	public static final String OUTCOMES_TEST_INCLUDED_TOBACCO='Tobacco';
	public static final String OUTCOMES_TEST_INCLUDED_CHOLESTEROL='Cholesterol';	
	public static final String OUTCOMES_TEST_INCLUDED_HDL='HDL';
	public static final String OUTCOMES_TEST_INCLUDED_TRIGLYCERIDES='Triglycerides';
	public static final String OUTCOMES_TEST_INCLUDED_LDL='LDL'; 
	public static final String OUTCOMES_TEST_INCLUDED_HDL_LDL='HDL:LDL';
	public static final String OUTCOMES_TEST_INCLUDED_WTHR='WtHR';
	public static final String OUTCOMES_TEST_INCLUDED_BODY_FAT='Body Fat %';
	public static final String OUTCOMES_TEST_INCLUDED_HEART_RATE='Heart Rate';
	public static final String OUTCOMES_TEST_INCLUDED_TCH_LDL='TCH/LDL';
	public static final String OUTCOMES_TEST_INCLUDED_TCH_HDL='TCH/HDL'; 
	public static final String OUTCOMES_TEST_INCLUDED_WAIST='Waist';
	public static final String OUTCOMES_TEST_INCLUDED_SYSTOLIC='Systolic';
	public static final String OUTCOMES_TEST_INCLUDED_DIASTOLIC='Diastolic';
	public static final String OUTCOMES_TEST_INCLUDED_WEIGHT='Weight';  
	public static final String OUTCOMES_TEST_INCLUDED_A1C='A1C';
	 
	public static final String OUTCOMES_IMPROVEMENT_TYPE_PERCENTAGE='Percentage';
	public static final String OUTCOMES_IMPROVEMENT_TYPE_VALUE='Value';
	public static final String OUTCOMES_IMPROVEMENT_TYPE_FACTOR='Factor';
	public static final String OUTCOMES_IMPROVEMENT_TYPE_CATEGORY='Category';

	public static final String OUTCOMES_MEDICALLY_INADVISABLE_BMI='BMI';
	public static final String OUTCOMES_MEDICALLY_INADVISABLE_BP='BP';
	public static final String OUTCOMES_MEDICALLY_INADVISABLE_LDL='LDL';
	public static final String OUTCOMES_MEDICALLY_INADVISABLE_GLUCOSE='Glucose';
	public static final String OUTCOMES_PHYSICIAN_ALTERNATIVE_ACTION='Physician Alternative Action';
	
	
	public static final String OUTCOMES_TEST_TYPE_BLOOD_PRESSURE='Blood Pressure';
	public static final String OUTCOMES_TEST_TYPE_SYSTOLIC='Systolic';
	public static final String OUTCOMES_TEST_TYPE_DIASTOLIC='Diastolic';
	public static final String OUTCOMES_TEST_TYPE_CHOLESTEROL='Cholesterol';
	public static final String OUTCOMES_TEST_TYPE_GLUCOSE_FASTING='Glucose Fasting';
	public static final String OUTCOMES_TEST_TYPE_GLUCOSE_NON_FASTING ='Glucose Non Fasting';
	public static final String OUTCOMES_TEST_TYPE_TRIGLYCERIDES='Triglycerides';
	public static final String OUTCOMES_TEST_TYPE_HDL='HDL';
	public static final String OUTCOMES_TEST_TYPE_LDL='LDL';
	public static final String OUTCOMES_TEST_TYPE_HDL_LDL='HDL/LDL';
	public static final String OUTCOMES_TEST_TYPE_HEART_RATE='Heart Rate';
	public static final String OUTCOMES_TEST_TYPE_BODY_FAT='Body Fat %';
	public static final String OUTCOMES_TEST_TYPE_BMI='BMI';
	public static final String OUTCOMES_TEST_TYPE_TCH_HDL='TCH/HDL';
	public static final String OUTCOMES_TEST_TYPE_WAIST_HEIGHT='Waist/Height';
	public static final String OUTCOMES_TEST_TYPE_TCH_LDL='TCH/LDL';
	public static final String OUTCOMES_TEST_TYPE_WAIST='Waist';
	public static final String OUTCOMES_TEST_TYPE_TOBACCO='Tobacco';
	public static final String OUTCOMES_TEST_TYPE_WEIGHT='Weight';
	public static final String OUTCOMES_TEST_TYPE_HEIGHT='Height';
	public static final String OUTCOMES_TEST_TYPE_GLUCOSE='Glucose';
	public static final String OUTCOMES_TEST_TYPE_A1C='A1C';
	
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_PAP_SMEAR='Pap Smear';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_MAMMOGRAM='Mammogram';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_PCP='PCP';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_PCP_FOLLOW_UP_2='PCP Follow Up 2';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_COLORECTAL='Colorectal';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_PROSTATE='Prostate';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_COLONOSCOPY='Colonoscopy';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_DENTAL='Dental';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_VISION='Vision';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI1 ='Pregnancy Program-Tri 1';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI2 ='Pregnancy Program-Tri 2';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_ATTESTATION ='Tobacco Attestation';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_CHECK_IN_CHECK_UP ='Check In-Check Up';
	
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_2ND_HEMOGLOBIN_A1C ='2nd Hemoglobin A1C';
	public static final String PRVENTIVE_SCREENING_TEST_TYPE_URINE_PROTEIN_TEST ='Urine Protein Test';
			
	public static Set<String> SetLimeadePreventiveScreeningRangeTypes=new Set<String>(); 
	static
	{
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_PAP_SMEAR);
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_MAMMOGRAM);  
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_PCP);
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_PCP_FOLLOW_UP_2);  
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_COLORECTAL);
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_PROSTATE);  
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_COLONOSCOPY);
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_DENTAL);  
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_VISION);
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI1);  
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_PREGNANCY_PROGRAM_TRI2);
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_ATTESTATION);
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_TOBACCO_CHECK_IN_CHECK_UP);
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_2ND_HEMOGLOBIN_A1C); 
		SetLimeadePreventiveScreeningRangeTypes.add(PRVENTIVE_SCREENING_TEST_TYPE_URINE_PROTEIN_TEST);   						
	}	
	/*public static Set<String> SetOutcomesTestTypes=new Set<String>(); 
	static
	{
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_SYSTOLIC);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_DIASTOLIC);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_CHOLESTEROL);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_GLUCOSE);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_TRIGLYCERIDES);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_HDL);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_LDL);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_HDL_LDL);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_HEART_RATE);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_BODY_FAT);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_BMI);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_TCH_HDL);
		SetOutcomesTestTypes.add(OUTCOMES_TEST_TYPE_WAIST_HEIGHT); 
	}	*/
	
	public static Set<String> SetLimeadeSendOrderTypes=new Set<String>(); 
	static
	{
		SetLimeadeSendOrderTypes.add('HTK');
		SetLimeadeSendOrderTypes.add('Onsite Test');  
		SetLimeadeSendOrderTypes.add('Physician Form');
		SetLimeadeSendOrderTypes.add('Lab Test');
		SetLimeadeSendOrderTypes.add('External Data');
		SetLimeadeSendOrderTypes.add('Venipuncture');
		SetLimeadeSendOrderTypes.add('Wellness Center');
		//SetLimeadeSendOrderTypes.add('Preventative Screening');  
	}
	public static Set<String> SetLimeadeValidateOrderTypes=new Set<String>(); 
	static
	{
		SetLimeadeValidateOrderTypes.add('HTK');
		SetLimeadeValidateOrderTypes.add('Onsite Test');  
		SetLimeadeValidateOrderTypes.add('Physician Form');
		SetLimeadeValidateOrderTypes.add('Lab Test');
		SetLimeadeValidateOrderTypes.add('External Data');
		SetLimeadeValidateOrderTypes.add('Venipuncture');
		SetLimeadeValidateOrderTypes.add('Wellness Center');
		SetLimeadeValidateOrderTypes.add('Tobacco Attestation');
		SetLimeadeValidateOrderTypes.add('CHP- Vision Screening Visit');  
		SetLimeadeValidateOrderTypes.add('CHP- Dental Visit');
		SetLimeadeValidateOrderTypes.add('CHP- PCP Visit');
		SetLimeadeValidateOrderTypes.add('Preventative Screening');    
	}	
	public static Set<String> SetLimeadePreventiveScreeningOrderTypes=new Set<String>(); 
	static
	{
		SetLimeadePreventiveScreeningOrderTypes.add('Tobacco Attestation');
		SetLimeadePreventiveScreeningOrderTypes.add('CHP- Vision Screening Visit');  
		SetLimeadePreventiveScreeningOrderTypes.add('CHP- Dental Visit');
		SetLimeadePreventiveScreeningOrderTypes.add('CHP- PCP Visit');
		SetLimeadePreventiveScreeningOrderTypes.add('Preventative Screening');  
	}	
	public static Map<String,String> MAPTIMEZONES=new Map<String,String>(); 
	static
	{
		mapTimeZones.put('EST','America/New_York');
		mapTimeZones.put('CST','America/Chicago'); 
		mapTimeZones.put('MST','America/Denver');
		mapTimeZones.put('PST','America/Los_Angeles');
		mapTimeZones.put('AKST','America/Anchorage');  
	}
	public static Map<String,String> MAPRANGETESTORDERFIELD=new Map<String,String>(); 
	static
	{
		MAPRANGETESTORDERFIELD.put('BMI','Range_BMI__c');
		MAPRANGETESTORDERFIELD.put('Systolic','Range_Systolic__c'); 
		MAPRANGETESTORDERFIELD.put('Diastolic','Range_Diastolic__c'); 
		MAPRANGETESTORDERFIELD.put('Tobacco','Range_Tobacco__c');
		MAPRANGETESTORDERFIELD.put('Waist','Range_Waist__c');

		MAPRANGETESTORDERFIELD.put('A1C','Range_A1C__c');
		MAPRANGETESTORDERFIELD.put('Heart Rate','Range_HR_Pulse__c'); 
		MAPRANGETESTORDERFIELD.put('HDL/LDL','Range_LDL_HDL_Ratio__c');
		MAPRANGETESTORDERFIELD.put('Cholesterol','Range_RCho__c');
		MAPRANGETESTORDERFIELD.put('Glucose Fasting','Range_RFpg__c');
		MAPRANGETESTORDERFIELD.put('Glucose Non Fasting','Range_RFpg__c');
		MAPRANGETESTORDERFIELD.put('HDL','Range_RHdl__c');
		MAPRANGETESTORDERFIELD.put('LDL','Range_RLdl__c'); 
		MAPRANGETESTORDERFIELD.put('Triglycerides','Range_RTrig__c');
		MAPRANGETESTORDERFIELD.put('TCH/HDL','Range_TC_HDL_Ratio__c');
		MAPRANGETESTORDERFIELD.put('TCH/LDL','Range_TC_LDL_Ratio__c');
		MAPRANGETESTORDERFIELD.put('Weight','Range_Weight__c');		
	}
	public static Map<String,String> MAPTESTORDERFIELD=new Map<String,String>(); 
	static
	{
		MAPTESTORDERFIELD.put('BMI','BMI_Best__c');
		MAPTESTORDERFIELD.put('Systolic','BP_Systolic_Best__c'); 
		MAPTESTORDERFIELD.put('Diastolic','BP_Diastolic_Best__c');
		MAPTESTORDERFIELD.put('Tobacco','Tobacco_Free_Best__c');
		MAPTESTORDERFIELD.put('Waist','Waist_Best__c');
		
		MAPTESTORDERFIELD.put('A1C','A1C_Best__c');
		MAPTESTORDERFIELD.put('Heart Rate','HR_Pulse_Best__c'); 
		MAPTESTORDERFIELD.put('HDL/LDL','LDL_HDL_Ratio_Best__c');
		MAPTESTORDERFIELD.put('Cholesterol','RCho_Best__c');
		MAPTESTORDERFIELD.put('Glucose Fasting','RFpg_Best__c');
		MAPTESTORDERFIELD.put('Glucose Non Fasting','RFpg_Best__c');
		MAPTESTORDERFIELD.put('HDL','RHdl_Best__c');
		MAPTESTORDERFIELD.put('LDL','RLdl_Best__c'); 
		MAPTESTORDERFIELD.put('Triglycerides','RTrig_Best__c');
		MAPTESTORDERFIELD.put('TCH/HDL','TC_HDL_Ratio_Best__c');
		MAPTESTORDERFIELD.put('TCH/LDL','TC_LDL_Ratio_Best__c');
		MAPTESTORDERFIELD.put('Weight','Weight_Best__c');

	}	
}