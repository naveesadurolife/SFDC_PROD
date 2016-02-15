/* 
 * Name: BridgeRESTCalloutUtility
 * Type: Apex Class
 * Test Class: BridgeRESTCalloutUtilityTest
 * Description:  This class is used to make REST Callouts to Bridge system. 
 * Change History:
 *===================================================================================================================================
 * Version     Author               Date             Description 
 * 1.0         Sreeni               01/16/2016       1. Initial Version created
 */
public with sharing class BridgeRESTCalloutUtility {
    
    //public static void checkBridgeUserCreation(List<Order__c> listOrders,Map<Id,Order__c> mapOldOrders)
    
    public static void checkBridgeUserCreation(List<Order__c> listOrders)
    {
        if(listOrders!=null && listOrders.size()>0)
        {
            Set<Id> orderIds=new Set<Id>();
            Set<Id> applicablrOrderIds=new Set<Id>();
            for(Order__c oRec:listOrders) {
                orderIds.add(oRec.Id);
            }         
            for(Order__c o:[select id, ProgramID__r.Enable_LMS_Bridge__c from Order__c where ID = :orderIds]){
                if(o.ProgramID__r.Enable_LMS_Bridge__c)
                    applicablrOrderIds.add(o.id);
            }
            orderIds.clear();
            for(Order__c oRec:listOrders) {
                if(applicablrOrderIds != null && applicablrOrderIds.contains(oRec.id) && oRec.Bridge_Details_Sent__c == null && oRec.Demographic_Tag_Sent__c!=null){ 
                   orderIds.add(oRec.Id);
                }
            }
            if(!orderIds.isEmpty()){
                if(!(System.isFuture() || System.isBatch()) && Limits.getFutureCalls() < Limits.getLimitFutureCalls()){                 
                        createBridgeUser(orderIds);
                }
            }
        }
    }
        
    @future (callout=true) 
    public static void createBridgeUser(Set<ID> orderIDs) { 
        List<Order__c> lstOrder = [SELECT PatientFirstName__c
                                            ,PatientLastName__c
                                            ,PatientEmailH__c
                                            ,Demographic_Tag_Sent__c
                                            ,Bridge_Details_Sent__c
                                            ,Range_Tier__r.Demographic_Tag__c
                                            ,Limeade_Participant_Code__c
                                            ,Bridge_Error_Message__c
                                            ,In_Bridge__c                                            
                                            ,Contact__c
                                            ,ProgramID__c
                                            FROM Order__c WHERE Id IN : orderIDs
                                            AND Range_Tier__r.Demographic_Tag__c != null
                                            AND Range_Tier__r.Demographic_Tag__c != ''
                                            AND Range_Tier__r.Bridge_Qualified__c = true];
        
        List<Order__c> lstUpdateOrder = new List<Order__c>();
        List<Goal__c> lstGoal = new List<Goal__c>(); 
        CreateUserJSON usrLst = new CreateUserJSON();
        usrLst.users = new  List<CreateUserJSON.Users>();
        
        for(Order__c recOrder : lstOrder){
            CreateUserJSON.Users indvOrder = new CreateUserJSON.Users();
            indvOrder.uid = recOrder.PatientEmailH__c;
            indvOrder.first_name = recOrder.PatientFirstName__c;
            indvOrder.last_name = recOrder.PatientLastName__c;
            indvOrder.email = recOrder.PatientEmailH__c;
            
            List<CreateUserJSON.Custom_fields> custDataLst = new List<CreateUserJSON.Custom_fields>(); 
            CreateUserJSON.Custom_fields custData = new CreateUserJSON.Custom_fields();
            custData.custom_field_id = '1';
            custData.Value = recOrder.Limeade_Participant_Code__c;
            custDataLst.add(custData);
            custData = new CreateUserJSON.Custom_fields();
            custData.custom_field_id = '2';
            custData.Value = recOrder.Range_Tier__r.Demographic_Tag__c;
            custDataLst.add(custData);
                        
            indvOrder.custom_fields = custDataLst;
            usrLst.users.add(indvOrder);
            
            //recOrder.Bridge_Details_Sent__c = system.Now();
            //lstUpdateOrder.add(recOrder);
        }
        if(!lstOrder.isEmpty()){
            String createUserJson = JSON.serialize(usrLst);
            String httpMethod = 'POST';
            String endPointURL = label.Bridge_End_Point_URL + label.Bridge_Create_User_Path;
            String authorUserURL = label.Bridge_End_Point_URL + label.Bridge_Author_User_Path;
            String authString = label.Bridge_Token;
            String errBridgeErrTxt = '';
            String inBridge = '';  
            Map<String, Object> jsonMap;
			List<Object> usrList;
			Map<String, Object> usrNode;
			String uid = '';			
			String welcomeURL = '';  
            try {                                   
                HTTPResponse res = createUserRequest(createUserJson, httpMethod, endPointURL, authString);
                system.debug('@@@@@@@ Bridge POST Response: '  + res);
                if (res.getStatusCode() != 200) {
                    system.debug('Error Response From Bridge: '  + res.getStatusCode() + ' ' + res.getStatus());
                    system.debug('Error Response Body : '  + res.getBody());
                    JSONParser parser = JSON.createParser(res.getBody());
                    while (parser.nextToken() != null) {
                            if(parser.getCurrentToken() == JSONToken.VALUE_STRING 
                                && parser.getCurrentName() == 'title'){                         
                                errBridgeErrTxt += parser.getText();                            
                       }
                    }                
                } else {
                	jsonMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
					usrList = (List<Object>)jsonMap.get('users');
					usrNode =  (Map<String, Object>)usrList[0];
					uid =  String.valueof(usrNode.get('id'));
					authorUserURL += '/'+uid;
					httpMethod = 'GET';
					res = getUserWelcomeURL(httpMethod, authorUserURL, authString);
					system.debug('@@@@@@@ Bridge GET Response: '  + res);
					if (res.getStatusCode() == 200) {
						jsonMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
						usrList = (List<Object>)jsonMap.get('users');
						usrNode =  (Map<String, Object>)usrList[0];
						welcomeURL =  String.valueof(usrNode.get('welcomeUrl'));
					}
                }
                
                errBridgeErrTxt = (errBridgeErrTxt.length() > 255)? errBridgeErrTxt.substring(0,255):errBridgeErrTxt;
                inBridge = (errBridgeErrTxt == '')?'Yes':'No';
                
                for(Order__c recOrder : lstOrder){
                    if(errBridgeErrTxt == ''){
                    	if(welcomeURL != ''){
                    		recOrder.Bridge_WelcomeURL__c = welcomeURL;	
                    	}
                        recOrder.Bridge_Details_Sent__c = system.Now();
                        Goal__c recGoal = new Goal__c();
                        recGoal.Goal_Name__c = 'RAS - '+recOrder.Range_Tier__r.Demographic_Tag__c;
                        recGoal.X6_Week_Engagement_Goal_Type__c = 'Medical';
                        recGoal.X6_Week_Engagement_Modality__c = 'RAS';
                        recGoal.Contact__c = recOrder.Contact__c;
                        recGoal.Program__c = recOrder.ProgramID__c;
                        recGoal.Overall_Goal_Status__c = 'Registration Phase';
                        recGoal.Created_Date__c=Date.today();
                        lstGoal.add(recGoal);
                    }   
                    recOrder.Bridge_Error_Message__c = errBridgeErrTxt;
                    recOrder.In_Bridge__c = inBridge;
                    lstUpdateOrder.add(recOrder);
                }
                
                if(!lstUpdateOrder.isEmpty())
                    update lstUpdateOrder; 
                if(!lstGoal.isEmpty())
                    insert lstGoal;          
                
            }
            catch (System.CalloutException e){
                system.debug('@@@@@@@ Exception in Callout:' + e);
            }
        }
    }
    
    public static HTTPResponse createUserRequest(String jsonString, String httpMethod, String endPointURL, String authString){
        HttpRequest req = new HttpRequest();
        HTTPResponse resp=new HTTPResponse();
        if(authString != null && authString!='') {
            req.setHeader('Authorization', authString);
        }
        req.setMethod(httpMethod);
        req.setEndpoint(endPointURL);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonString);
        Http http = new Http();  
        if (!Test.isRunningTest()) {
            resp = http.send(req);
        }else {
            resp=new HTTPResponse();
            resp.setStatus('OK');
            resp.setStatusCode(200);
            resp.setBody('{"meta":{},"linked":{},"users":[{"id":"158","uid":"satest@satest.com","first_name":"satestFN","last_name":"satestLN","email":"satest@satest.com","roles":[],"name":"satestFNsatestLN","avatar_url":null,"deleted_at":null,"unsubscribed":null,"welcomedAt":null,"loggedInAt":null,"links":{},"meta":{"can_masquerade":true}}]}');
        }
        
        return resp;
    }
    
    public static HTTPResponse getUserWelcomeURL(String httpMethod, String endPointURL, String authString){
        HttpRequest req = new HttpRequest();
        HTTPResponse resp=new HTTPResponse();
        if(authString != null && authString!='') {
            req.setHeader('Authorization', authString);
        }
        req.setMethod(httpMethod);
        req.setEndpoint(endPointURL);
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();  
        if (!Test.isRunningTest()) {
            resp = http.send(req);
        }else {
            resp=new HTTPResponse();
            resp.setStatus('OK');
            resp.setStatusCode(200);
            resp.setBody('{"meta":{},"linked":{},"users":[{"id":"158","uid":"satest@satest.com","first_name":"satestFN","last_name":"satestLN","email":"satest@satest.com","roles":[],"name":"satestFNsatestLN","avatar_url":null,"deleted_at":null,"unsubscribed":null,"welcomedAt":"2016-02-01T04:17:39.458-07:00","loggedInAt":null,"welcomeUrl":"https://aduro.bridgeapp.com/user-setup/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InNhdGVzdEBzYXRlc3QuY29tIiwiZXhwaXJlc19hdCI6bnVsbH0.V0Rs49Jz3q6iQ-ZHWQi--zM3IiUyJlak-2p0011Kv8I","passwordUrl":"https://aduro.bridgeapp.com/reset-password/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InNhdGVzdEBzYXRlc3QuY29tIiwiZXhwaXJlc19hdCI6bnVsbH0.V0Rs49Jz3q6iQ-ZHWQi--zM3IiUyJlak-2p0011Kv8I","links":{},"meta":{"can_masquerade":true}}]}');
        }
        
        return resp;
    }

}