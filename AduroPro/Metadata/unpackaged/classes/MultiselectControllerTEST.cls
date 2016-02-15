@istest
public class MultiselectControllerTEST {
    public static testmethod void testSelect(){
        MultiselectController con = new MultiselectController();
        List<SelectOption> options = new List<SelectOption>();
        con.leftOptions = new List<SelectOption>();
        con.rightOptions = new List<SelectOption>() ;
        con.leftOptionsHidden ='abc&xyx';
        con.rightOptionsHidden  = 'aaa&eee';
    }
}