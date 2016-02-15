/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
//@isTest (SeeAllData = true)
@isTest 
private class EventRegisterStep2Test {
	
	static WW_Event__c objEvent=null;
	static Program__c objProgram=null;
	static Slot__c objSlot=null;
	static Contact objCon=null;
	static EventRegisterStep2 con=null;
	
	static testMethod void testSetup(){
		Date tomorrow = Date.today().addDays(1);
    	Time morning = Time.newInstance(11, 0, 0, 0);
    	Datetime startDateTime = Datetime.newInstance(tomorrow, morning);
    	
    	objEvent = TestDataGenerator.getOneEvent();
    	objEvent.Validate_Contacts_Against_Limeade__c=true;
    	update objEvent;
    	
    	objProgram = TestDataGenerator.testProgram;
    	objProgram.Limeade_E_Id__c='TESTLIMEADEKEY';
    	objProgram.Limeade_PSK_ID__c='TESTAPIKEY123456';
    	update objProgram;
    	
    	objSlot = new Slot__c(WW_Event__c=objEvent.Id,Start_Date__c=startDateTime,End_Date__c=startDateTime.addMinutes(15),Type__c='Regular');
    	insert objSlot;
    	
    	Account theAccount = TestDataGenerator.testAccount;
		RecordType rt = [select id from RecordType where SobjectType='Contact' and Name = 'Participants' limit 1];
		objCon = new Contact( 
			AccountId = theAccount.Id, 
			RecordTypeId = rt.Id,
			FirstName = 'First', 
			LastName = 'Last', 
			Limeade_Identifier_Email__c = 'test1@limeade.com',
			Sex__c ='Male',
			Employee_Id__c = 'emp1233',
			Medical_History__c = 'None',
			MailingStreet = '11', MailingCity = 'Testville', MailingState = 'CA', MailingPostalCode = '99999');
		insert objCon;
    	
    	pageReference pageRef = new pageReference('/apex/EventRegisterStep2');
    	Test.setCurrentPage(pageRef);
    	
    	ApexPages.currentPage().getParameters().put('eid', objEvent.Id);
    	ApexPages.currentPage().getParameters().put('sid', objSlot.Id);
    	
    	
    	
	}	//	end of testSetup
	
	static testMethod void testConstructor(){
		
		testSetup();
		
		con = new EventRegisterStep2();
		
	}	//	end of testConstructor

    static testMethod void testSaveWithoutData() {
    	
    	testSetup();
    	con = new EventRegisterStep2();
    	con.save();
    	
    }	//	end of testSaveWithoutData
    
    static testMethod void testSaveWithSameData(){
    	testSetup();
    	objSlot.Email__c='test@test.com';
    	update objSlot;
    	
    	objCon.LastName = 'Last Test';
    	objCon.Email = 'test@test.com';
    	update objCon;
    	
    	con = new EventRegisterStep2();
    	con.s.First_Name__c='First Test';
    	con.s.Last_Name__c='Last Test';
    	con.s.Email__c='test@test.com';
    	con.dateOfBirth='01/01/1980';
    	con.agreement=true;
    	con.save();
    }	//	end of testSaveWithSameData
    
    static testMethod void testSaveWithInvalidDOB(){
    	testSetup();
    	
    	con = new EventRegisterStep2();
    	con.s.First_Name__c='First Test';
    	con.s.Last_Name__c='Last Test';
    	con.s.Email__c='test@test.com';
    	con.dateOfBirth='01/ab/1980';
    	con.agreement=true;
    	con.save();
    	
    }	//	end of testSaveWithInvalidDOB
    
    static testMethod void testSaveWithFutureDOB(){
    	testSetup();
    	
    	con = new EventRegisterStep2();
    	con.s.First_Name__c='First Test';
    	con.s.Last_Name__c='Last Test';
    	con.s.Email__c='test@test.com';
    	con.dateOfBirth='01/ab/2100';
    	con.agreement=true;
    	con.save();
    	
    }	//	end of testSaveWithFutureDOB
    
    static testMethod void testSaveWithData(){
    	testSetup();
    	
    	con = new EventRegisterStep2();
    	con.s.First_Name__c='First Test';
    	con.s.Last_Name__c='Last Test';
    	con.s.Email__c='test@test.com';
    	con.dateOfBirth='01/01/1980';
    	con.agreement=true;
    	con.save();
    	
    }	//	end of testSaveWithData
    
    
}	//	end of EventRegisterStep2Test