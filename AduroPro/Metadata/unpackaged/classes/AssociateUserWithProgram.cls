public class AssociateUserWithProgram {
    public SelectOption[] selectedGroupds { get; set; }
    public SelectOption[] availableGroups { get; set; }
    public Program__c currentProgram { get; set; }

    public AssociateUserWithProgram(ApexPages.StandardController controller){
        currentProgram = (Program__c) controller.getRecord();
        currentProgram = [SELECT Id,Groups__c,Allowed_Duration__c,Coaching_Calendar_Name__c,Limeade_PSK_ID__c,
                          PreventValidation_on_CoachingAppointment__c,X1_1_Coaching_Identifier_Employee_ID__c,
                          X1_1_Coaching_Identifier_DOB__c,Limeade_E_Id__c
                          FROM Program__c WHERE Id =:currentProgram.Id  ];
        Set<String> groupIds = currentProgram.Groups__c == NULL || currentProgram.Groups__c == '' ? new Set<String>() : new Set<String>(currentProgram.Groups__c.split(','));
        List<Group> groups = [SELECT Name, DeveloperName, Id FROM Group];       
        System.debug('************ groupIds **************' + groupIds);
        selectedGroupds = new List<SelectOption>();         
        availableGroups = new List<SelectOption>();
        for ( Group g : groups ) {
            if(groupIds.contains(g.Id)){
              selectedGroupds.add(new SelectOption(g.Id, g.DeveloperName));
            }
            else{
            availableGroups.add(new SelectOption(g.Id, g.DeveloperName));
            }
        }
        if(selectedGroupds <> NULL && selectedGroupds.size() >0){
            selectedGroupds.sort();            
        }
        if(availableGroups <> NULL && availableGroups.size() >0){
           // availableGroups.sort();            
        }
    }
    
    public String message { get; set; }

    public PageReference save() {
        message = 'Selected Contacts: ';
        String groupIds ='';
        List<String> selectdGroups ; 
        Boolean first = true;
        for ( SelectOption so : selectedGroupds ) {
            if (!first) {
                message += ', ';
            }
            message += so.getLabel() + ' (' + so.getValue() + ')';
            groupIds += so.getValue() + ',';
            first = false;
        }
        groupIds = groupIds.replace(',,',',');
        groupIds = groupIds <> NULL && groupIds.length() > 15 ? groupIds.substring(0,groupIds.length()-1) : ''; //groupIds.substring(0,groupIds.length()-1);
        message = groupIds;
        selectdGroups = groupIds.split(',');
        List<Associated_Coach__c> coaches = new List<Associated_Coach__c>();
        List<String> selectedUsers = new List<String>();
        for( GroupMember gm : [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN :selectdGroups ]){
			coaches.add(new Associated_Coach__c(Coach__c = gm.UserOrGroupId, Program__c = currentProgram.Id ));
            selectedUsers.add(gm.UserOrGroupId);
        }
        delete([SELECT Id FROM Associated_Coach__c WHERE Program__c =: currentProgram.Id ]);
        insert coaches;
        currentProgram.Groups__c = groupIds;
        update currentProgram;
        return null;      
    }
}