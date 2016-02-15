public class SimpleCalender {
    public String timeZone {get;set;}
    public SimpleCalender(){
        TimeZoneInfo__c tInfo = TimeZoneInfo__c.getInstance(userinfo.getTimeZone().getId());
        timeZone = tInfo <> NULL ? tInfo.Display__c : '';
    }
    public Static Datetime getGMTTime(Datetime dt){        
        Date gmtDate = Date.newInstance(dt.yearGmt(), dt.monthGmt(), dt.dayGmt());
        Time gmtTime = Time.newInstance(dt.hourGmt(),dt.minuteGmt(),dt.secondGmt(),dt.millisecondGmt());
        return Datetime.newinstance(gmtDate,gmtTime); 
    }
    public Static Integer getOffset(){
        TimeZone tz = UserInfo.getTimeZone();                              
        DateTime localTime = System.now();
        return tz.getOffset(localTime)/(1000*60);
    }
    @RemoteAction 
    public static list<EventWrapper> getEventData(Integer clientOffset){ 
       List <EventWrapper> eventList = new List<EventWrapper>();
       for(Event currentEvent : [SELECT Id,ActivityDate,DurationInMinutes,EndDateTime,StartDateTime,Description,Confirmed__c FROM Event WHERE ownerId=:userInfo.getUserId() AND For_Training__c = TRUE  LIMIT 50000]){
            EventWrapper event = new EventWrapper();
            event.description = String.valueOf( currentEvent.Description);
            event.eventId     = String.valueOf( currentEvent.id );
            Integer sfOffset  = getOffset();
            Integer sfClientOffset      = clientOffset * -1;
            Integer diff;
            System.debug('******************* sfOffset *************' + sfOffset);
            System.debug('******************* sfClientOffset *************' + sfClientOffset);
            // both behind GMT
            if(sfClientOffset <0 && sfOffset <0){
               diff =   sfOffset - sfClientOffset;
            }
           // sf in IST and  system pst/est 
           if(sfClientOffset < 0 && sfOffset > 0){
               diff = (sfOffset - sfClientOffset) ;
           }
           // system in IST and  sf pst/est 
           if(sfClientOffset > 0 && sfOffset < 0){
               diff = sfOffset - sfClientOffset;  
           }
           // system in IST and  sf + GMT  
           if(sfClientOffset > 0 && sfOffset > 0){
               diff = sfOffset - sfClientOffset;
               if(sfClientOffset > sfOffset){
                diff *= -1;
               }
            }
           
            System.debug('******************* diff *************' + diff );
            System.debug('******************* currentEvent  *************' + currentEvent );
            if(currentEvent <> NULL && currentEvent.StartDateTime <> NULL && currentEvent.EndDateTime <> NULL){
                event.startTime   = currentEvent.StartDateTime.addMinutes(diff);       
                event.endTime     = currentEvent.EndDateTime.addMinutes(diff);
                event.isPast      = currentEvent.StartDateTime > System.now() ? false : true;
                event.isBooked    = currentEvent.Confirmed__c;
                eventList.add(event);
            }
        }
        return eventList; 
    }
    @RemoteAction 
    public static String saveEvent(DateTime startTime, DateTime endTime,String description, String slots,String eventId,Integer clientOffset){
        String message;
        try{
            Event customEvent = new Event();
            if(eventId <> NULL && eventId.length()>=15){
                customEvent.Id=eventId;
            }
            
            customEvent.EndDateTime = endTime;
            customEvent.StartDateTime = startTime;
            System.debug('***** Start Time **** '+customEvent.StartDateTime);
            customEvent.StartDateTime =  customEvent.StartDateTime.addMinutes(60);
            System.debug('***** Start Time **** '+customEvent.StartDateTime);
            customEvent.EndDateTime =  customEvent.EndDateTime.addMinutes(60);
            System.debug('***** End Time **** '+customEvent.EndDateTime);
            DateTime sTime = Datetime.newInstance(startTime.year(), startTime.month(), startTime.day(), startTime.hour(), startTime.minute(), 0);
            DateTime eTime = Datetime.newInstance(endTime.year(), endTime.month(), endTime.day(), endTime.hour(), endTime.minute(), 0);
            Integer sfOffset  = getOffset();
            Integer sfClientOffset      = clientOffset * -1;
            Integer diff = sfOffset - sfClientOffset;
            // Both behind GMT   
           if(sfClientOffset < 0 && sfOffset <0){
               // Salesforce in a zone behind sf (PST) system (EST)
               if(sfOffset < sfClientOffset){
                  // System time is ahead of SF so we nedd to deduct the time diff has tobe negative
                  diff =  sfOffset - sfClientOffset; // -480 - (-300) = -180 
               }
            
           }
           if(sfClientOffset < 0 && sfOffset > 0){
               diff = (sfOffset - sfClientOffset) ;
           }
           if(sfClientOffset > 0 && sfOffset < 0){
               diff = sfOffset - sfClientOffset;  
           }
           if(sfClientOffset > 0 && sfOffset > 0){
               diff = sfOffset - sfClientOffset;
               if(sfClientOffset > sfOffset){
                diff *= -1;
               }
           }
           System.debug('############ sfOffset ######'+sfOffset);
           System.debug('############ sfClientOffset ######'+sfClientOffset);
           
            System.debug('##################'+diff);
            diff *=-1;
            sTime = sTime.addMinutes(diff);
            eTime = eTime.addMinutes(diff);
            System.debug('*** sTime *** '+ sTime + '       *** etime *** ' + etime);
            //sTime = sTime.addMinutes(60);
            //eTime = eTime.addMinutes(60);
            /*
            customEvent.StartDateTime = customEvent.StartDateTime.addMinutes(tz.getOffset(localTime)/(1000*60));
            System.debug('************ Final start time *************' + customEvent.StartDateTime);
            customEvent.EndDateTime = customEvent.EndDateTime.addMinutes();
            System.debug('************ Final end time *************' + customEvent.EndDateTime);
            */
            Integer totalDuration = Integer.valueOf((eTime.getTime() - sTime.getTime())/(1000*60));
            Integer numSlots = 1;
            system.debug('*********** totalDuration *************' + totalDuration);
            if(slots <> NULL && Integer.valueOf(slots) > 0){
                numSlots = Math.mod(Integer.valueOf(slots),totalDuration);
            } 
            system.debug('*********** numSlots *************' + numSlots);
            List<Event> events = new List<Event>();
            if(numSlots > 1){
                for(Integer index =0 ; index < numSlots; index ++){
                    Event newEvent = new Event();
                    if(eventId <> NULL && eventId.length()>=15){
                        newEvent.Id=eventId;
                    }
                    newEvent.StartDateTime = sTime.addMinutes((index * Integer.valueOf(slots)));
                    newEvent.EndDateTime = newEvent.StartDateTime.addMinutes(Integer.valueOf(slots));
                    if(newEvent.EndDateTime > eTime){
                        break;
                    }
                    newEvent.Subject = description;
                    newEvent.Description = description;
                    newEvent.OwnerId = userinfo.getUserId();
                    newEvent.IsReminderSet = true;
                    newEvent.For_Training__c = TRUE;
                    events.add(newEvent);
                }
            }
            else{
                    Event newEvent = new Event();
                    if(eventId <> NULL && eventId.length()>=15){
                        newEvent.Id=eventId;
                    }
                    newEvent.StartDateTime = sTime;
                    newEvent.EndDateTime = eTime;
                    newEvent.Subject = description;
                    newEvent.Description = description;
                    newEvent.OwnerId = userinfo.getUserId();
                    newEvent.IsReminderSet = true;
                	newEvent.For_Training__c = TRUE;
                    events.add(newEvent);
            }
            upsert events;
        } 
        catch(Exception e){
            message = e.getMessage();
        }
        return message;
    }
    @RemoteAction
    public static String deleteEvent(String eventId){
        String message ;
        List<Event> toBeDeleted = [SELECT Id FROM Event WHERE Id =: eventId];
        delete toBeDeleted;
        return message;
    }
    public class EventWrapper {
        public String description    {get;set;}
        public String eventId        {get;set;}
        public Boolean isPast        {get;set;}
        public Boolean isBooked      {get;set;}
        public Datetime startTime    {get;set;}
        public Datetime endTime      {get;set;}
        
    }
}