/* 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts. However, this class is
 * public because we want the test data singletons to be available to external
 * test classes. Only private top-level non-exception class types can be
 * marked as tests
 * 
 * Unit test methods take no arguments, commit no data to the database, and 
 * are flagged with the testMethod keyword in the method definition.
 *
 * Added 2011-12-21 tburre@soliantconsulting.com
 */
  
public class TestDataGenerator {

	// starts test data singletons
	//system.debug('\n\nIn the TestDataGen\n\n');
	
	public static User testUser = null;
	
	public static testMethod User getOneUser() {
		if ( null == TestDataGenerator.testUser ) {
			Profile sysAdminProfile = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1 ];
			TestDataGenerator.testUser = new User( FirstName='Jimmy' , LastName='Test' , Username='jimmytest@example.com', TimeZoneSidKey='GMT', Phone='(555) 555-1234',
				ProfileId=sysAdminProfile.Id, LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', Email='jimmytest@example.com', CommunityNickname='jtest', Alias='jtest' );
			insert TestDataGenerator.testUser;
		}
		return TestDataGenerator.testUser;
	}
	
	public static Account testAccount = null;
	
	public static testMethod Account getOneAccount() {
		if ( null == TestDataGenerator.testAccount ) {
			RecordType rt = [select id from RecordType where SobjectType='Account' and Name = 'Employer' limit 1];
			TestDataGenerator.testAccount = new Account( Name='Acme', RecordTypeId = rt.id );
			TestDataGenerator.testAccount.Limeade_e__c = 'wellmetrics demo';
			TestDataGenerator.testAccount.Limeade_PSK__c = 'b3dda09c-1317-433c-9809-359ce8f2f61f';
			insert TestDataGenerator.testAccount;
		}
		return TestDataGenerator.testAccount;
	}
	
	public static Account[] testAccountList = null;
	
	public static testMethod Account[] getAccountList() {
		if ( null == TestDataGenerator.testAccountList ) {
			RecordType rt = [select id from RecordType where SobjectType='Account' and Name = 'Employer' limit 1];
			TestDataGenerator.testAccountList = new List<Account>();
			for( Integer i = 0; i < 5; i++ ){
				Account acct = new Account( Name='Acme_'+i, RecordTypeId = rt.id );
				TestDataGenerator.testAccountList.add( acct );
			}
			
			insert TestDataGenerator.testAccountList;
		}
		return TestDataGenerator.testAccountList;
	}
	
	public static Contact testContact = null;
	
	public static testMethod Contact getOneContact() {
		if ( null == TestDataGenerator.testContact ) {
			Account theAccount = getOneAccount();
			RecordType rt = [select id from RecordType where SobjectType='Contact' and Name = 'Participants' limit 1];
			TestDataGenerator.testContact = new Contact( 
				AccountId = theAccount.Id, 
				RecordTypeId = rt.Id,
				FirstName = 'Jim', 
				LastName = 'Test', 
				Sex__c ='Male',
				Employee_Id__c = 'emp1233',
				Medical_History__c = 'None',
				MailingStreet = '11', MailingCity = 'Testville', MailingState = 'CA', MailingPostalCode = '99999', Email = 'testjim@example.com' );
			insert TestDataGenerator.testContact;
		}
		return TestDataGenerator.testContact;
	}
	
	public static Contact[] testContactList = null;
	
	public static testMethod Contact[] getContactList() {
		if ( null == TestDataGenerator.testContactList ) {			
			Account[] accounts = getAccountList();
			RecordType rt = [select id from RecordType where SobjectType='Contact' and Name = 'Participants' limit 1];
			TestDataGenerator.testContactList = new List<Contact>();
			for( Integer i = 0; i < 5; i++ ){
				Contact theContact = new Contact( 
				AccountId = accounts[i].Id,
				RecordTypeId = rt.Id, 
				FirstName = 'Jim_'+i, LastName = 'Test_'+i, Medical_History__c = 'None',
				MailingStreet = '11'+i, MailingCity = 'Testville', MailingState = 'CA', 
				MailingPostalCode = '99999', Email = i+'testjim@example.com' );
				
				TestDataGenerator.testContactList.add( theContact );
			}
			
			insert TestDataGenerator.testContactList;
		}
		return TestDataGenerator.testContactList;
	}
	
	public static Program__c testProgram = null;
	
	public static testMethod Program__c getOneProgram() {
		if ( null == TestDataGenerator.testProgram ) {
			Account theAccount = getOneAccount();
			TestDataGenerator.testProgram = new Program__c( 
				Account__c = theAccount.Id, 
				Name = 'AttackYourHeart' ,Limeade_Identifier_Email__c=true); 
			TestDataGenerator.testProgram.Limeade_E_Id__c = 'wellmetrics demo';
			TestDataGenerator.testProgram.Limeade_PSK_ID__c = 'b3dda09c-1317-433c-9809-359ce8f2f61f';
			insert TestDataGenerator.testProgram;
		}
		return TestDataGenerator.testProgram;
	}
	
	public static Program__c[] testProgramList = null;
	
	public static testMethod Program__c[] getProgramList() {
		if ( null == TestDataGenerator.testProgramList ) {			
			Account[] accounts = getAccountList();
			TestDataGenerator.testProgramList = new List<Program__c>();
			for( Integer i = 0; i < 5; i++ ){
				Program__c theProgram = new Program__c( 
					Account__c = accounts[i].Id, 
					Name = 'prog_'+i 
				);				
				TestDataGenerator.testProgramList.add( theProgram );
			}
			
			insert TestDataGenerator.testProgramList;
		}
		return TestDataGenerator.testProgramList;
	}
	
	public static Order__c testOrder = null;
	
	public static testMethod Order__c getOneOrder() {
		if ( null == TestDataGenerator.testOrder ) {
			Program__c theProgram = getOneProgram();
			TestDataGenerator.testOrder = new Order__c( 
					ProgramID__c = theProgram.Id,
					PatientFirstName__c = 'Pat',
					PatientLastName__c = 'Bloggs',
					PatientEmailH__c = 'rapsac@gmail.com',
					PatientDOB__c = Date.newinstance(1976, 12, 3) ,
					Onsite_Card_Code__c = '123'
			);
			insert TestDataGenerator.testOrder;
		}
		return TestDataGenerator.testOrder;
	}
	
	public static Order__c[] testOrderList = null;
	
	public static testMethod Order__c[] getOrderList() {
		if ( null == TestDataGenerator.testOrderList ) {			
			Program__c[] programs = getProgramList();
			TestDataGenerator.testOrderList = new List<Order__c>();
			for( Integer i = 0; i < 5; i++ ){
				Order__c theOrder = new Order__c( 
					ProgramID__c = programs[i].Id, 
					PatientFirstName__c = 'Pat_'+i,
					PatientLastName__c = 'Bear_'+i,
					PatientEmailH__c = i+'pb@example.com',
					PatientDOB__c = Date.newinstance(1960, 2, 17),
					Onsite_Card_Code__c = '123'
				);				
				TestDataGenerator.testOrderList.add( theOrder );
			}
			
			insert TestDataGenerator.testOrderList;
		}
		return TestDataGenerator.testOrderList;
	}
	
	public static WW_Event__c testEvent = null;
	
	public static testMethod WW_Event__c getOneEvent() {
		if ( null == TestDataGenerator.testEvent ) {
			Account theAccount = getOneAccount();
			Program__c theProgram = getOneProgram();
			TestDataGenerator.testEvent = new WW_Event__c( 
					Employer__c = theProgram.Account__c,
					Event_Status__c = 'Confirmed',
					Name = 'Test Event',
					Event_Date__c = Date.today(),
					Program__c = theProgram.Id
			);
			insert TestDataGenerator.testEvent;
		}
		return TestDataGenerator.testEvent;
	}


}