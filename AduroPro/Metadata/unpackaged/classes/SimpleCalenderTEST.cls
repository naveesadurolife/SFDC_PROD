@istest
public class SimpleCalenderTEST {
	public static Account acct;
  	public static Contact con;
  	public static Program__c currentYearProgram;
    public static void init(){
    acct=TestDataGenerator.getOneAccount(); 
    con=TestDataGenerator.getOneContact();
    con.Limeade_ParticipantCode__c='1234abcd';
    update con;
    currentYearProgram=TestDataGenerator.getOneProgram();
    currentYearProgram.Program_Start_Date__c=Date.newInstance(Date.today().year(), 1, 1);
    currentYearProgram.Program_End_Date__c=Date.newInstance(Date.today().year(), 12, 31);
    currentYearProgram.Program_Status__c='Active';
    currentYearProgram.Limeade_Live_Date__c=Date.today();
    currentYearProgram.Program_Manager__c=Userinfo.getUserId();
    currentYearProgram.Allowed_Duration__c = '30';
    currentYearProgram.Limeade_PSK_ID__c = 'abcdef';
    currentYearProgram.Groups__c = '12345';
    update currentYearProgram;
    Associated_Coach__c ac = new Associated_Coach__c(Coach__c = userInfo.getUserId(), Program__c =currentYearProgram.id );
    insert ac;    
    }
    public static testmethod void getEventDataTest(){
        init();
        Event e = new Event(For_Training__c = TRUE );
        e.subject = 'Test';
        e.EndDateTime = System.now().addMinutes(800);
        e.StartDateTime = System.now().addMinutes(770); 
        e.Client_Timezone__c = 'GMT - 5.00 EST';
        e.ClientOffset__c = -300;
        insert e;       
        Event e1 = new Event(For_Training__c = TRUE );
        e1.subject = 'Test1';
        e1.EndDateTime = System.now().addMinutes(900);
        e1.StartDateTime = System.now().addMinutes(870);
        e1.Trainee_Email__c = 'abcdef@test.com';
        e1.Client_Timezone__c = 'GMT - 5.00 EST';
        e1.ClientOffset__c = -300;
        insert e1;
        SimpleCalender s = new SimpleCalender();
        SimpleCalender.getGMTTime(System.now());
        SimpleCalender.getEventData(-300);
        SimpleCalender.saveEvent(System.now().addMinutes(30), System.now().addMinutes(120),'Testing', '30' ,'',-300);
        SimpleCalender.saveEvent(System.now().addMinutes(300), System.now().addMinutes(500),'Testing', '0' ,'',300);
        e1.EndDateTime = System.now().addMinutes(1200);
        e1.StartDateTime = System.now().addMinutes(1170);
        e1.Send_One_Hour_Reminder__c = true;
        e1.Send_One_Day_Reminder__c = true;
        update e1;
        CancelAppointment c = new CancelAppointment();
        CancelAppointment.CancelAppointmentUserChoice(e1.id); 
        SimpleCalender.deleteEvent(e.Id);
    }
}