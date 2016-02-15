public with sharing class OAuthHelper {

	public static String constructRequestURL(string protocol, string host, 
												string resource, String oAuthAccessTokenSecret,
												String consumerKey, String consumerSecret, 
												map<string, string> parameters){
		string url='';
		string oauthSecret = consumerSecret + '&' + oAuthAccessTokenSecret;
		String baseString = generateOAuthBaseString(protocol, host, resource, parameters);
		Blob sig = Crypto.generateMac(
           'HmacSHA1'
          , Blob.valueOf(baseString)
          , Blob.valueOf(oAuthSecret)
        );
		parameters.put('oauth_signature', EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), 'UTF-8'));
		
		url = protocol+'://'+host+'/'+resource+'?';
		list<string> lstParamKeys = new list<String>(parameters.keySet());
		lstParamKeys.sort();
		String amp='';
		for(String key : lstParamKeys){
			url += amp+key  +'=' + parameters.get(key);
            amp = '&';
		}
        
		return url;
	}	//	end of constructRequestURL
	
	
	public static String generateOAuthBaseString(string protocol, string host, 
													string resource, 
													map<string, string> parameters){
        list<string> sortedKeys = new list<string>(parameters.keySet());
        sortedKeys.sort();


        string paramPart = '';
        string amp = '';
        for (integer i = 0 ; i < sortedKeys.size(); i++)
        {
            paramPart+=amp+sortedKeys[i]+'='+parameters.get(sortedKeys[i]);
            amp = '&';
        }

        return ('GET'+'&'+ EncodingUtil.urlEncode(protocol+'://'+host+'/'+resource, 'UTF-8') + '&' + EncodingUtil.urlEncode(paramPart, 'UTF-8'));
    }	//	end of generateOAuthBaseString
    
    public static map<string, string> createDefaultParameters(String consumerKey){
    	map<string, string> mapParameters = new map<string, string>();
    	mapParameters.put('oauth_consumer_key', consumerKey);
		mapParameters.put('oauth_nonce', generateNonce());
		mapParameters.put('oauth_timestamp', generateOAuthTimestamp());
		mapParameters.put('oauth_signature_method', 'HMAC-SHA1');
		mapParameters.put('oauth_version', '1.0');
    	return mapParameters;
    }	//	end of createDefaultParameters
    
    public static string generateNonce(){ 
    	return String.valueOf(Crypto.getRandomLong());
    }	//	end of generateNonce
    
    public static string generateOAuthTimestamp(){ 
    	return String.valueOf(DateTime.now().getTime() / 1000);
    }	//	end of generateOAuthTimestamp
	
	public static map<string, string> createMapFromResponse(String response){
		map<string, string> mapResponseParams = new map<string, string>();
		
		if(String.isBlank(response) ||
			! response.contains('&')){
			return mapResponseParams;
		}
		
		for(String param : response.split('&', -1)){
			mapResponseParams.put(param.split('=',2)[0], param.split('=',2)[1]);
		}	//	end of fore-each reponse param
		
		return mapResponseParams;
	}	//	end of createMapFromResponse
	
	
}	//	end of OAuthHelper