public with sharing class OnsiteHRASearch{
	public String contentType{get;Set;}
	public String renderAs{get;Set;}
	public Boolean showHeader{get;Set;}
	public Boolean sidebar{get;Set;}
	public Boolean standardStylesheets{get;Set;}
	public Boolean renderForm{get;Set;}
	public WW_Event__c eventForDate{get;Set;}
	public List<Order__c> listOrders{get;Set;}
	public List<csvWrapper> listOrdersText{get;Set;}
	public String csvText{get;Set;}
	public String startDate{get;Set;}
	public String endDate{get;Set;}
	public String hraExported{get;Set;}
	public Boolean includeHRAExported{get;Set;}
	public String exportDate{get;Set;}
	public String columnHeader{get;Set;}
	public String columnDescription{get;Set;}
	public OnsiteHRASearch()
	{
		hraExported='';
		contentType='';
		csvText='';
		showHeader=true;
		sidebar=true;
		standardStylesheets=true;
		renderForm=true;
		includeHRAExported=false;
		renderAs=ApexPages.currentPage().getParameters().get('e');
		startDate=ApexPages.currentPage().getParameters().get('sd');
		endDate=ApexPages.currentPage().getParameters().get('ed');
		hraExported=ApexPages.currentPage().getParameters().get('ex');
		eventForDate=new WW_Event__c();
		listOrders=new List<Order__c>();
		listOrdersText=new List<csvWrapper>();
		if(!String.isBlank(renderAs) && renderAs=='t')
		{
			eventForDate.Event_Date__c=Date.parse(startDate);
			eventForDate.Home_Test_Kit_Launch_Date__c=Date.parse(endDate);
			exportDate=startDate.replace('/','-')+'_'+endDate.replace('/','-');
			if(!String.isBlank(hraExported) && hraExported=='true')
			{
				includeHRAExported=true;
			}
			//search();
			contentType='application/octet-stream#test.csv';
			showHeader=false;
			sidebar=false;
			standardStylesheets=false;	
			renderForm=false;
			//csvText=getCSVText();
		}
		//application/octet-stream#{!fileName}.csv
	}
	
	public PageReference search()
	{
		listOrders=new List<Order__c>();
		listOrdersText=new List<csvWrapper>();
		Boolean errorOnPage=false;
		if(eventForDate.Event_Date__c==null || eventForDate.Home_Test_Kit_Launch_Date__c==null)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Start and End Dates are required.');
			ApexPages.addMessage(myMsg);				
			errorOnPage=true;
		}
		else if(eventForDate.Event_Date__c>eventForDate.Home_Test_Kit_Launch_Date__c)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'End Date must be greater or equal to start date.');
			ApexPages.addMessage(myMsg);				
			errorOnPage=true;
		}		
		if(!errorOnPage)
		{
			if(!includeHRAExported)
			{
				hraExported=' AND HRA_Exported__c=null';
			}
			else{
				hraExported='';
			}
			startDate=eventForDate.Event_Date__c.format();
			endDate=eventForDate.Home_Test_Kit_Launch_Date__c.format();
			Date startDateD=eventForDate.Event_Date__c;
			Date endDateD=eventForDate.Home_Test_Kit_Launch_Date__c;			
		//	String query=
			Set<Id> orderIds=new Set<Id>();
//////////////////////////////////
List<HRA__c> hraList=[Select Id,Column_Header__c,Description__c,Convert_Picklist_Value__c,
                      Order_API_Field_Name__c,Sort_Order__c From HRA__c Where Active__c=true Order By Sort_Order__c];
String fieldNames='';
Map<Decimal,HRA__c> mapHRA=new Map<Decimal,HRA__c>();
List<Decimal> HRASortOrder=new List<Decimal>();
for(HRA__c h:hraList)
{
    if(String.isNotBlank(h.Order_API_Field_Name__c))
    {
        if(fieldNames.length()>0)
        {
            fieldNames+=',';
        }
        fieldNames+=h.Order_API_Field_Name__c;
    }
    mapHRA.put(h.Sort_Order__c,h);
    HRASortOrder.add(h.Sort_Order__c);	
}
HRASortOrder.sort();	
columnHeader='';
columnDescription='';
for(Decimal sortOrder:HRASortOrder)
{
	if(columnHeader.length()>0)
	{
		columnHeader+=',';
	}
	HRA__c h=mapHRA.get(sortOrder);
	columnHeader+=h.Column_Header__c;
	columnDescription+='"'+h.Description__c.replace('"','')+'"';
}
/*
'
					 +' HRA_Sex__c,HRA_Age__c,HRA_Know_High_Blood_Pressure__c,HRA_Know_High_Cholesterol__c,HRA_Know_Good_Cholesterol__c, '
					 +' HRA_Know_Blood_Sugar__c,HRA_How_many_alcoholic_drinks__c,HRA_Use_Medication_For_Mood__c,HRA_Medical_Conditions__c , '
					 +' HRA_You_Have_Stress__c,HRA_How_Often_Have_You_Felt_Depressed__c,HRA_Medication_For_Anxiety_or_Depression__c, '
					 +' HRA_Do_you_smoke__c,HRA_How_often_do_you_exercise__c,HRA_how_would_you_describe_your_health__c, '
					 +' HRA_recurring_back_pain__c,HRA_puts_my_health_at_risk__c,HRA_do_extra_things_at_work__c, '
					 +' HRA_motivated_to_do_my_job__c,HRA_time_at_work_is_spent_wisely__c,HRA_give_my_all_work__c,HRA_absent_from_work__c, '
					 +' HRA_organization_support_healthier_life__c,HRA_well_being_in_my_life__c,HRA_Completed__c,HRA_Pregnant__c, '
					 +' PatientFirstName__c,PatientLastName__c,PatientDOB__c,PatientEmailH__c,HRA_Exported__c,EmployeeID__c
*/
////////////////////////////////
system.debug('Select Id,'+fieldNames+'  From Order__c  '
					 +' WHERE HRA_Completed__c>=:startDateD  '
					 +' AND HRA_Completed__c<=:endDateD '+hraExported);
			for(Order__c o:Database.query('Select Id,'+fieldNames+'  From Order__c  '
					 +' WHERE HRA_Completed__c>=:startDateD  '
					 +' AND HRA_Completed__c<=:endDateD '+hraExported))			
			{
				if(!String.isBlank(renderAs) && renderAs=='t')
				{
					orderIds.add(o.Id);
				}
				listOrders.add(o);
				listOrdersText.add(new csvWrapper(getCSVText(o,HRASortOrder,mapHRA)));
			}
			if(!String.isBlank(renderAs) && renderAs=='t' && !System.isBatch() && !System.isFuture() && !System.isScheduled())
			{
				UpdateOrders(orderIds);
			}			
		}
		return null;
	}
	public String getNewLine() {
	    return '\r\n';
	}	
	//@future 
	public static void UpdateOrders(Set<Id> orderIds)
	{
		if(orderIds!=null && orderIds.size()>0)
		{
			List<Order__c> updateOrders=new List<Order__c>();
			for(Id oid:orderIds)
			{
				updateOrders.add(new Order__c(Id=oid,HRA_Exported__c=Datetime.now()));
			}
			update updateOrders;
		}
	}
	public String getCSVText(Order__c o,List<Decimal> HRASortOrder,Map<Decimal,HRA__c> mapHRA)
	{
		csvText='';
		SObject obj=o;
		Integer i=0;
		for(Decimal sortOrder:HRASortOrder)
		{
			HRA__c h=mapHRA.get(sortOrder);
			String value='';
			//value=h.Column_Header__c;
			if(h.Convert_Picklist_Value__c && String.isNotBlank(h.Order_API_Field_Name__c))
			{
				value+=getPicklistValues(o,h.Order_API_Field_Name__c,String.valueOf(obj.get(h.Order_API_Field_Name__c)));	
			}
			else if(String.isNotBlank(h.Order_API_Field_Name__c))
			{
				value+=String.valueOf(obj.get(h.Order_API_Field_Name__c));	
			}
			value=value==null?'':value;
			value=value=='null'?'':value;
			if(i>0)
				csvText+=',';
			csvText+=value;
			i++;
		}
			/*csvText+=''+o.EmployeeID__c+',';	
			csvText+=''+o.PatientFirstName__c+' '+o.PatientLastName__c+',';	
			csvText+=''+o.HRA_Sex__c+',';	
			csvText+=''+o.HRA_Age__c+',';		
			csvText+=''+getPicklistValues(o,'HRA_Pregnant__c',o.HRA_Pregnant__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_Know_High_Blood_Pressure__c',o.HRA_Know_High_Blood_Pressure__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_Know_High_Cholesterol__c',o.HRA_Know_High_Cholesterol__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_Know_Good_Cholesterol__c',o.HRA_Know_Good_Cholesterol__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_Know_Blood_Sugar__c',o.HRA_Know_Blood_Sugar__c)+',';	
			//csvText+=''+getPicklistValues(o,'HRA_Know_High_Cholesterol__c',o.HRA_Know_High_Cholesterol__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_How_many_alcoholic_drinks__c',o.HRA_How_many_alcoholic_drinks__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_Use_Medication_For_Mood__c',o.HRA_Use_Medication_For_Mood__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_Medical_Conditions__c',o.HRA_Medical_Conditions__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_You_Have_Stress__c',o.HRA_You_Have_Stress__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_How_Often_Have_You_Felt_Depressed__c',o.HRA_How_Often_Have_You_Felt_Depressed__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_Medication_For_Anxiety_or_Depression__c',o.HRA_Medication_For_Anxiety_or_Depression__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_Do_you_smoke__c',o.HRA_Do_you_smoke__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_How_often_do_you_exercise__c',o.HRA_How_often_do_you_exercise__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_how_would_you_describe_your_health__c',o.HRA_how_would_you_describe_your_health__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_recurring_back_pain__c',o.HRA_recurring_back_pain__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_puts_my_health_at_risk__c',o.HRA_puts_my_health_at_risk__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_do_extra_things_at_work__c',o.HRA_do_extra_things_at_work__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_motivated_to_do_my_job__c',o.HRA_motivated_to_do_my_job__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_time_at_work_is_spent_wisely__c',o.HRA_time_at_work_is_spent_wisely__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_give_my_all_work__c',o.HRA_give_my_all_work__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_absent_from_work__c',o.HRA_absent_from_work__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_organization_support_healthier_life__c',o.HRA_organization_support_healthier_life__c)+',';	
			csvText+=''+getPicklistValues(o,'HRA_well_being_in_my_life__c',o.HRA_well_being_in_my_life__c);	
			*/
		return csvText;
	}
	public class csvWrapper
	{
		public String csvTextVar{get;Set;}
		public csvWrapper(String csvTextVar)
		{
			this.csvTextVar=csvTextVar;
		}
	}
   // Get a list of picklist values from an existing object field.
   public static String getPicklistValues(SObject obj, String fld,String value)
   {
      Map<String,Integer> options = new Map<String,Integer>();
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
	   Integer count=1;
      for (Schema.PicklistEntry a : values)
      {
         options.put(a.getValue(),count++);
      }
      return options.containsKey(value)?options.get(value)+'':'';
   }
}