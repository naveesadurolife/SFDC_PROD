public class WithingsBodyMeasure {
	
	private static map<string, string> mapMeasureTypes = new map<string, string>{
															'1' =>'Weight (kg)',
															'4' => 'Height (meter)',
															'5' => 'Fat Free Mass (kg)',
															'6' => 'Fat Ratio (%)',
															'8' => 'Fat Mass Weight (kg)',
															'9' => 'Diastolic Blood Pressure (mmHg)',
															'10' => 'Systolic Blood Pressure (mmHg)',
															'11' => 'Heart Pulse (bpm)',
															'54' => 'SP02(%)'		
														 };
	
	
	public Integer status;
	public Body body;
	
	public class Body {
		public Integer updatetime;
		public Integer more;
		public List<Measuregrps> measuregrps;
	}
	
	public class Measuregrps {
		public Integer grpid;
		public Integer attrib;
		public Integer measureDate;
		public Integer category;
		public String comment;
		public List<Measures> measures;
		
		public void setDate(Integer dateInt){
			measureDate = dateInt;
		}	//	end of setDate
	}

	public class Measures {
		public Integer value;
		public Integer type;
		public Integer unit;
	}
	
	
	public static WithingsBodyMeasure parse(String json) {
		json = json.replace('"date"', '"measureDate"');
		return (WithingsBodyMeasure) System.JSON.deserialize(json, WithingsBodyMeasure.class);
	}
	
	
	
		/*
			Business Methods
		*/
		
	public DateTime getLastUpdatedTime(){
		try{
			WithingsHelper helper = new WithingsHelper();
			return helper.getDateFromUnixEpoch(body.updatetime);
		} catch(Exception e){
			system.debug('##--Problem getting last updated time: ' + e.getMessage());
		}
		return null;
	}	//	end of getLastUpdatedTime
	
	
	
	public list<Withings_Measure_Group__c> getListOfMeasureGroups(Id contactId, Goal__c objGoal){
		list<Withings_Measure_Group__c> lstGroups = new list<Withings_Measure_Group__c>();
		WithingsHelper helper = new WithingsHelper();
		
		if(body.measuregrps == null || body.measuregrps.isEmpty()){
			return lstGroups;
		}
		for(Measuregrps grp : body.measuregrps){
			//system.debug('##--Creating Group: ' + grp);
			Withings_Measure_Group__c objMeasureGrp = new Withings_Measure_Group__c(Name = String.valueOf(grp.grpid),
																					GroupId__c = grp.grpid,
																					Attributed__c = grp.attrib,
																					Category__c = grp.category,
																					Comments__c = grp.comment,
																					Measure_Date__c = helper.getDateFromUnixEpoch(grp.measureDate),
																					Last_Updated__c = helper.getDateFromUnixEpoch(body.updatetime),
																					Contact__c = contactId);
			if(objGoal != null){
				objMeasureGrp.Goal__c = objGoal.Id;
			}
			lstGroups.add(objMeasureGrp);
		}	//	end of for-each MeasureGroup
		
		return lstGroups;
		
	}	//	end of getListOfMeasureGroups
	
	public list<Withings_Measure__c> getListOfMeasuresForGroup(Withings_Measure_Group__c objGroup, Goal__c objGoal){
		list<Withings_Measure__c> lstMeasures = new list<Withings_Measure__c>();
		
		for(Measuregrps grp : body.measuregrps){
			system.debug('##--SF Group: ' + objGroup);
			system.debug('##--Measure Group: ' + grp);
			if(objGroup.GroupId__c == grp.grpid){
				return createMeasuresForGroup(grp, objGroup.Id, objGoal.Id);
			}
		}	//	end of for-each Measure Group
		
		return lstMeasures;
		
	}	//	end of getListOfMeasuresForGroup
	
	/*
	public map<Withings_Measure_Group__c, list<Withings_Measure__c>> createSFMeasureGroups(Id contactId){
		WithingsHelper helper = new WithingsHelper();
		map<Withings_Measure_Group__c, list<Withings_Measure__c>> mapMeasureGrpData = new map<Withings_Measure_Group__c, list<Withings_Measure__c>>();
		
		if(body.measuregrps == null || body.measuregrps.isEmpty()){
			return mapMeasureGrpData;
		}
		
		for(Measuregrps grp : body.measuregrps){
			//system.debug('##--Creating Group: ' + grp);
			Withings_Measure_Group__c objMeasureGrp = new Withings_Measure_Group__c(Name = String.valueOf(grp.grpid),
																					GroupId__c = grp.grpid,
																					Attributed__c = grp.attrib,
																					Category__c = grp.category,
																					Comments__c = grp.comment,
																					Measure_Date__c = helper.getDateFromUnixEpoch(grp.measureDate),
																					Last_Updated__c = helper.getDateFromUnixEpoch(body.updatetime),
																					Contact__c = contactId);
			//system.debug('##--Done creating the Group: ' + objMeasureGrp);
			//list<Withings_Measure__c> lstMeasures = this.createMeasuresForGroup(grp);
			
			//mapMeasureGrpData.put(objMeasureGrp, lstMeasures);
		}	//	end of for-each MeasureGroup
		
		return mapMeasureGrpData;
	}	//	end of createSFMeasureGroups
	*/
	
	private list<Withings_Measure__c> createMeasuresForGroup(Measuregrps grp, Id groupId, Id goalId){
		list<Withings_Measure__c> lstMeasures = new list<Withings_Measure__c>();
		
		for(Measures measure : grp.measures){
			lstMeasures.add(new Withings_Measure__c(Name = mapMeasureTypes.get(String.valueOf(measure.type)),
													Measure_Group__c = groupId,
													Type__c = measure.type,
													Unit__c = measure.unit,
													Value__c = measure.value,
													Goal__c = goalId));
			
		}	//	end of for-each Measure
		
		return lstMeasures;
	}	//	end of createMeasuresForGroup
	
	
	/*
	static testMethod void testParse() {
		String json = '{'+
		'    \"status\": 0,'+
		'    \"body\": {'+
		'        \"updatetime\": 1426456551,'+
		'        \"measuregrps\": ['+
		'            {'+
		'                \"grpid\": 327888840,'+
		'                \"attrib\": 2,'+
		'                \"date\": 1426123682,'+
		'                \"category\": 1,'+
		'                \"comment\": \"Would like to reduce Fat Mass %\",'+
		'                \"measures\": ['+
		'                    {'+
		'                        \"value\": 7711,'+
		'                        \"type\": 1,'+
		'                        \"unit\": -2'+
		'                    },'+
		'                    {'+
		'                        \"value\": 5937,'+
		'                        \"type\": 5,'+
		'                        \"unit\": -2'+
		'                    },'+
		'                    {'+
		'                        \"value\": 2300,'+
		'                        \"type\": 6,'+
		'                        \"unit\": -2'+
		'                    },'+
		'                    {'+
		'                        \"value\": 1774,'+
		'                        \"type\": 8,'+
		'                        \"unit\": -2'+
		'                    }'+
		'                ]'+
		'            },'+
		'            {'+
		'                \"grpid\": 316346695,'+
		'                \"attrib\": 2,'+
		'                \"date\": 1423924043,'+
		'                \"category\": 1,'+
		'                \"measures\": ['+
		'                    {'+
		'                        \"value\": 1727,'+
		'                        \"type\": 4,'+
		'                        \"unit\": -3'+
		'                    }'+
		'                ]'+
		'            },'+
		'            {'+
		'                \"grpid\": 316346694,'+
		'                \"attrib\": 2,'+
		'                \"date\": 1423924043,'+
		'                \"category\": 1,'+
		'                \"measures\": ['+
		'                    {'+
		'                        \"value\": 7711,'+
		'                        \"type\": 1,'+
		'                        \"unit\": -2'+
		'                    }'+
		'                ]'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		WithingsBodyMeasure obj = parse(json);
		System.assert(obj != null);
	}*/
	
	
}	//	end of WithingsBodyMeasure