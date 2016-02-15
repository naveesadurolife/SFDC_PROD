@isTest
private class OnsiteStaffSignOffTest {
	static testMethod void myUnitTest() {
        Account a=new Account(Name='Aduro');
        insert a;
        Contact con=new Contact(LastName='Placeholder',AccountId=a.Id);
        insert con;
        WW_Event__c e=new WW_Event__c(Employer__c=a.Id,Create_Event_Resource__c=false);
        insert e;  
		Event_Resource__c er=new Event_Resource__c(WW_Event__c=e.Id,Resource_Type__c='Event Staff',Account__c=a.Id,Contact__c=con.Id);
		insert er;
		PageReference pageRef = Page.OnsiteStaffSignOff;
        Test.setCurrentPage(pageRef);	
		ApexPages.currentPage().getParameters().put('event', e.Id);
		ApexPages.currentPage().getParameters().put('sid', er.Id);	
		OnsiteStaffSignOff obj=new OnsiteStaffSignOff();
		obj.changeErrorMessageVisibility(true);
		obj.getTransitMethods();
		obj.signature='aaa';
		obj.save();
		OnsiteStaffSignOff.getDistance('98052','98103');
		
	}
}