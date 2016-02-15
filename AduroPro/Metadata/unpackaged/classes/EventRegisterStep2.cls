public with sharing class EventRegisterStep2  implements Database.AllowsCallouts{
    public Slot__c s{get;set;}
    public Slot__c oldS{get;set;}
    public WW_Event__c e{get;set;}
    public String eventId{get;set;}
    public String dateOfBirth{get;set;}
    public String slotId{get;set;}
    public String oldSlotId{get;set;}
    public Boolean slotHasBeenTaken{get;set;}
    public Boolean slotRegistered{get;set;}
    public Boolean alreadyRegistered{get;set;}
    public String eventRegistrationHeader{get;set;}
    public Boolean alreadyRegisteredEmail{get;set;}
    public String eventRegistrationLogo{get;set;}
    public String startTimeStr{get;set;}
    public String endTimeStr{get;set;}
    public String oldEventDateStr{get;set;}
    public String newEventDateStr{get;set;}     
    public String newStartTimeStr{get;set;}
    public String newEndTimeStr{get;set;}       
    public Boolean agreement{get;set;}
    public String formTxt {get;set;}
    
    public EventRegisterStep2()
    {
        agreement=false;
        eventId=Apexpages.currentPage().getParameters().get('eid');
        slotId=Apexpages.currentPage().getParameters().get('sid');
        oldSlotId=Apexpages.currentPage().getParameters().get('osid');
        slotHasBeenTaken=false;
        slotRegistered=false;
        alreadyRegistered=false;
        system.debug('eventId======================='+eventId);
        system.debug('slotId======================='+slotId); 
        //if(!String.isBlank(slotId))
        e=[Select Id,Time_Zone__c,Event_Address__c,Room_Location__c,Event_Logo__c,Program__c,Event_Type__c, Program__r.Consent_Form__r.Scheduling_Consent_Form__c, Time_Frame_Per_Slot__c,Validate_Contacts_Against_Limeade__c From WW_Event__c Where Id=:eventId];
        system.debug('##--Event: ' + e);
        formTxt = e.Program__r.Consent_Form__r.Scheduling_Consent_Form__c;
        if(!String.isBlank(e.Event_Logo__c))
        {
            eventRegistrationLogo=Constant.DOCUMENT_URL.replace('@@DOCID@@', e.Event_Logo__c);
        }       
        {
            s=[Select s.WW_Event__r.Location__c, s.WW_Event__r.Event_Type__c, s.WW_Event__r.End_Time__c,s.WW_Event__r.Email_Text__c, 
                      s.WW_Event__r.Start_Time__c, s.WW_Event__r.Event_Date__c, s.WW_Event__r.Name, s.WW_Event__c, One_Day_Reminder_Sent__c,
                      s.Start_Date__c, s.Name, s.Last_Name__c, s.First_Name__c, s.End_Date__c, s.Email__c,WW_Event__r.Event_Address__c, 
                      s.DOB__c, s.Contact__c,WW_Event__r.Event_Registration_Header__c,WW_Event__r.Validate_Contacts_Against_Limeade__c,
                      s.WW_Event__r.Room_Location__c,
                      s.WW_Event__r.Employer__c,s.Employee_ID__c,
                      s.WW_Event__r.Program__r.Limeade_Identifier_DOB__c, 
                      s.WW_Event__r.Program__r.Limeade_Identifier_Email__c,
                      s.WW_Event__r.Program__r.Limeade_Identifier_Employee_ID__c,
                      s.WW_Event__r.Program__r.Limeade_Identifier_LastName__c,
                      s.WW_Event__r.Attach_Calendar_File__c,
                      s.Type__c
                      From Slot__c s Where Id=:slotId and s.Type__c != 'Break'];
                newStartTimeStr=s.Start_Date__c.format('hh:mm a','America/Los_Angeles');
                newEndTimeStr=s.End_Date__c.format('hh:mm a','America/Los_Angeles');    
                newEventDateStr=s.Start_Date__c.date().format();    
                eventRegistrationHeader='You will receive a confirmation email after you complete this registration.';//s.WW_Event__r.Event_Registration_Header__c;                           
            if(s.Contact__c!=null)
            {
                slotHasBeenTaken=true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Sorry this slot has been taken. Please go back and select a different slot.');
                ApexPages.addMessage(myMsg);                
            }
        }
        if(!String.isBlank(oldSlotId))
        {
            try
            {
                oldS=[Select s.WW_Event__r.Location__c, s.WW_Event__r.Event_Type__c, s.WW_Event__r.End_Time__c,s.WW_Event__r.Email_Text__c, 
                      s.WW_Event__r.Start_Time__c, s.WW_Event__r.Event_Date__c, s.WW_Event__r.Name, s.WW_Event__c, 
                      s.Start_Date__c, s.Name, s.Last_Name__c, s.First_Name__c, s.End_Date__c, s.Email__c, WW_Event__r.Event_Address__c,
                      s.DOB__c, s.Contact__c,WW_Event__r.Event_Registration_Header__c,Employee_ID__c
                      From Slot__c s Where Id=:oldSlotId];
                alreadyRegistered=true; 
                startTimeStr=oldS.Start_Date__c.format('hh:mm a','America/Los_Angeles');
                endTimeStr=oldS.End_Date__c.format('hh:mm a','America/Los_Angeles');
                oldEventDateStr=oldS.Start_Date__c.date().format();
                s.First_Name__c=oldS.First_Name__c;
                s.Last_Name__c=oldS.Last_Name__c;
                s.Email__c=oldS.Email__c;
                dateOfBirth=olds.DOB__c.format();                           
            }
            catch(Exception ex){}
        }
    }
    public void cancel()
    {
        
    }   
    public void save()
    {
        Boolean errorOnPage=false;
        LimeadeValidator lv;
        if(s!=null)
        {
            if(String.isBlank(s.First_Name__c))
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter First Name');
                ApexPages.addMessage(myMsg);
                errorOnPage=true;               
            }
            if(String.isBlank(s.Last_Name__c))
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Last Name');
                ApexPages.addMessage(myMsg);
                errorOnPage=true;               
            }
            if(String.isBlank(s.Email__c))
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Email');
                ApexPages.addMessage(myMsg);
                errorOnPage=true;               
            }
            if(String.isBlank(dateOfBirth))
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Date of Birth');
                ApexPages.addMessage(myMsg);
                errorOnPage=true;               
            }
            else
            {
                try
                {
                    s.DOB__c=Date.parse(dateOfBirth);
                }
                catch(Exception ex)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter valid Date of Birth');
                    ApexPages.addMessage(myMsg);
                    errorOnPage=true;                       
                }
            }
            if(!errorOnPage && s.DOB__c>=Date.today())
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter valid Date of Birth');
                ApexPages.addMessage(myMsg);
                errorOnPage=true;                   
            }
            if(!errorOnPage && e.Validate_Contacts_Against_Limeade__c)
            {
                lv=validateContactInLimeade();
                if(!String.isBlank(lv.ErrorMessage))
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, lv.ErrorMessage);
                    ApexPages.addMessage(myMsg);
                    errorOnPage=true;                   
                }
            }
            if(!agreement)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'You cannot register until you agree with the Terms & Conditions.');
                ApexPages.addMessage(myMsg);
                errorOnPage=true;               
            }           
            if(!errorOnPage)
            {
                Slot__c sTemp=[Select Contact__c From Slot__c Where Id=:s.Id];
                if(!String.isBlank(sTemp.Contact__c))
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Sorry this slot has been taken. Please go back and select a different slot.');
                    ApexPages.addMessage(myMsg);
                    errorOnPage=true;                   
                }
            }
            if(errorOnPage)
            {
                return;
            }
            else
            {
                alreadyRegisteredEmail=false;
                try
                {//Last_Name__c=:s.Last_Name__c AND
                    Slot__c alreadyRegisteredSlot=[Select Id From Slot__c Where  Email__c=:s.Email__c AND WW_Event__c=:s.WW_Event__c AND Id!=:oldSlotId limit 1];
                    alreadyRegisteredEmail=true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'There is already an appointment scheduled using this email.  Use another email or click on \'Forgot your appointment time?\' on the scheduler page to retrieve the details of the appointment.  If you feel you have reached this message in error, please contact support@adurolife.com.');
                    ApexPages.addMessage(myMsg);
                    errorOnPage=true;                       
                }
                catch(Exception ex){}
                if(!alreadyRegisteredEmail)
                {
                    Contact c;
                    if(lv!=null && String.isBlank(lv.ErrorMessage) && String.isNotBlank(lv.LimeadeParticipantCode))
                    {
                        try{
                            c=[Select Id From Contact Where Limeade_ParticipantCode__c=:lv.LimeadeParticipantCode];
                        }
                        catch(Exception ex){}
                    }
                    if(c==null)
                    {
                        
                        List<Contact> listC=[Select Id,Limeade_ParticipantCode__c,CreatedDate,(Select Id,OrderDate__c From Orders__r order by OrderDate__c desc limit 1) From Contact Where LastName=:s.Last_Name__c AND Email=:s.Email__c AND Birthdate=:s.DOB__c];
                        if(listC.size()>0)
                        {
                            if(listC.size()==1)
                            {
                                c=listC[0];
                            }
                            else
                            {
                                Date orderDate=null;
                                Contact latestContact;
                                Contact latestContactWithOrder;
                                Contact latestContactWithParticipantCode;
                                for(Contact cT:listC)
                                {
                                    if(latestContact==null)
                                    {
                                        latestContact=cT;
                                    }
                                    else if(latestContact.CreatedDate<cT.CreatedDate)
                                    {
                                        latestContact=cT;
                                    }
                                    if(latestContactWithParticipantCode==null && !String.isBlank(cT.Limeade_ParticipantCode__c))
                                    {
                                        latestContactWithParticipantCode=cT;
                                    }
                                    else if(latestContactWithParticipantCode!=null && latestContactWithParticipantCode.CreatedDate<cT.CreatedDate && !String.isBlank(cT.Limeade_ParticipantCode__c))
                                    {
                                        latestContactWithParticipantCode=cT;
                                    }                                   
                                    if(cT.Orders__r.size()>0 && cT.Orders__r[0].OrderDate__c!=null &&
                                        (orderDate==null || orderDate<cT.Orders__r[0].OrderDate__c)
                                      )
                                    {
                                        latestContactWithOrder=cT;
                                    }
                                }
                                if(latestContactWithOrder!=null)
                                {
                                    c=latestContactWithOrder;
                                }
                                else if(latestContactWithParticipantCode!=null)
                                {
                                    c=latestContactWithParticipantCode;
                                }
                                else if(latestContact!=null)
                                {
                                    c=latestContact;
                                }                                                               
                            }
                        }
                    }
                    //catch(Exception ex){}
                    if(c!=null)
                    {
                        s.Contact__c=c.Id;
                    }
                    else
                    {
                        RecordType rt=[Select Id From RecordType Where DeveloperName='Participants' limit 1];
                        c=new Contact();
                        c.RecordTypeId=rt.Id;
                        c.FirstName=s.First_Name__c;
                        c.LastName=s.Last_Name__c;
                        c.Email=s.Email__c;
                        c.Birthdate=s.DOB__c;
                        c.AccountID=s.WW_Event__r.Employer__c;
                        c.Employee_ID__c=s.Employee_ID__c;
                        c.Limeade_ParticipantCode__c=lv!=null?lv.LimeadeParticipantCode:'';
                        insert c;
                        s.Contact__c=c.Id;
                    }
                    c.Event__c=s.WW_Event__c;
                    c.Appointment_Time__c=s.Start_Date__c;
                    s.One_Day_Reminder_Sent__c=false;
                    s.Seven_Day_Reminder_Sent__c=false;
                    update s;
                    update c;
                    if(oldS!=null)
                    {
                        oldS.Contact__c=null;
                        oldS.First_Name__c=null;
                        oldS.Last_Name__c=null;
                        oldS.Email__c=null;
                        oldS.DOB__c=null;
                        oldS.Employee_ID__c=null;
                        update oldS;
                    }
                    
                  /*  OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'noreply@adurolife.com' limit 1];
                    system.debug('e.Program__c======================'+e.Program__c);
                    Program__c p=[Select p.Test_Weight_Onsite__c, p.Test_Waist_Onsite__c, p.Test_Trig_Onsite__c,p.Body_Fat__c, 
                                    p.Test_TC_Onsite__c, p.Test_LDL_Onsite__c, p.Test_Height_Onsite__c, p.Test_HR_Onsite__c, 
                                    p.Test_HDL_Onsite__c, p.Test_Glucose_Onsite__c, p.Test_Glucose_HTK__c, p.Test_Cholesterol_HTK__c, 
                                    p.Test_BP_Onsite__c, p.Test_BMI_Onsite__c,Tobacco_Saliva__c, Type_of_Tobacco_Testing__c From Program__c p where id=:e.Program__c];
                    String tests='<ul>';
                    if(p.Test_TC_Onsite__c) tests+='<li>Total Cholesterol</li>';
                    if(p.Test_LDL_Onsite__c)    tests+='<li>LDLs</li>';
                    if(p.Test_HDL_Onsite__c)    tests+='<li>HDLs</li>';
                    if(p.Test_Trig_Onsite__c)   tests+='<li>Triglycerides</li>';
                    if(p.Test_Glucose_Onsite__c)    tests+='<li>Glucose</li>';
                    if(p.Test_BP_Onsite__c) tests+='<li>Blood Pressure</li>';
                    if(p.Test_HR_Onsite__c) tests+='<li>Heart Rate</li>';                  
                    if(p.Tobacco_Saliva__c) tests+='<li>Tobacco Use - '+ p.Type_of_Tobacco_Testing__c + '</li>';
                    if(p.Test_Height_Onsite__c) tests+='<li>Height</li>';   
                    if(p.Test_Weight_Onsite__c) tests+='<li>Weight</li>';               
                    if(p.Test_Waist_Onsite__c)  tests+='<li>Waist Circumference</li>';                  
                    if(p.Test_BMI_Onsite__c)    tests+='<li>BMI</li>';
                    if(p.Body_Fat__c)   tests+='<li>Body Fat % </li>';
                   
                    tests+='</ul>';
                    EmailTemplate et=[Select e.IsActive, e.Id,e.Subject,e.Body, e.HtmlValue, e.DeveloperName From EmailTemplate e where developername='Event_Registration_Email'];
                    String subject=et.Subject;
                    subject=subject.replace('@@EVENTNAME@@',s.WW_Event__r.Name);
                    subject=subject.replace('@@EVENTDATE@@',s.Start_Date__c.date().format()+'-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles'));
                    String htmlValue=et.HtmlValue;
                    htmlValue=htmlValue.replace('@@USERNAME@@',(s.First_Name__c+' '+s.Last_Name__c));
                    htmlValue=htmlValue.replace('@@EVENTTEXT@@',(s.WW_Event__r.Email_Text__c!=null?'<b><u>Note:</b></u>&nbsp;'+s.WW_Event__r.Email_Text__c+'<br/><br/>':''));
                    //htmlValue=htmlValue.replace('@@EVENTTEST@@','<b><u>To be tested at your appointment:</b></u>&nbsp;please allow '+e.Time_Frame_Per_Slot__c+' for testing.'+tests+'<br/><br/>');
                    htmlValue=htmlValue.replace('@@EVENTTEST@@','<b><u>Screenings will include:</b></u><br/>(please allow 15 minutes for testing)<br/>'+tests+'<br/><br/>');                    
                    htmlValue=htmlValue.replace('@@EVENTADDRESS@@',(e.Event_Address__c!=null?e.Event_Address__c:''));
                    htmlValue=htmlValue.replace('@@ROOMLOCATION@@',e.Room_Location__c!=null?e.Room_Location__c:'');
                    htmlValue=htmlValue.replace('@@EMAIL@@',(s.Email__c!=null?s.Email__c:''));
                    htmlValue=htmlValue.replace('@@EVENTNAME@@',s.WW_Event__r.Name);
                    htmlValue=htmlValue.replace('@@DOB@@',(s.DOB__c!=null?s.DOB__c.format():''));//'+s.End_Date__c.format('hh:mm a','America/Los_Angeles')+'
                    htmlValue=htmlValue.replace('@@DATE@@',s.Start_Date__c.date().format()+'-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+' ('+e.Time_Zone__c+')');
                    htmlValue=htmlValue.replace('@@URL@@',Constant.EVENT_REGISTRATION_URL.replace('@@EVENTID@@',s.WW_Event__c).replace('@@SLOTID@@',s.Id));
                    if(e.Event_Type__c=='Venipuncture')
                    {
                        htmlValue=htmlValue.replace('@@DETAIL@@','The cholesterol/glucose screening is a full blood draw (venipuncture).  Results will be available and in your wellness account 7-10 days after the event. Staying hydrated and refraining from consuming any food or beverages (other than water) eight hours prior to your test will help with collecting a sample and ensure a more accurate reading.');
                    }
                    else
                    {
                        htmlValue=htmlValue.replace('@@DETAIL@@','The cholesterol/glucose screening is a simple finger-stick test that will provide you with immediate results.  Staying hydrated and refraining from consuming any food or beverages (other than water) eight hours prior to your test will help with collecting a sample and ensure a more accurate reading.');
                    }
                    Messaging.reserveSingleEmailCapacity(2);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[] {s.Email__c}; 
                    //String[] ccAddresses = new String[] {'smith@gmail.com'}; 
                    mail.setToAddresses(toAddresses);
                    //mail.setCcAddresses(ccAddresses);
                    mail.setReplyTo('noreply@adurolife.com');
                    //mail.setSenderDisplayName('Aduro Support');
                    mail.setSubject(subject);
                    mail.setBccSender(false);
                    mail.setUseSignature(false);
                    mail.setOrgWideEmailAddressId(owea.Id);
                    //mail.setPlainTextBody(et.Body);
                    mail.setHtmlBody(htmlValue);
                    mail.setWhatId(s.WW_Event__c);
                    mail.setSaveAsActivity(true);
//////////////////////////////////////////////////////////////////////
                if(s.WW_Event__r.Attach_Calendar_File__c)
                {
                    String calendarText='BEGIN:VCALENDAR\n';
                    calendarText+='VERSION:2.0\n';
                    calendarText+='PRODID:-//www.marudot.com//iCal Event Maker\n';
                    calendarText+='X-WR-TIMEZONE:'+Utility.getTimeZone(e.Time_Zone__c)+'\n';
                    calendarText+='BEGIN:VEVENT\n';
                    calendarText+='DTSTART;TZID='+Utility.getTimeZone(e.Time_Zone__c)+':'+s.Start_Date__c.format('yyyyMMdd\'T\'HHmmss')+'\n';
                    calendarText+='DTEND;TZID='+Utility.getTimeZone(e.Time_Zone__c)+':'+s.End_Date__c.format('yyyyMMdd\'T\'HHmmss')+'\n';
                    calendarText+='SUMMARY:Health Screening Appointment-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+'-'+e.Time_Zone__c+'\n';
                    calendarText+='DESCRIPTION:Health Screening Appointment-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+'-'+e.Time_Zone__c+'\n';
                    calendarText+='LOCATION:'+e.Event_Address__c.trim().replaceAll('\r\n',', ')+(e.Room_Location__c!=null?', Room Location: '+e.Room_Location__c:'')+'\n';
                    calendarText+='END:VEVENT\n';
                    calendarText+='END:VCALENDAR\n';                
                    Blob b=Blob.valueOf(calendarText);
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName('Health Screening Appointment.ics');
                    efa.setBody(b);
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});                     
                }
///////////////////////////////////////////////////////////////////////                 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   */
                slotRegistered=true;    
                }       
            }                                   
        }   
    }
public LimeadeValidator validateContactInLimeade () {
    Program__c p=[Select Limeade_E_Id__c,Limeade_PSK_ID__c From Program__c p where id=:e.Program__c];           
    LimeadeValidator lv=new LimeadeValidator();
    lv.LimeadeEID=p.Limeade_E_Id__c;
    lv.LimeadePSKID=p.Limeade_PSK_ID__c; 
    lv.LastName=s.Last_Name__c;
    lv.DOB=s.DOB__c==null?'':s.DOB__c.format();
    lv.Email=s.Email__c;
    lv.employeeId=s.Employee_ID__c;
    lv.IdentifierLastName=s.WW_Event__r.Program__r.Limeade_Identifier_LastName__c;
    lv.IdentifierDOB=s.WW_Event__r.Program__r.Limeade_Identifier_DOB__c;
    lv.IdentifierEmail=s.WW_Event__r.Program__r.Limeade_Identifier_Email__c;
    lv.IdentifierEmployeeID=s.WW_Event__r.Program__r.Limeade_Identifier_Employee_ID__c;
    lv.validate();  
    return lv;
        /*Http h = new Http();
        String mainIdentifier = '';
        String errors = '';
        //mainIdentifier = 'email=' + EncodingUtil.urlEncode(s.Email__c, 'UTF-8');
        if (s.WW_Event__r.Program__r.Limeade_Identifier_Employee_ID__c && !String.isBlank(s.Employee_ID__c)) {
            mainIdentifier = 'employeeid=' + EncodingUtil.urlEncode(s.Employee_ID__c, 'UTF-8');
        }else if(s.WW_Event__r.Program__r.Limeade_Identifier_Email__c && !String.isBlank(s.Email__c)) {
            mainIdentifier = 'email=' + EncodingUtil.urlEncode(s.Email__c, 'UTF-8');
        }   
        Program__c p=[Select Limeade_E_Id__c,Limeade_PSK_ID__c From Program__c p where id=:e.Program__c];           
        try{ 

            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
            String url =    Constant.LIMEMADE_API+'User.ashx?' + mainIdentifier +
                            '&e='           + EncodingUtil.urlEncode(p.Limeade_E_Id__c, 'UTF-8') + 
                            '&psk='         + EncodingUtil.urlEncode(p.Limeade_PSK_ID__c, 'UTF-8') +
                            '&response=XML';
            
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            
            req.setEndpoint(url);
            req.setMethod('GET');
            
            if (!Test.isRunningTest()) {
                res = h.send(req);
            }else {
                res.setBody('<Document status=\'OK\'>' +
                                '<Participant employeeid=\'41\' birthdate=\'10/10/1990\' lastname=\'lname\' email=\'test@adurolife.com\'/>' +
                            '</Document>');
            }

            System.debug( 'RES: ' + res.getBody()  );
            
             if ( res.getBody() == '0' ) {
                return '';
             }
             
             Dom.Document doc = res.getBodyDocument();
             Dom.XMLNode response = doc.getRootElement();
             Dom.XMLNode participant = response.getChildElement('Participant', null);
             String lname = participant.getAttribute('lastname', null);
             if(lname==null)
             {
                lname = participant.getAttribute('LastName', null);
             }
             String bday = participant.getAttribute('birthdate', null);
             if(String.isBlank(bday))
             {
                bday = participant.getAttribute('BirthDate', null);
             }  
             String employeeid = participant.getAttribute('employeeid', null);
             if(employeeid==null)
             {
                employeeid = participant.getAttribute('EmployeeID', null);
             }
             String email = participant.getAttribute('email', null);
             if(email==null)
             {
                email = participant.getAttribute('Email', null);
             }
             if (s.WW_Event__r.Program__r.Limeade_Identifier_LastName__c && !validateLastName(lname,s.Last_Name__c)) 
                errors += 'The last name you entered does not match your name in our system.\n';
                errors += 'You can check what name is in the system by visiting "Settings" in your wellness platform.';
             //if (s.WW_Event__r.Program__r.Limeade_Identifier_LastName__c && !lname.equalsIgnoreCase(s.Last_Name__c)) 
                //errors += 'Your supplied last name does not match your lastname in our system.\n';             
             if (s.WW_Event__r.Program__r.Limeade_Identifier_DOB__c && String.isNotBlank(bday) && Date.parse(bday) != s.DOB__c) 
                errors += 'The date of birth you entered does not match your date of birth in our system.\n';
             if (s.WW_Event__r.Program__r.Limeade_Identifier_Email__c && !email.equalsIgnoreCase(s.Email__c)) 
                errors += 'Your supplied email does not match in our system.\n';                                
             if (s.WW_Event__r.Program__r.Limeade_Identifier_Employee_ID__c && !employeeid.equalsIgnoreCase(s.Employee_ID__c)) 
                errors += 'Your supplied employee id does not match in our system.\n';   
        }
        catch (Exception e) {
            System.debug( logginglevel.FINE, 'SOLIANT ERROR: ' + e  );
            //errors = 'Your details could not be found in our system.\n'+e.getMessage();
            errors='Details need to be the same details used to register on your online platform. Please contact support@adurolife.com if you need further assistance.'; 
        }
        //default case:
        return errors;*/
    }
    public Boolean validateLastName(String limeadeName,String aduroName)
    {
        Boolean result=false;
        if(String.isNotBlank(limeadeName) && String.isNotBlank(aduroName))
        {
            limeadeName=limeadeName.replace(' ','').replace('-','').replace('.','').replace(',','').replace('(','').replace(')','').replace(':','').replace(';','').toLowerCase();
            aduroName=aduroName.replace(' ','').replace('-','').replace('.','').replace(',','').replace('(','').replace(')','').replace(':','').replace(';','').toLowerCase();
            result=limeadeName.contains(aduroName);
        }
        return result;
    }
}