public class PopulateOwnerOffsetHandler {
    public static void populateOffset(Map<Id,Event> eventsNew,Map<Id,Event> eventsOld,List<Event> newEvents){      
        List<Event> oneHourReminder = new List<Event>();
        List<Event> oneDayReminder = new List<Event>();
        List<Email_Tool__C>  emails = new List<Email_Tool__C>();
        if(eventsNew <> NULL && eventsOld <> NULL && eventsOld.size()>0){
            for(Event e : eventsNew.values()){
                Event oldEvent = eventsOld <> NULL ? eventsOld.get(e.id) : NULL ;
                if(oldEvent<> NULL && (oldEvent.StartDateTime <> e.startDateTime || oldEvent.endDateTime <> e.endDateTime)) {
                    e.Owner_Offset__c  = ProgramCalenderController.getOffset();
                    e.Owner_TimeZone__c =  UserInfo.getTimeZone().getId();
                }
                System.debug('*************** e.Send_One_Hour_Reminder__c **********' + e.Send_One_Hour_Reminder__c);
                if(e.Send_One_Hour_Reminder__c == TRUE){
                    // updated by work flow send one hour email
                    oneHourReminder.add(e); 
                }
                if(e.Send_One_Day_Reminder__c == TRUE){
                    // updated by work flow send one hour email 
                    oneDayReminder.add(e);
                }
            }
        }
        else{
            for(Event e : newEvents){
                 e.Owner_Offset__c  = ProgramCalenderController.getOffset();
                 e.Owner_TimeZone__c =  UserInfo.getTimeZone().getId();
                 
            }
        }
        if(oneHourReminder.size() > 0){
            // Create email tool record to send email 
            for(Event e : oneHourReminder){         
               String timeStr =  ProgramCalenderController.getAMPM(ProgramCalenderController.getOwenerTime(e.StartDateTime,e.ClientOffset__c)) ;
               Email_Tool__c em = new Email_Tool__c(isOneHour__c = true);
               em.To__c   = e.Trainee_Email__c;
               em.Date__c = timeStr.split(' ') [0];
               em.Time__c = timeStr.split(' ') [1] + ' ' + timeStr.split(' ') [2] + ' ' + e.Client_Timezone__c;
               em.Event__c = 'Coaching Appointment';
               em.Phone_Number__c = e.Trainee_Phone__c;
               em.Full_Name__c = e.Subject;
               em.Email__c = e.Trainee_Email__c;
               em.Fname__c = e.Subject.split(' ') [0];
               em.Reason_for_Scheduling__c = e.Description;
               em.EventId__c = e.Id;
               emails.add(em);
            }
        }
        if(oneDayReminder.size()>0){
            // Create email tool record to send email
            for(Event e : oneDayReminder){
               String timeStr =  ProgramCalenderController.getAMPM(ProgramCalenderController.getOwenerTime(e.StartDateTime,e.ClientOffset__c)) ;
               Email_Tool__c em = new Email_Tool__c(isOneDay__c = true);
               em.To__c   = e.Trainee_Email__c;
               em.Date__c = timeStr.split(' ')[0];
               em.Time__c = timeStr.split(' ')[1] + ' '+ timeStr.split(' ')[2]+ ' ' + e.Client_Timezone__c;
               em.Event__c = 'Coaching Appointment';
               em.Phone_Number__c = e.Trainee_Phone__c;
               em.Full_Name__c = e.Subject;
               em.Email__c = e.Trainee_Email__c;
               em.Fname__c = e.Subject.split(' ') [0];
               em.Reason_for_Scheduling__c = e.Description;
               em.EventId__c = e.Id;
               emails.add(em);
            } 
        }
        if(emails.size() > 0 ){
            Database.insert(emails);
        }
    }
    
}