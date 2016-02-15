public with sharing class EmailMessageTriggerHandler { 
	public static void UpdateFirstResponse(List<EmailMessage> listEM)
	{
		if(listEM!=null && listEM.size()>0)
		{
			//Select id,parentid,createddate,messagedate From EmailMessage e where parentid='5007000000WpHwZ' and incoming=false
			Map<Id,EmailMessage> caseIDs=new Map<Id,EmailMessage>();
			for(EmailMessage em:listEM)
			{
				if(em.ParentId!=null && String.valueOf(em.ParentId).startsWith('500') && !em.Incoming && em.Subject!='Thank you for contacting ADURO, Inc Support Team.')
				{
					caseIDs.put(em.ParentId,em);
				}
			}
			if(caseIDs!=null && caseIDs.size()>0)
			{
				List<Case> listCases=new List<Case>();
				for(Case c:[Select Id,First_Response__c From Case Where First_Response__c=null AND Id IN :caseIDs.keySet()])
				{
					c.First_Response__c=caseIDs.get(c.Id).MessageDate;
					listCases.add(c);
				}
				update listCases;
			}
		}
	}

}