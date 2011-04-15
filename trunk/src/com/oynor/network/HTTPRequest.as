package com.oynor.network
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 * @author Oyvind Nordhagen
	 * @date 21. apr. 2010
	 */
	public class HTTPRequest extends EventDispatcher
	{
		public var isReusable:Boolean = false;

		protected var _url:String;
		protected var _request:URLRequest;
		protected var _get:Object;
		protected var _post:Object;
		protected var _resultIsXML:Boolean;
		protected var _lastResultXML:XML;
		protected var _lastResultString:String;
		protected var _loader:URLLoader;
		protected var _pollCount:int;
		protected var _resultCount:int;

		[Event(name="complete", type="flash.events.Event")]
		[Event(name="ioError", type="flash.events.IOErrorEvent")]
		[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
		public function HTTPRequest ( url:String , GETvars:Object = null , POSTvars:Object = null , resultIsXML:Boolean = true ):void
		{
			_url = url;
			_get = GETvars;
			_post = POSTvars;
			_resultIsXML = resultIsXML;
			_init();
		}

		protected function _init ():void
		{
			_request = new URLRequest();
			_processGET();
			_processPOST();
			_initLoader();
		}

		protected function _initLoader ():void
		{
			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE , _onLoadComplete );
			_loader.addEventListener( Event.COMPLETE , _relay );
			_loader.addEventListener( IOErrorEvent.IO_ERROR , _relay );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR , _relay );
		}

		protected function _relay ( e:Event ):void
		{
			dispatchEvent( e );
		}

		protected function _processPOST ():void
		{
			if (_post)
			{
				var vars:URLVariables = new URLVariables();
				for (var p:String in _post)
					vars[p] = _post[p];
			}
		}

		protected function _processGET ():void
		{
			if (_get)
			{
				for (var p:String in _get)
					addGETVariable( p , _get[p] );
			}
		}

		protected function _onLoadComplete ( e:Event ):void
		{
			_resultCount++;
			if (!isReusable)
				disposeLoader();
			if (_resultIsXML)
				_lastResultXML = new XML( e.target.data );
			_lastResultString = String( e.target.data );
		}

		public function disposeLoader ():void
		{
			_loader.close();
			_loader.removeEventListener( Event.COMPLETE , _onLoadComplete );
			_loader.removeEventListener( Event.COMPLETE , _relay );
			_loader.removeEventListener( IOErrorEvent.IO_ERROR , _relay );
			_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR , _relay );
			_loader = null;
		}

		public function load ():void
		{
			_pollCount++;
			_loader.load( request );
		}

		public function get pollCount ():int
		{
			return _pollCount;
		}

		public function get resultCount ():int
		{
			return _resultCount;
		}

		public function get lastResult ():XML
		{
			return _lastResultXML;
		}

		public function get lastResultAsString ():String
		{
			return _lastResultString;
		}

		public function get request ():URLRequest
		{
			_request.url = _url;
			return _request;
		}

		public function get url ():String
		{
			return _url;
		}

		public function setPOSTVariable ( name:String , value:* ):void
		{
			if (!_request.data)
				_request.data = new URLVariables();
			_request.data[name] = value;
		}

		public function addGETVariable ( name:String , value:String ):void
		{
			if (_url.indexOf( "?" ) != -1)
				_url += "&" + name + "=" + value;
			else
				_url += "?" + name + "=" + value;
		}
	}
}
