global class ProgramCalenderController {
    global String pkey {get;set;}
    global String cName {get;set;}
    global String programId {get;set;}
    global String fName {get;set;}
    global String lName {get;set;}
    global String email {get;set;}
    global String eId {get;set;}
    global String DOB {get;set;}
    global String phone {get;set;}
    global String brandedURL {get;set;}
    global Boolean dobRequired {public get;private set;}
    global Boolean eIdRequired {public get;private set;}
    global ProgramCalenderController(){
       pkey = ApexPages.currentPage().getParameters().get('e');
       //programId = ApexPages.currentPage().getParameters().get('pid');
       List<Program__c> currentProgramList = [SELECT Id,Groups__c,Allowed_Duration__c,Coaching_Calendar_Name__c,
                                              Branded_URL__c,X1_1_Coaching_Identifier_DOB__c,X1_1_Coaching_Identifier_Employee_ID__c
                                              FROM Program__c WHERE Limeade_E_Id__c =:pkey AND Program_Status__c = 'Active' ] ;  
       programId   =  currentProgramList <> NULL && currentProgramList.size() > 0 ? currentProgramList[0].id : NULL; 
       cName       = currentProgramList <> NULL && currentProgramList.size() > 0 ? currentProgramList[0].Coaching_Calendar_Name__c : '';
       brandedURL  = currentProgramList <> NULL && currentProgramList.size() > 0 ? currentProgramList[0].Branded_URL__c : '';
       dobRequired = currentProgramList <> NULL && currentProgramList.size() > 0 ? currentProgramList[0].X1_1_Coaching_Identifier_DOB__c : false;
       eIdRequired = currentProgramList <> NULL && currentProgramList.size() > 0 ? currentProgramList[0].X1_1_Coaching_Identifier_Employee_ID__c : false;
       email     = ApexPages.currentPage().getParameters().get('em');
       email 	 = email <> NULL && email.indexOf('[') >= 0 ? '' : email ;
       fName     = ApexPages.currentPage().getParameters().get('fname');
       fName 	 = fName <> NULL && fName.indexOf('[') >= 0 ? '' : fName ; 
       lName     = ApexPages.currentPage().getParameters().get('lname');
       lName 	 = lName <> NULL && lName.indexOf('[') >= 0 ? '' : lName ; 
       eId       = ApexPages.currentPage().getParameters().get('emid');
       eId 	     = eId <> NULL && eId.indexOf('[') >= 0 ? '' : eId ; 
       DOB       = ApexPages.currentPage().getParameters().get('dob');
       DOB 	     = DOB <> NULL && DOB.indexOf('[') >= 0 ? '' : DOB ; 
       phone     = ApexPages.currentPage().getParameters().get('phone'); 
       phone 	 = phone <> NULL && phone.indexOf('[') >= 0 ? '' : phone ;  
    }
    global class EventWrapper {
        public String description    {get;set;}
        public String eventId        {get;set;}
        public Boolean isPast        {get;set;}
        public Boolean isBooked      {get;set;}
        public Boolean isTrainer     {get;set;}
        public String startTime      {get;set;}
        public String endTime        {get;set;}
        
    }
    global Static Datetime getGMTTime(Datetime dt){        
        Date gmtDate = Date.newInstance(dt.yearGmt(), dt.monthGmt(), dt.dayGmt());
        Time gmtTime = Time.newInstance(dt.hourGmt(),dt.minuteGmt(),dt.secondGmt(),dt.millisecondGmt());
        return Datetime.newinstance(gmtDate,gmtTime); 
    }
    global Static Integer getOffset(){
        TimeZone tz = UserInfo.getTimeZone();                              
        DateTime localTime = System.now();
        System.debug('***** SF Offset is *****' + tz.getOffset(localTime)/(1000*60));
        return tz.getOffset(localTime)/(1000*60);
    }
    global static String getOwenerTime(DateTime dt,Decimal offset){       
        try{
        	Integer intOffset = Integer.valueOf(offset);
        	DateTime ownerTime = Datetime.newInstance(dt.yearGMT(), dt.monthGMT(), dt.dayGMT(), dt.hourGMT(), dt.minuteGMT(), dt.secondGMT());
        	return String.valueOf(ownerTime.addMinutes(intOffset));
        }catch(Exception e){return '';}    
    }
    @RemoteAction
    global static list<EventWrapper> getProgramEventData(Integer clientOffset,String pkey,String email,Boolean isExternal,String programId){ 
     List <EventWrapper> eventList = new List<EventWrapper>();
     List<String> owners = new List<String>();
     Integer allowedDuration = 0;   
     String programKey = pkey;
     Map<String,Event> eventMap = new Map<String,Event>();  
     if(programKey == NULL || programKey ==''){ System.debug('***** NO PROGRAM KEY PASSED ************************'); return eventList;  }
     List<Program__c> currentProgram = [SELECT Id,Groups__c,Allowed_Duration__c FROM Program__c WHERE  Id =:programId] ;
     if(currentProgram == NULL || currentProgram.size() ==0){System.debug('***** NO PROGRAM FOUND ************************' + programKey);  return eventList;}
     else if (currentProgram[0].Groups__c == NULL || currentProgram[0].Groups__c =='' || currentProgram[0].Allowed_Duration__c == NULL){System.debug('***** NO GROUP ON PROGRAM OR NO DURATION ************************'); return eventList;}
     else{
        // Getting all the users 
        List<Associated_Coach__c> coaches = [SELECT Id,Coach__c FROM Associated_Coach__c WHERE Program__c =: currentProgram[0].Id];
        System.debug('***** coaches ************************' + coaches); 
        if(coaches <> NULL && coaches.size()>0) {
            for(Associated_Coach__c c : coaches){
                owners.add(c.Coach__c);  
            }
            allowedDuration = Integer.valueOf(currentProgram[0].Allowed_Duration__c);
        }
     }
    System.debug('***** allowedDuration ************************' + allowedDuration); 
    System.debug('***** owners ************************' + owners);     
    for(Event currentEvent : [SELECT Id,ActivityDate,subject,DurationInMinutes,Confirmed__c,EndDateTime,
                               StartDateTime,Owner_Offset__c,Description,Trainee_DOB__c,  
                               Trainee_EID__c,Trainee_Email__c,Trainee_First_Name__c,
                               Trainee_Last_Name__c,owner.firstname,owner.lastname 
                               FROM Event WHERE ownerId IN:owners 
                               AND Confirmed__c = false  AND Durationinminutes =:allowedDuration 
                               AND StartDateTime >: System.now() AND EndDateTime <> NULL AND StartDateTime <> NULL 
                               AND For_Training__c = TRUE LIMIT 50000]){
           System.debug('************ NULL Found ********' + currentEvent);                        
           if(currentEvent.StartDateTime == NULL || currentEvent.EndDateTime == NULL){continue; System.debug('************ NULL Found skipping ********' + currentEvent);}                        
           String keyVal = getOwenerTime(currentEvent.StartDateTime,currentEvent.Owner_Offset__c) + getOwenerTime(currentEvent.EndDateTime,currentEvent.Owner_Offset__c);
           if(currentEvent.Trainee_Email__c == email && isExternal && currentEvent.StartDateTime <> NULL && currentEvent.EndDateTime <> NULL ){
                EventWrapper event = new EventWrapper();
                event.description = String.valueOf( currentEvent.subject);
                event.eventId     = String.valueOf( currentEvent.id ); 
               if(getOwenerTime(currentEvent.StartDateTime,currentEvent.Owner_Offset__c) == '' || getOwenerTime(currentEvent.EndDateTime,currentEvent.Owner_Offset__c) == ''){continue;}               
                event.startTime   = getOwenerTime(currentEvent.StartDateTime,currentEvent.Owner_Offset__c);
                event.endTime     = getOwenerTime(currentEvent.EndDateTime,currentEvent.Owner_Offset__c);
                event.isPast      = currentEvent.StartDateTime > System.now() ? false : true;
                event.isBooked    = currentEvent.Confirmed__c;
                event.isTrainer   = true;
                eventList.add(event);
               // String keyVal = String.valueOf(currentEvent.StartDateTime.hour()) + String.valueOf(currentEvent.StartDateTime.minute()) + String.valueOf(currentEvent.EndDateTime.hour()) +String.valueOf(currentEvent.EndDateTime.minute());
               // eventMap.put(keyVal,keyVal);
           }
           else if(eventMap.get(keyVal) == NULL && currentEvent.StartDateTime <> NULL && currentEvent.EndDateTime <> NULL ){                
                eventMap.put(keyVal,currentEvent);
                EventWrapper event = new EventWrapper();
                event.description =  'Available'; //;String.valueOf( currentEvent.owner.firstname + ' ' + currentEvent.owner.lastname );
                event.eventId     = String.valueOf( currentEvent.id );                
                event.startTime   = getOwenerTime(currentEvent.StartDateTime,-clientOffset);//getOwenerTime(currentEvent.StartDateTime,currentEvent.Owner_Offset__c);
                event.endTime     = getOwenerTime(currentEvent.EndDateTime,-clientOffset);//getOwenerTime(currentEvent.EndDateTime,currentEvent.Owner_Offset__c);
                event.isPast      = currentEvent.StartDateTime > System.now() ? false : true;
                event.isBooked   = currentEvent.Confirmed__c;
                event.isTrainer   = false;
                eventList.add(event);
           }     
        }
        System.debug('****************** eventMap Keys************* '+ eventMap.keySet());
        return eventList;  
    }
    @RemoteAction
    global static String confirmAppointment(String eventId, String programId,String fName,String lName,String email,String phone,String reason,String dob,string eId,String clientTimeZone, Integer clientOffset){ 
        String message ='';
        Boolean passDOB = false;
        Boolean passEid = false;
        Boolean validateFromLimeade = FALSE;
        String limeadeEid;
        String limeadePSK;
        List<String> owners = new List<String>();
        List<Contact> contacts = new List<Contact>();
        LimeadeValidator lv=new LimeadeValidator();
        try{
        // Getting all the users 
        List<Associated_Coach__c> coaches = [SELECT Id,Coach__c,Program__r.X1_1_Coaching_Identifier_DOB__c,
                                             Program__r.X1_1_Coaching_Identifier_Employee_ID__c,
                                             Program__r.PreventValidation_on_CoachingAppointment__c,
                                             Program__r.Limeade_E_Id__c,Program__r.Limeade_PSK_ID__c                                             
                                             FROM Associated_Coach__c WHERE Program__c =:programId];
        System.debug('***** coaches ************************' + coaches); 
        if(coaches <> NULL && coaches.size()>0) {
			lv.IdentifierLastName=false;
			lv.IdentifierDOB=coaches[0].Program__r.X1_1_Coaching_Identifier_DOB__c;
			lv.IdentifierEmail=false;
			lv.IdentifierEmployeeID=coaches[0].Program__r.X1_1_Coaching_Identifier_Employee_ID__c;
            for(Associated_Coach__c c : coaches){
                owners.add(c.Coach__c);  
            }
            if(coaches[0].Program__r.X1_1_Coaching_Identifier_Employee_ID__c == TRUE){
                passEid = TRUE;
            }
            if(coaches[0].Program__r.X1_1_Coaching_Identifier_DOB__c == TRUE){
                passDOB = TRUE;
            }
            if(coaches[0].Program__r.PreventValidation_on_CoachingAppointment__c == NULL || coaches[0].Program__r.PreventValidation_on_CoachingAppointment__c == FALSE){
                validateFromLimeade = TRUE;
            }
            limeadePSK = coaches[0].Program__r.Limeade_PSK_ID__c;
            limeadeEid = coaches[0].Program__r.Limeade_E_Id__c;
        }
        /** Going to call Limeade service before event assignment **/
        if(validateFromLimeade == TRUE){       	 
        	lv.LimeadeEID=limeadeEid;
            lv.LimeadePSKID=limeadePSK; 
            lv.LastName=lname;
            lv.IdentifierLastName = true;
            lv.IdentifierDOB = passDOB;
            lv.IdentifierEmployeeID= passEid;
            lv.DOB = (dob == null || dob =='' )?'': Date.parse(dob).format();
            lv.IdentifierEmail= true;
            lv.Email=email;
            lv.employeeId=eid;
            try{lv.validate();}catch(Exception e){ System.debug('######### EXception #############' + e); return 'Unable to validate with Limeade';} 
            System.debug('************* Limeade Response OUT **************' + lv.ErrorMessage);
            if(lv.ErrorMessage <> NULL && lv.ErrorMessage <> ''){
                System.debug('************* Limeade Response IN **************' + lv.ErrorMessage);
                return lv.ErrorMessage;
            }
            else{
                System.debug('************* Search Contact **************' );
                contacts = [SELECT ID,Limeade_ParticipantCode__c FROM Contact WHERE Limeade_ParticipantCode__c =:lv.LimeadeParticipantCode ORDER BY LastModifiedDate DESC LIMIT 1];
            }
        }
        System.debug('************* Search EVENT **************' );
        List<Event> selectedEvents = [SELECT Id,EndDateTime,StartDateTime FROM Event WHERE Id =:eventId Limit 1];
        if(selectedEvents <> NULL && selectedEvents.size()>0){
            Event selectedEvent = selectedEvents[0];
            Map<String,Integer> calculatedDuration = new Map<String,Integer>();
            Map<String,Integer> calculatedDurationBooked = new Map<String,Integer>();
            Map<String,String> eventOwnerMap = new Map<String,String>();
            Map<ID, Event> eventCanBeSelectedMap = new Map<ID, Event>([SELECT Id,Owner_TimeZone__c,Owner_Offset__c,Trainee_Phone__c,ownerId,Subject,ActivityDate,DurationInMinutes,
                                                                       Confirmed__c,EndDateTime,StartDateTime,Description,
                                                                       Trainee_DOB__c,Trainee_EID__c,Trainee_Email__c,
                                                                       Trainee_First_Name__c,Trainee_Last_Name__c,
                                                                       Reminder_One_Day__c,Reminder_One_Hour__c,Status__c,
                                                                       ClientOffset__c,Client_Timezone__c,Program__c,In_Limeade__c,
                                                                       Limeade_Participant_code__c,WhoId
                                                                       FROM Event WHERE Confirmed__c = false AND 
                                                                       StartDateTime =: selectedEvent.StartDateTime AND 
                                                                       EndDateTime =: selectedEvent.EndDateTime AND ownerId IN:owners ]);
            String selectedOwner ='';
            if(eventCanBeSelectedMap <> NULL && eventCanBeSelectedMap.size() == 1){
                // only one slot available no checking required assign to the user
                Event tempEvent = eventCanBeSelectedMap.values()[0];
                tempEvent.Confirmed__c          = true;
                tempEvent.Description           = reason; //fname + ' ' + lname;
                tempEvent.Subject               = fname + ' ' + lname;
                if(dob <> NULL && dob <> '' && dob.length() == 10){
                tempEvent.Trainee_DOB__c        = Date.parse(dob);
                }    
                tempEvent.Trainee_EID__c        = eId;
                tempEvent.Trainee_Phone__c      = phone;
                tempEvent.Trainee_Email__c      = email; 
                tempEvent.Trainee_First_Name__c = fname;
                tempEvent.Trainee_Last_Name__c  = lname;
                tempEvent.Reminder_One_Day__c   = true;
                tempEvent.Reminder_One_Hour__c  = true;
                tempEvent.Status__c = 'Unavailable';
                tempEvent.Client_Timezone__c = clientTimeZone;
                tempEvent.ClientOffset__c  =clientOffset; 
                tempEvent.Program__c = programId;
                // Limeade code 
                if(validateFromLimeade == TRUE){
                	tempEvent.In_Limeade__c = validateFromLimeade == TRUE ? 'Yes' : NULL;
                	tempEvent.Limeade_Participant_code__c = validateFromLimeade == TRUE ? lv.LimeadeParticipantCode : NULL;
                	tempEvent.WhoId = validateFromLimeade == TRUE ? contacts.size() > 0 ? contacts[0].Id : NULL : NULL;
                }
                update tempEvent; 
                String emailBody = 'Hi '+tempEvent.Trainee_First_Name__c +',\n\nThis message is confirmation that your appointment has been created. See your appointment details below and be sure to save the date on your calendar.\n\n' ;
                emailBody += 'New Appointment Details: \n\n';
                String timeStr =  getAMPM(getOwenerTime(tempEvent.StartDateTime,clientOffset)) ;
                Email_Tool__c em = new Email_Tool__c(isCreate__c = true);
                em.To__c   = tempEvent.Trainee_Email__c;
                em.Date__c = timeStr.split(' ') [0];
			    em.Time__c = timeStr.split(' ') [1] + ' ' + timeStr.split(' ') [2] + ' ' + clientTimeZone;
                em.Event__c = 'Coaching Appointment';
                em.Phone_Number__c = phone;
                em.Full_Name__c = tempEvent.Subject;
                em.Email__c = email;
                em.Reason_for_Scheduling__c = reason;
                em.Fname__c = fname;
                insert em;
            }
            else{
                // multiple member available here 
                AggregateResult[] groupedResults = [SELECT ownerId,SUM(DurationInMinutes) FROM Event WHERE Id IN :eventCanBeSelectedMap.keySet() GROUP BY ownerId ORDER BY SUM(DurationInMinutes) DESC];
                selectedOwner = (String) groupedResults[0].get('ownerId');
                for(Event tempEvent : eventCanBeSelectedMap.values()){
                    if(tempEvent.OwnerId == selectedOwner){
                        tempEvent.Confirmed__c          = true;
                        tempEvent.Description           = reason;
                        tempEvent.Subject               = fname + ' ' + lname;
                        if(dob <> NULL && dob <> '' && dob.length() == 10){
                        	tempEvent.Trainee_DOB__c        = Date.parse(dob);
                        }   
                        tempEvent.Trainee_EID__c        = eId;
                        tempEvent.Trainee_Email__c      = email; 
                        tempEvent.Trainee_First_Name__c = fname;
                        tempEvent.Trainee_Last_Name__c  = lname;
                        tempEvent.Trainee_Phone__c     = phone;
                        tempEvent.Reminder_One_Day__c   = true;
                        tempEvent.Reminder_One_Hour__c  = true;
                        tempEvent.Status__c = 'Unavailable';
                        tempEvent.Client_Timezone__c = clientTimeZone;
                        tempEvent.ClientOffset__c  =clientOffset; 
                        tempEvent.Program__c = programId;
                         // Limeade code 
                        if(validateFromLimeade == TRUE){
                			tempEvent.In_Limeade__c = validateFromLimeade == TRUE ? 'Yes' : NULL;
                			tempEvent.Limeade_Participant_code__c = validateFromLimeade == TRUE ? lv.LimeadeParticipantCode : NULL;
                			tempEvent.WhoId = validateFromLimeade == TRUE ? contacts.size() > 0 ? contacts[0].Id : NULL : NULL;
                	   }
                        update tempEvent;
                        String emailBody = 'Hi '+tempEvent.Trainee_First_Name__c +',\n\nThis message is confirmation that your appointment has been created. See your appointment details below and be sure to save the date on your calendar.\n\n' ;
                        emailBody += 'New Appointment Details: \n\n';
                        String timeStr =  getAMPM(getOwenerTime(tempEvent.StartDateTime,clientOffset)) ;                
                        Email_Tool__c em = new Email_Tool__c(isCreate__c = true);
                        em.To__c   = tempEvent.Trainee_Email__c;
                        em.Date__c = timeStr.split(' ') [0];
						em.Time__c = timeStr.split(' ') [1] + ' ' + timeStr.split(' ') [2] + ' ' + clientTimeZone;
                        em.Event__c = 'Coaching Appointment';
                        em.Phone_Number__c = phone;
                        em.Full_Name__c = tempEvent.Subject;
                        em.Email__c = email;
                        em.Fname__c = fname;
                        em.Reason_for_Scheduling__c = reason;
                        insert em;
                        
                        break;
                    }
                }
            }
            
        }
        }catch(Exception e){ message = e.getMessage();}    
        return message;    
    }
    @RemoteAction
    global static String cancelAppointment(String eventId){
        String message;
        List<Event> events = [SELECT Id,ownerId,Subject,ActivityDate,DurationInMinutes,
                       Confirmed__c,EndDateTime,StartDateTime,Description,
                       Trainee_DOB__c,Trainee_EID__c,Trainee_Email__c,
                       Trainee_First_Name__c,Trainee_Last_Name__c,Reminder_One_Day__c,Reminder_One_Hour__c,Status__c,
                       ClientOffset__c,Client_Timezone__c,Limeade_Participant_code__c,In_Limeade__c
                       FROM Event WHERE Id =:eventId ];
        if(events <> NULL && events.size()>0){
            Event tempEvent = events[0];
            tempEvent.Confirmed__c          = false;
            tempEvent.Description           = 'Open for appointment';
            tempEvent.Subject               = 'Open for appointment';
            tempEvent.Trainee_DOB__c        = NULL;
            tempEvent.Trainee_EID__c        = '';
            tempEvent.Trainee_Email__c      = ''; 
            tempEvent.Trainee_First_Name__c = '';
            tempEvent.Trainee_Last_Name__c  = '';
            tempEvent.Reminder_One_Day__c   = false;
            tempEvent.Reminder_One_Hour__c  = false;
            tempEvent.Send_One_Hour_Reminder__c = false;
            tempEvent.Send_One_Day_Reminder__c = false;
            tempEvent.Status__c = 'Cancelled';
            tempEvent.Client_Timezone__c = NULL;
            tempEvent.ClientOffset__c = NULL;
            tempEvent.Program__c = NULL;
            tempEvent.Limeade_Participant_code__c = NULL;
            tempEvent.In_Limeade__c = NULL;
            update tempEvent;
        }
        return message; 
    }
       
    @RemoteAction
    global static List<EventWrapper> searchAppointment(String email){
        List <EventWrapper> eventList = new List<EventWrapper>();
        if(email == NULL || email == ''){
            return eventList;
        }
        for(Event currentEvent :  [SELECT id,StartDateTime,EndDateTime,Confirmed__c,Owner_TimeZone__c,subject,
                                   Owner_Offset__c,Description,ActivityDate,Trainee_EID__c,Trainee_Email__c,
                                   Trainee_First_Name__c,Trainee_Last_Name__c,Client_Timezone__c,ClientOffset__c
                                   FROM event WHERE Trainee_Email__c =:email AND StartDateTime >:System.now() ]){
                EventWrapper event = new EventWrapper();
            	TimeZoneInfo__c tInfo = TimeZoneInfo__c.getInstance(currentEvent.Owner_TimeZone__c);
                String tZoneStr = tInfo <> NULL ? tInfo.Display__c : ' ';
                event.description = String.valueOf( currentEvent.subject);
                event.eventId     = String.valueOf( currentEvent.id );                
                event.startTime   = getAMPM(getOwenerTime(currentEvent.StartDateTime,currentEvent.ClientOffset__c)) + ' ' + currentEvent.Client_Timezone__c;
                event.endTime     = getAMPM(getOwenerTime(currentEvent.EndDateTime,currentEvent.ClientOffset__c));
                eventList.add(event);
        }
        return eventList;
    }    
    global Static String getAMPM(String dateVal){
        String datein12Hour ='';
        String amPm;
        String temp = dateVal; //2015-12-22 18:00:00
        String datePart = temp.split(' ')[0];
        String timePart = temp.split(' ')[1];
        String strHour = timePart.split(':')[0];
        String strMin = timePart.split(':')[1];
        Integer hour = Integer.valueOf(strHour);
        if(hour >= 12){
          amPm =' PM'  ;
          hour = hour - 12;          
        }
        else{
            amPm =' AM'  ;
        }
        if(hour == 0){
           hour = 12;
        }  
        dateIn12Hour = datePart.split('-')[1] +'/' + datePart.split('-')[2]+ '/' + datePart.split('-')[0] + ' ' + hour + ':' + strMin + amPm;
        return dateIn12Hour;
    }
}