public without sharing class A1CFormCC {
	
	private string q1;
    private string q2;
    private string q3;
    private string q4;
    private string q5;
    private string q6;
    private string q7;
    
    
    public list<string> lstFirstNameAlphas {get;set;}
    public list<string> lstLastNameAlphas {get;set;} 
    public list<string> lstEmailAlphas {get;set;}
    public list<string> lstEmployeeAlphas {get;set;}  
     
    public map<integer, decimal> mapFirstNameIndex {get;set;}
    public map<integer, decimal> mapLastNameIndex {get;set;}
    public map<integer, decimal> mapEmailIndex {get;set;}
    public map<integer, decimal> mapEmployeeIndex {get;set;} 
    public string imageURL{get;set;} 
    public string coverSheetURL {get;set;}
    public string barCodeURL{get;set;}
    public string programNumber{get;set;}
    
    public A1CFormCC(){
    
        q1 = system.currentPageReference().getParameters().get('q1');
        q2 = system.currentPageReference().getParameters().get('q2'); 
        q3 = system.currentPageReference().getParameters().get('q3');
        q4 = system.currentPageReference().getParameters().get('q4');  
        q5 = system.currentPageReference().getParameters().get('q5'); 
        q6 = system.currentPageReference().getParameters().get('q6'); 
        q7 = system.currentPageReference().getParameters().get('q7');  
        
        populateFirstName();
        populateLastName(); 
        populateEmail();
        populateEmployeeId();
        populateLogo_BarCode_CoverSheetURL(); 
        
    }// end of constructor
    
    public void populateFirstName(){
    
        lstFirstNameAlphas = new list<string>();
        mapFirstNameIndex = new map<integer, decimal>();
        
        for(integer i=1; i<q1.length()+1 ; i++){ 
            
            lstFirstNameAlphas.add(q1.split('')[i]);
            mapFirstNameIndex.put(i, (i<8 ? (60+(25*(i-1))) : (60+(24.5*(i-1))) ) );
            
        } //end of for-each firstName 
    
    } // end of populateFirstName
    
    public void populateLastName(){
    
        lstLastNameAlphas = new list<string>();
        mapLastNameIndex = new map<integer, decimal>();
        
        string lastName = '';
        
        if(q2 != null){
        	
	    	if(q2.split(' ').size() > 1){
	    		lastName = q2.split(' ')[1];
	        } else{
	        	lastName = q2;
	        }
        	
        }
        
        for(integer i=1; i<lastName.length()+1 ; i++){ 
            
            lstLastNameAlphas.add(lastName.split('')[i]);
            
            mapLastNameIndex.put(i,  (i<8 ? (60+(25*(i-1))) : (60+(24.5*(i-1))) ) );
            
        } //end of for-each lastName 
    
    } // end of populateLastName 
    
    public void populateEmployeeId(){
    
        lstEmployeeAlphas = new list<string>();
        mapEmployeeIndex = new map<integer, decimal>();
        
        for(integer i=1; i<q6.length()+1 ; i++){ 
            
            lstEmployeeAlphas.add(q6.split('')[i]);
            mapEmployeeIndex.put(i, (i<8 ? (542+(25*(i-1))) : (542+(24.5*(i-1))) ) );
            
        } //end of for-each employee 
    
    } // end of populateEmployeeId
    
    public void populateEmail(){
    
        lstEmailAlphas = new list<string>();
        mapEmailIndex = new map<integer, decimal>();
        
        for(integer i=1; i<q5.length()+1 ; i++){ 
            
            lstEmailAlphas.add(q5.split('')[i]);
            
            mapEmailIndex.put(i, (i<8 ? (55+(21*(i-1))) : (i< 12 ? (55+(21*(i-1))) : (55+(21.25*(i-1))) ) ) );
            
        } //end of for-each Email 
    
    } // end of populateEmail
    
    public void populateLogo_BarCode_CoverSheetURL(){
    	
    	String query='';
    	
    	system.debug('##--populateLogoAndCoverSheetURL.q7: '+ q7);
    	
    	list<Program__c> lstProgram = new list<Program__c>();
    	
		if(q3 != null || q3 != ''){	
				
			if(q4 != null && q4 != '')	{	
				lstProgram = [SELECT Id, Cover_Sheet_Document_Id__c, Physician_Form_Logo__c,  Program_Logo__c, 
			    											Bar_Code_Document_Id__c, Program_Number__c  
			    											FROM Program__c 
			    											WHERE Limeade_PSK_ID__c = :q7 
			    											AND PFF_Form_Type__c = :q3 
			    											AND Program_Status__c = 'Draft' 
															ORDER BY Program_Start_Date__c Desc];
				
			}	else{
				lstProgram = [SELECT Id, Cover_Sheet_Document_Id__c, Physician_Form_Logo__c,  Program_Logo__c, 
			    											Bar_Code_Document_Id__c, Program_Number__c  
			    											FROM Program__c 
			    											WHERE Limeade_PSK_ID__c = :q7 
			    											AND PFF_Form_Type__c = :q3 
			    											AND Program_Status__c = 'Active' 
															ORDER BY Program_Start_Date__c Desc];
			}	// end of inner else-if				
					
		} else{
			
			if(q4 != null && q4 != '')	{
				
				lstProgram = [SELECT Id, Cover_Sheet_Document_Id__c, Physician_Form_Logo__c,  Program_Logo__c, 
    											Bar_Code_Document_Id__c, Program_Number__c  
    											FROM Program__c 
    											WHERE Limeade_PSK_ID__c = :q7 
    											AND Program_Status__c = 'Draft' 
												ORDER BY Program_Start_Date__c Desc]; 
				
			}else{
				
				lstProgram = [SELECT Id, Cover_Sheet_Document_Id__c, Physician_Form_Logo__c,  Program_Logo__c, 
    											Bar_Code_Document_Id__c, Program_Number__c  
    											FROM Program__c 
    											WHERE Limeade_PSK_ID__c = :q7 
    											AND Program_Status__c = 'Active' 
												ORDER BY Program_Start_Date__c Desc]; 
			}	// end of inner else-if
			
		
		}		// end of else-if	
    	
    	system.debug('##--Query: '+Query); 
    													
    	coverSheetURL='/servlet/servlet.FileDownload?file='+lstProgram[0].Cover_Sheet_Document_Id__c;
    	
    	system.debug('##--populateLogoAndCoverSheetURL.coverSheetURL: '+ coverSheetURL);
    	imageURL='/servlet/servlet.FileDownload?file='+lstProgram[0].Program_Logo__c;
    	barCodeURL='/servlet/servlet.FileDownload?file='+lstProgram[0].Bar_Code_Document_Id__c;
    	if(lstProgram[0].Program_Number__c.contains('PROG-')){
    		programNumber = lstProgram[0].Program_Number__c.replace('PROG-','');
    	} else {
    		programNumber = lstProgram[0].Program_Number__c;
    	}
    	
    	system.debug('##--populateLogoAndCoverSheetURL.lstProgram[0].Program_Number__c: '+ lstProgram[0].Program_Number__c);
    	
    }// end of populateimageURL  
    

}