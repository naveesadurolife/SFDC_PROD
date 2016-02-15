trigger Contact_beforeUpsert on Contact (before insert, before update, after Update) {
	
	ContactTriggerHandler handler = new ContactTriggerHandler();
	
	
	if(trigger.isBefore){
		for( Contact contact : trigger.new ) {
			if( contact.Birthdate != null && contact.Email != null ){
				String key = contact.LastName + '_'+ 
					contact.Email + '_' + 
					contact.Birthdate.year() + 
					contact.Birthdate.month() + 
					contact.Birthdate.day();
				key = key.toUpperCase();
				contact.Concat_Unique_Key__c = key;
			}
		}
	}else if(trigger.isAfter && trigger.isUpdate){
		
		handler.onAfterUpdate(trigger.new, trigger.OldMap);
	}
}