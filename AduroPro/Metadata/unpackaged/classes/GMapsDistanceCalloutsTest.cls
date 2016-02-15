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
private class GMapsDistanceCalloutsTest {

	static Account objAcc;
	static Contact objCon;
	static WW_Event__c objAduroEvent;
	static Event_Resource__c objEvtResource;
	
	
	static void setupTest(){
		objAcc = TestUtility.createEmployerAccount(1);
		insert objAcc;
		
		objCon = TestUtility.createStandardContactWithAddress(1);
		insert objCon;
		
		objAduroEvent = TestUtility.createEvent(1, objAcc);
		objAduroEvent.Event_Address__c = '1 Test Street, TestCity, VA, USA';
		insert objAduroEvent;
		
		objEvtResource = TestUtility.createEventResource(1, objAcc, objCon, objAduroEvent);
		
	}	//	end of setupTest
	
    static testMethod void myUnitTest() {
    	setupTest();
    	
    	Test.startTest();
    	
    	insert objEvtResource;
    	
    	Test.stopTest();
    	
    	Event_Resource__c objEvtRes = [SELECT Id, Name, Projected_Driving_Distance__c, Contact__r.Name, 
													Contact__r.MailingStreet, Contact__r.MailingCity, 
													Contact__r.MailingState, Contact__r.MailingPostalCode, 
													Contact__r.MailingCountry, WW_Event__r.Name, Event_Address_ER__c
											   FROM Event_Resource__c
											  WHERE Id = :objEvtResource.Id ];
    	
    	System.assertEquals('1,529 km', objEvtRes.Projected_Driving_Distance__c);
    	
    
    }	//	end of 
    
}	//	end of GMapsDistanceCalloutsTest