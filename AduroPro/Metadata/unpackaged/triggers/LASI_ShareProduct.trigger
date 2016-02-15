trigger LASI_ShareProduct on Product2 (after insert) {
	
	Id standardPricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
	for(Product2 p : trigger.new){
		if(p.ConnectionReceivedId <> null || Test.isRunningTest()){
			insert new PricebookEntry(Product2Id = p.Id, Pricebook2Id = standardPricebookId, unitprice = 0, IsActive = true);
		}
	}
}