trigger LASI_ShareAttachment on Attachment (after insert, after update, after delete) {


	boolean run = false;
	if(trigger.isDelete){
		for(Attachment a : trigger.old){
			if(String.ValueOf(a.ParentId).StartsWith('800')){
				run = true;
				break;
			}
		}
	} else {
		for(Attachment a : trigger.new){
			if(String.ValueOf(a.ParentId).StartsWith('800')){
				run = true;
				break;
			}
		}
	}
	if(run){

		Map<Id, Contract> sharedContracts = new Map<Id, Contract>([SELECT Id, Limeade_Contract_Id__c FROM Contract WHERE Limeade_Contract_Id__c <> null]);

		String ConnectionName = 'Limeade';

		if(Trigger.isDelete){
			for(Attachment a : Trigger.old){
				if(sharedContracts.containsKey(a.ParentId)){
					String endpointURL = 'callout:Limeade/services/apexrest/AttachmentShare/newAttachment';
					Map<String, String> bodyMap = new Map<String, String>();
					bodyMap.put('action', 'delete');
					bodyMap.put('oldName', a.Name);
					bodyMap.put('ParentId', a.ParentId);
					LASI_HelperClass.callPartner(endpointURL, BodyMap);
				}
			}
		} else {
			for(Attachment a : Trigger.new){
				if(sharedContracts.containsKey(a.ParentId)){
					if(trigger.isInsert){
						String endpointURL = 'callout:Limeade/services/apexrest/AttachmentShare/newAttachment';
						Map<String, String> bodyMap = new Map<String, String>();
						String b64 = EncodingUtil.base64Encode(a.Body);
						bodyMap.put('action', 'new');
						bodyMap.put('Body', b64);
						bodyMap.put('Name', a.Name);
						bodyMap.put('ContentType', a.ContentType);
						bodyMap.put('ParentId', a.ParentId);
						LASI_HelperClass.callPartner(endpointURL, BodyMap);
					} else if(Trigger.isUpdate){
						String oldName = trigger.OldMap.get(a.Id).Name;
						String endpointURL = 'callout:Limeade/services/apexrest/AttachmentShare/updateAttachment';
						Map<String, String> bodyMap = new Map<String, String>();
						bodyMap.put('action', 'update');
						bodyMap.put('oldName', oldName);
						bodyMap.put('Name', a.Name);
						bodyMap.put('ParentId', a.ParentId);
						LASI_HelperClass.callPartner(endpointURL, BodyMap);
					} 
				}
			}
		}
	}
}