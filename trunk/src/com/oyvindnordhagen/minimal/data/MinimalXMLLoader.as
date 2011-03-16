package com.oyvindnordhagen.minimal.data {
	import flash.events.ErrorEvent;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;

	/**
	 * @author Oyvind Nordhagen
	 * @date 1. feb. 2011
	 */
	public class MinimalXMLLoader {
		public var _url:String;
		private var _loader:URLLoader;
		private var _resultHandler:Function;
		private var _errorHandler:Function;
		private var _lastResult:XML;
		private var _lastError:ErrorEvent;

		public function MinimalXMLLoader ( url:String, resultHandler:Function, errorHandler:Function, autoLoad:Boolean = true ) {
			_url = url;
			_errorHandler = errorHandler;
			_resultHandler = resultHandler;
			if (autoLoad) load();
		}

		public function get lastResult ():XML {
			return _lastResult;
		}

		public function get lastError ():ErrorEvent {
			return _lastError;
		}

		public function load ():void {
			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, _loadCompleteHandler );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, _loadErrorHandler );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _loadErrorHandler );
			_loader.load( new URLRequest( _url ) );
		}

		public function destroy ( deleteResults:Boolean = false ):void {
			_errorHandler = null;
			_resultHandler = null;
			if (deleteResults) {
				_lastResult = null;
				_lastError = null;
			}
		}

		private function _loadCompleteHandler ( event:Event ):void {
			_lastResult = new XML( _loader.data );
			_resultHandler();
			_cleanup();
		}

		private function _loadErrorHandler ( event:ErrorEvent ):void {
			_lastError = event;
			_errorHandler();
			_cleanup();
		}

		private function _cleanup ():void {
			_loader.removeEventListener( Event.COMPLETE, _loadCompleteHandler );
			_loader.removeEventListener( IOErrorEvent.IO_ERROR, _loadErrorHandler );
			_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _loadErrorHandler );
			_loader = null;
			destroy( false );
		}
	}
}
