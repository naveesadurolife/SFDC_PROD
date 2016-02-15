@isTest
class TestOrderTransferMarshaller {

		static testmethod void test() {
			Test.startTest();
			
		    // Schedule the test job 		
			String sch = '0 30 19 * * ? ' + String.valueOf(Date.today().year()); //Class runs every day at 2:30 PM during the year 2011.
			String jobId = System.schedule(
				'OrderTransferMarshallerTest'
				, sch
		        , new OrderTransferMarshaller()
		    );
		    
		    // Get the information from the CronTrigger API object 
		    CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
		         				FROM CronTrigger WHERE id = :jobId];

		   // Verify the job has not run 
		   System.assertEquals(0, ct.TimesTriggered);
		
		   // Verify the next time the job will run 
		   String nextrun = String.valueOf(Date.today().year()) + '-'
		   					+ String.valueOf(Date.today().month()) + '-'
		   					+ String.valueOf(Date.today().day())
		   					+ ' 19:30:00';
		   
		   System.assert( ct.NextFireTime > Datetime.now() );
		
		   Test.stopTest();
		
	
	   }
}