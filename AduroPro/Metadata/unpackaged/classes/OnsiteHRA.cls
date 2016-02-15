public with sharing class OnsiteHRA{
	public WW_Event__c objEvent{get;set;}
	public Order__c objOrder{get;set;}
	public string eventId{get;set;}
	public string orderId{get;set;}
	public String errorMsg{get;Set;}
	public Boolean errorOnPage{get;Set;}
	public OnsiteHRA()
	{
		errorOnPage=false;
		eventId=ApexPages.currentPage().getParameters().get('event');
		orderId=ApexPages.currentPage().getParameters().get('oid');
		objEvent=[Select Id,Name  From WW_Event__c Where Id=:eventId];
		objOrder=[Select Id,HRA_Sex__c,HRA_Age__c,HRA_Know_High_Blood_Pressure__c,HRA_Know_High_Cholesterol__c,HRA_Know_Good_Cholesterol__c,
					HRA_Know_Blood_Sugar__c,HRA_How_many_alcoholic_drinks__c,HRA_Use_Medication_For_Mood__c,HRA_Medical_Conditions__c ,
					HRA_You_Have_Stress__c,HRA_How_Often_Have_You_Felt_Depressed__c,HRA_Medication_For_Anxiety_or_Depression__c,
					HRA_Do_you_smoke__c,HRA_How_often_do_you_exercise__c,HRA_how_would_you_describe_your_health__c,
					HRA_recurring_back_pain__c,HRA_puts_my_health_at_risk__c,HRA_do_extra_things_at_work__c,
					HRA_motivated_to_do_my_job__c,HRA_time_at_work_is_spent_wisely__c,HRA_give_my_all_work__c,HRA_absent_from_work__c,
					HRA_organization_support_healthier_life__c,HRA_well_being_in_my_life__c,HRA_Completed__c,HRA_Pregnant__c,
					PatientFirstName__c,PatientLastName__c,PatientDOB__c,PatientEmailH__c,EmployeeID__c From Order__c Where Id=:orderId];
	}
	public PageReference saveQuick()
	{
		update objOrder;
		return null;
	}
	public PageReference ToBiometrics()
	{
		save();
		PageReference pr;
		if(!errorOnPage || errorMsg=='This HRA is already completed')
		{
			pr=Page.OnsiteDataEntry;
			pr.setRedirect(true);
			pr.getParameters().put('orderid',objOrder.Id);		
		}
		return pr;		
	}	
	public PageReference save()
	{
		errorOnPage=false;
		PageReference pr;
		if(
			String.isBlank(objOrder.HRA_Sex__c) || String.isBlank(objOrder.HRA_Age__c)  || String.isBlank(objOrder.HRA_Pregnant__c) || String.isBlank(objOrder.HRA_Know_High_Blood_Pressure__c) || 
			String.isBlank(objOrder.HRA_Know_High_Cholesterol__c) || String.isBlank(objOrder.HRA_Know_Good_Cholesterol__c) || 
			String.isBlank(objOrder.HRA_Know_Blood_Sugar__c) || String.isBlank(objOrder.HRA_How_many_alcoholic_drinks__c) || String.isBlank(objOrder.HRA_Use_Medication_For_Mood__c) || 
			String.isBlank(objOrder.HRA_Medical_Conditions__c) || String.isBlank(objOrder.HRA_You_Have_Stress__c) || String.isBlank(objOrder.HRA_How_Often_Have_You_Felt_Depressed__c) || 
			String.isBlank(objOrder.HRA_Medication_For_Anxiety_or_Depression__c) || String.isBlank(objOrder.HRA_Do_you_smoke__c) || 
			String.isBlank(objOrder.HRA_How_often_do_you_exercise__c) || String.isBlank(objOrder.HRA_how_would_you_describe_your_health__c) || 
			String.isBlank(objOrder.HRA_recurring_back_pain__c) || String.isBlank(objOrder.HRA_puts_my_health_at_risk__c) || String.isBlank(objOrder.HRA_do_extra_things_at_work__c) || 
			String.isBlank(objOrder.HRA_motivated_to_do_my_job__c) || String.isBlank(objOrder.HRA_time_at_work_is_spent_wisely__c) || String.isBlank(objOrder.HRA_give_my_all_work__c) || 
			String.isBlank(objOrder.HRA_absent_from_work__c) || String.isBlank(objOrder.HRA_organization_support_healthier_life__c) || String.isBlank(objOrder.HRA_well_being_in_my_life__c)
		)
		{
			errorOnPage=true;
			errorMsg='HRA still needs to be completed';	
		}
		else if(objOrder.HRA_Completed__c==null)
		{
			objOrder.HRA_Completed__c=Datetime.now();
			update objOrder;
			pr=Page.CheckedIn;
			pr.setRedirect(true);
			pr.getParameters().put('event',eventId);
		}
		else if(objOrder.HRA_Completed__c!=null)
		{
			errorOnPage=true;
			errorMsg='This HRA is already completed';				
		}
		return pr;
	}
	public PageReference cancel()
	{
		PageReference pr;
		pr=Page.CheckedIn;
		pr.setRedirect(true);
		pr.getParameters().put('event',eventId);		
		return pr;
	}	
	public list<SelectOption> getSex()
	{
		return getPicklistValues(objOrder, 'HRA_Sex__c',false);
	}
	public list<SelectOption> getPregnant()
	{
		return getPicklistValues(objOrder, 'HRA_Pregnant__c',false);
	}	
	public list<SelectOption> getBloodPressure()
	{
		return getPicklistValues(objOrder, 'HRA_Know_High_Blood_Pressure__c',false);
	}
	public list<SelectOption> getHighCholesterol()
	{
		return getPicklistValues(objOrder, 'HRA_Know_High_Cholesterol__c',false);
	}
	public list<SelectOption> getGoodCholesterol()
	{
		return getPicklistValues(objOrder, 'HRA_Know_Good_Cholesterol__c',false);
	}	
	public list<SelectOption> getBloodSugar()
	{
		return getPicklistValues(objOrder, 'HRA_Know_Blood_Sugar__c',false);
	}	
	public list<SelectOption> getAlcoholicDrinks()
	{
		return getPicklistValues(objOrder, 'HRA_How_many_alcoholic_drinks__c',false);
	}
	public list<SelectOption> getMedicationForMood()
	{
		return getPicklistValues(objOrder, 'HRA_Use_Medication_For_Mood__c',false);
	}
	public list<SelectOption> getMedicalConditions()
	{
		return getPicklistValues(objOrder, 'HRA_Medical_Conditions__c',true);
	}
	public list<SelectOption> getHaveStress()
	{
		return getPicklistValues(objOrder, 'HRA_You_Have_Stress__c',true);
	}
	public list<SelectOption> getFeltDepressed()
	{
		return getPicklistValues(objOrder, 'HRA_How_Often_Have_You_Felt_Depressed__c',false);
	}
	public list<SelectOption> getAnxietyDepression()
	{
		return getPicklistValues(objOrder, 'HRA_Medication_For_Anxiety_or_Depression__c',false);
	}	
	public list<SelectOption> getSmoke()
	{
		return getPicklistValues(objOrder, 'HRA_Do_you_smoke__c',false);
	}
	public list<SelectOption> getExercise()
	{
		return getPicklistValues(objOrder, 'HRA_How_often_do_you_exercise__c',false);
	}	
	public list<SelectOption> getDescribeHealth()
	{
		return getPicklistValues(objOrder, 'HRA_how_would_you_describe_your_health__c',false);
	}	
	public list<SelectOption> getBackpain()
	{
		return getPicklistValues(objOrder, 'HRA_recurring_back_pain__c',true);
	}	
	public list<SelectOption> getHealthrisk()
	{
		return getPicklistValues(objOrder, 'HRA_puts_my_health_at_risk__c',true);
	}	
	public list<SelectOption> getExtraThingsAtWork()
	{
		return getPicklistValues(objOrder, 'HRA_do_extra_things_at_work__c',true);
	}	
	public list<SelectOption> getMotivatedToDoJob()
	{
		return getPicklistValues(objOrder, 'HRA_motivated_to_do_my_job__c',true);
	}	
	public list<SelectOption> getSpentWisely()
	{
		return getPicklistValues(objOrder, 'HRA_time_at_work_is_spent_wisely__c',true);
	}	
	public list<SelectOption> getAllWork()
	{
		return getPicklistValues(objOrder, 'HRA_give_my_all_work__c',true);
	}	
	public list<SelectOption> getAbsentFromWork()
	{
		return getPicklistValues(objOrder, 'HRA_absent_from_work__c',true);
	}
	public list<SelectOption> getOrganizationSupportHealthierLife()
	{
		return getPicklistValues(objOrder, 'HRA_organization_support_healthier_life__c',true);
	}	
	public list<SelectOption> getWellBeing()
	{
		return getPicklistValues(objOrder, 'HRA_well_being_in_my_life__c',true);
	}	
   // Get a list of picklist values from an existing object field.
   public static list<SelectOption> getPicklistValues(SObject obj, String fld,Boolean addNone)
   {
      list<SelectOption> options = new list<SelectOption>();
      // Get the object type of the SObject.
      Schema.sObjectType objType = obj.getSObjectType();
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();      
      // Get a map of fields for the SObject
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
      // Get the list of picklist values for this field.
      list<Schema.PicklistEntry> values =
         fieldMap.get(fld).getDescribe().getPickListValues();
      // Add these values to the selectoption list.
	   if(addNone)
	   {
	   		options.add(new SelectOption('', 'Please Answer'));
	   }
      for (Schema.PicklistEntry a : values)
      {
         options.add(new SelectOption(a.getLabel(), a.getValue()));
      }
      return options;
   }	
}