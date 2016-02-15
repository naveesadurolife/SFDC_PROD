@RestResource(urlMapping='/DeleteProducts/*')
global with sharing class LASI_DeleteProducts {
	@HttpPost
	global static String deleteLineItems(String LineItemIds) {
		List<String> ProductIdList = LineItemIds.split(';');
		List<OpportunityLineItem> delLineItems = new List<OpportunityLineItem>();
		for(String id : ProductIdList){
			delLineItems.add(new OpportunityLineItem(Id = id));
		}
		String returnBody = '';
		Database.DeleteResult[] dsr = Database.delete(delLineItems);
		for(Integer i = 0; i < dsr.Size(); i++){
			Database.DeleteResult dr = dsr[i];
			returnBody += 'DELETE:';
			returnBody += dr.Id+'=>';
			returnBody += dr.isSuccess()+'=>';
			returnBody += dr.getErrors()+';';
		}
		return returnBody;
	}
}