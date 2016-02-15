public class CancelAppointment {
    public String eId {get;set;}
    Public String message {get;set;}
    public String email {get;set;}
    public List<ProgramCalenderController.EventWrapper> appointments {get;set;}
    public CancelAppointment(){
      eId =  ApexPages.currentPage().getParameters().get('id');
      email =  ApexPages.currentPage().getParameters().get('email');
      System.debug('***** Email *** ' + email);
      appointments = new List<ProgramCalenderController.EventWrapper>();
      appointments = ProgramCalenderController.searchAppointment(email);
      System.debug('***** appointments *** ' + appointments);
      message ='';
    }
    @RemoteAction    
    public static void CancelAppointmentUserChoice(String eId){
        ProgramCalenderController.cancelAppointment(eId);
    }
}