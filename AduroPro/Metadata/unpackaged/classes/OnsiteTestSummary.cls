public with sharing class OnsiteTestSummary {
	public Order__c onsiteTest{get;Set;}
    public OnsiteTestSummary(ApexPages.StandardController stdController) {
    }	
    public void updateScreeningEnd()
    {
    	try
    	{
    		String orderid = ApexPages.currentPage().getParameters().get('id');
    		onsiteTest=[Select id,Screening_End_Time__c,LDL_HDL_Ratio__c,BMI__c,Waist_to_Height_Ratio__c,
								Height_Total_Inches__c,TC_HDL_Ratio__c,ProgramID__r.Screening_HRA__c From Order__c Where Id=:orderid];
			if(onsiteTest.Screening_End_Time__c==null)
			{
				onsiteTest.Screening_End_Time__c=Datetime.now();
				update onsiteTest;
			} 
    	}
    	catch(Exception ex){}   	
    }
}