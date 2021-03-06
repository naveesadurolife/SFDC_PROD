@isTest
public class ValidateLimeadeOnEventTEST {
    public static testmethod void testController(){
        ProgramCalenderControllerTEST.init();
        Event e = new Event();
        e.subject = 'Test';
        e.EndDateTime = System.now().addMinutes(800);
        e.StartDateTime = System.now().addMinutes(770); 
        e.ClientOffset__c = -300;
        e.Client_Timezone__c = 'GMT -5.00 EST';
        e.Program__c = ProgramCalenderControllerTEST.currentYearProgram.Id;
        e.Trainee_Phone__c = '1234567890' ;
        e.Trainee_DOB__c = Date.parse('11/12/1980');
        e.Trainee_EID__c = '1234567890' ;
        e.Trainee_Email__c = 'abc@abc.com';
        e.Trainee_First_Name__c = 'abc';
        e.Trainee_Last_Name__c ='XYZ';
        e.Confirmed__c = true;
        insert e;       
        ValidateLimeadeOnEvent v = new ValidateLimeadeOnEvent(new ApexPages.StandardController(e));
        v.validateWithLimeade();
        Event e1 = new Event();
        e1.subject = 'Test';
        e1.EndDateTime = System.now().addMinutes(800);
        e1.StartDateTime = System.now().addMinutes(770); 
        e1.ClientOffset__c = -300;
        e1.Client_Timezone__c = 'GMT -5.00 EST';
        e1.Program__c = ProgramCalenderControllerTEST.currentYearProgram.Id;
        e1.Trainee_Phone__c = '1234567890' ;
        e1.Trainee_DOB__c = Date.parse('11/12/1980');
        e1.Trainee_EID__c = '1234567890' ;
        e1.Trainee_Email__c = 'abc@abc.com';
        e1.Trainee_First_Name__c = 'abc';
        e1.Trainee_Last_Name__c ='XYZ';
        e1.Confirmed__c = true;
		e1.In_Limeade__c = 'Yes';
        insert e1;
        v = new ValidateLimeadeOnEvent(new ApexPages.StandardController(e1));
        v.validateWithLimeade();
        Event e2 = new Event();
        e2.subject = 'Test';
        e2.EndDateTime = System.now().addMinutes(800);
        e2.StartDateTime = System.now().addMinutes(770); 
        e2.ClientOffset__c = -300;
        e2.Client_Timezone__c = 'GMT -5.00 EST';
        e2.Trainee_Phone__c = '1234567890' ;
        e2.Trainee_DOB__c = Date.parse('11/12/1980');
        e2.Trainee_EID__c = '1234567890' ;
        e2.Trainee_Email__c = 'abc@abc.com';
        e2.Trainee_First_Name__c = 'abc';
        e2.Trainee_Last_Name__c ='XYZ';
        e2.Program__c = NULL;
        e2.Confirmed__c = true;
        insert e2;
        v = new ValidateLimeadeOnEvent(new ApexPages.StandardController(e2));
        v.validateWithLimeade();
        Event e3 = new Event();
        e3.subject = 'Test';
        e3.EndDateTime = System.now().addMinutes(800);
        e3.StartDateTime = System.now().addMinutes(770); 
        e3.ClientOffset__c = -300;
        e3.Client_Timezone__c = 'GMT -5.00 EST';
        e3.Program__c = ProgramCalenderControllerTEST.currentYearProgram.Id;
        e3.Trainee_Phone__c = '1234567890' ;
        e3.Trainee_DOB__c = Date.parse('11/12/1980');
        e3.Trainee_EID__c = '1234567890' ;
        e3.Trainee_Email__c = 'abc@abc.com';
        e3.Trainee_First_Name__c = 'abc';
        e3.Trainee_Last_Name__c ='XYZ';
        insert e3; 
        v = new ValidateLimeadeOnEvent(new ApexPages.StandardController(e3));
        v.validateWithLimeade();
    }
}