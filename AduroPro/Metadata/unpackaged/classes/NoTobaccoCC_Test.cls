@isTest
public with sharing class NoTobaccoCC_Test {
	
	public static testMethod void testController(){
		
		PageReference pageRef = Page.NoTobaccoForm;
        Test.setCurrentPage(pageRef);
		
		ApexPages.currentPage().getParameters().put('q1', 'FIRSTNAME');
		ApexPages.currentPage().getParameters().put('q2', 'LASTNAME');
		ApexPages.currentPage().getParameters().put('q5', 'TEST@TEST.COM');
		ApexPages.currentPage().getParameters().put('q6', 'EMPID');
		ApexPages.currentPage().getParameters().put('q7', 'b2cb8dd7-1b19-4ecb-9ede-33e40a6ecada'); 
		Account acct=TestDataGenerator.getOneAccount();
		Contact con=TestDataGenerator.getOneContact();
		con.Limeade_ParticipantCode__c='1234abcd';
		update con;
		
		Program__c objProg = TestDataGenerator.getOneProgram();
		objProg.Program_Start_Date__c=Date.newInstance(Date.today().year(), 1, 1);
		objProg.Program_End_Date__c=Date.newInstance(Date.today().year(), 12, 31);
		objProg.Limeade_Live_Date__c=Date.today(); 
		objProg.Program_Status__c='Active'; 
		objProg.Program_Manager__c=Userinfo.getUserId();
		objProg.Limeade_PSK_ID__c='b2cb8dd7-1b19-4ecb-9ede-33e40a6ecada';
		update objProg;
		
		NoTobaccoCC controller = new NoTobaccoCC();
		
			//	Aserting the list have the same info
		System.assertEquals(controller.lstFirstNameAlphas.size(), 9);
		System.assertEquals(controller.lstFirstNameAlphas[0], 'F');
		
		System.assertEquals(controller.lstLastNameAlphas.size(), 8);
		System.assertEquals(controller.lstLastNameAlphas[0], 'L');
		
		System.assertEquals(controller.lstEmailAlphas.size(), 13);
		System.assertEquals(controller.lstEmailAlphas[0], 'T');
		
		System.assertEquals(controller.lstEmployeeAlphas.size(), 5);
		System.assertEquals(controller.lstEmployeeAlphas[0], 'E');
		
	}	//	end of testController

}