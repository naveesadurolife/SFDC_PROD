public class OnsiteDataEntryController {


    public String orderid {get; private set;}

    public Order__c onsiteTest {get; set;}
    public Order__c onsiteTemp {get; set;}
    
    public String cardCode {get; set;}
    public String returnPage {get; set;}
    public Boolean overrideCardCode{get;set;}
    
    public WW_Event__c event {get; private set;}
    public String errorMessage {get; private set;}
	public String errorMessageStyle {get; private set;}
    
    private static final String VISIBLE_STYLE = '';
    private static final String INVISIBLE_STYLE = 'display:none;';
    //
    private InputCollector testInput;
    public InputCollector getTestInput() {
    	if (testInput == null){	testInput = new InputCollector();	} 
    	return testInput;
    }
    public void setTestInput(InputCollector value) {
    	testInput = value;
    }
    //
    private InputCollector testVerify  = new InputCollector();
    public InputCollector getTestVerify() {
    	return testVerify;
    }
    public void setTestVerify(InputCollector value) {
    	TestVerify = value;
    }

    public OnsiteDataEntryController( ){

		cardCode = '';
		overrideCardCode=false;
		onsiteTest = new Order__c();
    	onsiteTemp = new Order__c();
		errorMessage = '';
		errorMessageStyle = INVISIBLE_STYLE;
    	orderid = ApexPages.currentPage().getParameters().get('orderid');
    	returnPage = ApexPages.currentPage().getParameters().get('rp');
    	getOrder();

    }
    
    private void getOrder() {
    
    	Order__c[] orderList = [    SELECT o.Id,o.BMI__c,  o.WW_Event__c, o.PatientPrimaryPhone__c, o.PatientPhoneWork__c, o.Onsite_Test_Completed__c, 
    										 o.PatientPhoneHome__c, o.PatientPhoneCell__c, o.PatientLastName__c, o.PatientGender__c, o.EmployeeId__c,
    										 o.PatientFirstName__c, o.PatientEmailH__c, o.PatientDOB__c, o.Order_Status__c, o.Onsite_Tester_Name__c,
    										 o.Weight__c, o.Waist__c, o.Tobacco__c, o.Height_Inches__c, o.Height_Feet__c, o.HR_Pulse__c,
    										 o.Fasting_Y_N__c,  o.BP_Systolic__c, o.BP_Diastolic__c,Screening_Start_Time__c,Screening_End_Time__c,
    										 o.RTrig__c, o.RLdl__c, o.RHdl__c, o.RFpg__c, o.RCho__c, o.BF__c,
    										 o.Comment_Weight__c, o.Comment_Waist__c, o.Comment_Triglycerides__c, o.Comment_TChol__c,
    										 o.Comment_Systole__c, o.Comment_Smokefree__c, o.Comment_Sex__c, o.Comment_Pulse__c,
    										 o.Comment_LDL__c, o.Comment_Height_Inches__c, o.Comment_Height_Feet__c, o.Comment_HDL__c,
    										 o.Comment_Glucose__c, o.Comment_Fasting__c, o.Comment_Diastole__c, o.Comment_Bodyfat__c ,
    										 o.Onsite_Card_Code__c,
											 ProgramID__r.Test_Weight_Onsite__c, ProgramID__r.Test_Waist_Onsite__c, ProgramID__r.Test_Trig_Onsite__c,ProgramID__r.Body_Fat__c, 
											 ProgramID__r.Test_TC_Onsite__c, ProgramID__r.Test_LDL_Onsite__c, ProgramID__r.Test_Height_Onsite__c, ProgramID__r.Test_HR_Onsite__c, 
											 ProgramID__r.Test_HDL_Onsite__c, ProgramID__r.Test_Glucose_Onsite__c, ProgramID__r.Test_Glucose_HTK__c, ProgramID__r.Test_Cholesterol_HTK__c, 
											 ProgramID__r.Test_BP_Onsite__c, ProgramID__r.Test_BMI_Onsite__c,ProgramID__r.Tobacco_Saliva__c,
											 ProgramID__r.Venipuncture_Event_Test__c    										 
                						FROM Order__c o 
                						WHERE o.Id = :orderid LIMIT 1];
                						
        System.debug(logginglevel.Fine, orderList);
    						
        if ( orderList.size() < 1) {
        	return;
        }
        //else
    	onsiteTest = orderList[0];

    	WW_Event__c[] eventList = [ SELECT Name, Id, Event_Date__c,Program__r.Screening_HRA__c,Event_Type__c
    							FROM WW_Event__c
    							WHERE Id = :onsiteTest.WW_Event__c LIMIT 1];
    							
    	System.debug(logginglevel.Fine, eventList);
    							
    	if ( eventList.size() < 1) {
        	return;
        }
        //else
        event = new WW_Event__c();
        event = eventList[0];
		
		if(String.isNotBlank(event.Event_Type__c) && event.Event_Type__c=='Venipuncture' && String.isNotBlank(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c))
		{
			onsiteTest.ProgramID__r.Tobacco_Saliva__c=false;
			onsiteTest.ProgramID__r.Test_TC_Onsite__c=false;
			onsiteTest.ProgramID__r.Test_HDL_Onsite__c=false;
			onsiteTest.ProgramID__r.Test_Trig_Onsite__c=false;
			onsiteTest.ProgramID__r.Test_LDL_Onsite__c=false;
			onsiteTest.ProgramID__r.Test_Glucose_Onsite__c=false;
			onsiteTest.ProgramID__r.Test_Waist_Onsite__c=false;
			onsiteTest.ProgramID__r.Test_Height_Onsite__c=false;
			onsiteTest.ProgramID__r.Test_Weight_Onsite__c=false;
			onsiteTest.ProgramID__r.Test_HR_Onsite__c=false;
			onsiteTest.ProgramID__r.Test_BP_Onsite__c=false;
			onsiteTest.ProgramID__r.Body_Fat__c=false;
			
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_TOBACCO))
				onsiteTest.ProgramID__r.Tobacco_Saliva__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_CHOLESTEROL))
				onsiteTest.ProgramID__r.Test_TC_Onsite__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_HDL))
				onsiteTest.ProgramID__r.Test_HDL_Onsite__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_TRIGLYCERIDES))
				onsiteTest.ProgramID__r.Test_Trig_Onsite__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_LDL))
				onsiteTest.ProgramID__r.Test_LDL_Onsite__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_GLUCOSE))
				onsiteTest.ProgramID__r.Test_Glucose_Onsite__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_WAIST))
				onsiteTest.ProgramID__r.Test_Waist_Onsite__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_HEIGHT))
				onsiteTest.ProgramID__r.Test_Height_Onsite__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_WEIGHT))
				onsiteTest.ProgramID__r.Test_Weight_Onsite__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_HEART_RATE))
				onsiteTest.ProgramID__r.Test_HR_Onsite__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_BLOOD_PRESSURE))
				onsiteTest.ProgramID__r.Test_BP_Onsite__c=true;
			if(onsiteTest.ProgramID__r.Venipuncture_Event_Test__c.contains(Constant.OUTCOMES_TEST_TYPE_BODY_FAT))
				onsiteTest.ProgramID__r.Body_Fat__c=true;
						
		}
		
        testInput = new InputCollector();
        testVerify = new InputCollector();
        
        saveOrderToInputCollector (testInput);
        saveOrderToInputCollector (testVerify);
    }
    public void updateScreeningStart()
    {
    	try
    	{
			if(onsiteTest.Screening_Start_Time__c==null)
			{
				onsiteTest.Screening_Start_Time__c=Datetime.now();
				update onsiteTest;
			} 
    	}
    	catch(Exception ex){}   	
    }
     public PageReference submitOrder(){
     	errorMessage = '';
    	quickSaveOrder();
    	if ( errorMessage != '') {
    		return null;
    	} 
    	checkRequiredFields();
    	if ( errorMessage != '') {
    		return null;
    	} 
    	
    	onsiteTest.Order_Status__c = 'Received';
		if(onsiteTest.Screening_End_Time__c==null)
		{
			onsiteTest.Screening_End_Time__c=Datetime.now();
		}
    	update onsiteTest;
    	/*if(!String.isBlank(returnPage) && returnPage=='cwnr')
    	{
    		return new PageReference('/apex/OnsiteCheckedInWithNoResults?event=' + event.Id);
    	}
    	if(!String.isBlank(returnPage) && returnPage=='cwr')
    	{
    		return new PageReference('/apex/OnsitePeopleWithResults?event=' + event.Id);
    	}    	
    	else
    	{*/
    		return new PageReference('/apex/OnsiteTestSummary?id=' + onsiteTest.Id + '&event=' + event.Id+'&rp='+returnPage);
    	//}
    	
    }
    public List<SelectOption> getSmokeFreeOptions()
	 {
	 	List<SelectOption> listOptions=new List<SelectOption>();
		 listOptions.add(new SelectOption('','None'));
		 listOptions.add(new SelectOption('Y','Yes-Pass'));
		 listOptions.add(new SelectOption('N','No-Fail'));
		 listOptions.add(new SelectOption('','Declined'));
		 return listOptions;
	 }
    public PageReference ToHRA()
	 {
		 PageReference pr;
	 	quickSaveOrder();
		 if(String.isBlank(errorMessage))
		 {
			pr=Page.OnsiteHRA;
			pr.setRedirect(true);
			pr.getParameters().put('event',event.Id);		
			 pr.getParameters().put('oid',orderid);		
		 }
		 return pr;
	 }
    public PageReference quickSaveOrder(){
		errorMessage = '';
    	String noMatch = '';

		if((overrideCardCode==null || overrideCardCode==false ) && !cardCode.equalsIgnoreCase(onsiteTest.Onsite_Card_Code__c )){
    		noMatch = 'The Card Code you entered (' + cardCode +
    		           ')<br/>doesn\'t match the code supplied on Check-in (' + onsiteTest.Onsite_Card_Code__c + ')';
    		changeErrorMessageVisibility(true);
    		errorMessage = noMatch;
    		return null;
    	} 
    	
    	errorMessage = '';
    	noMatch = '';
		
    	if(testInput.PatientGender != testVerify.PatientGender ){  noMatch += ' [Gender] '; } 
    	if(testInput.Fasting != testVerify.Fasting ){  noMatch += ' [Fasting] '; } 
    	if(testInput.Height_Feet != testVerify.Height_Feet ){  noMatch += ' [Height (Feet)] '; } 
    	if(testInput.Height_Inches != testVerify.Height_Inches ){  noMatch += ' [Height (Inches)] '; } 
    	if(testInput.Waist != testVerify.Waist ){  noMatch += ' [Waist] '; } 
    	if(testInput.Weight != testVerify.Weight ){  noMatch += ' [Weight] '; } 
    	if(testInput.Pulse != testVerify.Pulse ){  noMatch += ' [Pulse] '; } 
    	if(testInput.Systole != testVerify.Systole ){  noMatch += ' [Systole] '; } 
    	if(testInput.Diastole != testVerify.Diastole ){  noMatch += ' [Diastole] '; } 
    	if(testInput.TotalCholesterol != testVerify.TotalCholesterol ){  noMatch += ' [Total Cholesterol] '; } 
    	if(testInput.HDL != testVerify.HDL ){  noMatch += ' [HDL] '; } 
    	if(testInput.LDL != testVerify.LDL ){  noMatch += ' [LDL] '; } 
    	if(testInput.Triglycerides != testVerify.Triglycerides ){  noMatch += ' [Triglicerides] '; } 
    	if(testInput.Glucose != testVerify.Glucose ){  noMatch += ' [Glucose] '; } 
    	if(testInput.Smokefree != testVerify.Smokefree ){  noMatch += ' [Tobacco Free?] '; } 
    	if(testInput.Bodyfat != testVerify.Bodyfat ){  noMatch += ' [Body Fat] '; } 
    	
    	System.debug(LoggingLevel.Fine,'SOLIANT NO MATCH ' +  noMatch);
    	System.debug(LoggingLevel.Fine, 'SOLIANT ' + testInput);
    	System.debug(LoggingLevel.Fine, 'SOLIANT ' + testVerify);
    	
    	if (noMatch != '') {
    		noMatch = 'The following fields don\'t match:<br/>' + noMatch;
    		changeErrorMessageVisibility(true);
    		errorMessage = noMatch;
    		return null;
    	}
		if(!String.isBlank(testInput.Height_Feet) && !isInteger(testInput.Height_Feet))
		{
			errorMessage='Please enter valid Height (Feet)';
			return null;
		}
		if(!String.isBlank(testInput.Height_Inches) && !isInteger(testInput.Height_Inches))
		{
			errorMessage='Please enter valid Height (Inches)';
			return null;
		}
		if(!String.isBlank(testInput.Waist) && !isInteger(testInput.Waist))
		{
			errorMessage='Please enter valid Waist';
			return null;
		}
		if(!String.isBlank(testInput.Pulse) && !isInteger(testInput.Pulse))
		{
			errorMessage='Please enter valid Pulse';
			return null;
		}
		if(!String.isBlank(testInput.Systole) && !isInteger(testInput.Systole))
		{
			errorMessage='Please enter valid Systole';
			return null;
		}
		if(!String.isBlank(testInput.Diastole) && !isInteger(testInput.Diastole))
		{
			errorMessage='Please enter valid Diastole';
			return null;
		}
		if(!String.isBlank(testInput.TotalCholesterol) && !isInteger(testInput.TotalCholesterol))
		{
			errorMessage='Please enter valid Total Cholesterol';
			return null;
		}
		if(!String.isBlank(testInput.HDL) && !isInteger(testInput.HDL))
		{
			errorMessage='Please enter valid HDL';
			return null;
		}
		if(!String.isBlank(testInput.LDL) && !isInteger(testInput.LDL))
		{
			errorMessage='Please enter valid LDL';
			return null;
		}
		if(!String.isBlank(testInput.Glucose) && !isInteger(testInput.Glucose))
		{
			errorMessage='Please enter valid Glucose';
			return null;
		}
		if(!String.isBlank(testInput.Bodyfat) && !isInteger(testInput.Bodyfat))
		{
			errorMessage='Please enter valid Bodyfat';
			return null;
		}
		if(!String.isBlank(testInput.Triglycerides) && !isInteger(testInput.Triglycerides))
		{
			errorMessage='Please enter valid Triglycerides';
			return null;
		}																						
    	//save the input to a temporary object so the values get converted to numbers:
    	saveInputToTemp();
    	
    	String outOfRange = '';
    	
    	/*if( (onsiteTemp.PatientGender__c != 'Male' && onsiteTemp.PatientGender__c != 'Female' && onsiteTemp.PatientGender__c != 'Other' ) 
    		&&  isBlank (onsiteTest.Comment_Sex__c ) && !(isBlank(onsiteTemp.PatientGender__c)) ){ 
    		outOfRange += ' [Gender (Values Allowed are: M, F and Other) ]<br/> '; 
    	} */
    	//    		&&  isBlank (onsiteTest.Comment_Sex__c ) && !(isBlank(onsiteTemp.PatientGender__c))
    	if( (testInput.PatientGender != 'M' && testInput.PatientGender != 'F'  ) ){ 
    		outOfRange += ' [Gender (Values Allowed are: M or F) ]<br/> '; 
    	}
    	  
    		//&&  isBlank (onsiteTest.Comment_Fasting__c ) && !(isBlank(onsiteTemp.Fasting_Y_N__c))
    	if( testInput.Fasting != 'Y' && testInput.Fasting != 'N' ){
    		outOfRange += ' [Fasting (Values allowed are: Y or N )]<br/> '; 
    	}
    	outOfRange += getRangeError(onsiteTemp.Height_Feet__c,onsiteTest.Comment_Height_Feet__c, 4, 7, ' [Height | Feet (Values can be between 4 and 7 feet)]<br/> ' );
    	outOfRange += getRangeError(onsiteTemp.Height_Inches__c,onsiteTest.Comment_Height_Inches__c, 0, 11, ' [Height | Inches (Values can be between 0 and 11 inches)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.Waist__c,onsiteTest.Comment_Waist__c, 15, 60, ' [Waist (Values can be between 15 and 60 inches)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.Weight__c,onsiteTest.Comment_Weight__c, 80, 400, ' [Weight (Values can be between 80 and 400 lbs)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.HR_Pulse__c,onsiteTest.Comment_Pulse__c, 45, 100, ' [Pulse (Values can be between 45 and 100 bpm)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.BP_Systolic__c,onsiteTest.Comment_Systole__c, 80, 160, ' [Blood Pressure | Systolic (Values can be between 80 and 160)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.BP_Diastolic__c,onsiteTest.Comment_Diastole__c, 60, 100, ' [Blood Pressure | Diastolic (Values can be between 60 and 100)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.RCho__c,onsiteTest.Comment_TChol__c, 60, 300, ' [Total Cholesterol (Values can be between 60 and 300)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.RHdl__c,onsiteTest.Comment_HDL__c, 15, 100, ' [HDL (If result is <15 or >100, write result in the comment section.)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.RLdl__c,onsiteTest.Comment_LDL__c, 10, 200, ' [LDL (If result is <0 or >200, write result in the comment section.)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.RTrig__c,onsiteTest.Comment_Triglycerides__c, 45, 650, ' [Triglycerides(If result is <45 or >650, write result in the comment section.)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.RFpg__c,onsiteTest.Comment_Glucose__c, 50, 300, ' [Glucose (Values can be between 50 and 300)]<br/> ' );
		outOfRange += getRangeError(onsiteTemp.BF__c,onsiteTest.Comment_Bodyfat__c, 6, 50, ' [Body Fat (Values can be between 6 and 50)]<br/> ' );
//   		&&  isBlank (onsiteTest.Comment_Smokefree__c ) && !(isBlank(onsiteTemp.Tobacco__c))
		//if( (!String.isBlank(testInput.Smokefree) && testInput.Smokefree != 'Y' && testInput.Smokefree != 'N' ) || (String.isBlank(testInput.Smokefree) && String.isBlank(onsiteTest.Comment_Smokefree__c))){
    	//	outOfRange += ' [Smoke Free (Values allowed are: Y and N ) or enter comments]<br/> '; 
    	//} 
		if( onsiteTest.ProgramID__r.Tobacco_Saliva__c && String.isBlank(onsiteTest.Comment_Smokefree__c)){
    		outOfRange += ' [Tobacco Free comments are required]<br/> '; 
    	} 
  
    	if (outOfRange != '') {
    		outOfRange = 'The following field values are out of range:<br/>' + outOfRange;
    		changeErrorMessageVisibility(true);
    		errorMessage = outOfRange;
    		return null;
    	}

		//all clear
		changeErrorMessageVisibility(false);
    	saveInputData();
    	//refresh all order data
    	return null;
    }
    public  List<SelectOption> getSmokeFreeList(){
    	List<SelectOption> SmokeFreeList= new List<SelectOption>();
		SmokeFreeList.add(new SelectOption('','None'));
    	SmokeFreeList.add(new SelectOption('Cotinine', 'Cotinine')); 
    	SmokeFreeList.add(new SelectOption('Affidavit', 'Affidavit')); 
    	SmokeFreeList.add(new SelectOption('Verbal', 'Verbal')); 
    	return SmokeFreeList;
    }    
    private String getRangeError (Decimal value, String comment , Integer low, Integer high, String message) {
    	if (null == value) {
    		return '';
    	}
    	if( (value < low || value > high )  &&  isBlank (comment)  ){
    		return message; 
    	}
    	return '';
    }
    
    private Boolean isBlank ( String val) {
    	if ( null == val || val == ''){
    		return true;
    	}
    	return false;
    }
    
   private Boolean isInteger(String tempInt)
   {
   		try
   		{
   			Integer.valueOf(tempInt);
   			return true;
   		}
   		catch(Exception ex){return false;}
   }
    private void changeErrorMessageVisibility(Boolean show) {
    	if ( show ) {
    		errorMessageStyle = VISIBLE_STYLE;
    	}else {
    		errorMessageStyle = INVISIBLE_STYLE;
    	}
    }
    
    private void saveInputToTemp(){
    	
    	//used to convert the string values of the input to mixed values of the SObject 
    	//(Strings are used on the UI because they look nicer (ie don't have 0.0 when empty))
    	onsiteTemp = new Order__c();
    	String gender =  testInput.PatientGender.toUpperCase();
    	
    	onsiteTemp.PatientGender__c = 	( gender.toUpperCase() == 'M' || gender.toUpperCase() == 'MALE' ) ? 'Male' : ( gender.toUpperCase() == 'F' || gender.toUpperCase() == 'FEMALE' ) ? 'Female' : gender;
		onsiteTemp.Fasting_Y_N__c =   	( testInput.Fasting.toUpperCase() == 'Y' || testInput.Fasting.toUpperCase() == 'YES' ) ? 'Y' : ( testInput.Fasting.toUpperCase() == 'N' || testInput.Fasting.toUpperCase() == 'NO' ) ? 'N' : testInput.Fasting;
		if ( !isBlank(testInput.Height_Feet)) 		    { onsiteTemp.Height_Feet__c    	=   Integer.valueOf(testInput.Height_Feet);            }
		if ( !isBlank(testInput.Height_Inches))         { onsiteTemp.Height_Inches__c  	=   Integer.valueOf(testInput.Height_Inches);          }
		if ( !isBlank(testInput.Waist))                 { onsiteTemp.Waist__c          	=   Integer.valueOf(testInput.Waist);                  }
		if ( !isBlank(testInput.Weight))                { onsiteTemp.Weight__c         	=   Integer.valueOf(testInput.Weight);                 }
		if ( !isBlank(testInput.Pulse))                 { onsiteTemp.HR_Pulse__c       	=   Integer.valueOf(testInput.Pulse);                  }
		if ( !isBlank(testInput.Systole))               { onsiteTemp.BP_Systolic__c    	=   Integer.valueOf(testInput.Systole);                }
		if ( !isBlank(testInput.Diastole))              { onsiteTemp.BP_Diastolic__c   	=   Integer.valueOf(testInput.Diastole);               }
		if ( !isBlank(testInput.TotalCholesterol))      { onsiteTemp.RCho__c           	=   Integer.valueOf(testInput.TotalCholesterol);       }
		if ( !isBlank(testInput.HDL))                   { onsiteTemp.RHdl__c           	=   Integer.valueOf(testInput.HDL);                    }
		if ( !isBlank(testInput.LDL))                   { onsiteTemp.RLdl__c           	=   Integer.valueOf(testInput.LDL);                    }
		if ( !isBlank(testInput.Triglycerides))         { onsiteTemp.RTrig__c          	=   Integer.valueOf(testInput.Triglycerides);          }
		if ( !isBlank(testInput.Glucose))			    { onsiteTemp.RFpg__c           	=   Integer.valueOf(testInput.Glucose);                }
		if ( !isBlank(testInput.Bodyfat))			    { onsiteTemp.BF__c           	=   Integer.valueOf(testInput.Bodyfat	);             }
		onsiteTemp.Tobacco__c =       	testInput.Smokefree;
		
		//update OnsiteTest;
    }
    
    private String checkRequiredFields() {
    
    	String required = '';
    
    	if ( isBlank(testInput.PatientGender) && String.isBlank(onsiteTest.Comment_Sex__c))         {required += ' [Gender] ';}
    	if ( isBlank(testInput.Fasting) && String.isBlank(onsiteTest.Comment_Fasting__c))               {required += ' [Fasting] ';}
    	if (onsiteTest.ProgramID__r.Test_Height_Onsite__c && isBlank(testInput.Height_Feet) && String.isBlank(onsiteTest.Comment_Height_Feet__c)) 		   {required += ' [Height(Feet)] ';}
    	if (onsiteTest.ProgramID__r.Test_Height_Onsite__c && isBlank(testInput.Height_Inches) && String.isBlank(onsiteTest.Comment_Height_Inches__c))         {required += ' [Height(Inches)] ';}
    	if (onsiteTest.ProgramID__r.Test_Waist_Onsite__c && isBlank(testInput.Waist) && String.isBlank(onsiteTest.Comment_Waist__c))                 {required += ' [Waist] ';}
    	if (onsiteTest.ProgramID__r.Test_Weight_Onsite__c && isBlank(testInput.Weight) && String.isBlank(onsiteTest.Comment_Weight__c))                {required += ' [Weight] ';}
    	if (onsiteTest.ProgramID__r.Test_HR_Onsite__c && isBlank(testInput.Pulse) && String.isBlank(onsiteTest.Comment_Pulse__c))                 {required += ' [Pulse] ';}
    	if (onsiteTest.ProgramID__r.Test_BP_Onsite__c && isBlank(testInput.Systole) && String.isBlank(onsiteTest.Comment_Systole__c))               {required += ' [Systole] ';}
    	if (onsiteTest.ProgramID__r.Test_BP_Onsite__c && isBlank(testInput.Diastole) && String.isBlank(onsiteTest.Comment_Diastole__c))              {required += ' [Diastole] ';}
    	if (onsiteTest.ProgramID__r.Test_TC_Onsite__c && isBlank(testInput.TotalCholesterol) && String.isBlank(onsiteTest.Comment_TChol__c))      {required += ' [TotalCholesterol] ';}
    	if (onsiteTest.ProgramID__r.Test_HDL_Onsite__c && isBlank(testInput.HDL) && String.isBlank(onsiteTest.Comment_HDL__c))                   {required += ' [HDL] ';}
    	if (onsiteTest.ProgramID__r.Test_LDL_Onsite__c && isBlank(testInput.LDL) && String.isBlank(onsiteTest.Comment_LDL__c))                   {required += ' [LDL] ';}
    	if (onsiteTest.ProgramID__r.Test_Trig_Onsite__c && isBlank(testInput.Triglycerides) && String.isBlank(onsiteTest.Comment_Triglycerides__c))         {required += ' [Triglicerides] ';}
    	if (onsiteTest.ProgramID__r.Test_Glucose_Onsite__c && isBlank(testInput.Glucose) && String.isBlank(onsiteTest.Comment_Glucose__c))			   {required += ' [Glucose] ';}
    	//if ( isBlank(testInput.Smokefree))             {required += ' [SmokeFree] ';}
    	
    	if (required != '') {
    		required = 'Please fill in the following required fields:<br/>' + required;
    		changeErrorMessageVisibility(true);
    		errorMessage = required;
    	}
    	
    	return required;
    }
    	
    
    //we want to display any values already on the order that have been saved
    private void saveOrderToInputCollector(InputCollector input){
    	
    	//used to convert the string values of the input to mixed values of the SObject 
    	//(Strings are used on the UI because they look nicer (ie don't have 0.0 when empty))

    	input.PatientGender 			= 		onsiteTest.PatientGender__c == 'Male' ? 'M' : onsiteTest.PatientGender__c == 'Female' ? 'F' : '';
		input.Fasting					=		onsiteTest.Fasting_Y_N__c;
		input.Height_Feet      			= 		String.valueOf(Integer.valueOf(onsiteTest.Height_Feet__c  ));
		input.Height_Inches    			= 		String.valueOf(Integer.valueOf(onsiteTest.Height_Inches__c));
		input.Waist            			= 		String.valueOf(onsiteTest.Waist__c        );
		input.Weight           			= 		String.valueOf(onsiteTest.Weight__c       );
		input.Pulse            			= 		String.valueOf(onsiteTest.HR_Pulse__c     );
		input.Systole          			= 		String.valueOf(onsiteTest.BP_Systolic__c  );
		input.Diastole         			= 		String.valueOf(onsiteTest.BP_Diastolic__c );
		input.TotalCholesterol 			= 		String.valueOf(onsiteTest.RCho__c         );
		input.HDL              			= 		String.valueOf(onsiteTest.RHdl__c         );
		input.LDL              			= 		String.valueOf(onsiteTest.RLdl__c         );
		input.Triglycerides    			= 		String.valueOf(onsiteTest.RTrig__c        );
		input.Glucose          			= 		String.valueOf(onsiteTest.RFpg__c         );
		input.Bodyfat	        		= 		String.valueOf(onsiteTest.BF__c           );
		input.Smokefree					=		onsiteTest.Tobacco__c;

    }
    
    private void saveInputData(){
    	
    	onsiteTest.PatientGender__c   =		onsiteTemp.PatientGender__c;   
		onsiteTest.Fasting_Y_N__c     =		onsiteTemp.Fasting_Y_N__c  ;   
		onsiteTest.Height_Feet__c     =		onsiteTemp.Height_Feet__c  ;   
		onsiteTest.Height_Inches__c   =		onsiteTemp.Height_Inches__c;   
		onsiteTest.Waist__c           =		onsiteTemp.Waist__c        ;   
		onsiteTest.Weight__c          =		onsiteTemp.Weight__c       ;   
		onsiteTest.HR_Pulse__c        =		onsiteTemp.HR_Pulse__c     ;   
		onsiteTest.BP_Systolic__c     =		onsiteTemp.BP_Systolic__c  ;   
		onsiteTest.BP_Diastolic__c    =		onsiteTemp.BP_Diastolic__c ;   
		onsiteTest.RCho__c            =		onsiteTemp.RCho__c         ;   
		onsiteTest.RHdl__c            =		onsiteTemp.RHdl__c         ;   
		onsiteTest.RLdl__c            =		onsiteTemp.RLdl__c         ;   
		onsiteTest.RTrig__c           =		onsiteTemp.RTrig__c        ;   
		onsiteTest.RFpg__c            =		onsiteTemp.RFpg__c         ;   
		onsiteTest.Tobacco__c         =		onsiteTemp.Tobacco__c      ;   
		onsiteTest.BF__c              =		onsiteTemp.BF__c           ;   
		onsiteTest.BMI__c=null;
		if(onsiteTest.Height_Inches__c!=null && onsiteTest.Weight__c!=null)
		{
			Decimal height_inches = onsiteTest.Height_Inches__c + (12 * onsiteTest.Height_Feet__c);
			if(height_inches!=0)
			{
				//onsiteTest.BMI__c= Integer.ValueOf(Math.floor(((onsiteTest.Weight__c/(height_inches*height_inches))*703)).round(System.RoundingMode.HALF_UP));
				onsiteTest.BMI__c= Integer.ValueOf(Math.floor(((onsiteTest.Weight__c/(height_inches*height_inches))*703)).setscale(1));
			}
		}
		if(overrideCardCode!=null && overrideCardCode)
		{
			OnsiteTest.Onsite_Card_Code__c=cardCode;
		}
		//onsiteTest.PatientDOB__c=onsiteTest.PatientDOB__c;
		update OnsiteTest;
    }
    
    public PageReference autofill(){
    	testInput.PatientGender      = 'Female';
		testInput.Fasting            = 'Y';
		testInput.Height_Feet        = '6';
		testInput.Height_Inches      = '4';
		testInput.Waist              = '34';
		testInput.Weight             = '120';
		testInput.Pulse              = '55';
		testInput.Systole            = '110';
		testInput.Diastole           = '80';
		testInput.TotalCholesterol   = '180';
		testInput.HDL                = '140';
		testInput.LDL                = '40';
		testInput.Triglycerides      = '200';
		testInput.Glucose            = '300';
		testInput.Smokefree          = 'y';
		testInput.Bodyfat            = '23';
		
		testVerify.PatientGender      = 'Female';
		testVerify.Fasting            = 'Y';
		testVerify.Height_Feet        = '6';
		testVerify.Height_Inches      = '4';
		testVerify.Waist              = '34';
		testVerify.Weight             = '120';
		testVerify.Pulse              = '55';
		testVerify.Systole            = '110';
		testVerify.Diastole           = '80';
		testVerify.TotalCholesterol   = '180';
		testVerify.HDL                = '140';
		testVerify.LDL                = '40';
		testVerify.Triglycerides      = '200';
		testVerify.Glucose            = '300';
		testVerify.Smokefree          = 'y';
		testVerify.Bodyfat            = '23';
		
		return null;
    }
    
    public class InputCollector {
    	
    	public String PatientGender {get;set;}
    	public String Fasting {get;set;}
    	public String Height_Feet {get;set;}
    	public String Height_Inches {get;set;}
    	public String Waist {get;set;}
    	public String Weight {get;set;}
    	public String Pulse {get;set;}
    	public String Systole {get;set;}
    	public String Diastole {get;set;}
    	public String TotalCholesterol {get;set;}
    	public String HDL {get;set;}
    	public String LDL {get;set;}
    	public String Triglycerides {get;set;}
    	public String Glucose {get;set;}
    	public String Smokefree {get;set;}
    	public String Bodyfat {get;set;}

    }
    
   static testMethod void testDataEntryController(){
    	Account acct = TestDataGenerator.getOneAccount();
    	Contact contact = TestDataGenerator.getOneContact();
    	WW_Event__c wwevent = TestDataGenerator.getOneEvent();
    	Order__c wworder = TestDataGenerator.getOneOrder();
    	wworder.WW_Event__c = wwevent.Id;
    	update wworder;
    	
    	PageReference ref = new PageReference('/apex/OnsiteDataEntry?orderid=' + wworder.Id );
    	Test.setCurrentPage(ref); 
    
    	OnsiteDataEntryController controller = new OnsiteDataEntryController (); 
    	controller.quickSaveOrder();
    	controller.submitOrder();
    	
    	controller.cardCode = '123';
    	
    	InputCollector input = controller.getTestInput();
    	input.PatientGender      = 'Female';
		input.Fasting            = 'Y';
		input.Height_Feet        = '6';
		input.Height_Inches      = '4';
		input.Waist              = '34';
		input.Weight             = '120';
		input.Pulse              = '55';
		input.Systole            = '110';
		input.Diastole           = '80';
		input.TotalCholesterol   = '180';
		input.HDL                = '140';
		input.LDL                = '40';
		input.Triglycerides      = '200';
		input.Glucose            = '300';
		input.Smokefree          = 'y';
		input.Bodyfat            = '23';

		controller.setTestInput(input);
		
		//test no verify set
		controller.quickSaveOrder();
    	controller.submitOrder();
    	
    	//test verify set
    	InputCollector verify = controller.getTestVerify();
    	verify.PatientGender      = 'Female';
		verify.Fasting            = 'Y';
		verify.Height_Feet        = '6';
		verify.Height_Inches      = '4';
		verify.Waist              = '34';
		verify.Weight             = '120';
		verify.Pulse              = '55';
		verify.Systole            = '110';
		verify.Diastole           = '80';
		verify.TotalCholesterol   = '180';
		verify.HDL                = '140';
		verify.LDL                = '40';
		verify.Triglycerides      = '200';
		verify.Glucose            = '300';
		verify.Smokefree          = 'y';
		verify.Bodyfat            = '23';
		controller.setTestVerify(verify);
		
		controller.quickSaveOrder();
    	controller.submitOrder();
    	
    	//test verify different
    	verify = controller.getTestVerify();
		verify.PatientGender      = 'different';
		verify.Fasting            = 'different';
		verify.Height_Feet        = 'different';
		verify.Height_Inches      = 'different';
		verify.Waist              = 'different';
		verify.Weight             = 'different';
		verify.Pulse              = 'different';
		verify.Systole            = 'different';
		verify.Diastole           = 'different';
		verify.TotalCholesterol   = 'different';
		verify.HDL                = 'different';
		verify.LDL                = 'different';
		verify.Triglycerides      = 'different';
		verify.Glucose            = 'different';
		verify.Smokefree          = 'different';
		verify.Bodyfat            = 'different';
		controller.setTestVerify(verify);
		
		controller.quickSaveOrder();
    	controller.submitOrder();
    	
    	//test values there and the same, but out of range:
    	input = controller.getTestInput();
		input.PatientGender      = 'Boggle';
		input.Fasting            = 'Woggle';
		input.Height_Feet        = '8';
		input.Height_Inches      = '14';
		input.Waist              = '400';
		input.Weight             = '600';
		input.Pulse              = '500';
		input.Systole            = '300';
		input.Diastole           = '300';
		input.TotalCholesterol   = '700';
		input.HDL                = '900';
		input.LDL                = '899';
		input.Triglycerides      = '800';
		input.Glucose            = '900';
		input.Smokefree          = 'Hey';
		input.Bodyfat            = '150';

		controller.setTestInput(input);

    	//test verify set
    	verify = controller.getTestVerify();
    	verify.PatientGender      = 'Boggle';
		verify.Fasting            = 'Woggle';
		verify.Height_Feet        = '8';
		verify.Height_Inches      = '14';
		verify.Waist              = '400';
		verify.Weight             = '600';
		verify.Pulse              = '500';
		verify.Systole            = '300';
		verify.Diastole           = '300';
		verify.TotalCholesterol   = '700';
		verify.HDL                = '900';
		verify.LDL                = '899';
		verify.Triglycerides      = '800';
		verify.Glucose            = '900';
		verify.Smokefree          = 'Hey';
		verify.Bodyfat            = '150';
		controller.setTestVerify(verify);
		
		controller.quickSaveOrder();
    	controller.submitOrder();
    	
    	//this method only really for debugging, but I'll leave in for now
    	controller.autoFill();
    	
    }

}