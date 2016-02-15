@isTest
private class EmailMessageTriggerHandlerTest {

    static testMethod void testEmailMessageTriggerHandler() {
        Case c=new Case();
        insert c;
        EmailMessage em=new EmailMessage();
        em.ParentId=c.Id;
        em.Incoming=false;
        em.ToAddress='abc@adurolife.com';
        insert em;
    }
}