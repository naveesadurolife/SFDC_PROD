public with sharing class EventRegisterForgotEmail {
    public String searchEmail{get;set;}
    public Boolean emailSent{get;set;}
    public PageReference SearchEmail()
    {
        emailSent=false;
        if(String.isBlank(searchEmail))
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Email');
            ApexPages.addMessage(myMsg);
        }
        else{
            String eid=Apexpages.currentPage().getParameters().get('eid');
            Slot__c s;
            try
            {
                s=[Select WW_Event__r.Location__c, WW_Event__r.Event_Type__c, WW_Event__r.End_Time__c,WW_Event__r.Email_Text__c,
                WW_Event__r.Start_Time__c, WW_Event__r.Event_Date__c, WW_Event__r.Name, WW_Event__c, 
                Start_Date__c, Name, Last_Name__c, First_Name__c, End_Date__c, Email__c,
                DOB__c, Contact__c,WW_Event__r.Event_Registration_Header__c,WW_Event__r.Time_Zone__c,WW_Event__r.Event_Address__c,WW_Event__r.Room_Location__c,WW_Event__r.Time_Frame_Per_Slot__c, 
                WW_Event__r.Program__r.Test_Weight_Onsite__c, WW_Event__r.Program__r.Test_Waist_Onsite__c, WW_Event__r.Program__r.Test_Trig_Onsite__c, 
                WW_Event__r.Program__r.Test_TC_Onsite__c, WW_Event__r.Program__r.Test_LDL_Onsite__c, WW_Event__r.Program__r.Test_Height_Onsite__c, WW_Event__r.Program__r.Test_HR_Onsite__c, 
                WW_Event__r.Program__r.Test_HDL_Onsite__c, WW_Event__r.Program__r.Test_Glucose_Onsite__c, WW_Event__r.Program__r.Test_Glucose_HTK__c, WW_Event__r.Program__r.Test_Cholesterol_HTK__c, 
                WW_Event__r.Program__r.Test_BP_Onsite__c, WW_Event__r.Program__r.Test_BMI_Onsite__c,WW_Event__r.Program__r.Tobacco_Saliva__c,WW_Event__r.Program__r.Type_of_Tobacco_Testing__c, WW_Event__r.Program__r.Body_Fat__c
                From Slot__c where WW_Event__r.Event_Status__c!='Cancelled' AND Email__c=:searchEmail AND WW_Event__c=:eid];
            }
            catch(Exception ex){}
            if(s!=null)
            {
            
             String tests='<ul>';
                    if(s.WW_Event__r.Program__r.Test_TC_Onsite__c) tests+='<li>Total Cholesterol</li>';
                    if(s.WW_Event__r.Program__r.Test_LDL_Onsite__c)    tests+='<li>LDLs</li>';
                    if(s.WW_Event__r.Program__r.Test_HDL_Onsite__c)    tests+='<li>HDLs</li>';
                    if(s.WW_Event__r.Program__r.Test_Trig_Onsite__c)   tests+='<li>Triglycerides</li>';
                    if(s.WW_Event__r.Program__r.Test_Glucose_Onsite__c)    tests+='<li>Glucose</li>';
                    if(s.WW_Event__r.Program__r.Test_BP_Onsite__c) tests+='<li>Blood Pressure</li>';
                    if(s.WW_Event__r.Program__r.Test_HR_Onsite__c) tests+='<li>Heart Rate</li>';                  
                    if(s.WW_Event__r.Program__r.Tobacco_Saliva__c) tests+='<li>Tobacco Use - '+ s.WW_Event__r.Program__r.Type_of_Tobacco_Testing__c + '</li>';
                    if(s.WW_Event__r.Program__r.Test_Height_Onsite__c) tests+='<li>Height</li>';   
                    if(s.WW_Event__r.Program__r.Test_Weight_Onsite__c) tests+='<li>Weight</li>';               
                    if(s.WW_Event__r.Program__r.Test_Waist_Onsite__c)  tests+='<li>Waist Circumference</li>';                  
                    if(s.WW_Event__r.Program__r.Test_BMI_Onsite__c)    tests+='<li>BMI</li>';
                    if(s.WW_Event__r.Program__r.Body_Fat__c)   tests+='<li>Body Fat % </li>';
                   
                    tests+='</ul>';
               
                EmailTemplate et=[Select e.IsActive, e.Id,e.Subject,e.Body, e.HtmlValue, e.DeveloperName From EmailTemplate e where developername='Event_Registration_Email'];
                OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'noreply@adurolife.com' limit 1];
                String subject=et.Subject;
                subject=subject.replace('@@EVENTNAME@@',s.WW_Event__r.Name);
                subject=subject.replace('@@EVENTDATE@@',s.Start_Date__c.Date().format()+'-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles'));
                String htmlValue=et.HtmlValue;
                htmlValue=htmlValue.replace('@@USERNAME@@',(s.First_Name__c+' '+s.Last_Name__c));
                htmlValue=htmlValue.replace('@@EVENTTEXT@@',(s.WW_Event__r.Email_Text__c!=null?'<b><u>Note:</b></u>&nbsp;'+s.WW_Event__r.Email_Text__c+'<br/><br/>':''));
                htmlValue=htmlValue.replace('@@EVENTTEST@@','<b><u>Screenings will include:</b></u><br/>(please allow 15 minutes for testing)<br/>'+tests+'<br/><br/>');
                htmlValue=htmlValue.replace('@@EVENTADDRESS@@',(s.WW_Event__r.Event_Address__c!=null?s.WW_Event__r.Event_Address__c:''));
                htmlValue=htmlValue.replace('@@ROOMLOCATION@@',s.WW_Event__r.Room_Location__c!=null?s.WW_Event__r.Room_Location__c:'');
                htmlValue=htmlValue.replace('@@EMAIL@@',(s.Email__c!=null?s.Email__c:''));
                htmlValue=htmlValue.replace('@@EVENTNAME@@',s.WW_Event__r.Name);
                htmlValue=htmlValue.replace('@@DOB@@',(s.DOB__c!=null?s.DOB__c.format():''));//'+s.End_Date__c.format('hh:mm a','America/Los_Angeles')+'
                htmlValue=htmlValue.replace('@@DATE@@',s.Start_Date__c.Date().format()+'-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+'- ('+s.WW_Event__r.Time_Zone__c+')');
                htmlValue=htmlValue.replace('@@URL@@',Constant.EVENT_REGISTRATION_URL.replace('@@EVENTID@@',s.WW_Event__c).replace('@@SLOTID@@',s.Id));
                if(s.WW_Event__r.Event_Type__c=='Venipuncture')
                {
                    htmlValue=htmlValue.replace('@@DETAIL@@','The cholesterol/glucose test is a full blood draw (venipuncture).  Results will be available and in your wellness account 7-10 days after the event. Staying hydrated and refraining from consuming any food or beverages (other than water) eight hours prior to your test will help with collecting a sample and ensure a more accurate reading.');
                }
                else
                {
                    htmlValue=htmlValue.replace('@@DETAIL@@','The cholesterol/glucose test is a simple finger-stick test that will provide you with immediate results.  Staying hydrated and refraining from consuming any food or beverages (other than water) eight hours prior to your test will help with collecting a sample and ensure a more accurate reading.');
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
//working
/*String calendarText='BEGIN:VCALENDAR\n';
calendarText+='PRODID:-//Microsoft Corporation//Outlook 14.0 MIMEDIR//EN\n';
calendarText+='X-WR-TIMEZONE:America/Los_Angeles\n';
calendarText+='VERSION:2.0\n';
calendarText+='METHOD:PUBLISH\n';
calendarText+='X-MS-OLK-FORCEINSPECTOROPEN:TRUE\n';
calendarText+='BEGIN:VEVENT\n';
calendarText+='CLASS:PUBLIC\n';
calendarText+='CREATED:'+DateTime.now().format('yyyyMMdd\'T\'hhmmss00\'Z\'')+'\n';
calendarText+='DTEND;TZID=America/Los_Angeles:'+s.End_Date__c.format('yyyyMMdd\'T\'hhmmss00')+'\n';
calendarText+='DTSTAMP:'+DateTime.now().format('yyyyMMdd\'T\'hhmmss00\'Z\'')+'\n';
calendarText+='DTSTART;TZID=America/Los_Angeles:'+s.Start_Date__c.format('yyyyMMdd\'T\'hhmmss00')+'\n';
calendarText+='LAST-MODIFIED:'+DateTime.now().format('yyyyMMdd\'T\'hhmmss00\'Z\'')+'\n';
calendarText+='LOCATION: '+s.WW_Event__r.Event_Address__c.trim().replaceAll('\r\n',', ')+(s.WW_Event__r.Room_Location__c!=null?', Room Location: '+s.WW_Event__r.Room_Location__c:'')+'\n';
calendarText+='SEQUENCE:0\n';
calendarText+='SUMMARY;LANGUAGE=en-us: Health Screening Appointment-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+'-'+s.WW_Event__r.Time_Zone__c+'\n';
calendarText+='DESCRIPTION: Health Screening Appointment-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+'-'+s.WW_Event__r.Time_Zone__c+'\n';
calendarText+='TRANSP:OPAQUE\n';
calendarText+='X-MICROSOFT-CDO-BUSYSTATUS:BUSY\n';
calendarText+='END:VEVENT\n';
calendarText+='END:VCALENDAR\n';*/



String calendarText='BEGIN:VCALENDAR\n';
calendarText+='VERSION:2.0\n';
calendarText+='PRODID:-//www.marudot.com//iCal Event Maker\n';
//calendarText+='X-WR-CALNAME:Health Screening Appointment\n';
calendarText+='X-WR-TIMEZONE:'+Utility.getTimeZone(s.WW_Event__r.Time_Zone__c)+'\n';
calendarText+='BEGIN:VEVENT\n';
//calendarText+='DTSTAMP:'+DateTime.now().format('yyyyMMdd\'T\'hhmmss\'Z\'')+'\n';
//calendarText+='UID:20131110T073234Z-1529407587@marudot.com\n';
calendarText+='DTSTART;TZID='+Utility.getTimeZone(s.WW_Event__r.Time_Zone__c)+':'+s.Start_Date__c.format('yyyyMMdd\'T\'HHmmss')+'\n';
calendarText+='DTEND;TZID='+Utility.getTimeZone(s.WW_Event__r.Time_Zone__c)+':'+s.End_Date__c.format('yyyyMMdd\'T\'HHmmss')+'\n';
calendarText+='SUMMARY:Health Screening Appointment-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+'-'+s.WW_Event__r.Time_Zone__c+'\n';
calendarText+='DESCRIPTION:Health Screening Appointment-'+s.Start_Date__c.format('hh:mm a','America/Los_Angeles')+'-'+s.WW_Event__r.Time_Zone__c+'\n';
calendarText+='LOCATION:'+s.WW_Event__r.Event_Address__c.trim().replaceAll('\r\n',', ')+(s.WW_Event__r.Room_Location__c!=null?', Room Location: '+s.WW_Event__r.Room_Location__c:'')+'\n';
calendarText+='END:VEVENT\n';
calendarText+='END:VCALENDAR\n';


Blob b=Blob.valueOf(calendarText);
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Health Screening Appointment.ics');
                efa.setBody(b);
///////////////////////////////////////////////////////////////////////             
                // Create the email attachment
/*              String calendarText='BEGIN:VCALENDAR\n';
                calendarText+='VERSION:2.0\n';
                //calendarText+='PRODID:-//hacksw/handcal//NONSGML v1.0//EN\n';
                calendarText+='BEGIN:VEVENT\n';
                calendarText+='DTSTART:'+s.Start_Date__c.format('yyyyMMdd\'T\'hhmmss00\'Z\'',String.isBlank(s.WW_Event__r.Time_Zone__c)?'America/Los_Angeles':Constant.MAPTIMEZONES.get(s.WW_Event__r.Time_Zone__c))+'\n';
                calendarText+='DTEND:'+s.End_Date__c.format('yyyyMMdd\'T\'hhmmss00\'Z\'',String.isBlank(s.WW_Event__r.Time_Zone__c)?'America/Los_Angeles':Constant.MAPTIMEZONES.get(s.WW_Event__r.Time_Zone__c))+'\n';
                //calendarText+='DTEND:'+dateStart+'T1401400Z\n';
                calendarText+='SUMMARY: Outlook-Health Screening Appointment-'+s.Start_Date__c.format('hh:mm a',String.isBlank(s.WW_Event__r.Time_Zone__c)?'America/Los_Angeles':Constant.MAPTIMEZONES.get(s.WW_Event__r.Time_Zone__c))+'-'+s.WW_Event__r.Time_Zone__c+'\n';
                calendarText+='LOCATION: '+s.WW_Event__r.Event_Address__c.trim().replaceAll('\r\n',', ')+(s.WW_Event__r.Room_Location__c!=null?', Room Location: '+s.WW_Event__r.Room_Location__c:'')+'\n';
                calendarText+='END:VEVENT\n';
                calendarText+='END:VCALENDAR';                  
                Blob b=Blob.valueOf(calendarText);
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Outlook-Health Screening Appointment.ics');
                efa.setBody(b);
////////////////////////////////
                    calendarText='BEGIN:VCALENDAR\n';
                    //calendarText='TZID=America/New_York:'+s.Start_Date__c.format('yyyyMMdd\'T\'hhmmss00',String.isBlank(e.Time_Zone__c)?'America/Los_Angeles':Constant.MAPTIMEZONES.get(e.Time_Zone__c))+'\n';
                    calendarText+='VERSION:2.0\n';
                    //calendarText+='PRODID:-//hacksw/handcal//NONSGML v1.0//EN\n';
                    calendarText+='BEGIN:VEVENT\n';
                    calendarText+='DTSTART;TZID='+(String.isBlank(s.WW_Event__r.Time_Zone__c)?'America/Los_Angeles':Constant.MAPTIMEZONES.get(s.WW_Event__r.Time_Zone__c))+':'+s.Start_Date__c.format('yyyyMMdd\'T\'hhmmss00',String.isBlank(s.WW_Event__r.Time_Zone__c)?'America/Los_Angeles':Constant.MAPTIMEZONES.get(s.WW_Event__r.Time_Zone__c))+'\n';
                    calendarText+='DTEND;TZID='+(String.isBlank(s.WW_Event__r.Time_Zone__c)?'America/Los_Angeles':Constant.MAPTIMEZONES.get(s.WW_Event__r.Time_Zone__c))+':'+s.Start_Date__c.format('yyyyMMdd\'T\'hhmmss00',String.isBlank(s.WW_Event__r.Time_Zone__c)?'America/Los_Angeles':Constant.MAPTIMEZONES.get(s.WW_Event__r.Time_Zone__c))+'\n';
                    //calendarText+='DTEND:'+dateStart+'T1401400Z\n';
                    calendarText+='SUMMARY: Google-Health Screening Appointment-'+s.Start_Date__c.format('hh:mm a',String.isBlank(s.WW_Event__r.Time_Zone__c)?'America/Los_Angeles':Constant.MAPTIMEZONES.get(s.WW_Event__r.Time_Zone__c))+'-'+s.WW_Event__r.Time_Zone__c+'\n';
                    calendarText+='LOCATION: '+s.WW_Event__r.Event_Address__c.trim().replaceAll('\r\n',', ')+(s.WW_Event__r.Room_Location__c!=null?', Room Location: '+s.WW_Event__r.Room_Location__c:'')+'\n';
                    calendarText+='END:VEVENT\n';
                    calendarText+='END:VCALENDAR';  
                    b=Blob.valueOf(calendarText);
                    Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
                    efa1.setFileName('Google-Health Screening Appointment.ics');
                    efa1.setBody(b);*/

///////////////////////////////////             
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});                     
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                   
                emailSent=true;
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'No appointment with this email was found in the system for this event. Please confirm you have selected the correct date and location. For help, contact <a href="mailto:support@adurolife.com">support@adurolife.com</a>');
                ApexPages.addMessage(myMsg);                
            }
        }       
        return null;
    }   
}