@isTest
private class OnsiteTest {
	private static Account acct ;
	private static Account aduroAccount ;
	private static Contact contact;
	private static Contact contact1;
	private static Program__c pro;
	private static WW_Event__c wwevent ;
	static void init()
	{
    	acct = TestDataGenerator.getOneAccount();
    	contact = TestDataGenerator.getOneContact();
    	contact1=contact.clone();
    	insert contact1;
    	contact1.LastName='Bloggs';
    	contact1.Employee_ID__c='41';
    	contact1.Birthdate=Date.newInstance(1976, 3, 12);
    	contact1.Email='ray@gmail.com';
    	update contact1;
    	pro=TestDataGenerator.getOneProgram();
    	wwevent = TestDataGenerator.getOneEvent();	
    	wwevent.Event_Type__c = 'Biometrics Event';
    	wwevent.Event_Date__c=Date.today().addYears(1);	
    	update wwevent;
    	
		RecordType rt = [select id from RecordType where SobjectType='Account' and Name = 'Employer' limit 1];
		aduroAccount = new Account( Name='ADURO Screening Event Staff', RecordTypeId = rt.id );
		insert aduroAccount;    	
	}
    static testMethod void myUnitTest() {
        init();
    	PageReference ref = new PageReference('/apex/EventList?type=checkin' );
    	Test.setCurrentPage(ref); 
    
    	EventListController controller = new EventListController (); 
    	system.assertEquals(controller.eventList.size()>0,true);
    	//////////////////////////////////
    	PageReference refOS= new PageReference('/apex/OnsiteStart?event='+controller.eventList[0].Id );
    	Test.setCurrentPage(refOS);  
    	OnsiteStart os=new OnsiteStart();
    	system.assertNotEquals(os.objEvent, null); 
    	//////////////////////////////////////////////
    	PageReference refCheckIn= new PageReference('/apex/CheckIn?event='+controller.eventList[0].Id );
    	Test.setCurrentPage(refCheckIn);  
    	CheckInControllerV2 cc=new CheckInControllerV2();
    	system.assertEquals(cc.checkinList.size()>0,true); 	
    	ApexPages.currentPage().getParameters().put('filter','J');
    	cc.filterList();  
    	system.assertEquals(cc.checkinList.size()>0,true);
    	cc.searchString='Jim';
    	cc.searchForEmployee(); 
    	system.assertEquals(cc.checkinList.size()>0,true);
    	cc.searchString='';
    	cc.searchForEmployee(); 
    	system.assertEquals(cc.checkinList.size()>0,true);  
    	ApexPages.currentPage().getParameters().put('filter','');
    	cc.filterList();  
    	system.assertEquals(cc.checkinList.size()>0,true);    	
    	cc.checkInNow();   	    	
    	cc.selectedContactId=cc.checkinList[0].Id;
    	cc.checkInNow();  
    	cc.selectedContactId=cc.checkinList[1].Id;
    	cc.cardCode='123';
    	cc.checkInNow(); 
    	cc.checkInNow();     	
    	cc.newOrder(); 
    	cc.selectedContactId=cc.checkinList[0].Id;
    	cc.cardCode='123';
    	cc.checkInNow(); 
    	cc.cardCode='1234';
    	PageReference pr=cc.checkInNow();    
    	system.assertNotEquals(pr, null); 
    	//////////////////////////////////////////////////
    	Test.startTest();
    	Test.setCurrentPage(pr);    
    	OnsiteNewOrderController onc=new OnsiteNewOrderController();	     
    	onc.cancelNewOrder();
    	onc.goBackToCheckinPage();	
    	onc.buildGenderList();
    	onc.submit();   	
    	onc.checkLimeade=true;
    	onc.submit();   	
    	system.debug('errorMessage=============================='+onc.errorMessage);
    	///////////////////////////////////////////////////////////
    	PageReference oer = new PageReference('apex/OnsiteEventResult?event='+controller.eventList[0].Id );
    	Test.setCurrentPage(oer);     	
    	OnsiteEventResult oerc=new OnsiteEventResult();
    	oerc.save();
    	oerc.getPeopleWithResults();
    	oerc.getPeopleCheckedInWithNoResults();
    	/////////////////////////////////////////////////////////
    	PageReference oenr = new PageReference('apex/OnsiteCheckedInWithNoResults?event='+controller.eventList[0].Id );
    	Test.setCurrentPage(oenr);     	
    	OnsiteCheckedInWithNoResults oenrc=new OnsiteCheckedInWithNoResults();   
    	oenrc.getPeopleCheckedInWithNoResults();
    	oenrc.cancelOrder(); 
    	/////////////////////////////////////////////////////////
    	PageReference oewr = new PageReference('apex/OnsitePeopleWithResults?event='+controller.eventList[0].Id );
    	Test.setCurrentPage(oewr);     	
    	OnsitePeopleWithResults oewrc=new OnsitePeopleWithResults();   
    	oewrc.getPeopleCheckedInWithResults()  ; 		
    	/////////////////////////////////////////////////////////
    	PageReference osp = new PageReference('apex/OnsiteStaff?event='+controller.eventList[0].Id +'&m=s' );
    	Test.setCurrentPage(osp);     	
    	OnsiteStaff osc=new OnsiteStaff();   
    	osc.getEventStaff();
    	
    	PageReference ospe = new PageReference('apex/OnsiteStaffEdit?event='+controller.eventList[0].Id );
    	Test.setCurrentPage(ospe);     	
    	OnsiteStaffEdit osce=new OnsiteStaffEdit();  
    	osce.save();   	
    	osce.con.FirstName='fname';
    	osce.con.LastName='lname';
    	osce.con.Email='test@adurolife.com';
    	osce.ParkingCredit=true;
    	osce.er.Role__c='Lead';
    	osce.save(); 
    	wwevent.Event_Lead__c= 	osce.con.id;
    	update wwevent;    	
    	ospe = new PageReference('apex/OnsiteStaffEdit?event='+controller.eventList[0].Id +'&sid='+osce.er.id);
    	Test.setCurrentPage(ospe);     	
    	osce=new OnsiteStaffEdit();    
    	osce.ParkingCredit=false;
    	osce.save();  	 

    	osp = new PageReference('apex/OnsiteStaff?event='+controller.eventList[0].Id +'&m=s' );
    	Test.setCurrentPage(osp);     	
    	osc=new OnsiteStaff();   
    	osc.getEventStaff();

    	/////////////////////////////////////////////////////////
    	PageReference oe = new PageReference('apex/OnsiteExpenses?event='+controller.eventList[0].Id +'&m=s' );
    	Test.setCurrentPage(oe);     	
    	OnsiteExpenses oec=new OnsiteExpenses();   
    	oec.getEventOnsiteExpenses();
    	oec.changeErrorMessageVisibility(false);	
    	
    	PageReference oeae = new PageReference('apex/OnsiteExpenseAddEdit?event='+controller.eventList[0].Id );
    	Test.setCurrentPage(oeae);     	
    	OnsiteExpenseAddEdit oeaec=new OnsiteExpenseAddEdit();  
    	oeaec.er.Expense_Type__c='Hours';
    	oeaec.er.Account__c=acct.Id;
    	oeaec.er.Contact__c=contact.Id;
    	oeaec.save();  
    	system.debug('errorMessage================'+oeaec.errorMessage);
    	oe = new PageReference('apex/OnsiteExpenses?event='+controller.eventList[0].Id +'&m=s' );
    	Test.setCurrentPage(oe);     	
    	oec=new OnsiteExpenses();   
    	oec.getEventOnsiteExpenses();    	
    	
    	system.assertNotEquals(oec.listER.size(), 0);
    	oeae = new PageReference('apex/OnsiteExpenseAddEdit?event='+controller.eventList[0].Id+'&eid='+oec.listER[0].Id);
    	Test.setCurrentPage(oeae);     	
    	oeaec=new OnsiteExpenseAddEdit();  
    	oeaec.er.Expense_Type__c='Hours';
    	oeaec.save();     
    	/////////////////////////
    	wwevent.Name='Kohl\'s Wellness Center- Patterson';
    	update wwevent;
    	try
    	{
    		User ku=[Select id From User Where Alias='Kohls'];
    		system.runAs(ku)
    		{
		    	ref = new PageReference('/apex/EventList?type=checkin' );
		    	Test.setCurrentPage(ref); 
		    
		    	controller = new EventListController (); 
		    	system.assertEquals(controller.eventList.size()>0,true);    			
    		}
    	}
    	catch(Exception ex){}
    	Test.stopTest();  	  	    	
    }
}