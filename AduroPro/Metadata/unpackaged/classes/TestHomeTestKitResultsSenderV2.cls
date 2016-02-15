@isTest
private class TestHomeTestKitResultsSenderV2 {

    /*static testMethod void test1HomeTestKitResultsSenderV2() {
        Test.StartTest();
        HomeTestKitResultsSenderV2 rs = new HomeTestKitResultsSenderV2('wellmetric demo', true);
        ID batchprocessid = Database.executeBatch(rs);
   		Test.StopTest();
    }
    
    static testMethod void test2HomeTestKitResultsSenderV2() {      
        Program__c testProgram = TestDataGenerator.getOneProgram();
        Order__c[] orders = new List<Order__c>();
        Set<Id> orderIds = new Set<Id>();
        for( Integer i = 0; i < 5; i++ ){
				Order__c theOrder = new Order__c( 
					ProgramID__c = testProgram.Id, 
					PatientFirstName__c = 'Pat_'+i,
					PatientLastName__c = 'SoliantBear_'+i,
					PatientEmailH__c = i+'pb@example.com',
					PatientDOB__c = date.newinstance(1960, 2, 17),
					Order_Type__c = 'HTK',
					Order_Status__c = 'Received'
				);				
				orders.add( theOrder );
		}
		for( Integer i = 5; i < 10; i++ ){
				Order__c theOrder = new Order__c( 
					ProgramID__c = testProgram.Id, 
					PatientFirstName__c = 'Pat_'+i,
					PatientLastName__c = 'SoliantBear_'+i,
					PatientEmailH__c = i+'pb@example.com',
					PatientDOB__c = date.newinstance(1960, 2, 17),
					Order_Type__c = 'HTK',
					Order_Status__c = 'Received',
					Height_Feet__c = 6.0, Height_Inches__c = 3.0,
        			Weight__c = 200.00, BMI__c = 30.00,
        			RLdl__c = 345.0, RHdl__c = 345.0, RTrig__c = 345.0,
        			RCho__c = 345.0, BP_Systolic__c = 345.0, BP_Diastolic__c = 345.0, RFpg__c = 40.0
				);				
				orders.add( theOrder );
		}
        insert orders;
       
        testProgram.Prevent_Automatic_Results_Transfer__c = true;
        testProgram.Limeade_Live_Date__c = date.newinstance(2011, 12, 20);
		
		orders = [ SELECT PatientEmailH__c, Order_Status__c, Limeade_E__c, Limeade_PSK__c, ProgramID__r.Limeade_Live_Date__c, Limeade_Transfer_Complete__c, Limeade_Transfer_First_Failed__c,
						Height_Feet__c, Height_Inches__c, Weight__c, BMI__c, RLdl__c, RHdl__c, RTrig__c, RCho__c, RFpg__c, BP_Systolic__c, BP_Diastolic__c, EmployeeID__c
				   FROM Order__c WHERE PatientLastName__c LIKE 'SoliantBear_%' ];
		
		HomeTestKitResultsSenderV2 rs = new HomeTestKitResultsSenderV2('wellmetric demo', true);
   		rs.executeHelper(orders);
   		Order__c[] noOrders = new List<Order__c>(); 
   		rs.executeHelper(noOrders);
   		rs.upload( 'bunch of xml', 'wellmetric demo', 'b3dda09c-1317-433c-9809-359ce8f2f61f', 1);
   		
   		Test.StartTest();
        rs = new HomeTestKitResultsSenderV2('wellmetric demo', true);
        Id batchprocessid = Database.executeBatch(rs);
   		Test.StopTest();
   		
   		rs.setFailure(orders);
   		rs.setSuccess(orders);
   		
   		update orders;
   		
   		orders = [ SELECT Id FROM Order__c 
   					WHERE Order_Status__c = 'Sent Limeade' AND PatientLastName__c LIKE 'SoliantBear_%' ];
   		system.assertEquals( orders.size(), 10 );

    }*/
    

}