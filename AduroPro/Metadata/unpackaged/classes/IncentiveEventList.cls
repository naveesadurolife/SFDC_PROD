/**
	* IncentiveEventList - <description>
	* Created by BrainEngine Cloud Studio
	* @author: Navees Ahmed
	* @version: 1.0
*/

public with sharing class IncentiveEventList{
	public Boolean errorOnPage{get;set;}
	public String pageMessage{get;set;}	
	public List<WW_Event__c> listEvents{get;set;}
	public String programName{get;set;}
	public String eventRegistrationLogo{get;set;}
	public IncentiveEventList()
	{
		String programId=ApexPages.currentPage().getParameters().get('id');
		listEvents=[Select Id,Name,Event_Date__c,Location__c,Program__c,Program__r.Name,Start_Time__c,End_Time__c,Program__r.Program_Logo__c 
					From WW_Event__c Where Program__c=:programId AND Event_Type__c=:'Incentive Event'];
		if(listEvents.size()>0)
		{
			programName=listEvents[0].Program__r.Name;
			if(!String.isBlank(listEvents[0].Program__r.Program_Logo__c))
			{
				eventRegistrationLogo=Constant.DOCUMENT_URL.replace('@@DOCID@@', listEvents[0].Program__r.Program_Logo__c);
			}			
		}
	}
}