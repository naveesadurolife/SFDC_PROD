@isTest
private class JobValidateProgramContactsTest {

    static testMethod void testJobValidateProgramContacts() {
		Account a=new Account(Name='abc');
		insert a;
		Contact c=new Contact(LastName='lname',AccountId=a.Id,Email='abc@salesforce.com');
		insert c;
		Program__c p=new Program__c(Name='abc');
		p.Account__c=a.Id;
		insert p;
		Database.executeBatch(new JobValidateProgramContacts(p.Id), 10); 
    }
}