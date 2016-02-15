global class WithingsImporterBatch implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts{

	global WithingsImporterBatch(){
		
	}	//	end of constructor
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		string query = 'SELECT Id, temp_request_key__c, '+
					   '		Temp_Request_Secret__c, '+
					   '		Withings_User_Id__c, '+
					   '		Withings_User_Token__c, '+
					   '		Withings_User_Secret__c, '+
					   '		Withings_Last_Updated__c, '+
					   '		Withings_Sync__c '+
					   '  FROM Contact '+
					   ' WHERE Withings_User_Id__c != null ' +
					   '   AND Withings_Sync__c = false ' +
					   ' LIMIT 25';
    	
    	return Database.getQueryLocator(query);
    	
    }	//	end of start
    
	global void execute(Database.BatchableContext BC, List<sObject>scope){
		list<Contact> lstContacts = (list<Contact>)scope;
		map<Id, Goal__c> mapContactIdGoal = new map<Id, Goal__c>();
		map<Id, Contact> mapIdContact = new map<Id, Contact>();
		map<Id, WithingsBodyMeasure> mapContactIdMeasure = new map<Id, WithingsBodyMeasure>();
		WithingsBodyMeasure initialMeasure = new WithingsBodyMeasure();
		WithingsHelper helper = new WithingsHelper();
		boolean contactsUpdated=false;
		
		system.debug('##--Contacts going to be updated: ' + lstContacts);
		
		mapContactIdGoal = helper.getGoalsForContacts(lstContacts);
		
		for(Contact objContact : lstContacts){
			
			/*	Setting up Notification Service*/
        	helper.setupWithingsNotification(objContact);
        	
        	objContact.Withings_Sync__c=true;
			
			
			/*
				If the User doesn't have a Goal Associated their data will not be 
				attempted
			*/
			if(mapContactIdGoal.get(objContact.Id) == null){
				continue;
			}
			
			initialMeasure = helper.getMeasureData(objContact, objContact.Withings_Last_Updated__c);
			
			mapIdContact.put(objContact.Id, objContact);
			mapContactIdMeasure.put(objContact.Id, initialMeasure);
			
		}	//	end of for-each Contact
		
		if(mapIdContact.keySet() != null && mapIdContact.keySet().size()>0){
			for(Id conId : mapIdContact.keySet()){
				
				Contact objContact = mapIdContact.get(conId);
				initialMeasure = mapContactIdMeasure.get(conId);
				
				DateTime lastupdatedDate = initialMeasure.getLastUpdatedTime();
				if(lastupdatedDate != null){
					objContact.Withings_Last_Updated__c = lastupdatedDate; 
					contactsUpdated=true;
				}
				
				
				list<Withings_Measure_Group__c> lstGroups = initialMeasure.getListOfMeasureGroups(objContact.Id, mapContactIdGoal.get(objContact.Id));
		        //system.debug('##--Inserting the Measure Groups: ' + lstGroups);
		        if(! lstGroups.isEmpty()){
		        	insert lstGroups;
		        }
		        
		        system.debug('##--Finished Inserting the Measure Groups: ' + lstGroups);
		        
		        list<Withings_Measure__c> lstMeasures = new list<Withings_Measure__c>();
		        for(Withings_Measure_Group__c grp : lstGroups){
		        	
		        	lstMeasures.addAll(initialMeasure.getListOfMeasuresForGroup(grp, mapContactIdGoal.get(objContact.Id)));
		        	
		        }	//	end of for-each Group in the Map
				
				system.debug('##--Inserting the Measures: ' + lstMeasures);
				if(! lstMeasures.isEmpty()){
					insert lstMeasures;
				}
				
			}	//	end of for-each Contact
			
			if(contactsUpdated){
				update lstContacts;
			}
		}	//	end of if
		
		
	}	//	end of execute
 
   	global void finish(Database.BatchableContext BC){
    	    // Logic to be Executed at finish
   	}	//	end of finish
   	
   	
   	global void execute(SchedulableContext sc)
	{
	    Database.executeBatch(new WithingsImporterBatch(), 10);
	}


   
}	//	end of WithingsImporterBatch