@isTest
private class WWEventTriggerHandlerTest {

    static testMethod void testWWEventTriggerHandler() {
        Account a=new Account(Name='Aduro event supplies');
        insert a;
        Contact kit=new Contact(LastName='Kit Placeholder',AccountId=a.Id);
        insert kit;
        Contact bin=new Contact(LastName='Bin Placeholder',AccountId=a.Id);
        insert bin;      
        WW_Event__c e=new WW_Event__c(	Employer__c=a.Id,Create_Event_Resource__c=true);
        insert e;  
    }
}