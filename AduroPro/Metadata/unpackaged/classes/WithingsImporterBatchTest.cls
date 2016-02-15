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
@isTest
private class WithingsImporterBatchTest {
	
	static Account objAcc;
	static Contact objCon;
	static Goal__c objGoal;
	
	static string requestKey='ABCD1234REQUESTKEY';
	static string requestSecret='ABCD1234REQUESTSECRET';
	static string oauthKey='ABCD1234OAUTHKEY';
	static string oauthSecret='ABCD1234OAUTHSECRET';
	static string userId='1234567';
	
	static void setupTest(){
		
		objAcc = TestUtility.createAccount(1);
		insert objAcc;
		
		Program__c objProg = TestUtility.createProgram(1, objAcc);
		insert objProg;
		
		Contact coach = TestUtility.createStandardContact(1);
		insert coach;
		
		objCon = TestUtility.createParticipantContact(1, objAcc, 'tester@gmail.com', 
														objProg, coach);
		objCon.Withings_User_Id__c=userId;
		objCon.Temp_Request_Key__c=requestKey;
		objCon.Temp_Request_Secret__c=requestSecret;
		objCon.Withings_User_Token__c=oauthKey;
		objCon.Withings_User_Secret__c=oauthSecret;
		insert objCOn;
		
		objGoal = TestUtility.createGoal(1, objCon);
		insert objGoal;
		
	}	//	end of setupTest
	
    static testMethod void testBatch() {
        setupTest();
        
        WithingsHelper.testMeasureData = TestUtility.getSampleMearuseData();
        
        Test.startTest();
        Database.executeBatch(new WithingsImporterBatch(), 10);
        Test.stopTest();
        
        objCon = [SELECT id, Name, Withings_Last_Updated__c FROM Contact WHERE Id = :objCon.Id];
        system.assertNotEquals(null, objCon.Withings_Last_Updated__c);
    }	//	end of testBatch
    
}	//	end of WithingsImporterBatchTest