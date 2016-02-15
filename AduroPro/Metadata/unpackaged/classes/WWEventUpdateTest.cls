@isTest
private class WWEventUpdateTest {
	static testMethod void myUnitTest() {
        Account a=new Account(Name='Aduro event supplies');
        insert a;
        Contact kit=new Contact(LastName='Kit Placeholder',AccountId=a.Id);
        insert kit;
        Contact bin=new Contact(LastName='Bin Placeholder',AccountId=a.Id);
        insert bin;  
		List<WW_Event__c> listE=new List<WW_Event__c>();
		for(Integer i=1;i<5;i++)
		{
			listE.add(new WW_Event__c(	Employer__c=a.Id,Create_Event_Resource__c=false,Event_Group_Id__c='1',Coaching_Event_Number__c=i));
			
		}
        insert listE;  
		Test.startTest();
		PageReference pageRef = Page.WWEventUpdate;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController std = new ApexPages.StandardController(listE[0]);
        WWEventUpdate objC = new WWEventUpdate(std);
		objC.getFields();
		for(WWEventUpdate.EventWrapper ew:objC.listEW)
		{
			ew.selected=true;
		}
		objC.synchEvents();
		Test.stopTest();
	}
}