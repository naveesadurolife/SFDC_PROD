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
private class CreatePackagingSlipControllerTest {

	static Account objAcc;
	static list<WW_Event__c> lstAduroEvents = new list<WW_Event__c>();
	static Event_Series__c objEventSeries;
	
	
	static void setupTest(){
		objAcc = TestUtility.createEmployerAccount(1);
		insert objAcc;
		
		objEventSeries = new Event_Series__c(Name='Test Event Series');
		insert objEventSeries;
		
		for(integer i=0; i<10; i++){
			WW_Event__c objEvent = TestUtility.createEvent(i, objAcc);
			objEvent.Event_Series__c = objEventSeries.Id;
			lstAduroEvents.add(objEvent);
		}	//	end of for-each
		insert lstAduroEvents;
		
	}	//	end of setupTest
	
    static testMethod void testController() {
    	setupTest();
    	
    	ApexPages.StandardSetController sc = new ApexPages.StandardSetController(new list<Event_Series__c>{objEventSeries});
    	sc.setSelected(new list<Event_Series__c>{objEventSeries});
        CreatePackagingSlipController ext = new CreatePackagingSlipController(sc);
        
    }	//	end of testController
    
    
}	//	end of CreatePackagingSlipControllerTest