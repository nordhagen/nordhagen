package com.oyvindnordhagen.utils
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class ErrorNotifyer {
		private static var _url : String = "http://services.allegro.no/scripts/sendmail.asp";
		private static var _recipient : String = "oyvind@allegro.no";

		public function ErrorNotifyer() {
			throw new Error("ErrorNotifyer is static. Do not instantiate");
		}

		public static function send($error : Error, $project : String = "project") : void {
			var mail : URLVariables = new URLVariables();
			mail.sender = _recipient;
			mail.recipient = _recipient;
			mail.subject = "Error in " + $project;
			mail.body = $error.getStackTrace();
				
			var ur : URLRequest = new URLRequest(_url);
			ur.data = mail;
			ur.contentType = URLLoaderDataFormat.VARIABLES;
			ur.method = URLRequestMethod.POST;
				
			var ul : URLLoader = new URLLoader();
			ul.load(ur);
		}
	}
}