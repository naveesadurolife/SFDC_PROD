public class WithingsHelper {
	
	public static String CONSUMER_KEY = '487b43bf444b4fd2dc8f460046c21757bf0c395cf1d63e478fde89fffcfe7';
	public static String CONSUMER_SECRET = 'eb104060fc24641384662bb6df91e733c2e26f9695f0dd99809cdebb4eb';
	public static String CALLBACK_URL = 'https://wellmetricssurveys.secure.force.com/withings/';
	public static String NOTIFICATION_URL = 'https://wellmetricssurveys.secure.force.com/withings?notify=1';
	
	//public static String CALLBACK_URL = 'https://dev-wellmetricssurveys.cs30.force.com/withings/';
	//public static String NOTIFICATION_URL = 'https://dev-wellmetricssurveys.cs30.force.com/withings/?notify=1';
	
	
	public static String testReponseData='';	//	This is to help with Test methods.
	public static String testMeasureData='';	//	This is to help with Test methods.
	
	public map<Id, Goal__c> getGoalsForContacts(list<Contact> lstContacts){
		map<Id, Goal__c> mapContactIdGoal = new map<Id, Goal__c>();
		
		for(Goal__c goal : [SELECT Id, Name, Contact__c
								//,Withings_Initial_Weight__c, Withings_Recent_Weight__c
							  FROM Goal__c 
							 WHERE Contact__c IN :lstContacts
							   AND Program_Name__c = 'Ignite Health Recovery Program_PDMS'
							 ORDER BY Created_Date__c DESC
							   //AND Overall_Goal_Status__c = 'In Progress'
							   ]){
							   	
			if(mapContactIdGoal.get(goal.Contact__c) == null){
				//	Add only if there is no entry for the Contact in the map
				mapContactIdGoal.put(goal.Contact__c, goal);
			}
		}	//	end of for-each goal
		
		return mapContactIdGoal;
	}	//	end of 
	
	public WithingsBodyMeasure getMeasureData(Contact objContact, DateTime lastUpdated){
		
		
		String responseData='', url='';
		map<String, String> mapParameters = new map<String, String>();
		WithingsBodyMeasure objMeasure = new WithingsBodyMeasure();
		
		mapParameters = OAuthHelper.createDefaultParameters(WithingsHelper.CONSUMER_KEY);
		mapParameters.put('action', 'getmeas');
		mapParameters.put('userid', objContact.Withings_User_Id__c);
		mapParameters.put('oauth_token', objContact.Withings_User_Token__c);
		
		if(lastUpdated != null){
			mapParameters.put('lastupdate', this.getUnixEpochFromDate(lastUpdated)+'');
		}
		
		url = OAuthHelper.constructRequestURL('https', 'wbsapi.withings.net', 
										'measure', objContact.Withings_User_Secret__c,
										WithingsHelper.CONSUMER_KEY, WithingsHelper.CONSUMER_SECRET, 
										mapParameters);
		
		system.debug('##--Created the URL for request token: ' + url);
		
        
        responseData = getDataStringFromUrl(url);
        
        if( String.isBlank(responseData)){
        	// TODO: Show Error
        }
        system.debug('##--Response from WIthings: ' + responseData);
        
        objMeasure = WithingsBodyMeasure.parse(responseData);
        
        return objMeasure;
        
	}	//	end of getMeasureData
	
	
	/*	Added for Notification service*/
	
	/*
		
	*/
	public void setupWithingsNotification(Contact objContact){
		
		
		String responseData='', url='';
		map<String, String> mapParameters = new map<String, String>();
		
		mapParameters = OAuthHelper.createDefaultParameters(WithingsHelper.CONSUMER_KEY);
		mapParameters.put('action', 'subscribe');
		mapParameters.put('userid', objContact.Withings_User_Id__c);
		mapParameters.put('callbackurl', EncodingUtil.urlEncode(NOTIFICATION_URL, 'UTF-8'));
		mapParameters.put('comment', 'Notification_Service_for_Aduro_Life');
		mapParameters.put('oauth_token', objContact.Withings_User_Token__c);
		
		
		url = OAuthHelper.constructRequestURL('https', 'wbsapi.withings.net', 
										'notify', objContact.Withings_User_Secret__c,
										WithingsHelper.CONSUMER_KEY, WithingsHelper.CONSUMER_SECRET, 
										mapParameters);
		
		system.debug('##--Created the URL for Notification Service: ' + url);
		
        
        responseData = getDataStringFromUrl(url);
        
        if( String.isBlank(responseData)){
        	// TODO: Show Error
        }
        system.debug('##--Response from WIthings: ' + responseData);
        
	}	//	end of setupWithingsNotification
	
	
	
		/*
    		Since we need to send emails to a different email then the original email of contact
    		We need to first rollback the emails sent to original email and then send them to TO Address
    	*/
    public list<Messaging.SendEmailResult> sendEmails(list<Messaging.SingleEmailMessage> lstEmails){
    	list<Messaging.SendEmailResult> lstEmailResults;
    	
    	Savepoint sp = Database.setSavepoint();
    	Messaging.sendEmail(lstEmails);
    	Database.rollback(sp); // Email will not send as it is rolled Back
    	
    	List<Messaging.SingleEmailMessage> msgListToBeSend = new List<Messaging.SingleEmailMessage>();
		for (Messaging.SingleEmailMessage email : lstEmails) {
			Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
			emailToSend.setToAddresses(email.getToAddresses());
			emailToSend.setPlainTextBody(email.getPlainTextBody());
			emailToSend.setHTMLBody(email.getHTMLBody());
			emailToSend.setSubject(email.getSubject());
			msgListToBeSend .add(emailToSend);
		}
		if(! Test.isRunningTest()){
			lstEmailResults = Messaging.sendEmail(msgListToBeSend);
		}
    	
    	return lstEmailResults;
    }	//	end of sendEmails
	
	public EmailTemplate getWithingsEmailTemplate(){
		
		return [SELECT ID, Name FROM EmailTemplate WHERE name = 'Withings OAuth Request'];
		
	}	//	end of getWithingsEmailTemplate
	
	
	public DateTime getDateFromUnixEpoch(Integer epoch){
		//system.debug('##--Creating the Date from Int: ' + epoch);
		if(epoch == null || epoch < 1){
			return null;
		}
		Long longEpoch = Long.valueOf(String.valueOf(epoch)) * 1000;
		return DateTime.newInstance(longEpoch);
	}	//	end of getDateFromUnixEpoch
	
	public Long getUnixEpochFromDate(DateTime dt){
		//system.debug('##--Creating the Int from Date: ' + dt);
		if(dt == null){
			return null;
		}
		return dt.getTime()/1000;
	}	//	end of getUnixEpochFromDate
	
	public string getDataStringFromUrl(String url){
		
		HttpRequest request = new HttpRequest();
		HttpResponse res=null;
        Http http = new Http();
		string responseData = '';
		
		request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        
        if(Test.isRunningTest()){
        	if(url.contains('https://wbsapi.withings.net/measure') ||
        		url.contains('https://wbsapi.withings.net/notify')){
        		responsedata = testMeasureData;
        	}else {
        		responsedata = testReponseData;
        	}
        } else{
        	res = http.send(request);
        	responseData = res.getBody();
        }
        
        
		return responseData;
		
	}	//	end of getDataStringFromUrl
	
}	//	end of WithingsHelper