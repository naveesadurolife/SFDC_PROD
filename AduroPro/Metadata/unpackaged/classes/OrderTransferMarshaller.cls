/*******************************************************************************
Author: Caspar Harmer
Email: charmer@soliantconsulting.com
Description:  Schedule send results to Limeade in batches

system.schedule('AutoLimeadeSender00', '0 0 * * * ?', new OrderTransferMarshaller());
system.schedule('AutoLimeadeSender15', '0 15 * * * ?', new OrderTransferMarshaller());
system.schedule('AutoLimeadeSender30', '0 30 * * * ?', new OrderTransferMarshaller());
system.schedule('AutoLimeadeSender45', '0 45 * * * ?', new OrderTransferMarshaller());
********************************************************************************/
global with sharing class OrderTransferMarshaller implements Schedulable {
	
	global void execute(SchedulableContext sc){

		List<AggregateResult> employers = [	SELECT ProgramID__r.Limeade_E_Id__c FROM Order__c 
									WHERE Order_Status__c = 'Received' 
									AND ( ProgramID__r.Program_Status__c != 'Draft' OR ProgramID__r.Program_Status__c != 'Cancelled' )
									GROUP BY ProgramID__r.Limeade_E_Id__c ];
		
		Integer size = employers.size() > 5 ? 5 : employers.size();
							
		for ( Integer i = 0 ; i < size ; i++ ) {
			HomeTestKitResultsSenderV2 sender = new HomeTestKitResultsSenderV2(String.valueOf(employers[i].get('Limeade_E_Id__c')), false);
			//do not set higher than 30 unless you also edit the HomeTestKitResultSenderV2 to send batches bigger than 3 each (salesforce limit)
        	ID batchprocessid = Database.executeBatch(sender,30); 
		}
													
		System.debug( logginglevel.FINE, employers );
		System.debug( logginglevel.FINE, size );
	}
}