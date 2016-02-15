public with sharing class OrderResultsFormController {
	public String program {get;set;}
    public String employer {get;set;}
    public Boolean ignoreTransferSetting {get;set;}
    
    public OrderResultsFormController(String program, String e, Boolean ignoreTransferSetting) {
    	this.program = program;
        this.employer = e;
        this.ignoreTransferSetting = ignoreTransferSetting;
    }
    
    public OrderResultsFormController() {
    	employer = '';
        ignoreTransferSetting = false;
    	program = ApexPages.currentPage().getParameters().get('program');
        employer = ApexPages.currentPage().getParameters().get('e');
        //ignoreTransferSetting = ApexPages.currentPage().getParameters().get('ignoreTransferSetting') == 'true' ? true : false;
        ignoreTransferSetting = true;
        System.debug( logginglevel.FINE, ApexPages.currentPage().getParameters() );
    } 
    
    public PageReference submitResults() {
        
        //HomeTestKitResultsSenderV2 sender = new HomeTestKitResultsSenderV2(employer, ignoreTransferSetting);
        HomeTestKitResultsSenderV2 sender = new HomeTestKitResultsSenderV2(employer, false);
        //do not set higher than 30 unless you also edit the HomeTestKitResultSenderV2 to send batches bigger than 3 each (salesforce limit)
        ID batchprocessid = Database.executeBatch(sender,30);
        
        // Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + program);
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    
    static testMethod void testOrderResultsFormController() {
    	OrderResultsFormController orfc = new OrderResultsFormController( 'testProg','wellmetrics demo', false);
    	
    	PageReference resultRef = orfc.submitResults();
    	PageReference pageRef = new PageReference('/testProg');
    	system.assertEquals( resultRef.getUrl(), pageRef.getUrl() );
    	
    	orfc = new OrderResultsFormController();
    	system.assertEquals( orfc.employer, null );
    	
    }
}