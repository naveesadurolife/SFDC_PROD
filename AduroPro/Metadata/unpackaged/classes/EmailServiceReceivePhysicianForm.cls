global class EmailServiceReceivePhysicianForm implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        system.debug('code======='+email.htmlBody);
       system.debug('code======='+email.plainTextBody);
        system.debug('from======='+email.fromAddress);
        system.debug('headers ======='+email.headers );
		if ((email.binaryAttachments !=null && email.binaryAttachments.size() > 0) ||
		    (email.textAttachments !=null && email.textAttachments.size() > 0))
		{
			List<Document> listDocuments=new List<Document>();
			Id folderId=[Select Id From Folder Where DeveloperName=:'Physician_FAX_Forms'].Id;
			if(email.binaryAttachments !=null && email.binaryAttachments.size() > 0)
			{			
				for (integer i = 0 ; i < email.binaryAttachments.size() ; i++)
				{
			        Document doc = new Document();
			        doc.name = email.binaryAttachments[i].filename;
					doc.body = email.binaryAttachments[i].body;
					doc.folderid =folderId;
					listDocuments.add(doc);
			    }
			}
			if(email.textAttachments !=null && email.textAttachments.size() > 0)
			{
				for (integer i = 0 ; i < email.textAttachments.size() ; i++)
				{
			        Document doc = new Document();
			        doc.name = email.textAttachments[i].filename;
					doc.body = Blob.valueOf(email.textAttachments[i].body);
					doc.folderid =folderId;
					listDocuments.add(doc);
			    }
			}		    
		    insert listDocuments;
			Custom_Configuration__c PhysicianFormDefaultProgramId = Custom_Configuration__c.getValues('PhysicianFormDefaultProgramId');
			if(PhysicianFormDefaultProgramId!=null && String.isNotBlank(PhysicianFormDefaultProgramId.Value__c))
			{
				List<Program__c> listProgram=[Select Id From Program__c Where Id=:PhysicianFormDefaultProgramId.Value__c]; 
				List<Uploaded_Document__c> listUploadedDocuments=new List<Uploaded_Document__c>();
				if(listProgram.size()==1)
				{
					String programId=listProgram[0].Id;
					for(Document doc:listDocuments)
					{
						Uploaded_Document__c ud=new Uploaded_Document__c();
						ud.Document_Id__c=doc.Id;
						//ud.Contact__c=c.Id;
						ud.File_Name__c=doc.Name;
						ud.File_Size__c=doc.BodyLength;
						ud.Program__c=programId;
						ud.Email__c=email.fromAddress;
						//ud.First_Name__c=firstName;
						//ud.Last_Name__c=lastName;
						//ud.DOB__c=dob;
						ud.Email_Subject__c=email.subject;
						ud.Email_Plain_Text_Body__c=email.plainTextBody;
						ud.Email_HTML_Body__c=email.htmlBody;
						listUploadedDocuments.add(ud);					
					}
				}
				insert listUploadedDocuments;
			}		    
		 }
        return result;
    }
}