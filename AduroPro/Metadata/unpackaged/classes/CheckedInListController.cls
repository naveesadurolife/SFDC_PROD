public class CheckedInListController {

	public List<Order__c> checkedinList {get; private set;} 
	public WW_Event__c event {get;private set;}

    public String eventid {get; private set;}
    
    public String searchString {get; set;}
    
    public List<string> alphabet{get;set;}
    
    private String filter = '';
    
    public CheckedInListController( ){
    	
    	searchString = '';
    	alphabet=new string[]{'all','a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };  
    	
    	eventid = '';
    	eventid = ApexPages.currentPage().getParameters().get('event');
        getCheckedInList();
    }
    
    private void getCheckedInList() {
    
    
    	checkedinList = new List<Order__c>();

    	checkedinList = [   SELECT 	o.Id, o.Name, o.WW_Event__c, o.PatientEmailH__c, o.PatientPrimaryPhone__c, o.Contact__c,
    								o.PatientDOB__c, o.EmployeeID__c, o.PatientFirstName__c, o.PatientLastName__c,HRA_Completed__c
                			FROM 	Order__c o 
                			WHERE 	(o.Order_Status__c = 'Submitted' OR (ProgramId__r.Screening_HRA__c=true AND HRA_Completed__c=null))
                				AND (o.Order_Type__c = 'Onsite Test' OR o.Order_Type__c = 'Wellness Center') 
                				AND o.WW_Event__c = :eventid LIMIT 1000 ];
                				
        event = 		   [SELECT 	e.Id, e.Name, e.Event_Date__c, e.Start_Time__c, e.End_Time__c, e.Event_Status__c, e.Employer__c, e.Program__c,Program__r.Screening_HRA__c
        			 	    FROM 	WW_Event__c e 
        			        WHERE 	e.Id = :eventid  ];
    }
    
    public PageReference filterList() {
    	
    	filter =  ApexPages.currentPage().getParameters().get('filter');
    	
    	if (null == filter || filter == 'all' || filter == '') {
    		getCheckedInList();
    	}else {
    		String filterAndWildcard = filter + '%';
    		checkedinList = [    SELECT o.Id, o.Name, o.WW_Event__c, o.PatientEmailH__c, o.PatientPrimaryPhone__c, 
    						o.PatientDOB__c, o.EmployeeID__c, o.PatientFirstName__c, o.PatientLastName__c
                			FROM Order__c o 
                			WHERE o.Order_Status__c = 'Submitted'
                				AND  o.Order_Type__c = 'Onsite Test'
                				AND  o.WW_Event__c = :eventid 
                				AND ( o.PatientFirstName__c LIKE :filterAndWildcard  OR o.PatientLastName__c LIKE :filterAndWildcard  ) LIMIT 500];
    	}
    	
    	return null;
	
    }
    
    public PageReference searchForEmployee() {

    	if (null == searchString ||  searchString == '') {
    		getCheckedInList();
    	}else {
    		String filterAndWildcard = '%' + searchString + '%';
    		
    		checkedinList = [    SELECT o.Id, o.Name, o.WW_Event__c, o.PatientEmailH__c, o.PatientPrimaryPhone__c, 
    						o.PatientDOB__c, o.EmployeeID__c, o.PatientFirstName__c, o.PatientLastName__c, o.Full_Name_Order__c
                			FROM Order__c o 
                			WHERE o.Order_Status__c = 'Submitted'
                				AND  o.Order_Type__c = 'Onsite Test'
                				AND  o.WW_Event__c = :eventid 
                				AND o.Full_Name_Order__c LIKE :filterAndWildcard  LIMIT 500];
    	}
    	
    	return null;
    }
    
    static testMethod void testCheckInController(){
    	Account acct = TestDataGenerator.getOneAccount();
    	Contact contact = TestDataGenerator.getOneContact();
    	WW_Event__c wwevent = TestDataGenerator.getOneEvent();
    	
    	PageReference ref = new PageReference('/apex/CheckedIn?event=' + wwevent.Id );
    	Test.setCurrentPage(ref); 
    
    	CheckedInListController controller = new CheckedInListController (); 
    	
  	
    	ref = new PageReference('/apex/CheckedIn?filter=all' );
    	Test.setCurrentPage(ref); 
    	controller.filterList();
    	
    	ref = new PageReference('/apex/CheckedIn?filter=m' );
    	Test.setCurrentPage(ref); 
    	controller.filterList();
    	
    	//finds nothing
    	controller.searchForEmployee();
    	controller.searchString = 'casp';
    	controller.searchForEmployee();
    	
    }
    

    

}