public class WithingsAccountCC {

    public Account objAcc {get; set; }
    public list<Contact> lstAssociatedContacts {get; set;}
    public string message {get; set;}
    
    public WithingsAccountCC (ApexPages.StandardController stdController) {
        this.objAcc = (Account)stdController.getRecord();
        
    }   //  end of constructor
    
    public PageReference sendEmails(){
    	list<Messaging.SendEmailResult> lstEmailResults;
    	WithingsHelper helper = new WithingsHelper();
    	try{
    		lstAssociatedContacts = [SELECT Id, Name, Email, Account.Name, RecordType.Name,
	        								Limeade_Identifier_Email__c, 
	        								Withings_User_Id__c  
	        						   FROM Contact 
	        						  WHERE Account.Id = :objAcc.Id
	        						    AND RecordType.Name = 'Participants'
	        						    AND Withings_User__c = true
	        						    AND Limeade_Identifier_Email__c != null
	        						    AND Withings_User_Id__c = null];
	        
	        list<Messaging.SingleEmailMessage> lstEmails = new list<Messaging.SingleEmailMessage>();
	        
	        EmailTemplate template = helper.getWithingsEmailTemplate();
	        
	        for(Contact objCon : lstAssociatedContacts){
	            
	            system.debug('##--Contacts: ' + objCon);
	            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	            
	            mail.setTargetObjectId(objCon.Id);
	            mail.setTemplateId(template.Id);
	            mail.setToAddresses(new String[] {objCon.Limeade_Identifier_Email__c});
	            lstEmails.add(mail);
	            
	        }   //  end of for-each contact
	        
	        if(! lstEmails.isEmpty()){
	            lstEmailResults = helper.sendEmails(lstEmails);
	            system.debug('##--Emails sent: ' + lstEmailResults);
	        }
	        
	        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Emails to the Contacts were sent'));
	        message = 'Emails to all the Participating Contacts were sent successfully.';
    	} catch(Exception e){
    		message = 'Failed to send Emails to the Participating Contacts: ' + e.getMessage();
    	}
        
        
        return null;
    }   //  end of sendEmails
    
    
    public PageReference goBack(){
    	PageReference ref = new PageReference('/' + objAcc.Id);
        ref.setRedirect(false);
        return ref;
    }	//	end of goBack
    
    
    	
}   //  end of WithingsAccountCC