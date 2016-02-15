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
private class WithingsContactCXTest {
    
    static Account objAcc;
    static Contact objCon;
    static EmailTemplate e;
    static WithingsContactCX ext;
    
    static boolean isValidUser=true;
    
    
    static void testSetup(){
        
        objAcc = TestUtility.createAccount(1);
        insert objAcc;
        
        Program__c objProg = TestUtility.createProgram(1, objAcc);
        insert objProg;
        
        Contact coach = TestUtility.createStandardContact(1);
        insert coach;
        
        objCon = TestUtility.createParticipantContact(1, objAcc, 'tester@gmail.com', 
                                                        objProg, coach);
        if(! isValidUser){
            objCon.Withings_User__c=false;
            isValidUser=true;
        }
        insert objCon;
        
        e = TestUtility.createEmailTemplate();
        
        
        ApexPages.StandardController con = new ApexPages.StandardController(objCOn);
        ext = new WithingsContactCX(con);
        
    }   //  end of testSetup
    
    
    static testMethod void testsendEmails() {
        testSetup();
        
        PageReference ref = ext.sendEmail();
        system.assertEquals(null, ref);
    }   //  end of testsendEmails
    
    static testMethod void testgoBack() {
        testSetup();
        
        PageReference ref = ext.goBack();
        
        system.assert(ref.getUrl().endsWith(objCon.Id));
    }   //  end of testgoBack
    
    static testMethod void testsendEmailsNonWithingsUser() {
        isValidUser=false;
        testSetup();
        
        PageReference ref = ext.sendEmail();
        
        system.assert(ext.message.contains('Contact is not a Withings User'));
        
    }   //  end of testsendEmailsNonWithingsUser
    
    /*static testMethod void testsendEmailsWithException() {
        testSetup();
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            insert e;
        }
        
        PageReference ref = ext.sendEmail();
        
        system.assert(ext.message.contains('Failed to send Email to the Selected Participating Contact'));
        
    }*/   //  end of testsendEmailsWithException
    
}   //  end of WithingsContactCXTest