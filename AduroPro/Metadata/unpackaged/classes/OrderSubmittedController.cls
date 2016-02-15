public class OrderSubmittedController {
	public Boolean isDuplicate {get;set;}
	
	public OrderSubmittedController() {
		
		isDuplicate = false;
		
        String duplicate = ApexPages.currentPage().getParameters().get('duplicate');
        if ( duplicate == 'true') {
        	isDuplicate = true;
        }
	}
	
	static testMethod void testOrderSubmittedController(){
		OrderSubmittedController osc = new OrderSubmittedController();
		system.assert( !osc.isDuplicate );
	}
}