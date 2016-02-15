public with sharing class OnsiteStaffSignOff {
    public string eventId{get;set;}
    public string orderId{get;set;}
    public string sid{get;set;}
    public string street{get;set;}
    public string city{get;set;}
    public string state{get;set;}
    public string zip{get;set;}
    public string country{get;set;}
    public string signedOff{get;set;}
    public Decimal totalMilesEligible{get;set;}
    public Decimal totalMiles{get;set;}
    public Decimal totalPay{get;set;}
    public Decimal totalPaySignedOff{get;set;}
    public WW_Event__c objEvent{get;set;}
    public Event_Resource__c objEventR{get;set;}
    private static final String VISIBLE_STYLE = '';
    private static final String INVISIBLE_STYLE = 'display:none;';
    public String errorMessage {get; private set;}
    public String errorMessageStyle {get; private set;} 
    public String signature{get;set;}
    public String selectedTransit{get;set;}
    public String driverName{get;Set;}
    public Decimal mileageReimbursement{get;Set;}
    public Decimal totalHoursPay{get;Set;}
    public Decimal EligibleMilesAfter{get;Set;}
    public Decimal EligibleMilesRate{get;Set;}
    public boolean Not_Eligible_for_Mileage {get;set;}
    //public Attachment attachment{get;Set;}
    public OnsiteStaffSignOff()
    {
        signedOff='no';
        //attachment = new Attachment();
        changeErrorMessageVisibility(false);
        eventId=ApexPages.currentPage().getParameters().get('event');
        sid=ApexPages.currentPage().getParameters().get('sid');
        objEvent=[Select Id,Name From WW_Event__c Where Id=:eventId];
        Custom_Configuration__c EligibleMilesAfterCC = Custom_Configuration__c.getValues('EligibleMilesAfter');     
        Custom_Configuration__c EligibleMilesRateCC = Custom_Configuration__c.getValues('EligibleMilesRate');   
        try
        {
            EligibleMilesAfter=Decimal.valueOf(EligibleMilesAfterCC.Value__c);
        }
        catch(Exception ex){EligibleMilesAfter=0;}
        try
        {
            EligibleMilesRate=Decimal.valueOf(EligibleMilesRateCC.Value__c);
        }
        catch(Exception ex){EligibleMilesRate=.53;}     
        getEventStaff();
    }
    private void getEventStaff()
    {
        objEventR=[Select Id,Contact__c,Contact__r.Name,Contact__r.Email,Event_Role__c,Start_Time__c,End_Time__c,Total_Miles__c,Total_Hours_Time__c,Event_Rate__c,
                    Additional_Expense_Credits__c,Attendance__c,Event_Staff_Rating__c,Staffing_Agency__c,WW_Event__r.Event_Address__c,
                    Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingState,Contact__r.MailingPostalCode,Contact__r.MailingCountry,
                    Mileage_Reimbursement__c,Total_Hours_Pay__c,Not_Eligible_for_Mileage__c,Transit_Method__c, Total_Calculated_Pay__c From Event_Resource__c where  WW_Event__c=:eventId and Resource_Type__c='Event Staff' AND Id=:sid];
        street=objEventR.Contact__r.MailingStreet;
        city=objEventR.Contact__r.MailingCity;
        state=objEventR.Contact__r.MailingState;
        zip=objEventR.Contact__r.MailingPostalCode;
        country='USA';//bjEventR.Contact__r.MailingCountry;
        String address=street+', '+city+', '+state+' '+zip+', '+country;
        objEventR.Total_Miles__c=getDistance(address,objEventR.WW_Event__r.Event_Address__c);
        totalMilesEligible=objEventR.Total_Miles__c-EligibleMilesAfter;
        mileageReimbursement=objEventR.Mileage_Reimbursement__c;
        totalHoursPay=objEventR.Total_Hours_Pay__c;
        selectedTransit=objEventR.Transit_Method__c;
        Not_Eligible_for_Mileage = objEventR.Not_Eligible_for_Mileage__c;
        if(totalMilesEligible==null || totalMilesEligible<0 || objEventR.Not_Eligible_for_Mileage__c == true)
        {
            totalMilesEligible=0;
        }
        //totalPay=((objEventR.Event_Rate__c==null?0:objEventR.Event_Rate__c)*(objEventR.Total_Hours_Time__c==null?0:objEventR.Total_Hours_Time__c))+(totalMilesEligible*.53);
        //totalPay=(objEventR.Total_Hours_Pay__c==null?0:objEventR.Total_Hours_Pay__c)+(totalMilesEligible*EligibleMilesRate);
        
        totalPay= objEventR.Total_Calculated_Pay__c;
        
        totalPaySignedOff=totalPay;
        totalMiles =0;
    }
    public void changeErrorMessageVisibility(Boolean show) {
        if ( show ) {
            errorMessageStyle = VISIBLE_STYLE;
        }else {
            errorMessageStyle = INVISIBLE_STYLE;
        }
    }
    /*public void uploadReceipt()
    {
                <tr>                
                    <td class="cell">Attach Receipts</td><td class="cell"><apex:actionRegion ><apex:outputPanel id="pnlUpload"><apex:inputFile value="{!attachment.body}" filename="{!attachment.name}" id="file" style="width:15em;"  accept="image/*;capture=camera" /><apex:commandButton value="Upload" action="{!uploadReceipt}"/></apex:outputPanel></apex:actionRegion></td>
                </tr>       
        attachment.ParentId=objEventR.Id;
        insert attachment;
        attachment = new Attachment();
    }*/
    
    public PageReference saveMileage()
    {
     PageReference pageRef = new PageReference('/' + ApexPages.currentPage().getParameters().get('id') );
     decimal total = 0;
     
     
         
        Event_Resource__c er=new Event_Resource__c(Id=objEventR.Id,Total_Miles__c = objEventR.Total_Miles__c,Driver_Name__c=driverName,Transit_Method__c=selectedTransit);
        update er;
   
       return null;
    }
    

    public void save()
    {
        /*Document doc=new Document();
        doc.folderid =[Select Id From Folder Where DeveloperName=:'cusomdocs'].Id;
        doc.name=personName+'.png';
        doc.body=EncodingUtil.base64Decode(signature.replace('data:image/png;base64,', ''));
        insert doc;     */
        String fileName='Signature_'+System.now().year()+'_'+System.now().month()+'_'+System.now().day()+'_'+System.now().hour()+'_'+System.now().minute()+'_'+System.now().second()+'.png';
        Attachment attachment = new Attachment();
        attachment.Body = EncodingUtil.base64Decode(signature.replace('data:image/png;base64,', ''));
        attachment.Name = fileName;//String.valueOf('test.txt');
        attachment.ParentId = objEventR.Id; 
        insert attachment;      
        if(String.isBlank(selectedTransit) || !selectedTransit.equalsIgnoreCase('Personal Vehicle') )
        {
            objEventR.Total_Miles__c=null;
        }       
        Event_Resource__c er=new Event_Resource__c(Id=objEventR.Id,Total_Miles__c=objEventR.Total_Miles__c,Signed_Off_Pay__c=totalPaySignedOff,Signed_Off_Date__c=System.now(),Driver_Name__c=driverName,Transit_Method__c=selectedTransit);
        update er;

        Contact c=new Contact(Id=objEventR.Contact__c,MailingStreet=street,MailingCity=city,MailingState=state,MailingPostalCode=zip,MailingCountry=country);
        update c;
        signedOff='yes';
    }
    public List<SelectOption> getTransitMethods()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','None'));
        Schema.DescribeFieldResult fieldResult = Event_Resource__c.Transit_Method__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }   
    
    
    
    @RemoteAction
    public static Decimal getDistance(String startAddress,String endAddress)
    {
        Decimal distance=0;
        startAddress=String.isNotBlank(startAddress)?startAddress:'';
        endAddress=String.isNotBlank(endAddress)?endAddress:'';
        googleMaps gm = new googleMaps(startAddress,endAddress);
        distance=gm.distance;
        if(distance==null)
        {
            distance=0;
        }
        distance=distance*2;
        return distance;

//      distance = gm.distance;
//      duration = gm.duration;
//      travelTime = gm.travelTime;     
    }
    
    
/*public static String getJsonResults(
            String address1,
            String address2) {
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        req.setMethod('GET');
        
        String url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
            + '?origins=' + EncodingUtil.urlEncode(address1, 'UTF-8')
            + '&destinations=' + EncodingUtil.urlEncode(address2, 'UTF-8')
            + '&mode=driving'
            + '&sensor=false'
            + '&language=en'
            + '&units=imperial';
            
        req.setEndPoint(url);
        System.debug('url======='+url);
        HTTPResponse resp = http.send(req);
        String jsonResults =resp.getBody();
        return jsonResults;
    }   */
}