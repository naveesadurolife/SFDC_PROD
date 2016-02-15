public class WithingsContactCX {

    public Contact objCon {get; set; }
    public string message {get; set;}
    
    public WithingsContactCX (ApexPages.StandardController stdController) {
        this.objCon = (Contact)stdController.getRecord();
        objCon = [SELECT Id, RecordType.Name, Withings_User__c, Limeade_Identifier_Email__c, Withings_User_Id__c 
        								FROM Contact 
        								WHERE Id = :objCon.Id LIMIT 1];
        
    }   //  end of constructor
    
    public PageReference sendEmail(){
    	list<Messaging.SendEmailResult> lstEmailResults;
    	WithingsHelper helper = new WithingsHelper();
    	try{
    			//	If the contact is not a Valid user we do not send the email out.
    		if(! isContactWithingsUser()){
    			message = 'Failed to send Email to the Selected Participating Contact: ' + 'Contact is not a Withings User';
    			return null;
    		}
    		
    		list<Messaging.SingleEmailMessage> lstEmails = new list<Messaging.SingleEmailMessage>();
	        
	        EmailTemplate template = helper.getWithingsEmailTemplate();
	        
	        
    		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	            
            mail.setTargetObjectId(objCon.Id);
            mail.setTemplateId(template.Id);
            mail.setToAddresses(new String[] {objCon.Limeade_Identifier_Email__c});
            lstEmails.add(mail);
	        
	        if(! lstEmails.isEmpty()){
	            lstEmailResults = helper.sendEmails(lstEmails);
	            system.debug('##--Emails sent: ' + lstEmailResults);
	        }
	        
	        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Emails to the Selected Contacts was sent'));
	        message = 'Emails to the Selected Participating Contacts was sent successfully.';
	        
    	} catch(Exception e){
    		message = 'Failed to send Email to the Selected Participating Contact: ' + e.getMessage();
    	}
        
        
        return null;
    }   //  end of sendEmail
    
    
    public PageReference goBack(){
    	PageReference ref = new PageReference('/' + objCon.Id);
        ref.setRedirect(false);
        return ref;
    }	//	end of goBack
    
    private boolean isContactWithingsUser(){
    	
    	if(objCon.RecordType.Name == 'Participants' &&
    		objCon.Withings_User__c == true &&
    		objCon.Limeade_Identifier_Email__c != null &&
    		objCon.Withings_User_Id__c == null){
    		return true;
    	}
    	
    	return false;
    }	//	end of isContactWithingsUser
    	
}   //  end of WithingsContactCX