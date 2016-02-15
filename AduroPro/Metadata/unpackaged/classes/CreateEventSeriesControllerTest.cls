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
private class CreateEventSeriesControllerTest {

	static Account objAcc;
	static list<WW_Event__c> lstAduroEvents = new list<WW_Event__c>();
	
	
	static void setupTest(){
		objAcc = TestUtility.createEmployerAccount(1);
		insert objAcc;
		
		for(integer i=0; i<10; i++){
			lstAduroEvents.add(TestUtility.createEvent(i, objAcc));
		}	//	end of for-each
		insert lstAduroEvents;
	}	//	end of setupTest
	
	
    public static testMethod void testCreateEventSeries() {
        setupTest();
        
        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(lstAduroEvents);
        setCon.setSelected(lstAduroEvents);
        CreateEventSeriesController ext = new CreateEventSeriesController(setcon);
        
        Event_Series__c objEventSeries = ext.objEventSeries;
        system.assertEquals(objEventSeries.Name, 'SERIES: ' + lstAduroEvents[0].Name);
        
    }	//	end of testCreateEventSeries
    
    public static testMethod void testCreateEventSeriesSave() {
        setupTest();
        
        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(lstAduroEvents);
        setCon.setSelected(lstAduroEvents);
        CreateEventSeriesController ext = new CreateEventSeriesController(setcon);
        ext.save();
        
        Event_Series__c objEventSeries = ext.objEventSeries;
        system.assertEquals(objEventSeries.Name, 'SERIES: ' + lstAduroEvents[0].Name);
        
    }	//	end of testCreateEventSeries
    
    
}	//	end of Class