/*
* Makes all PartnerNetworkRecordConnections available to any process
* in a static context with a single lookup.  Safe to call multiple times
* without invoking multiple soql calls.
* 
*/
public class LASI_HelperClass {
	
	//Flag to trigger sharing in Sandbox
	private static boolean sandboxShare = false;
	
	private static Map<String, Map<Id, Id>> PartnerConnectionMap; 

	private static Map<Id, Id> RecordIdMap;

	private static Map<String, Set<Id>> LocalRecordIdSetMap;

	private static Map<String, Id> connectionMap;

	private static PartnerNetworkRecordConnection[] recordConnections;

	public static PartnerNetworkRecordConnection[] deletedConnections {get; set;}
	
	public static boolean isSandbox;

	static {
		isSandbox = [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
		deletedConnections = new List<PartnerNetworkRecordConnection>();
		Map<Id, PartnerNetworkConnection> connections = new Map<Id, PartnerNetworkConnection>([SELECT Id, ConnectionName
												  FROM PartnerNetworkConnection
												  WHERE ConnectionStatus = 'Accepted']);

		recordConnections = [SELECT Id, ConnectionId, PartnerRecordId, LocalRecordId
							FROM PartnerNetworkRecordConnection
							WHERE Status IN ('Sent', 'Received') AND ConnectionId IN: connections.KeySet()];

		PartnerConnectionMap = new Map<String, Map<Id, Id>>();

		connectionMap = new Map<String, Id>();

		LocalRecordIdSetMap = new Map<String, Set<Id>>();

		for(Id pnc : connections.KeySet()){
			connectionMap.put(connections.get(pnc).ConnectionName, pnc);
		}

		for(PartnerNetworkRecordConnection pnrc : recordConnections){
			String ConnectionName = connections.get(pnrc.ConnectionId).ConnectionName;
			if(LocalRecordIdSetMap.containsKey(ConnectionName)){
				Set<Id> tempSet = LocalRecordIdSetMap.get(ConnectionName);
				tempSet.add(pnrc.LocalRecordId);
				LocalRecordIdSetMap.put(connectionName, tempSet);
			} else {
				set<Id> tempSet = new Set<Id>();
				tempSet.add(pnrc.LocalRecordId);
				LocalRecordIdSetMap.put(connectionName, tempSet);
			}

			if(PartnerConnectionMap.containsKey(ConnectionName)){
				Map<Id, Id> tempMap = PartnerConnectionMap.get(ConnectionName);
				tempMap.put(pnrc.PartnerRecordId, pnrc.LocalRecordId);
				PartnerConnectionMap.put(ConnectionName, tempMap);
			} else {
				Map<Id, Id> tempMap = new Map<Id, Id>();
				tempMap.put(pnrc.PartnerRecordId, pnrc.LocalRecordId);
				PartnerConnectionMap.put(ConnectionName, tempMap);
			}
		}
	}

	public static Map<Id, Id> getRecordMap(String ConnectionName){
		return PartnerConnectionMap.get(ConnectionName);
	}

	public static Id getConnectionId(String ConnectionName){
		if(!isSandbox || (isSandbox && SandboxShare))
			return connectionMap.get(ConnectionName);
		else
			return null;
	}

	public static PartnerNetworkRecordConnection getRecordConnection(Id LocalRecordId, String ConnectionName){
		for(PartnerNetworkRecordConnection pnrc : recordConnections){
			if(pnrc.LocalRecordId == LocalRecordId && pnrc.ConnectionId == getConnectionId(ConnectionName)){
				return pnrc;
				break;
			}
		}
		return null;
	}

	public static boolean recordShared(Id recordId, String ConnectionName){
		if(LocalRecordIdSetMap.containsKey(ConnectionName))
			return LocalRecordIdSetMap.get(ConnectionName).contains(recordId);
		else
			return false;
	}

	public static Set<Id> getLocalSharedIds(String ConnectionName){
		return LocalRecordIdSetMap.get(ConnectionName);
	}

	@future (callout=true)
	Public static void callPartner(String endpointURL, Map<String, String> BodyMap){
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();

		Http http = new Http();

		req.setEndpoint(endpointURL);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		String Body = '{';
		Integer i = 0;
		for(String key : bodyMap.keySet()){
			body += '"'+key+'": '+'"'+bodyMap.get(key)+'"';
			i++;
			if(i < bodyMap.keySet().size())
				body += ', ';
		}
		body+='}';
		req.setBody(body);

		System.debug(req.toString());
		System.debug(req.getBody());
		if(!Test.isRunningTest()){
			try {
				res = Http.send(Req);
			} catch(System.CalloutException e){
				System.debug('Callout error: ' + e);
				System.debug(res.toString());
			}
		}
		String responseBody = res.getBody();
		System.debug('***Response = '+responseBody);
		if(responseBody.startsWith('"Success;')){
			List<String> responseList = responseBody.split(';');
			System.debug(responseList);
			Id recordId = Id.valueOf(responseList[1]);
			sObject o = recordId.getSObjectType().newSObject(recordId);
			Id partnerRecordid = Id.valueOf(responseList[3].substring(0,18));
			String FieldName = responseList[2];
			o.put(FieldName, partnerRecordid);
			update o;
		}
	}
}