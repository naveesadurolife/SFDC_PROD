/* 
 * Name: BridgeRESTCalloutUtilityTest
 * Type: Apex Class
 * Description:  This class is used to test the functinality build under BridgeRESTCalloutUtility for making bridge callouts. 
 * Change History:
 *===================================================================================================================================
 * Version     Author               Date             Description 
 * 1.0         Sreeni               01/17/2016       1. Initial Version created
 */
@isTest
private class BridgeRESTCalloutUtilityTest {

    static testMethod void BridgeRESTCalloutUtilityUnitTest1() {
        //Create a test userJSON
        CreateUserJSON newUser = CreateUserJSON.getTestUserJSON();
        Set<ID> setID = new Set<ID>();
        Account testAcc = new Account( Name='TestAcc01');
		insert testAcc;
		Program__c testPrg = new Program__c( Account__c = testAcc.Id, Name = 'TestProg01'); 
		insert testPrg;
		Range__c testRange = new Range__c(	Program__c = testPrg.Id,Demographic_Tag__c='TsetTag',Bridge_Qualified__c = true);
		insert testRange;
		Contact recCon = new Contact(FirstName='testFN',LastName='testLN',email='testFN@testLN.com');
		insert recCon;
		Order__c testOdr = new Order__c(Contact__c=recCon.id,ProgramID__c = testPrg.Id, Range_Tier__c = testRange.id,PatientFirstName__c = 'testFN01',PatientLastName__c = 'testLN01',PatientEmailH__c = 'test01@testmail01.com',PatientDOB__c = Date.newinstance(1999, 11, 9) ,Onsite_Card_Code__c = '123');
		insert testOdr;		
		
		BridgeRESTCalloutUtility.checkBridgeUserCreation(new List<Order__c>{testOdr});  
		
		testPrg.Enable_LMS_Bridge__c = true;
		update testPrg;
		BridgeRESTCalloutUtility.checkBridgeUserCreation(new List<Order__c>{testOdr});
		
		Test.startTest();		
        BridgeRESTCalloutUtility.createBridgeUser(new Set<ID>{testOdr.id});
        Test.stopTest();
    }
}