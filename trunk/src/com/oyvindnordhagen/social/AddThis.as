package com.oyvindnordhagen.social
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;

	/**
	 * @author Oyvind Nordhagen
	 * @date 3. okt. 2010
	 */
	public class AddThis
	{
		private static const ADD_THIS_ROOT:String = "http://api.addthis.com/oexchange/0.8/forward";
		public static const BLOGGER:String = "blogger";
		public static const DELICIOUS:String = "delicious";
		public static const DIGG:String = "digg";
		public static const EVERNOTE:String = "evernote";
		public static const GOOGLE_BOOKMARK:String = "google";
		public static const LINKEDIN:String = "linkedin";
		public static const MYSPACE:String = "myspace";
		public static const FACEBOOK:String = "facebook";
		public static const STUMBLE_UPON:String = "stumbleupon";
		public static const TUMBLR:String = "tumblr";
		public static const TWITTER:String = "twitter";

		public static function share ( service:String , url:String , title:String = null , description:String = null , imageUrl:String = null , userName:String = null ):void
		{
			var params:URLVariables = new URLVariables();
			params.swfurl = url;
			params.url = url;
			params.width = 128;
			params.height = 128;
			params.title = title || "";
			params.description = description || "";
			params.screenshot = imageUrl || "";

			if (userName)
			{
				params.username = userName;
			}

			if (service == TWITTER)
			{
				params.templates = { twitter:title.substr( 0 , 100 ) + "{{url}}" };
			}

			var serviceUrl:URLRequest = new URLRequest( ADD_THIS_ROOT + "/" + service + "/offer" );
			serviceUrl.data = params;
			serviceUrl.method = URLRequestMethod.POST;

			navigateToURL( serviceUrl , "_blank" );
		}
	}
}
