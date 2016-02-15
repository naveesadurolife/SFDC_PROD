global class WithingsSyncBatch implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts{

	global WithingsSyncBatch(){
		
	}	//	end of constructor
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		string query = 'SELECT Id, Name, '+
					   '		Synced__c'+
					   '  FROM Withings_Sync__c '+
					   ' WHERE Synced__c = false'+
					   ' LIMIT 5';
    	
    	return Database.getQueryLocator(query);
    	
    }	//	end of start
    
	global void execute(Database.BatchableContext BC, List<sObject>scope){ 
		list<Withings_Sync__c> lstSyncObjects = (list<Withings_Sync__c>)scope;
		list<Contact> lstContacts = new list<Contact>();
		set<String> setUserIds = new set<String>();
		
		map<Id, Goal__c> mapContactIdGoal = new map<Id, Goal__c>();
		map<Id, Contact> mapIdContact = new map<Id, Contact>();
		map<Id, WithingsBodyMeasure> mapContactIdMeasure = new map<Id, WithingsBodyMeasure>();
		WithingsBodyMeasure initialMeasure = new WithingsBodyMeasure();
		WithingsHelper helper = new WithingsHelper();
		boolean contactsUpdated=false;
		
		for(Withings_Sync__c objSync : lstSyncObjects){
			setUserIds.add(objSync.Name);
		}
		
		lstContacts = [SELECT Id, temp_request_key__c, 
					   		Temp_Request_Secret__c, 
					   		Withings_User_Id__c, 
					   		Withings_User_Token__c, 
					   		Withings_User_Secret__c, 
					   		Withings_Last_Updated__c 
					     FROM Contact 
					    WHERE Withings_User_Id__c IN :setUserIds];
		
		system.debug('##--Contacts going to be updated: ' + lstContacts);
		
		mapContactIdGoal = helper.getGoalsForContacts(lstContacts);
		
		for(Contact objContact : lstContacts){
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
				
				objContact.Withings_Last_Updated__c = initialMeasure.getLastUpdatedTime();
				contactsUpdated=true;
				
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
				
				for(Withings_Sync__c objSync : lstSyncObjects){
					objSync.Synced__c=true;
				}
				update lstSyncObjects;
			}
			
			
		}	//	end of if
		
		
	}	//	end of execute
 
   	global void finish(Database.BatchableContext BC){
   		
   		/*if(! test.isRunningTest()){
   			
	   		system.debug('##-- Going to schedule next job');
			Datetime dt = DateTime.now();
	        //Interval of 2 minutes after processing of first job. It can be set in terms of seconds also.
	        dt = dt.addMinutes(2);     
	        String schExp = String.valueOf( dt.second() ) + ' ' + String.valueOf( dt.minute()   ) + ' ' + String.valueOf( dt.hour() ) + ' '  + String.valueOf( dt.day() ) +  ' ' + String.valueOf( dt.month() ) + ' '  + '? ' + String.valueOf( dt.Year());
			
			system.Schedule('Withings Sync Batch Job - ' + String.valueof(dt), schExp, new WithingsSyncBatch());
			
			system.debug('##-- Scheduled Next job');
   			
   		}*/
   		
   	}	//	end of finish
   	
   	
   	global void execute(SchedulableContext sc)
	{
	    Database.executeBatch(new WithingsSyncBatch(), 10);
	}


   
}	//	end of WithingsSyncBatch