@isTest
private class EmailServiceReceivePhysicianFormTest {

    static testMethod void testEmailServiceReceivePhysicianForm() {
        Program__c currentYearProgram=TestDataGenerator.getOneProgram();
        Custom_Configuration__c cc=new Custom_Configuration__c(Name='PhysicianFormDefaultProgramId',Value__c=currentYearProgram.Id);
        insert cc;
	   // Create a new email, envelope object and Attachment
	   Messaging.InboundEmail email = new Messaging.InboundEmail();
	   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
	   Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
	
	   email.subject = 'test';
	   env.fromAddress = 'user@acme.com';
	
	   // set the body of the attachment
	   inAtt.body = blob.valueOf('test');
	   inAtt.fileName = 'my attachment name';
	   inAtt.mimeTypeSubType = 'plain/txt';
	
	   email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 
	
	   // call the class and test it with the data in the testMethod
	   EmailServiceReceivePhysicianForm emailServiceObj = new EmailServiceReceivePhysicianForm();
	   emailServiceObj.handleInboundEmail(email, env );          
    }
}