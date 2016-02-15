global class BatchClassOrderCleanUp implements Database.Batchable<sObject>, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        
        string queryString = 'SELECT Id, Order_Type__c, Limeade_Participant_Code__c,Duplicate__c, Date_of_Test__c, '+
                              ' Order_Status__c FROM Order__c WHERE Order_Status__c = \'Sent Limeade\' AND Duplicate__c =FALSE '+
                               ' AND Limeade_Participant_Code__c != \'\' Order by Limeade_Participant_Code__c, CreatedDate ASC ';
         
         
        system.debug('##--queryString: '+ queryString);
        return Database.getQueryLocator(queryString);
        
    }// end of start method
    
    webService static String executeNow() {

        BatchClassOrderCleanUp batch = new BatchClassOrderCleanUp();
        Database.executeBatch(batch);

        return 'Succesfully scheduled batch';
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        
        set<string> setKeys;
        list<Order__c> lstDupeOrders = new list<Order__c>();
        list<Order__c> lstOrders = (list<Order__c>) scope;
        system.debug('##--setKeys: '+ setKeys);
        for(Order__c objOrder :lstOrders){
            
            if(setKeys == null){
                setKeys = new set<string>();
            }
            
            string key = objOrder.Order_Type__c+objOrder.Limeade_Participant_Code__c.toLowerCase()+ objOrder.Date_of_Test__c;
            if(setKeys.contains(key)) {
                objOrder.Duplicate__c= true;
                 lstDupeOrders.add(objOrder);
             } else {
                 setKeys.add(key);
             }
        }
         
         if(lstDupeOrders.size() > 0){
            update lstDupeOrders;
         }
         
    }   //  end of execute
    
    global void finish(Database.BatchableContext BC){
        
    } // end of finish method

}