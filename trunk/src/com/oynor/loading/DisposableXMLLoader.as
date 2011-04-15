package com.oynor.loading
{
	import no.olog.utilfunctions.nullFunction;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Oyvind Nordhagen
	 * @date 7. sep. 2010
	 */
	public class DisposableXMLLoader
	{
		private var _loader:URLLoader;

		public var successCallback:Function = nullFunction;
		public var errorCallback:Function = nullFunction;

		public function load ( url:String ):void
		{
			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE , _onLoaded );
			_loader.addEventListener( IOErrorEvent.IO_ERROR , _onError );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR , _onError );
			_loader.load( new URLRequest( url ) );
		}

		private function _onError ( e:ErrorEvent ) : void
		{
			errorCallback( e );
			_dispose();
		}

		private function _onLoaded ( e:Event ) : void
		{
			successCallback( new XML( _loader.data ) );
			_dispose();
		}

		private function _dispose () : void
		{
			successCallback = null;
			errorCallback = null;
			_loader.removeEventListener( Event.COMPLETE , _onLoaded );
			_loader.removeEventListener( IOErrorEvent.IO_ERROR , _onError );
			_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR , _onError );
			_loader = null;
		}
	}
}
