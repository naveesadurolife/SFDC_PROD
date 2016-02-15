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
private class TestBatchClassOrderCleanUp {
	
	private static Account objAccount;
	private static Program__c objProgram;
	private static Order__c objOrder1;
	private static Order__c objOrder2;
	
	static void runBatchOrderCleanUp(){
        Test.startTest();
        
        BatchClassOrderCleanUp bcc = new BatchClassOrderCleanUp();
        
        Database.executeBatch(bcc);
        
        Test.stopTest();
        
    }//runBatchOrderCleanUp
    
    static void testData(){
    	
    	objAccount = TestUtility.createAccount(1);
    	insert objAccount;
    	
    	objProgram = TestUtility.createProgram(1, objAccount);
    	insert objProgram;
    	
    	date DOB = Date.newInstance(1980, 2, 17);
    	
    	objOrder1 = TestUtility.createOrder(1, objProgram, 'Onsite Test', 'abcd1234', date.today(), 'pFName', 'pLName', 'pemail@gmail.com', DOB);
    	objOrder1.Order_Status__c = 'Sent Limeade';
    	insert objOrder1;
    	
    	objOrder2 = TestUtility.createOrder(1, objProgram, 'Onsite Test', 'abcd1234', date.today(), 'pFName', 'pLName', 'pemail@gmail.com', DOB);
    	objOrder2.Order_Status__c = 'Sent Limeade';
    	insert objOrder2;
    	
    }// end of testData
    
    static testMethod void batchClassOrderCleanUpTest(){
    	
    	testData();
    	
    	runBatchOrderCleanUp();
    	
    	objOrder1 = [SELECT Id, Duplicate__c FROM Order__c WHERE Id = :objOrder1.Id ];
    	system.assertEquals(false, objOrder1.Duplicate__c);
    	
    	objOrder2 = [SELECT Id, Duplicate__c FROM Order__c WHERE Id = :objOrder2.Id ];
    	system.assertEquals(true, objOrder2.Duplicate__c);
    }// end of batchClassOrderCleanUpTest

}