@isTest
private class GoalTriggerHandlerTest {
	static testMethod void myUnitTest() {
		try{
			Account a=new Account(Name='abc');
			insert a;
			Contact c=new Contact();
			c.LastName='bcd';
			c.AccountId=a.Id;
			insert c;
			Goal__c g=new Goal__c();
			g.Contact__c=c.Id;
			g.Created_Date__c=Date.today();
			insert g;
		}
		catch(Exception ex){}
	}
}