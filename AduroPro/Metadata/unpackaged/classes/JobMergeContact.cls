global class JobMergeContact  implements Schedulable,Database.Batchable<Sobject> {
	public static String sObjectFields;
	public static String goalfields=' Id, IsDeleted, Name,Goal_Name__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, ConnectionReceivedId, ConnectionSentId, Contact__c, Capacity_for_Change__c, Goal_Type__c, Initial_Positive_Behaviour_Change__c, Initial_No_Change__c, Initial_Negative_Behaviour_Change__c, X6_mo_Pos_BC__c, X6_mo_No_BC__c, X6_mo_Neg_BC__c, X12_mo_Pos_BC__c, X12_mo_No_BC__c, X12_mo_Neg_BC__c, Goal_Meaning__c, Invoiced_Date__c, Created_Date_Formula__c, X3_mo_No_BC__c, X3_mo_Pos_BC__c, X3_mo_Neg_BC__c, Created_Date__c, Goal_Completed__c, Goal_Completed_Formula__c, Tobacco_Cessation_Session__c ';
	global final String AccountID;
    global JobMergeContact(String accID){

      AccountID=accID;
    }	
    global void execute(SchedulableContext SC) {
        JobMergeContact batch = new JobMergeContact(AccountID); 
        Id batchId = Database.executeBatch(batch,1);  
    }    
     global Database.QueryLocator start(Database.BatchableContext info){    
     	//RecordType rt=[Select Id From RecordType Where DeveloperName='Participants' limit 1];
         String query = 'Select Id,Limeade_ParticipantCode__c,AccountId From Contact where RecordType.DeveloperName=\'Participants\' ';
         if(!String.isBlank(AccountID))
         {
         	query+=' AND AccountID=\''+AccountID+'\'';
         }
         return Database.getQueryLocator(query); 
     }  

     global void execute(Database.BatchableContext BC, List<Sobject> scope){
     	for(Sobject s:scope)
     	{
     		Contact c=(Contact)s;
     		if(!String.isBlank(c.Limeade_ParticipantCode__c))
     			mergeContacts(c.Limeade_ParticipantCode__c,c.AccountId);
     	}
     }
     global void finish(Database.BatchableContext BC){} 	
	public static void mergeContacts(String participanCode,String accID)
	{
		if(String.isBlank(participanCode) || String.isBlank(accID))
		{
			return;
		}
		sObjectFields=getsObjectFields();
		String[] sObjectFieldsArray=sObjectFields.split(',');
		List<String> listFields=new List<String>();
		listFields.addAll(sObjectFieldsArray);
		listFields.sort();
		//, (Select '+getsActivityHistoryFields()+' From ActivityHistories)
		List<Contact> listContacts=Database.query('Select '+sObjectFields+', (Select Id, WhoId From Tasks), (Select Id, Contact__c From Orders__r),(Select Id, Contact__c From Slots__r),(Select '+goalfields+' From Goals__r), (Select Id, ContactId From Cases),(Select Id, printsf__Contact__c From printsf__PrintSF_Mailers__r),( Select Contact__c,Goal__c, Id from Coaching_Application__r), ( Select Contact__c, Id,Report_Cards__c from Report_Cards__r) From Contact Where Limeade_ParticipantCode__c=\''+participanCode+'\' and AccountId=\''+accID+'\' AND  RecordType.DeveloperName=\'Participants\' order by LastModifiedDate DESC');
		if(listContacts.size()>1)
		{
			String xml='';
			List<Order__c> listOrders=new List<Order__c>();
			Contact newestContact=listContacts.remove(0);
			for(Order__c o:newestContact.Orders__r)
			{
				o.Limeade_Participant_Code__c=newestContact.Limeade_ParticipantCode__c;
			}
			listOrders.addAll(newestContact.Orders__r);			
			List<Task> listTasks=new List<Task>();
			List<ActivityHistory> listActivityHistory=new List<ActivityHistory>();
			List<Slot__c> listSlots=new List<Slot__c>();
			Map<String,Goal__c> mapGoals=new Map<String,Goal__c>();
			List<Report_Cards__c> listReportCards=new List<Report_Cards__c>();
			List<Coaching_Application__c> listCoachingApplication=new List<Coaching_Application__c>();
			List<printsf__Collateral_Send_History__c> listPM=new List<printsf__Collateral_Send_History__c>();
			List<Case> listCases=new List<Case>();
			List<Attachment> listAttachments=new List<Attachment>();
			List<Note> listNotes=new List<Note>();			
			List<Attachment> existingA=[ Select  SystemModstamp, ParentId, OwnerId, Name, LastModifiedDate, LastModifiedById, IsPrivate, IsPartnerShared, IsDeleted, Id, Description, CreatedDate, CreatedById, ContentType, ConnectionSentId, ConnectionReceivedId, BodyLength, Body From Attachment where parentId IN :listContacts];
			List<Note> existingN=[Select n.Title, n.SystemModstamp, n.ParentId, n.OwnerId, n.LastModifiedDate, n.LastModifiedById, n.IsPrivate, n.IsDeleted, n.Id, n.CreatedDate, n.CreatedById, n.Body From Note n  where parentId IN :listContacts];
			for(Attachment a:existingA)
			{
				Attachment aN=a.clone();
				aN.ParentId=newestContact.Id;
				listAttachments.add(aN);	
			}
			for(Note n:existingN)
			{
				Note aN=n.clone();
				aN.ParentId=newestContact.Id;
				listNotes.add(aN);	
			}						
			for(Contact c:listContacts)
			{
				Boolean mergeRecord=false;
				String newestContactFirstName=String.isNotBlank(newestContact.FirstName)?newestContact.FirstName:'';
				String cFirstName=String.isNotBlank(c.FirstName)?c.FirstName:'';
				newestContactFirstName=newestContactFirstName.length()>3?newestContactFirstName.subString(0,3):newestContactFirstName;
				cFirstName=cFirstName.length()>3?cFirstName.subString(0,3):cFirstName;
				if(newestContact.Birthdate!=null && c.Birthdate!=null && newestContact.Birthdate==c.Birthdate)
				{
					mergeRecord=true;
				}
				else if(
							(
								(newestContact.Birthdate==null && c.Birthdate==null) || 
								(newestContact.Birthdate==null && c.Birthdate!=null) || 
								(newestContact.Birthdate!=null && c.Birthdate==null) ) && 
								newestContactFirstName.equalsIgnoreCase(cFirstName)
						)
				{
					mergeRecord=true;
				}
				else if(
							newestContact.Birthdate!=null && 
							c.Birthdate!=null && 
							newestContact.Birthdate!=c.Birthdate && 
							(newestContact.Birthdate>Date.today().addYears(-4) || c.Birthdate>Date.today().addYears(-4)) &&
							newestContactFirstName.equalsIgnoreCase(cFirstName)
						)
				{
					mergeRecord=true;
				}				
				if(!mergeRecord)
				{
					return;
				}
				/*if(
					(newestContact.Birthdate!=null && c.Birthdate!=null && newestContact.Birthdate!=c.Birthdate) || 
					((
						(newestContact.Birthdate==null && c.Birthdate!=null) || 
						(newestContact.Birthdate!=null && c.Birthdate==null)) && !newestContact.FirstName.equalsIgnoreCase(c.FirstName))
				 )
				{
					return;
				}*/
				xml+=getsObjectXML(newestContact,c,listFields);
				for(Task t:c.Tasks)
				{
					t.WhoId=newestContact.Id;
				}
				listTasks.addAll(c.Tasks);
				/*for(ActivityHistory ah:c.ActivityHistories)
				{
					ActivityHistory ahnew=ah.clone();
					ahnew.WhoId=newestContact.Id;
					listActivityHistory.add(ahnew);
				}*/

							
				for(Slot__c s:c.Slots__r)
				{
					s.Contact__c=newestContact.Id;
				}
				listSlots.addAll(c.Slots__r);	
				for(Goal__c g:c.Goals__r)
				{
					Goal__c newG=g.clone();
					if(String.isBlank(newG.Goal_Name__c))
						newG.Goal_Name__c=newG.Name;
					newG.Contact__c=newestContact.Id;
					newG.Created_Date_Capture__c=g.CreatedDate.date();
					mapGoals.put(c.Id+'_'+g.id,newG);
				}
				for(printsf__Collateral_Send_History__c pm:c.printsf__PrintSF_Mailers__r)
				{
					pm.printsf__Contact__c=newestContact.Id;
				}
				listPM.addAll(c.printsf__PrintSF_Mailers__r);						
				for(Case ca:c.Cases)
				{
					ca.ContactId=newestContact.Id;
				}
				listCases.addAll(c.Cases);												
				for(Order__c o:c.Orders__r)
				{
					o.Contact__c=newestContact.Id;
					o.Limeade_Participant_Code__c=newestContact.Limeade_ParticipantCode__c;
				}
				listOrders.addAll(c.Orders__r);
				if(c.Report_Cards__r.size()>0)
					listReportCards.addAll(c.Report_Cards__r);
				if(c.Coaching_Application__r.size()>0)
					listCoachingApplication.add(c.Coaching_Application__r);
			}
			system.debug('xml============'+xml);
			system.debug('newestContact=============='+newestContact);
			if(String.isBlank(newestContact.Merged_Contact__c))
			{
				newestContact.Merged_Contact__c='';
			}
			newestContact.Merged_Contact__c+=xml;
			update listTasks;
			update listOrders;
			//update listActivityHistory;
			insert listAttachments;
			insert listNotes;  
			update listSlots;
			insert mapGoals.values();
			for(Coaching_Application__c ca:listCoachingApplication)
			{
				String key=ca.Contact__c+'_'+ca.Goal__c;
				ca.Contact__c=mapGoals.get(key).Contact__c;
				ca.Goal__c=mapGoals.get(key).Id;
			}
			update listCoachingApplication;
			update listCases;
			update listPM;
			for(Report_Cards__c rc:listReportCards)
			{
				String key=rc.Contact__c+'_'+rc.Report_Cards__c;
				rc.Contact__c=mapGoals.get(key).Contact__c;
				rc.Report_Cards__c=mapGoals.get(key).Id;
			}
			update listReportCards;
			update newestContact;
			delete listContacts;
			
		  Attachment attachment = new Attachment(); 
		  attachment.Body = Blob.valueOf(xml);
		  attachment.Name = String.valueOf('Merged_Contacts_'+Date.today().year()+'_'+Date.today().month()+'_'+Date.today().day()+'.xml');
		  attachment.ParentId = newestContact.Id; 
		  insert attachment;
  			
		}
	}
	public static String getsObjectXML(sObject newestContact,sObject obj,List<String> listFields)
	{
		String xml='<contact>';
		for(String apiName:listFields)
		{
			try
			{
				xml+='<field name="'+apiName+'">' +String.valueOf(obj.get(apiName)).replace('null','')+'</field>';
				if(newestContact.get(apiName)==null && obj.get(apiName)!=null)
				{
					newestContact.put(apiName,obj.get(apiName));
				}
			}
			catch(Exception ex){}
		}
		xml+='</contact>';
		return xml;
	}
	public static String getsObjectFields()
	{
		Set<String> exclude=new Set<String>();
		exclude.add('hasoptedoutoffax');
		exclude.add('department');
		exclude.add('usesalesforce');
		exclude.add('reportstoid');
		String fileds ='';
		Map <String, Schema.SObjectField> fieldMap= Contact.sObjectType.getDescribe().fields.getMap();
		for(String key:fieldMap.keySet())
		{
			if(!exclude.contains(key))
			{
				if(!String.isBlank(fileds))
				{
					fileds+=',';
				}
				fileds+=key;
			}
		}
		return fileds;		
	}
	/*public static String getsActivityHistoryFields()
	{
		Set<String> exclude=new Set<String>();
		exclude.add('hasoptedoutoffax');
		exclude.add('department');
		exclude.add('usesalesforce');
		exclude.add('reportstoid');
		String fileds ='';
		Map <String, Schema.SObjectField> fieldMap= ActivityHistory.sObjectType.getDescribe().fields.getMap();
		for(String key:fieldMap.keySet())
		{
			if(!exclude.contains(key))
			{
				if(!String.isBlank(fileds))
				{
					fileds+=',';
				}
				fileds+=key;
			}
		}
		return fileds;		
	}	*/
}