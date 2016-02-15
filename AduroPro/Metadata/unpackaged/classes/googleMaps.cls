public with sharing class googleMaps implements Database.AllowsCallouts
{
	public String duration {get;set;}
	public Integer travelTime {get;set;}
	public Decimal distance {get;set;}

	public googleMaps(
			String address1,
			String address2) {
				
		String jsonResults = getJsonResults(address1, address2);
		jsonResults = formatJsonResults(jsonResults);
		System.debug('jsonResults******************'+jsonResults);
		updateJsonSections(jsonResults);
	}

	public String getJsonResults(
			String address1,
			String address2) {
		
		HttpRequest req = new HttpRequest();
		Http http = new Http();
		
		req.setMethod('GET');
		
		String url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
			+ '?origins=' + EncodingUtil.urlEncode(address1, 'UTF-8')
			+ '&destinations=' + EncodingUtil.urlEncode(address2, 'UTF-8')
			+ '&mode=driving'
			+ '&sensor=false'
			+ '&language=en'
			+ '&units=imperial';
			
		req.setEndPoint(url);
		
		HTTPResponse resp ;
		if (!Test.isRunningTest()) {
			resp = http.send(req);
		}else {
			resp=new HTTPResponse();
			resp.setBody('{   "destination_addresses" : [ "521 West Wayne Street, Paulding, OH 45879, USA" ],   "origin_addresses" : [ "Seattle Street, Bonanza, OR 97623, USA" ],   "rows" : [      {         "elements" : [            {               "distance" : {                  "text" : "2,225 mi",                  "value" : 3579988               },               "duration" : {                  "text" : "1 day 9 hours",                  "value" : 117377               },               "status" : "OK"            }         ]      }   ],   "status" : "OK"}');
		}		
		String jsonResults = resp.getBody().replace('\n', '');
		System.debug('jsonResults=================='+jsonResults);
		return jsonResults;
	}
	
	public String formatJsonResults(String value) {
		
		value = value.replace('{', ', ');
		value = value.replace('}', ', ');
		value = value.replace('[', ', ');
		value = value.replace(']', ', ');
		value = value.replace('"', '');
		
		return value;	
	}
	
	public void updateJsonSections(
		String jsonResults) {
		
		List<String> jsonSections = jsonResults.split(', ');
		
		for (Integer i = 0; i < jsonSections.size(); i++) {
			jsonSections[i] = jsonSections[i].trim();
			
			if (jsonSections[i].contains('duration :')) {
				duration = parseDuration(jsonSections[i + 1]);
				travelTime = parseTravelTime(duration);
			}
			
			if (jsonSections[i].contains('distance :')) {
				distance = parseDistance(jsonSections[i + 1]);
			}
		}
	}

	public Decimal parseDistance(String value) {
		value = value.replace('text : ', '');
		value = value.replace(' mi', '');
		value = value.replace(' ft', '');
		value = value.replace(',', '');
		value = value.trim();
		
		return Decimal.valueOf(value);
	}
	
	public String parseDuration(String value) {
		value = value.replace('text : ', '');
		
		return value;
	}
	
	public Integer parseTravelTime(String value) {
	
		Integer tmpMinutes = 0;
	
		List<String> durationNodes = value.split(' ');
		String prevDurationNode = '';
		
		for (String durationNode : durationNodes) {
			if (durationNode == 'day' || durationNode == 'days') {
				tmpMinutes += Integer.valueOf(prevDurationNode) * 1440;
			}
			if (durationNode == 'hour' || durationNode == 'hours') {
				tmpMinutes += Integer.valueOf(prevDurationNode) * 60;
			}
			if (durationNode == 'min' || durationNode == 'mins') {
				tmpMinutes += Integer.valueOf(prevDurationNode);
			}
			
			prevDurationNode = durationNode;
		}
	
		return tmpMinutes;	
	}

}