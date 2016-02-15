public with sharing class GMapsDistanceCallouts {

	@future (callout=true)
	public static void updateDistances(set<Id> setEvtResources){
		
		list<Event_Resource__c> lstValidEvtRes = new list<Event_Resource__c>();
		list<Event_Resource__c> lstEvtRes = [SELECT Id, Name, Projected_Driving_Distance__c, Contact__r.Name, 
													Contact__r.MailingStreet, Contact__r.MailingCity, 
													Contact__r.MailingState, Contact__r.MailingPostalCode, 
													Contact__r.MailingCountry, WW_Event__r.Name, Event_Address_ER__c
											   FROM Event_Resource__c
											  WHERE Id IN :setEvtResources ];
		
		String contactaddress='';
		String eventAddress='';
		String orig='';
		String dest='';
		for(Event_Resource__c objEvtRes : lstEvtRes){
			contactAddress = getContactAddressAsString(objEvtRes);
			eventAddress = getEventAddressAsString(objEvtRes);
			
			if(String.isNotBlank(contactAddress) && String.isNotBlank(eventAddress)){
				lstValidEvtRes.add(objEvtRes);
				orig += contactAddress + '|';
				dest += eventAddress + '|';
			}
		}	//	end of for-each Event Resource
		system.debug('##--lstValidEvtRes: '+lstValidEvtRes);
		if(lstValidEvtRes.size() > 0){
			GMapDistanceMatrix distMatrix = getMapMatrix(orig.removeEnd('|'), dest.removeEnd('|'));
			
			if(distMatrix.status.equalsIgnoreCase('OK')){
				integer index=0;
				
				for(Event_Resource__c objEvtRes : lstValidEvtRes){
					if(distMatrix.rows[index].elements[index].status.equalsIgnoreCase('OK')){
						objEvtRes.Projected_Driving_Distance__c = distMatrix.rows[index].elements[index].distance.text;
					}
					
					index++;
				}	//	end of for-each valid event resource
				
				update lstValidEvtRes;
				
			}	//	en of if call success
			
			
		}	//	end of if Valid Event Resource present
		
	}	//	end of updateDistances
	
	
	private static GMapDistanceMatrix getMapMatrix(String orig, String dest){
		
		String API_KEY = 'AIzaSyA620VxJg2KyMXJLMut4SQfzVBBOqq7OBI';
		// build callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String jsonString;
        system.debug('##-- Origins: ' + orig + '\n Destinations: ' + dest);
        req.setEndpoint('https://maps.googleapis.com/maps/api/distancematrix/json?origins='+orig+'&destinations='+dest+'&units=imperial&key='+API_KEY);
        req.setMethod('GET');
        req.setTimeout(60000);
        system.debug('##--calling google map api' + req);
        
        if(!Test.isRunningTest()){
        	res = h.send(req);
	        system.debug('##--response: '+ res);
	        system.debug('##--responseBody: '+ res.getBody());
	        
	        jsonString = res.getBody();
        } else {
        	jsonString = TestUtility.getTestGMapsMatrix();
        }
        
        return (GMapDistanceMatrix) System.JSON.deserialize(jsonString, GMapDistanceMatrix.class);
	}	//	end of getMapMatrix
	
	
	
	private static String getContactAddressAsString(Event_Resource__c objEvtRes){
		String address='';
		
		if(objEvtRes.Contact__r.MailingStreet != null)
			address += objEvtRes.Contact__r.MailingStreet +', ';
		if (objEvtRes.Contact__r.MailingCity != null)
            address += objEvtRes.Contact__r.MailingCity +', ';
        if (objEvtRes.Contact__r.MailingState != null)
            address += objEvtRes.Contact__r.MailingState +' ';
        if (objEvtRes.Contact__r.MailingPostalCode != null)
            address += objEvtRes.Contact__r.MailingPostalCode +', ';
        if (objEvtRes.Contact__r.MailingCountry != null)
            address += objEvtRes.Contact__r.MailingCountry;
 
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        
        return address;
	}	//	end of getContactAddressAsString
	
	private static String getEventAddressAsString(Event_Resource__c objEvtRes){
		
        return EncodingUtil.urlEncode(objEvtRes.Event_Address_ER__c, 'UTF-8');
        
	}	//	end of getEventAddressAsString
	
	
	public class GMapDistanceMatrix {

		public List<String> destination_addresses;
		public List<String> origin_addresses;
		public List<Rows> rows;
		public String status;
		
	}
	
	public class Elements {
		public Distance distance;
		public Distance duration;
		public String status;
	}

	public class Distance {
		public String text;
		public Integer value;
	}

	public class Rows {
		public List<Elements> elements;
	}
	
}	//	end of GMapsDistanceCallouts