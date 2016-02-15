@isTest
private class AjaxUtilityTest {

    static testMethod void testUpdateEventContacts() {
		Account a=new Account(Name='abc');
		insert a;
		Contact c=new Contact(LastName='lname',AccountId=a.Id);
		insert c;
		WW_Event__c e=new WW_Event__c();
		e.Employer__c=a.Id;
		insert e;
		c.Event__c=e.Id;
		update c; 
		AjaxUtility.UpdateEventContacts(e.Id);
    }
}