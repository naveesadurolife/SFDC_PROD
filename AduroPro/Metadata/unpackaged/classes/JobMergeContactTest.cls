@isTest
private class JobMergeContactTest {

    static testMethod void myUnitTest() {
		Account acct=TestDataGenerator.getOneAccount();
		Contact con=TestDataGenerator.getOneContact();
		con.Limeade_ParticipantCode__c='1221';
		update con;
		Contact con2=con.clone();
		con2.Limeade_ParticipantCode__c='1221';
		insert con2;
		Test.startTest();
        //JobMergeContact batch = new JobMergeContact(acct.Id); 
        //Id batchId = Database.executeBatch(batch,1);
        JobMergeContact.mergeContacts('1221', acct.Id);
        Test.stopTest();  
    }
}