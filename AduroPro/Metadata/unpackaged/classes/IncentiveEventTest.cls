@isTest
private class IncentiveEventTest {
	static testMethod void myUnitTest() {
		Account a=new Account(Name='aaaa');
		insert a;
		Program__c p=new Program__c(Name='pppp',Account__c=a.Id);
		insert p;
		WW_Event__c we=new WW_Event__c(Name='abc',Program__c=p.Id);
		insert we;
		Test.startTest();
		IncentiveEvent ie=new IncentiveEvent();
		PageReference pr=new PageReference('/Apex/IncentiveEvent');
		pr.getParameters().put('id',we.Id);
		Test.setCurrentPage(pr);
		ie=new IncentiveEvent();
		IncentiveEvent.getEvent(we.Id);
		IncentiveEvent.checkInUser(we.Id,'firstName','lastName','1/1/2010','a@abcdef.com','1234','false');
		Test.stopTest();
	}
}