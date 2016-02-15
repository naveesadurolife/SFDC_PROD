trigger Order_beforeUpsert on Order__c (before insert, before update) {

	for( Order__c theOrder : trigger.new ) {
		theOrder.Concat_Unique_Key__c = theOrder.Program_Number__c +'_'+ theOrder.PatientEmailH__c;
	}
	
	Set<Id> ProgramIds = new Set<Id>();
    Set<String> orderKeys = new Set<String>();

    Order__c[] ordersThatNeedContacts = new List<Order__c>();
    Contact[] contactsToInsert = new List<Contact>();
    Boolean contactsInserted = false;
    
    //build up unique keys
    for( Order__c theOrder : Trigger.new ) {
        if( theOrder.PatientDOB__c != null ) {
        	ProgramIds.add( theOrder.ProgramID__c );
        	String key = getOrderKey(theOrder);
        	orderKeys.add( key );
        }
    }
    System.debug(LoggingLevel.Fine, '------------------------------>orderKeys ' + orderKeys);
                                                           
  	Map<Id, Program__c> relatedPrograms = new Map<Id, Program__c>([ SELECT Id, Account__c 
  																	FROM Program__c 
																	WHERE Id IN :ProgramIds ]);
	//based on the keys, get the contacts that match.															
  	Contact[] relatedListOfContacts = [ SELECT Concat_Unique_Key__c, Id FROM Contact 
  									WHERE Concat_Unique_Key__c IN :orderKeys ];
  									
  	//add to map, indexed by the key
  	Map<String, Contact> relatedContacts = new Map<String, Contact>();	
  	for( Contact theCon : relatedListOfContacts ) {
  		relatedContacts.put( theCon.Concat_Unique_Key__c, theCon );
  	}							

	//System.debug(LoggingLevel.Fine, '------------------------------>Trigger ' + trigger.new);
    System.debug(LoggingLevel.Fine, '------------------------------>relatedContacts ' + relatedContacts);

    //try to find a matching key in the contact list. If one found, add as the contact for that order.
    for( Order__c theOrder : trigger.new ) {
        String key = '';
        if( theOrder.PatientDOB__c != null ) {
	        key = getOrderKey(theOrder);
        }

        if( relatedContacts.containsKey( key ) ) {
	   		theOrder.Contact__c = relatedContacts.get( key ).Id;
	   	} else if( theOrder.PatientDOB__c != null && theOrder.Dont_Create_Contact__c == false ) {
	   		ordersThatNeedContacts.add( theOrder );
	    }
    } 

    //create and insert contact if we could not find a match
    if( !ordersThatNeedContacts.isEmpty() ) {
    	
    	//CASPAR ADD
    	List<RecordType> recType = [Select SobjectType, Name, IsActive, Id  From RecordType
		WHERE IsActive = true AND SobjectType = 'Contact' AND Name = 'Participants' LIMIT 1];
		
		Id recordTypeId = recType[0].Id;
    	
    	for( Order__c orderContact : ordersThatNeedContacts ) {
    		Contact newContact = new Contact();
    		newContact.AccountId = relatedPrograms.get( orderContact.ProgramID__c ).Account__c;
    		newContact.FirstName = orderContact.PatientFirstName__c;
    		newContact.LastName = orderContact.PatientLastName__c;
    		newContact.Email = orderContact.PatientEmailH__c;
    		newContact.Birthdate = orderContact.PatientDOB__c != null ? orderContact.PatientDOB__c : null;
    		newContact.Limeade_Identifier_Last_Name__c = orderContact.PatientLastName__c;
    		newContact.Limeade_Identifier_EmployeeID__c = orderContact.EmployeeID__c != null ? orderContact.EmployeeID__c : null;
    		newContact.Limeade_Identifier_Email__c = orderContact.PatientEmailH__c;
    		newContact.Type_of_Contact__c = 'employee';
    		newContact.RecordTypeId = recordTypeId;
    		newContact.Most_Recent_Onsite_Checkin__c = orderContact.WW_Event__c;
    		newContact.Medical_History__c = 'Not Known';

    		contactsToInsert.add( newContact );
    		//attempt to insert contacts in batches, so bad data has a smaller impact
    		if (Math.mod(contactsToInsert.size(),100) == 0){
				try {
					insert contactsToInsert;
					contactsInserted = true;
				}catch (Exception e){
				}
				contactsToInsert.clear();
			}
    	}
    	try {
    		insert contactsToInsert;
    		contactsInserted = true;
    	} catch (Exception e) {
    	}   	
    }
    
    //if we created contacts, add them to the order as a reference
    if( contactsInserted ) {
    	Set<String> ordKeys = new Set<String>();
    	for( Order__c theOrder : ordersThatNeedContacts ) {
		    String key = getOrderKey(theOrder);
	        ordKeys.add( key );
	    }
    	
    	Contact[] justMadeContacts = [ SELECT Concat_Unique_Key__c, Id FROM Contact 
  										WHERE Concat_Unique_Key__c IN :ordKeys ];
	  	Map<String, Contact> relatedNewContacts = new Map<String, Contact>();	
	  	for( Contact theCon : justMadeContacts ) {
	  		relatedNewContacts.put( theCon.Concat_Unique_Key__c, theCon );
	  	}							
	
	    for( Order__c theOrder : trigger.new ) { //ordersThatNeedContacts ) {
	        if( theOrder.PatientDOB__c != null ) {
		        
		        String key = getOrderKey(theOrder);
		        
		        if( relatedNewContacts.containsKey( key ) ) {
		    		theOrder.Contact__c = relatedNewContacts.get( key ).Id;
		    	} 
	        }
	    }
    }
    
    private String getOrderKey(Order__c theOrder)  {
    	String key = '';
    		
    	if( theOrder.PatientDOB__c != null ) {
    		key = theOrder.PatientLastName__c  +'_'+ theOrder.PatientEmailH__c +'_'
		        			+ theOrder.PatientDOB__c.year() + theOrder.PatientDOB__c.month() + theOrder.PatientDOB__c.day();
		    key = key.toUpperCase();
    	}
    	return key; 
    }

}