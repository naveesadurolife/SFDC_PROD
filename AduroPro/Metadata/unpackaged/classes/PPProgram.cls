public with sharing class PPProgram {
	public Boolean step1{get;set;}
	public Boolean step2{get;set;}
	public Boolean step3{get;set;}
	public String documentURL{get;set;}
	public Boolean errorOnPage{get;set;}
	public String errorMessage{get;set;}
	public String programNumber{get;set;}
	public String programNumber1{get;set;}
	public String programNumber2{get;set;}
	public String programNumber3{get;set;}
	public String programNumber4{get;set;}
	public String programNumber5{get;set;}
	public String programNumber6{get;set;}
	public String programId{get;set;}
	public String firstName{get;set;}
	public String lastName{get;set;}
	public String dateOfBirth{get;set;}
	public String email{get;set;}
	public Document doc{get;set;}
	public static final String DOCUMENT_URL= ((UserInfo.getOrganizationId()=='00D700000009I07EAE')?'https://wellmetrics--c.na5.content.force.com/servlet/servlet.ImageServer?oid=00D700000009I07&id=@@DOCID@@':(UserInfo.getOrganizationId()=='00DQ000000GJi1GMAT'?'https://wellmetrics--staging--c.cs3.content.force.com/servlet/servlet.ImageServer?oid=00DQ000000GJi1GMAT&id=@@DOCID@@':'https://wellmetrics--dev1--c.cs1.content.force.com/servlet/servlet.ImageServer?oid=00DS0000003KAn4&id=@@DOCID@@'));
	public String url='https://wellmetrics--dev1--c.cs1.content.force.com/servlet/servlet.FileDownload?file=015S0000000cDp9';
	public PPProgram()
	{
		documentURL='';
		programNumber='';
		programNumber1='';
		programNumber2='';
		programNumber3='';
		programNumber4='';
		programNumber5='';
		programNumber6='';
		programId='';
		firstName='';
		lastName='';
		dateOfBirth='';
		email='';
		step1=true;
		step2=false;
		step3=false;
		errorOnPage=false;
		errorMessage='';
	}
	public PageReference gotoSetp2()
	{
		errorOnPage=false;
		programNumber='';
		documentURL='';
		programNumber+=String.isNotBlank(programNumber1)?programNumber1:'';
		programNumber+=String.isNotBlank(programNumber2)?programNumber2:'';
		programNumber+=String.isNotBlank(programNumber3)?programNumber3:'';
		programNumber+=String.isNotBlank(programNumber4)?programNumber4:'';
		programNumber+=String.isNotBlank(programNumber5)?programNumber5:'';
		programNumber+=String.isNotBlank(programNumber6)?programNumber6:'';
		if(String.isBlank(programNumber) || programNumber.trim().length()<6)
		{
			errorMessage='Please enter program number.';
			errorOnPage=true;
		}
		else
		{
			String tempProgramNumber='PROG-'+programNumber;
			List<Program__c> listProgram=[Select Id,Physician_Form_Logo__c From Program__c Where Program_Number__c=:tempProgramNumber];
			if(listProgram.size()!=1)
			{
				errorMessage='Invalid program number.';
				errorOnPage=true;				
			}
			else
			{
				programId=listProgram[0].Id;
				if(String.isNotBlank(listProgram[0].Physician_Form_Logo__c))
				{
					documentURL=listProgram[0].Physician_Form_Logo__c;
					documentURL=DOCUMENT_URL.replace('@@DOCID@@',documentURL);
				}
			}
		}
		
		if(!errorOnPage)
		{
			doc=new Document();
			step1=false;
			step2=true;
			step3=false;
		}
		return null;		
	}
	public PageReference gotoSetp3()
	{
		errorOnPage=false;
		errorMessage='';
		Date dob=null;
		if(String.isNotBlank(dateOfBirth))
		{
			try
			{
				dob=Date.parse(dateOfBirth);
			}
			catch(Exception ex){}
		}
		if( 
			String.isNotBlank(firstName) && 
			String.isNotBlank(lastName) && 
			dob!=null && doc!=null && String.isNotBlank(doc.name) && 
			(doc.name.toLowerCase().endsWith('.pdf') || 
				doc.name.toLowerCase().endsWith('.jpg') || 
				doc.name.toLowerCase().endsWith('.tif')) && 
			String.isNotBlank(programId) && validateEmail(email))
		{
			List<Program__c> listProgram=[Select Id,Account__c From Program__c Where Id=:programId];
			doc.folderid =[Select Id From Folder Where DeveloperName=:'Physician_FAX_Forms'].Id;
			insert doc;
			doc=[select id,Name,BodyLength From Document Where Id=:doc.Id];
			
			List<Contact> con=[Select Id From Contact Where LastName=:lastName AND Email=:email AND Birthdate=:dob];
			Contact c;
			if(con.size()!=1)
			{
				RecordType rt=[Select Id From RecordType Where DeveloperName='Participants' limit 1];
				c=new Contact();
				c.RecordTypeId=rt.Id;
				c.FirstName=firstName;
				c.LastName=lastName;
				c.Email=email;
				c.Birthdate=dob;
				c.AccountId=listProgram[0].Account__c;
				insert c;
			}
			else
			{
				c=con[0];
			}
			
			Uploaded_Document__c ud=new Uploaded_Document__c();
			ud.Document_Id__c=doc.Id;
			ud.Contact__c=c.Id;
			ud.File_Name__c=doc.Name;
			ud.File_Size__c=doc.BodyLength;
			ud.Program__c=programId;
			ud.Email__c=email;
			ud.First_Name__c=firstName;
			ud.Last_Name__c=lastName;
			ud.DOB__c=dob;
			insert ud;
			
			step1=false;
			step2=false;
			step3=true;
			doc=new Document();		
		}
		else
		{
			errorMessage='Please enter First Name, Last Name, Date of Birth, Email and select document (only pdf, jpg, tif).';
			errorOnPage=true;			
			step1=false;
			step2=true;
			step3=false;
			doc=new Document();
		}
		return null;		
	}
	public static Boolean validateEmail(String email) {
		Boolean res = true;
			
		
		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank">http://www.regular-expressions.info/email.html</a>
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(email);
	
		if (!MyMatcher.matches()) 
		    res = false;
		return res;	
	}		
}