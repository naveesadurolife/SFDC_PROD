public class ValidateLimeadeOnEvent {
    public Event currentEvent {get;set;}
    public Program__c currentProgram {get;set;}
    public String message {get;set;}
    public ValidateLimeadeOnEvent(ApexPages.StandardController controller){
    	currentEvent = (Event) controller.getRecord();
        currentEvent = [SELECT Id,Trainee_Phone__c,Trainee_DOB__c,Trainee_EID__c,Trainee_Email__c,
                        Trainee_First_Name__c,Trainee_Last_Name__c,Program__c,Confirmed__c,In_Limeade__c,
                        Limeade_Participant_code__c,WhoID 
                        FROM EVENT WHERE Id =:currentEvent.Id ];
        if(currentEvent <> NULL && currentEvent.Program__c <> NULL){
           currentProgram = [SELECT ID,X1_1_Coaching_Identifier_DOB__c,X1_1_Coaching_Identifier_Employee_ID__c,
                            PreventValidation_on_CoachingAppointment__c,Limeade_E_Id__c,Limeade_PSK_ID__c,
                            Coaching_Identifier_LastName__c,Coaching_Identifier_DOB__c,Coaching_Identifier_Email__c,
                            Coaching_Identifier_Employee_ID__c
                            FROM Program__c WHERE Id =:currentEvent.Program__c ];
        }
    }
    public Pagereference validateWithLimeade(){
        if(currentEvent.In_Limeade__c == 'Yes' ){
            message = 'This event already validated in Limeade';
            return NULL;
        }
        if(currentEvent.Confirmed__c == FALSE){
        	message = 'This event is not associated with any cochee';
            return NULL;    
        }
        if(currentEvent.Program__c == NULL){
        	message = 'This event is not associated with any Program';
            return NULL;    
        }
        LimeadeValidator lv=new LimeadeValidator();
        lv.LimeadeEID=currentProgram.Limeade_E_Id__c;
        lv.LimeadePSKID=currentProgram.Limeade_PSK_ID__c; 
        lv.LastName=currentEvent.Trainee_Last_Name__c;
        lv.DOB= currentEvent.Trainee_DOB__c ==null  ?'':currentEvent.Trainee_DOB__c.format();
        lv.Email=currentEvent.Trainee_Email__c;
        lv.employeeId=currentEvent.Trainee_EID__c;
        lv.IdentifierLastName=true;
        lv.IdentifierDOB=currentProgram.X1_1_Coaching_Identifier_DOB__c;
        lv.IdentifierEmail=true;
        lv.IdentifierEmployeeID=currentProgram.X1_1_Coaching_Identifier_Employee_ID__c;
        lv.validate(); 
        updateEventContact(lv);
        return NULL;
    }
    public void updateEventContact(LimeadeValidator lv){
        if(lv.ErrorMessage == '' || lv.ErrorMessage == NULL){
            currentEvent.In_Limeade__c = 'Yes';
            List<Contact> contacts = [SELECT ID,Limeade_ParticipantCode__c FROM Contact WHERE Limeade_ParticipantCode__c =:lv.LimeadeParticipantCode ORDER BY LastModifiedDate DESC LIMIT 1];
            if(contacts <> NULL && contacts.size() > 0){
            	currentEvent.Limeade_Participant_code__c = lv.LimeadeParticipantCode;
                currentEvent.WhoID = contacts[0].Id;
            }
        } 
        else{
            currentEvent.In_Limeade__c = 'No';
            message = lv.ErrorMessage;
        }
        update currentEvent;
    }
	
}