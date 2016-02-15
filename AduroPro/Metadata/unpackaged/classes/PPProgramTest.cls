@isTest
private class PPProgramTest {
	private static Account acct;
	private static Contact con;
	private static Program__c currentYearProgram;
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
	}	
    static testMethod void testPPProgram() {
        init();
        Test.startTest();
        Program__c p=[Select Id,Program_Number__c From Program__c Where Id=:currentYearProgram.Id];
		PageReference pageRef = Page.PPProgram;
        Test.setCurrentPage(pageRef);
		PPProgram pp=new PPProgram();
		pp.gotoSetp2();
		system.assertEquals(pp.errorMessage,'Please enter program number.');
		String progNumber=p.Program_Number__c.replace('PROG-','');
		system.debug('progNumber==========='+progNumber);	  
		pp.programNumber1=progNumber.substring(0,1);
		pp.programNumber2=progNumber.substring(1,2);
		pp.programNumber3=progNumber.substring(2,3);
		pp.programNumber4=progNumber.substring(3,4);
		pp.programNumber5=progNumber.substring(4,5);
		pp.programNumber6=progNumber.substring(5,6);
		system.debug('pp.programNumber1==========='+pp.programNumber1);
		system.debug('pp.programNumber2==========='+pp.programNumber2);
		system.debug('pp.programNumber3==========='+pp.programNumber3);
		system.debug('pp.programNumber4==========='+pp.programNumber4);
		system.debug('pp.programNumber5==========='+pp.programNumber5);
		system.debug('pp.programNumber6==========='+pp.programNumber6);	
		pp.gotoSetp2();	
		system.debug('pp.programNumber==========='+pp.programNumber);	
		system.assert(pp.step2);
		pp.gotoSetp3();
		system.assertEquals(pp.errorMessage,'Please enter First Name, Last Name, Date of Birth, Email and select document (only pdf, jpg, tif).');
		pp.dateOfBirth='1/1/2010';
		pp.firstName='firstName';
		pp.lastName='lastName';
		pp.email='abc@acme.com';
        Document dummyDocument = new Document();
        dummyDocument.name = 'abc.jpg';
		dummyDocument.body = Blob.valueOf('Unit Test Document Body');
		dummyDocument.folderid =[Select Id From Folder Where DeveloperName=:'Physician_FAX_Forms'].Id;
		//insert dummyDocument;
		pp.doc=dummyDocument;
		pp.gotoSetp3();
		system.debug('pp.doc.name==========='+pp.doc.name);
		system.debug('pp.programId==========='+pp.programId);
		system.debug('pp.errorMessage==========='+pp.errorMessage);
		system.assert(pp.step3);	 
        Test.stopTest();
    }
}