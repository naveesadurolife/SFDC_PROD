public with sharing class WithingsMeasureTriggerHelper {
	
	public void version1(list<Withings_Measure__c> lstNewWithingsMeasures){
		
		set<Id> setWithingsMeasureGroupIds = new set<Id>();
		map<Id, list<Id>>mapWMGIdandWM = new map<Id, list<Id>>();
		map<Id, Goal__c> mapGoalsToBeUpdated = new map<Id, Goal__c>();
		for(Withings_Measure__c objWithingsMeasure :lstNewWithingsMeasures){
			
			setWithingsMeasureGroupIds.add(objWithingsMeasure.Measure_Group__c);
			
		}// end of for-each
		
		for(Withings_Measure__c objWithingsMeasure : [SELECT Id, Value__c, Measure_Group__c, Goal__c 
																			FROM Withings_Measure__c 
																			WHERE Measure_Group__c IN :setWithingsMeasureGroupIds
																			ORDER BY Measure_Date__c DESC]){
			
			system.debug('##--objWithingsMeasure.Measure_Group__c: '+objWithingsMeasure.Measure_Group__c);																	
			if(mapWMGIdandWM.get(objWithingsMeasure.Measure_Group__c) == null){
				mapWMGIdandWM.put(objWithingsMeasure.Measure_Group__c, new list<Id>());
			}
			
			mapWMGIdandWM.get(objWithingsMeasure.Measure_Group__c).add(objWithingsMeasure.Id);																	
		}
		
		for(Withings_Measure__c objWithingsMeasure :lstNewWithingsMeasures){
			
			if(objWithingsMeasure.Goal__c == null){
				continue;
			}
			if(mapWMGIdandWM.get(objWithingsMeasure.Measure_Group__c).size() == 1){
				
				Goal__c objGoal = new Goal__c(Id = objWithingsMeasure.Goal__c,
											  Weight_First_Taken__c = objWithingsMeasure.Converted_Value__c);
				
				mapGoalsToBeUpdated.put(objGoal.Id, objGoal);
			}else if(mapWMGIdandWM.get(objWithingsMeasure.Measure_Group__c).size() > 1){
				
				
				Goal__c objGoal = new Goal__c(Id = objWithingsMeasure.Goal__c,
											  Weight_Last_Taken__c = objWithingsMeasure.Converted_Value__c);
				
				mapGoalsToBeUpdated.put(objGoal.Id, objGoal);
			}
			
		}// end of for-each
		
		if(mapGoalsToBeUpdated.values().size() > 0){
			update mapGoalsToBeUpdated.values();
		}
	}// end of populateWeightFirstTakenAndWeightLastTaken
	
	
	/*
		This method is used to Assign the Weight First Taken and Last Takes details
		on a goal.
		Since the Measure object is directly related to Goal, We query all the
		Goals of the given List of Measures and their associated "Weight" Measures in Ascending order.
		First measure will the the Weight First Taken
		Last Measure will be Weight Last taken
	*/
	public void populateWeightFirstTakenAndWeightLastTaken(list<Withings_Measure__c> lstNewWithingsMeasures){
		set<Id> setGoals = new set<Id>();
		list<Goal__c> lstGoalsToBeUpdated = new list<Goal__c>();
		decimal firstWeight=null, lastWeight=null;
		
		for(Withings_Measure__c measure : lstNewWithingsMeasures){
			setGoals.add(measure.Goal__c);
		}	//	end of for-each Measure
		
		for(Goal__c objGoal : [SELECT Id, Weight_First_Taken__c, Weight_Last_Taken__c,
										(SELECT Id, Converted_Value__c, Measure_Date__c FROM Withings_Measures__r 
																WHERE Type__c = 1 AND Converted_Value__c > 40 ORDER BY Measure_Date__c ASC) 
								 FROM Goal__c WHERE Id IN :setGoals]){
				//	getting First and last weights via for loop to avoid the error
			for(Withings_Measure__c objMeasure : objGoal.Withings_Measures__r){
				if(firstWeight == null){
					firstWeight = objMeasure.Converted_Value__c;
				}
				
				lastWeight = objMeasure.Converted_Value__c;
				
			}	//	end of for-each
			
			objGoal.Weight_First_Taken__c = firstWeight;
			objGoal.Weight_Last_Taken__c = lastWeight;
			lstGoalsToBeUpdated.add(objGoal);
			
		}	//	end of for-each Goal
		
		if(lstGoalsToBeUpdated.size() > 0){
			update lstGoalsToBeUpdated;
		}
	}	//	end of version2
	
}	//	end of WithingsMeasureTriggerHelper