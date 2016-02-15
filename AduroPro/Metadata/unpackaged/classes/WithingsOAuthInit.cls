public with sharing class WithingsOAuthInit {
	
	private String customerId;
	private String requestKey;
	private String requestSecret;
	
	public String url {get; set;}
	public boolean errorOccured {get;set;}
	

	public WithingsOAuthInit(){
		url = 'This is the Home Page from plain page';
		errorOccured=false;
	}	//	end of constructor
	
	
	public PageReference checkParamsAndRedirect(){
		map<string, string> mapPageParams = ApexPages.currentPage().getParameters();
		
		if(mapPageParams.keySet().contains('customerId')){
			//	the request from the User trying to get the Authorization
			return getWithingsAuthorizationURL(mapPageParams.get('customerId'));
			
		} else if(mapPageParams.keySet().contains('notify') && mapPageParams.keySet().contains('userid')){
			String withingsData='';
			for(String param : mapPageParams.keySet()){
				withingsData += param + ':' + mapPageParams.get(param) + ' , ';
			}
			system.debug('##--Data from Withings: ' + withingsData);
				
				/*
					Create a Object in the Withings Sync object
				*/
			Withings_Sync__c objSync = new Withings_Sync__c(Name = mapPageParams.get('userid'));
			insert objSync;
			
			//getMeasureDataForUser(mapPageParams.get('userid'));
			
		} else if(mapPageParams.keySet().contains('userid') && mapPageParams.keySet().contains('oauth_token')){
			
			String userid = mapPageParams.get('userid');
			String requestToken = mapPageParams.get('oauth_token');
			
			getPermanentOAuthToken(userid, requestToken);
		}
		return null;
	}	//	end of checkParamsAndRedirect
	
	
	public PageReference getWithingsAuthorizationURL(String customerId){
		
		WithingsHelper helper = new WithingsHelper();
		String responseData='';
		map<String, String> mapParameters = new map<String, String>();
		
		system.debug('##--Quering COntact for: ' + customerId);
		
		Contact objContact = [SELECT Id, Name, temp_request_key__c, Temp_Request_Secret__c,
										Withings_User_Id__c, Withings_User_Token__c
							    FROM Contact WHERE Id = :customerId];
        
        system.debug('##--Got the COntact from DB: ' + objContact);
        
        mapParameters = OAuthHelper.createDefaultParameters(WithingsHelper.CONSUMER_KEY);
		mapParameters.put('oauth_callback', EncodingUtil.urlEncode(WithingsHelper.CALLBACK_URL, 'UTF-8'));
		
		url = OAuthHelper.constructRequestURL('https', 'oauth.withings.com', 
												'account/request_token', '',
												WithingsHelper.CONSUMER_KEY, WithingsHelper.CONSUMER_SECRET, 
												mapParameters);
		
		system.debug('##--Created the URL for request token: ' + url);
		
        responseData = helper.getDataStringFromUrl(url);
        
        if( String.isBlank(responseData)){
        	// TODO: Show Error
        }
        system.debug('##--Response from WIthings: ' + responseData);
        requestKey = responseData.split('&')[0].split('=')[1];
        requestSecret = responseData.split('&')[1].split('=')[1];
        
        
        
        objContact.temp_request_key__c = requestKey;
        objContact.Temp_Request_Secret__c = requestSecret;
        update objContact;
        
        mapParameters = OAuthHelper.createDefaultParameters(WithingsHelper.CONSUMER_KEY);
		mapParameters.put('oauth_token', requestKey);
        url = OAuthHelper.constructRequestURL('https', 'oauth.withings.com', 
												'account/authorize', requestSecret,
												WithingsHelper.CONSUMER_KEY, WithingsHelper.CONSUMER_SECRET, 
												mapParameters);
												
        PageReference pageRef = new PageReference(url);
        
        return pageRef;
        
	}	//	end of getRequestKeyAndSecret
	
	private void getPermanentOAuthToken(String userid, String requestToken){
		
		String responseData='';
		map<String, String> mapParameters = new map<String, String>();
		map<String, String> mapResponseParams = new map<String, String>();
		map<Id, Goal__c> mapContactIdGoal = new map<Id, Goal__c>();
		WithingsBodyMeasure initialMeasure = new WithingsBodyMeasure();
		WithingsHelper helper = new WithingsHelper();
		map<Withings_Measure_Group__c, list<Withings_Measure__c>> mapMeasureGrpData = new map<Withings_Measure_Group__c, list<Withings_Measure__c>>();
		
		Contact objContact = [SELECT Id, temp_request_key__c, 
										Temp_Request_Secret__c, 
										Withings_User_Id__c, 
										Withings_User_Token__c,
										Withings_User_Secret__c,
										Withings_Last_Updated__c
								FROM Contact
							   WHERE temp_request_key__c = :requestToken];
							   
		system.debug('##--Got the COntact from DB: ' + objContact);
		
		mapParameters = OAuthHelper.createDefaultParameters(WithingsHelper.CONSUMER_KEY);
		mapParameters.put('oauth_token', requestToken);
		
		url = OAuthHelper.constructRequestURL('https', 'oauth.withings.com', 
												'account/access_token', objContact.Temp_Request_Secret__c,
												WithingsHelper.CONSUMER_KEY, WithingsHelper.CONSUMER_SECRET, 
												mapParameters);
		
		system.debug('##--Created the URL for request token: ' + url);
		
        
        responseData = helper.getDataStringFromUrl(url);
        
        if( String.isBlank(responseData)){
        	// TODO: Show Error
        }
        system.debug('##--Response from WIthings: ' + responseData);
        
        mapResponseParams = OAuthHelper.createMapFromResponse(responseData);
        
        objContact.Withings_User_Id__c = mapResponseParams.get('userid');
        objContact.Withings_User_Token__c = mapResponseParams.get('oauth_token');
        objContact.Withings_User_Secret__c = mapResponseParams.get('oauth_token_secret');
        
        /*	Setting up Notification Service*/
        //helper.setupWithingsNotification(objContact);
        
        mapContactIdGoal = helper.getGoalsForContacts(new list<Contact>{objContact});
        
        if(mapContactIdGoal.get(objContact.Id) != null){
        	
			getMeasureDataForContact(objContact, mapContactIdGoal, null);	//	Sending null date so that we fetch all the initial data
			
        }else{
        	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Could not get the initial Data as you do not have a Goal Associated.');
            ApexPages.addMessage(myMsg);
            errorOccured=true;
        }
        
        update objContact;
        
        
	}	//	end of getPermanentOAuthToken
	
	
	private void getMeasureDataForUser(String userId){
		
		map<Id, Goal__c> mapContactIdGoal = new map<Id, Goal__c>();
		WithingsHelper helper = new WithingsHelper();
		
		Contact objContact = [SELECT Id, temp_request_key__c, 
										Temp_Request_Secret__c, 
										Withings_User_Id__c, 
										Withings_User_Token__c,
										Withings_User_Secret__c,
										Withings_Last_Updated__c
								FROM Contact
							   WHERE Withings_User_Id__c = :userId];
		
		
		mapContactIdGoal = helper.getGoalsForContacts(new list<Contact>{objContact});
        
        if(mapContactIdGoal.get(objContact.Id) != null){
        	
        	getMeasureDataForContact(objContact, mapContactIdGoal, objContact.Withings_Last_Updated__c);
	    	
        }
        
        update objContact;
		
	}	//	end of getMeasureDataForUser
	
	
	private void getMeasureDataForContact(Contact objContact, map<Id, Goal__c> mapContactIdGoal, DateTime lastUpdated){
		
		WithingsBodyMeasure initialMeasure = new WithingsBodyMeasure();
		WithingsHelper helper = new WithingsHelper();
		map<Withings_Measure_Group__c, list<Withings_Measure__c>> mapMeasureGrpData = new map<Withings_Measure_Group__c, list<Withings_Measure__c>>();
		
		initialMeasure = helper.getMeasureData(objContact, lastUpdated);
	        
        system.debug('##--Updated the Contact and initialMeasure: ' + initialMeasure);
        
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
		system.debug('##--Finished Inserting the Measures: ' + lstMeasures);
		
		DateTime lastupdatedDate = initialMeasure.getLastUpdatedTime();
		if(lastupdatedDate != null){
			objContact.Withings_Last_Updated__c = lastupdatedDate;
		}
		
    	//system.debug('##--Final Update for Contact: ' + objContact);
    	
	}	//	end of getMeasureDataForContact
	
	
	
}	//	end of WithingsOAuthInit