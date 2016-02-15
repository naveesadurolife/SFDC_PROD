public with sharing class ContactTriggerHandler {
    
    public void onAfterUpdate(list<Contact> lstContacts, map<Id, Contact> mapOldContacts){
        
        set<Id> setObjContactIds = new set<id>();
        set<Id> setContactIdswithAddressRemoved = new set<id>();
        for(Contact objContact :lstContacts){
        
            if(hasAccountAddressUpdated(objContact, mapOldContacts.get(objContact.Id))){
                
                setObjContactIds.add(objContact.Id);
            
            }
            
            if(hasAccountAddressRemoved(objContact, mapOldContacts.get(objContact.Id))){
            	
            	setContactIdswithAddressRemoved.add(objContact.Id);
            }
            
        }// end of for-each contact
        
        if(setObjContactIds.size() > 0){
        	
        	set<Id> setEventResourceIds = new set<Id>();
	        for(Event_Resource__c objEventResource :[SELECT Id, Event_Address_ER__c FROM Event_Resource__c WHERE Contact__c IN :setObjContactIds]){
	          
	          if(objEventResource.Event_Address_ER__c != null){
	            
	            setEventResourceIds.add(objEventResource.Id);
	          }
	        }// end of for-each event resource
	        
	        if(setEventResourceIds.size() > 0){
	          system.debug('Calling Google API');
	          GMapsDistanceCallouts.updateDistances(setEventResourceIds);
	        }
        	
        }
        
        if(setContactIdswithAddressRemoved.size() > 0){
        	
        	removeProjectedDistanceOnRelatedEvents(setContactIdswithAddressRemoved);
        	
        }
        
    
    }// end of onAfterUpdate
	
	private boolean hasAccountAddressUpdated(Contact newContact, Contact oldContact){
        
        if(newContact.MailingCity != oldContact.MailingCity ||
			newContact.MailingState != oldContact.MailingState ||
        	newContact.MailingCountry != oldContact.MailingCountry ||
        	newContact.MailingStreet != oldContact.MailingStreet ||
        	newContact.MailingPostalCode != oldContact.MailingPostalCode){
	            return true;
		}else {
		
			return false;
	    
		}  
        
    } //hasAccountAddressUpdated
    
    private boolean hasAccountAddressRemoved(Contact newContact, Contact oldContact){
    	
    	string newContactMailingAddress = '';
    	string oldContactMailingAddress = '';
    	newContactMailingAddress += newContact.MailingStreet != null? newContact.MailingStreet: '';
    	newContactMailingAddress += newContact.MailingCity != null? newContact.MailingCity: '';
    	newContactMailingAddress += newContact.MailingState != null? newContact.MailingState: '';
    	newContactMailingAddress += newContact.MailingCountry != null? newContact.MailingCountry: '';
    	newContactMailingAddress += newContact.MailingPostalCode != null? newContact.MailingPostalCode: '';
    	
    	oldContactMailingAddress += oldContact.MailingStreet != null? oldContact.MailingStreet: '';
    	oldContactMailingAddress += oldContact.MailingCity != null? oldContact.MailingCity: '';
    	oldContactMailingAddress += oldContact.MailingState != null? oldContact.MailingState: '';
    	oldContactMailingAddress += oldContact.MailingCountry != null? oldContact.MailingCountry: '';
    	oldContactMailingAddress += oldContact.MailingPostalCode != null? oldContact.MailingPostalCode: '';
    	
    	system.debug('##--hasAccountAddressRemoved.newContact.MailingAddress: '+ newContactMailingAddress);
    	system.debug('##--hasAccountAddressRemoved.oldContact.MailingAddress: '+ oldContactMailingAddress);								  
    	if(newContactMailingAddress == ''
    		&& oldContactMailingAddress != '' ){
    	
    		return true;
    	
    	}else{
    		return false;
    	}
    }//hasAccountAddressRemoved
    
    private void removeProjectedDistanceOnRelatedEvents(set<Id> setContactIds){
    	
    	list<Event_Resource__c> lstEventResources = new list<Event_Resource__c>();
    	for(Event_Resource__c objEventResource :[SELECT Id, Projected_Driving_Distance__c 
        													FROM Event_Resource__c 
        													WHERE Contact__c IN :setContactIds]){
	          
	          if(objEventResource.Projected_Driving_Distance__c != null){
	            objEventResource.Projected_Driving_Distance__c = null;
	            lstEventResources.add(objEventResource);
	          }
	    }// end of for-each event resource
	    if(lstEventResources.size() > 0){
	    	
	    	update lstEventResources;
	    }
    }


}