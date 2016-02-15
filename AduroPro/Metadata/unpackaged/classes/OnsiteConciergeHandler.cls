public with sharing class OnsiteConciergeHandler{
	public void saveOnsiteConciergeHandler()
	{
    	try
    	{
			String oid=ApexPages.currentPage().getParameters().get('oid');
	    	Order__c o=new Order__c(Id=oid);
			o.Concierge_Interested__c='Yes';
	    	update o;
    	}
    	catch(Exception ex)
		{
			System.debug('================='+ex.getMessage());
		}
	}

}