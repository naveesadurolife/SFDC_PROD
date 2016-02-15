@isTest
private class TestPhase1Triggers {

    static testMethod void contactTriggerTest() {        
        Contact[] someContacts = TestDataGenerator.getContactList();
       	someContacts[0].Birthdate = date.newinstance(1960, 2, 17);
       	update someContacts[0];
       	String key = someContacts[0].LastName + '_'+ someContacts[0].Email + '_'
				+ someContacts[0].Birthdate.year() + someContacts[0].Birthdate.month() + someContacts[0].Birthdate.day();
       	Contact theResult = [SELECT Concat_Unique_Key__c FROM Contact WHERE Id = :someContacts[0].Id ];
       	key = key.toUpperCase();
       	system.assertEquals( theResult.Concat_Unique_Key__c, key );
       
    }
    
    static testMethod void orderTriggerTest() {
        Program__c testProg = TestDataGenerator.getOneProgram();
        Order__c theOrder = new Order__c( 
					ProgramID__c = testProg.Id, 
					PatientFirstName__c = 'Pete Soliant',
					PatientLastName__c = 'Jones',
					PatientEmailH__c = 'soliant_jones@example.com'
				);
		insert theOrder;
		theOrder = new Order__c( 
					ProgramID__c = testProg.Id, 
					PatientFirstName__c = 'Pete Soliant',
					PatientLastName__c = 'Jones',
					PatientEmailH__c = 'soliant_jones@example.com'
				);
		insert theOrder;
		Order__c[] theOrderResults = [SELECT Id, Contact__c, PatientEmailH__c FROM Order__c WHERE PatientEmailH__c = 'soliant_jones@example.com'];
		Contact[] theContactResults = [SELECT Id, Email FROM Contact WHERE Email = 'soliant_jones@example.com'];
       	system.assertEquals( theOrderResults.size(), 2 );
       	system.assertEquals( theContactResults.size(), 0 );       	
       	delete theOrderResults;
       	delete theContactResults;
       	
       	theOrder = new Order__c( 
					ProgramID__c = testProg.Id, 
					PatientFirstName__c = 'Pete Soliant',
					PatientLastName__c = 'Jones',
					PatientEmailH__c = 'soliant_jones@example.com',
					PatientDOB__c = date.newinstance(1969, 12, 9),
					Limeade_Participant_Code__c='123abc'
				);
		insert theOrder;
		theOrderResults = [SELECT Id, Contact__c, PatientEmailH__c FROM Order__c WHERE PatientEmailH__c = 'soliant_jones@example.com'];
		theContactResults = [SELECT Id, Email FROM Contact WHERE Email = 'soliant_jones@example.com'];
       	system.assertEquals( theOrderResults[0].PatientEmailH__c, theContactResults[0].Email );   
       	system.assertEquals( theOrderResults.size(), 1 );
       	system.assertEquals( theContactResults.size(), 1 );  	       
    }
    
    static testMethod void programTriggerTest() {
        Program__c testProg = TestDataGenerator.getOneProgram();
        testProg.Program_Start_Date__c = date.newinstance(2012, 3, 1);
        testProg.Program_End_Date__c = date.newinstance(2012, 5, 1);
        testProg.Include_HTK_Component__c = true;
        update testProg;
        Boolean result = false;

       	
       	testProg = TestDataGenerator.getOneProgram();
        testProg.Program_Start_Date__c = date.newinstance(2012, 3, 1);
        testProg.Program_End_Date__c = date.newinstance(2012, 5, 1);
        testProg.Include_HTK_Component__c = false;
        testProg.Include_Onsite_component__c = true;
        update testProg;
        Program__c prog3 = new Program__c( 
			Account__c = testProg.Account__c, 
			Name = 'prog3',
			Program_Start_Date__c = date.newinstance(2012, 3, 1),
			Program_End_Date__c = date.newinstance(2012, 6, 1),
			Include_HTK_Component__c = true
		);
		result = false;
		try{
			insert prog3;	
		} catch (Exception e) {
			result = true;
		}	  
       	system.assert( !result );  	
       
    }
}