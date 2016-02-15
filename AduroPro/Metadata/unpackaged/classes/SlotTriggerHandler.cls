public with sharing class SlotTriggerHandler {
	public static Boolean RecreateSlot=true;
	public static void AfterDelete(List<Slot__c> listSlots)
	{
		if(listSlots!=null && listSlots.size()>0)
        {
            List<Slot__c> listSlotsNew=new List<Slot__c>();
            for(Slot__c s:listSlots)
            {
                Slot__c newS=new Slot__c();
                newS.WW_Event__c=s.WW_Event__c;
                newS.End_Date__c=s.End_Date__c;
                newS.Start_Date__c=s.Start_Date__c;
                newS.Type__c=s.Type__c;
                listSlotsNew.add(newS); 
            }
            insert listSlotsNew;   
        }
	} 
	public static void UpdateEvent(List<Slot__c> listSlots)
	{
		if(listSlots!=null && listSlots.size()>0)
        {
            Set<Id> eventIds=new Set<Id>();
            for(Slot__c s:listSlots)
            {
                eventIds.add(s.WW_Event__c);
            }
			if(!System.isBatch() && !System.isFuture() && !System.isScheduled()  && ((Limits.getLimitFutureCalls()-Limits.getFutureCalls())>0))
			{
				WWEventTriggerHandler.UpdateRollupFields(eventIDs);
			}
        }		
	} 
}