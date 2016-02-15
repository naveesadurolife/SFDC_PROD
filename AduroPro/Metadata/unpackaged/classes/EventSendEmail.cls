public with sharing class EventSendEmail {
	public String eventId{get;set;}
	public WW_Event__c wwEvent{get;set;}
	public EventSendEmail()
	{
		Boolean errorOnPage=false;
		eventId=Apexpages.currentPage().getParameters().get('id');
		if(!String.isBlank(eventId))
		{
			try
			{
				wwEvent=[Select Id,Name,Event_Email_Body__c,Event_Email_Subject__c,
						 (Select id,Slot_Selected__c,First_Name__c,Last_Name__c,Email__c,Contact__c 
						  From Slots__r Where Contact__c!=null order by First_Name__c,Last_Name__c) 
						 FROM WW_Event__c Where Id=:eventId];
				if(wwEvent.Slots__r.size()==0)
				{
					errorOnPage=true;	
				}
			}
			catch(Exception ex){
				errorOnPage=true;
			}
		}
		else
		{
			errorOnPage=true;			
		}
		if(errorOnPage)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Invalid event or there are no registered slots. Please select event again.');
			ApexPages.addMessage(myMsg);			
		}
	}
	public PageReference sendEmail()
	{
		PageReference pr;
		Boolean errorOnPage=false;
		if(String.isBlank(this.wwEvent.Event_Email_Subject__c))
		{
			errorOnPage=true;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter subject.');
			ApexPages.addMessage(myMsg);			
		}
		if(String.isBlank(this.wwEvent.Event_Email_Body__c))
		{
			errorOnPage=true;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter email body.');
			ApexPages.addMessage(myMsg);			
		}
		List<Id> contactIDs=new List<Id>();
		for(Slot__c s:this.wwEvent.Slots__r)
		{
			if(s.Slot_Selected__c)
			{
				contactIDs.add(s.Contact__c);
			}
		}
		if(contactIDs.size()==0)
		{
			errorOnPage=true;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select recepient.');
			ApexPages.addMessage(myMsg);				
		}		
		if(!errorOnPage)
		{
			List<Messaging.SingleEmailMessage> emailList=new List<Messaging.SingleEmailMessage>();
			Messaging.reserveSingleEmailCapacity(contactIDs.size());
			OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'noreply@adurolife.com' limit 1];
			for(Id cId:contactIDs)
			{
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				//String[] toAddresses = new String[] {s.Email__c}; 
				//String[] ccAddresses = new String[] {'smith@gmail.com'}; 
				//mail.setToAddresses(toAddresses);
				//mail.setCcAddresses(ccAddresses);
				mail.setReplyTo('noreply@adurolife.com');
				//mail.setSenderDisplayName('Aduro Support');
				mail.setSubject(this.wwEvent.Event_Email_Subject__c);
				mail.setBccSender(false);
				mail.setUseSignature(false);
				mail.setTargetObjectId(cId);
				mail.setOrgWideEmailAddressId(owea.Id);
				//mail.setPlainTextBody(et.Body);
				mail.setHtmlBody(this.wwEvent.Event_Email_Body__c);
				//mail.setWhatId(cId);
				mail.setSaveAsActivity(true);	
				emailList.add(mail);
			}
			Messaging.sendEmail(emailList);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Email successfully sent to selected recepients.');
			ApexPages.addMessage(myMsg);					
			//pr=new PageReference('/'+wwEvent.Id);
			//pr.setRedirect(true);
		}
		return pr;
	}	
	public PageReference cancel()
	{
		PageReference pr=new PageReference('/'+wwEvent.Id);
		pr.setRedirect(true);
		return pr;
	}	
}