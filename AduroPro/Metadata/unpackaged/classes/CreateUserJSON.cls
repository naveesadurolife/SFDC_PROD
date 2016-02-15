/* 
 * Name: CreateUserJSON
 * Type: Apex Class
 * Test Class: BridgeRESTCalloutUtilityTest
 * Description:  This class provide the user object structure for Bridge REST Callouts. 
 * Change History:
 *===================================================================================================================================
 * Version     Author               Date             Description 
 * 1.0         Sreeni               01/16/2016       1. Initial Version created
 */
public with sharing class CreateUserJSON {

	public List<Users> users;

	public class Custom_fields {
		public String custom_field_id;
		public String value;
	}

	public class Users {
		public String uid;
		public String first_name;
		public String last_name;
		public String email;
		public List<Custom_fields> custom_fields;
	}
	
	public static createUserJSON getTestUserJSON() {
		String json = '{'+
		'	\"users\": [{'+
		'		\"uid\": \"first7b@yesemail.com\",'+
		'		\"last_name\": \"Last7\",'+
		'		\"first_name\": \"First7b\",'+
		'		\"email\": \"first7b@yesemail.com\",'+
		'		\"custom_fields\": [{'+
		'			\"custom_field_id\": \"1\",'+
		'			\"value\": \"467DF5AB-7968-47D3-B837-70EEE03E6369\"'+
		'		}, {'+
		'			\"custom_field_id\": \"2\",'+
		'			\"value\": \"3\"'+
		'		}]'+
		'	}]'+
		'}';
		createUserJSON obj = (createUserJSON) System.JSON.deserialize(json, createUserJSON.class);
		return obj;
	}

}