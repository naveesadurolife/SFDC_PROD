public class EventListController {
    
    public List<WW_Event__c> eventList {get; private set;} 
    public List<WW_Event__c> eventListAll {get; private set;} 
    
    public String testerType {get; private set;}
    private string KOHLS_WELLNESS_CENTER = 'Kohl\'s Wellness Center';
    private string NEMOURS_CHILDRENS_HOSPITAL = 'Nemours Children\'s Hospital';
    private string WILLIAMS = 'Williams';
    private string ViaSat = 'ViaSat';
    private date eventDate = Date.newInstance(2015, 1, 1);
    
    public EventListController( ){
        
        testerType = ApexPages.currentPage().getParameters().get('type');
        
        eventList = getEventList();
    }
    
    private List<WW_Event__c> getEventList() {
    
    
        eventList = new List<WW_Event__c>();
        eventListAll = new List<WW_Event__c>();
        User u=[Select id, alias from user where id=:Userinfo.getUserId()];

        eventListAll = [    SELECT e.Id, e.Name, e.Employer__r.Name, e.Event_Date__c, e.Start_Time__c, e.End_Time__c, e.Event_Status__c, e.Employer__c, e.Employer__r.Parent.Name
                            FROM WW_Event__c e 
                            WHERE ((e.Event_Type__c = 'Biometrics Event' OR e.Event_Type__c ='Venipuncture') AND e.Event_Date__c > YESTERDAY ) ORDER BY e.Event_Date__c ASC];
        system.debug('##--u.alias: '+ u.alias);
        if(u.Alias=='Kohls')
        {
            /*Set<String> eventNames=new Set<String>();
            eventNames.add('Kohl\'s Wellness Center- Menomonee Falls');
            eventNames.add('Kohl\'s Wellness Center- San Antonio');
            eventNames.add('Kohl\'s Wellness Center- San Bernadino');
            eventNames.add('Kohl\'s Wellness Center- Patterson');*/
            for(WW_Event__c e:eventListAll)
            {
                if(e.Name.startsWith(KOHLS_WELLNESS_CENTER) && e.Event_Date__c > eventDate)// changed by srinivas sattoor on 12.8.2014
                {
                    eventList.add(e);
                }
            }
            eventListAll=eventList;
        }  
        
        if(u.Alias=='vonsi')
        {         
            for(WW_Event__c e:eventListAll)
            {
                if(e.Name.startsWith(ViaSat) && e.Event_Date__c > eventDate)
                {
                    eventList.add(e);
                }
            }
            eventListAll=eventList;
        }  
        
        //Added by Srinivas Sattoor on 01.05.2014 to allow Nemours user to see only Nemour related events
        if(u.Alias=='Nemours') {
            
            for(WW_Event__c e:eventListAll) {
                
                if(e.Employer__r.Name.startsWith(NEMOURS_CHILDRENS_HOSPITAL) 
                    && e.Event_Date__c > eventDate) {// changed by srinivas sattoor on 12.8.2014 
                        
                    eventList.add(e);
                }
                
            }// end of for-each
            
            eventListAll = eventList;
        }
        // Added by srinivas sattoor on 02.10.2015     
        if(u.Alias=='Williams') {
            
            for(WW_Event__c e:eventListAll) {
                
                if(e.Id == 'a077000000RkIL1' || e.Id == 'a077000000RkIL6') { 
                        
                    eventList.add(e);
                }
                
            }// end of for-each
            
            eventListAll = eventList;
        }          
        
        // Added by srinivas sattoor on 08.22.2015 
        if(u.Alias=='BHealth')  {
            
            for(WW_Event__c e:eventListAll){
                
                if(e.Employer__c != null
                    && (e.Employer__r.Parent.Name == 'Baptist Health System'
                        || e.Employer__r.Name == 'Baptist Health System')
                    && e.Event_Date__c > eventDate){
                    
                    eventList.add(e);
                    
                }
                
            }// end of for-each
            
            eventListAll = eventList;
        }  // end of if alias = bhealth         
        return eventListAll;
        
    }// end of getEventList
    
    static testMethod void testCheckInController(){
        /*Account acct = TestDataGenerator.getOneAccount();
        Contact contact = TestDataGenerator.getOneContact();
        WW_Event__c wwevent = TestDataGenerator.getOneEvent();*/
        
        PageReference ref = new PageReference('/apex/EventList?type=checkin' );
        Test.setCurrentPage(ref); 
    
        EventListController controller = new EventListController (); 
        
        ref = new PageReference('/apex/EventList?type=tester' );
        Test.setCurrentPage(ref); 
        
        
        
    }
    

}