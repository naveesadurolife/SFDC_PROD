@istest
public class ProgramCalenderControllerTEST {
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
    currentYearProgram.Limeade_E_Id__c = 'abcdef';
    currentYearProgram.Groups__c = '12345';
    currentYearProgram.X1_1_Coaching_Identifier_Employee_ID__c = TRUE;
    currentYearProgram.PreventValidation_on_CoachingAppointment__c = TRUE;
    currentYearProgram.X1_1_Coaching_Identifier_DOB__c = TRUE;
    update currentYearProgram;
    AssociateUserWithProgram ap = new AssociateUserWithProgram (new Apexpages.StandardController(currentYearProgram));
    ap.save();    
    Associated_Coach__c ac = new Associated_Coach__c(Coach__c = userInfo.getUserId(), Program__c =currentYearProgram.id );
    insert ac;
    }
    public static testmethod void getGMTTimeTest(){
        init();
        ProgramCalenderController.getGMTTime(System.now());
        ProgramCalenderController.getOffset();
        ProgramCalenderController.getOwenerTime(System.now(), -300);
        ApexPages.currentPage().getParameters().put('e','abcdef');
        ProgramCalenderController p = new ProgramCalenderController();
    }
    public static testmethod void getEventDataTest(){
        init();
        currentYearProgram.Groups__c = 'aaaaaaaaaaaaaa';
        update currentYearProgram;
        Event e = new Event();
        e.For_Training__c = TRUE;
        e.subject = 'Test';
        e.EndDateTime = System.now().addMinutes(800);
        e.StartDateTime = System.now().addMinutes(770); 
        e.ClientOffset__c = -300;
        e.Client_Timezone__c = 'GMT -5.00 EST';
        insert e;       
        Event e1 = new Event();
        e1.For_Training__c = TRUE;
        e1.subject = 'Test1';
        e1.EndDateTime = System.now().addMinutes(900);
        e1.StartDateTime = System.now().addMinutes(870);
        e1.Trainee_Email__c = 'abcdef@test.com';
        e1.ClientOffset__c = -300;
        e1.Client_Timezone__c = 'GMT -5.00 EST';
        insert e1;
        SimpleCalender.saveEvent(System.now() + 10000 , System.now() + 11000, 'description','30',e.id,-300);
        ProgramCalenderController.getProgramEventData(-300,'abcdef','abcdef@test.com',false,currentYearProgram.Id);
        ProgramCalenderController.getProgramEventData(-300,'abcdef','abcdef@test.com',true,currentYearProgram.Id);
        Program__c p = [SELECT ID from program__C where Limeade_E_Id__c = 'abcdef'];
        ProgramCalenderController.confirmAppointment(e.id, p.Id, 'fName','lName', 'email@email.com','1234567890','reason','12/01/1980','12345','GMT -5.00 EST',-300);
        Event e2 = new Event();
        e2.For_Training__c = TRUE;
        e2.subject = 'Test2';
        e2.EndDateTime = System.now().addMinutes(800);
        e2.StartDateTime = System.now().addMinutes(770);
        e2.ClientOffset__c = -300;
        e2.Client_Timezone__c = 'GMT -5.00 EST';
        insert e2;       
        Event e3 = new Event();
        e3.subject = 'Test3';
        e3.For_Training__c = TRUE;
        e3.EndDateTime = System.now().addMinutes(800);
        e3.StartDateTime = System.now().addMinutes(770); 
        insert e3;
        Event e4 = new Event();
        e4.subject = 'Test4';
        e4.For_Training__c = TRUE;
        e4.EndDateTime = System.now().addMinutes(800);
        e4.StartDateTime = System.now().addMinutes(770); 
        insert e4;
        ProgramCalenderController.confirmAppointment(e2.id, p.Id, 'fName','lName', 'email@email.com','1234567890','reason','12/01/1980','12345','GMT -5.00 EST',-300);
        Event e2a = new Event();
        e2a.subject = 'Test2';
        e2a.EndDateTime = System.now().addMinutes(800);
        e2a.StartDateTime = System.now().addMinutes(770);
        e2a.ClientOffset__c = -300;
        e2a.Client_Timezone__c = 'GMT -5.00 EST';
        e2a.For_Training__c = TRUE;
        insert e2a;
        Event e2b = new Event();
        e2b.subject = 'Test2';
        e2b.EndDateTime = System.now().addMinutes(800);
        e2b.StartDateTime = System.now().addMinutes(770);
        e2b.ClientOffset__c = -300;
        e2b.Client_Timezone__c = 'GMT -5.00 EST';
        e2b.For_Training__c = TRUE;
        insert e2b;
        Event e2c = new Event();
        e2c.subject = 'Test2';
        e2c.EndDateTime = System.now().addMinutes(800);
        e2c.StartDateTime = System.now().addMinutes(770);
        e2c.ClientOffset__c = -300;
        e2c.For_Training__c = TRUE;
        e2c.Client_Timezone__c = 'GMT -5.00 EST';
        insert e2c;
        ProgramCalenderController.confirmAppointment(e2a.id, p.Id, 'fName','lName', 'email@email.com','1234567890','reason','12/01/1980','12345','GMT -5.00 EST',-300);
        ProgramCalenderController.searchAppointment('email@email.com');
        ProgramCalenderController.cancelAppointment(e.id);
        currentYearProgram.PreventValidation_on_CoachingAppointment__c = FALSE;
        update currentYearProgram;
        ProgramCalenderController.confirmAppointment(e2c.id, p.Id, 'fName','lName', 'email@email.com','1234567890','reason','12/01/1980','12345','GMT -5.00 EST',-300);
    }
    
}