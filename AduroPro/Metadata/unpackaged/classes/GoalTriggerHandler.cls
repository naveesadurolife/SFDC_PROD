/**
	* GoalTriggerHandler - <description>
	* Created by BrainEngine Cloud Studio
	* @author: Navees Ahmed
	* @version: 1.0
*/

public with sharing class GoalTriggerHandler{
	public static Boolean AfterUpdateExecuted=false;
	
	public static void AfterInsert(List<Goal__c> listGoals)
	{
		UpdateRecords(listGoals);
	}
	public static void AfterUpdate(List<Goal__c> listGoals)
	{
		UpdateRecords(listGoals);
	}
	public static void AfterDelete(List<Goal__c> listGoals)
	{
		UpdateRecords(listGoals);
	}	
	public static void AfterUnDelete(List<Goal__c> listGoals)
	{
		UpdateRecords(listGoals);
	}
	public static void UpdateRecords(List<Goal__c> listGoals)
	{
		if(listGoals!=null && listGoals.size()>0)
		{
			Set<Id> contactIDs=new Set<Id>();
			for(Goal__c g:listGoals)
			{
				contactIDs.add(g.Contact__c);
			}
			if(!System.isBatch() && !System.isFuture() && !System.isScheduled())
			{
				UpdateRecordsFuture(contactIDs);
			}
		}
	}
	@future
	public static void UpdateRecordsFuture(Set<Id> contactIDs)
	{
		AfterUpdateExecuted=true;
		List<Goal__c> listGoals=new List<Goal__c>();
		for(Contact c:[Select Id,(Select Id,X6_Week_Engagement_Goal_Type__c,Coaching_Phase__c From Goals__r Where X6_Week_Engagement_Goal_Type__c!=null order by CreatedDate ASC) From Contact Where Id=:contactIDs])
		{
			Map<String,Integer> mapTypeCount=new Map<String,Integer>();
			for(Goal__c g:c.Goals__r)
			{
				if(!mapTypeCount.containsKey(g.X6_Week_Engagement_Goal_Type__c))
				{
					mapTypeCount.put(g.X6_Week_Engagement_Goal_Type__c,0);
				}
				Integer total=mapTypeCount.get(g.X6_Week_Engagement_Goal_Type__c);
				total=total+1;
				mapTypeCount.put(g.X6_Week_Engagement_Goal_Type__c,total);
				if(total<=1)
				{
					g.Coaching_Phase__c='Novice';
				}
				else if(total<=2)
				{
					g.Coaching_Phase__c='Intermediate';
				}
				else if(total>=3)
				{
					g.Coaching_Phase__c='Advanced';
				}	
				listGoals.add(g);
			}
		}
		update listGoals;
	}
}