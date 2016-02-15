@RestResource(urlMapping='/AttachmentShare/*')
global with sharing class LASI_ShareAttachments {
	@HttpPost
	global static String newAttachment(
					String action
					,String Body
					,String oldName
					,String Name
					,String ContentType
					,String ParentId) {
		if(action == 'new'){
			Contract c = [SELECT Id FROM Contract WHERE Limeade_Contract_Id__c =: ParentId];
			Attachment a = new Attachment(Body = EncodingUtil.base64Decode(Body), Name = Name, ContentType = ContentType, ParentId = c.Id);
			insert a;
			return null;
		} else if(action == 'update'){
			Contract c = [SELECT Id FROM Contract WHERE Limeade_Contract_Id__c =: ParentId];
			Attachment a = [SELECT Id FROM Attachment WHERE Name =: oldName AND ParentId =: c.Id];
			a.Name = Name;
			update a;
			return null;
		} else if(action == 'delete'){
			Contract c = [SELECT Id FROM Contract WHERE Limeade_Contract_Id__c =: ParentId];
			Attachment a = [SELECT Id FROM Attachment WHERE Name =: oldName AND ParentId =: c.Id];
			delete a;
		}

		return null;
			
	}
}