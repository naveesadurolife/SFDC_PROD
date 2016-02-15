public with sharing class Utility {
	public static String getTimeZone(String tz)
	{
		String timeZone;
		String defaultTZ='America/Los_Angeles';
		timeZone=(String.isBlank(tz)?defaultTZ:(Constant.MAPTIMEZONES.containsKey(tz)?Constant.MAPTIMEZONES.get(tz):defaultTZ));
		return timeZone;
	}
}