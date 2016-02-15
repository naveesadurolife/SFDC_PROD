public with sharing class OnsiteEventResult {
    public string eventId{get;set;}
    public Integer CountOfCotinineTest{get;set;}
    public WW_Event__c objEvent{get;set;}
    public string ReconciledBy{get;set;}
    public string ReconciledDateTime{get;set;}
    public String errorMessage {get; private set;}
    public String errorMessageStyle {get; private set;}
    private static final String VISIBLE_STYLE = '';
    private static final String INVISIBLE_STYLE = 'display:none;';      
    public OnsiteEventResult()
    {
        eventId=ApexPages.currentPage().getParameters().get('event');
        objEvent=[Select Id,Name,Physical_Count_from_Check_In__c,Physical_Count_from_Data_Sheets__c,Physical_Count_of_Cotinine_Test__c,
                    Reconciled_By__c,Reconciled_Date__c,Program__r.Tobacco_Saliva__c,Billing_Status__c
                  From WW_Event__c Where Id=:eventId];
        CountOfCotinineTest=[Select Count() From Order__c Where WW_Event__c=:objEvent.Id AND Comment_Smokefree__c='Cotinine'];
        ReconciledBy=objEvent.Reconciled_By__c;
        ReconciledDateTime=objEvent.Reconciled_Date__c==null?'':'('+objEvent.Reconciled_Date__c.format('MM/dd/yyyy h:m a')+')';
        changeErrorMessageVisibility(false);
    }
    public Integer getPeopleWithResults()
    {
        return [Select count() From Order__c where (Order_Status__c='Received' OR Order_Status__c='Sent Limeade') AND WW_Event__c=:eventId];
    }
    public Integer getReconcileResults()
    {
        return [Select count() From Order__c where Order_Status__c='Submitted' AND 
                Reconciliation_Reason__c!=null AND Reconciliation_Reason__c!='' AND WW_Event__c=:eventId];
    }
    public Integer getPeopleCheckedInWithNoResults()
    {
        return [Select count() From Order__c where Order_Status__c='Submitted' AND 
                (Reconciliation_Reason__c=null OR Reconciliation_Reason__c='') AND WW_Event__c=:eventId];
    }
    private void changeErrorMessageVisibility(Boolean show) {
        if ( show ) {
            errorMessageStyle = VISIBLE_STYLE;
        }else {
            errorMessageStyle = INVISIBLE_STYLE;
        }
    }   
    public PageReference reconsileNow()
    {
        PageReference pr;
        Boolean errorOnPage=false;
        Integer incompleteStaff=[Select count() From Event_Resource__c 
                                where  WW_Event__c=:objEvent.Id and Resource_Type__c='Event Staff' AND
                                (Start_Time__c=null OR End_Time__c=null OR 
                                    Attendance__c=null OR Attendance__c='' OR Staffing_Agency__c=null OR Staffing_Agency__c='' OR 
                                    Event_Staff_Rating__c=null OR Event_Staff_Rating__c='') ];
        Integer incompleteExpense=[Select count() From Event_Resource__c 
                                WHERE  WW_Event__c=:objEvent.Id and Expense_Type__c!=null and Expense_Type__c!='' AND
                                (Company__c=null OR Company__c='' OR Expense_Details__c=null OR Expense_Details__c='' OR Transaction_Date__c=null OR 
                                    Expected_Expense__c=null) ]; 
                                    
        errorMessage='Errors:<ul style=\"color:#c00;\">';
                                          
        if(String.isBlank(ReconciledBy))
        {
            errorMessage += '<li style=\"color:#c00;\">Reconciled By needs filled in</li>';
            errorOnPage=true;
        }
        if(getPeopleCheckedInWithNoResults()>0 || incompleteStaff>0 || incompleteExpense>0)
        {
            if(getPeopleCheckedInWithNoResults()>0)
                errorMessage += '<li style=\"color:#c00;\">People Checked In with No Results.</li>';
            if(incompleteStaff>0)
                errorMessage += '<li style=\"color:#c00;\">staff info must be filled in for each staff member</li>';
            if(incompleteExpense>0)
                errorMessage += '<li style=\"color:#c00;\">expenses must be filled out (if any)</li>';
            errorOnPage=true;
        }
        if(objEvent.Physical_Count_from_Check_In__c==null || objEvent.Physical_Count_from_Data_Sheets__c==null || (objEvent.Program__r.Tobacco_Saliva__c && objEvent.Physical_Count_of_Cotinine_Test__c==null))
        {
            errorMessage += '<li style=\"color:#c00;\">physical count boxes must have data entered</li>';
            errorOnPage=true;
        }
        else if(objEvent.Physical_Count_from_Data_Sheets__c!=getPeopleWithResults())
        {
            errorMessage += '<li style=\"color:#c00;\">Physical Count from Data Sheets must equal \"# of people w/ results"</li>';
            errorOnPage=true;
        }
        if(!errorOnPage && !String.isBlank(ReconciledBy) )
        {
            objEvent.Reconciled_By__c=ReconciledBy;
            objEvent.Reconciled_Date__c=Datetime.now();
            objEvent.Billing_Status__c='Reconciled';
            changeErrorMessageVisibility(false);
            pr=Page.OnsiteEventResult;
            pr.getParameters().put('event',objEvent.Id);
            pr.setRedirect(true);
        }
        else if(!errorOnPage) 
        {
            changeErrorMessageVisibility(false);
        }
        else if(errorOnPage) 
        {
           
            errorMessage += '</ul>';
            changeErrorMessageVisibility(true);
        }       
        
        
        
        update objEvent;
        return pr;
    }
    public PageReference save()
    {
        update objEvent;
        return null;
    }
    @RemoteAction
    public static List<String> getEventChallengesOptions()
    {
        List<String> listEventChallengesOptions=new List<String>();
       Schema.DescribeFieldResult fieldResult = WW_Event__c.Event_Challenges__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry f : ple)
       {
          listEventChallengesOptions.add(f.getValue());
       }
       return listEventChallengesOptions;       
    }   
    @RemoteAction
    public static String updateEventChallenges(String eid,String eventChallenges)
    {
        String result='';
        try
        {
            WW_Event__c e=new WW_Event__c(Id=eid,Event_Challenges__c=eventChallenges);
            update e;
            result='success';
        }
        catch(Exception ex)
        {
            result='Error Occured:'+ex.getMessage();
        }
        return result;
    }    
}