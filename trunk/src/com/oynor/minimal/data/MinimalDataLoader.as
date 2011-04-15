package com.oynor.minimal.data
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Oyvind Nordhagen
	 * @date 16. mar. 2011
	 */
	public class MinimalDataLoader
	{
		public var url:String;
		protected var _loader:URLLoader;
		protected var _resultHandler:Function;
		protected var _errorHandler:Function;
		protected var _lastResult:*;
		protected var _lastError:ErrorEvent;

		public function MinimalDataLoader ( url:String, resultHandler:Function, errorHandler:Function, autoLoad:Boolean = true )
		{
			this.url = url;
			_errorHandler = errorHandler;
			_resultHandler = resultHandler;
			if (autoLoad) load();
		}

		public function get lastResult ():*
		{
			return _lastResult;
		}

		public function get lastError ():ErrorEvent
		{
			return _lastError;
		}

		public function load ():void
		{
			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, _loadCompleteHandler );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, _loadErrorHandler );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _loadErrorHandler );
			_loader.load( new URLRequest( url ) );
		}

		public function destroy ( deleteResults:Boolean = false ):void
		{
			_errorHandler = null;
			_resultHandler = null;
			if (deleteResults)
			{
				_lastResult = null;
				_lastError = null;
			}
		}

		protected function _loadCompleteHandler ( event:Event ):void
		{
			_lastResult = _loader.data;
			_resultHandler();
			_cleanup();
		}

		protected function _loadErrorHandler ( event:ErrorEvent ):void
		{
			_lastError = event;
			_errorHandler();
			_cleanup();
		}

		protected function _cleanup ():void
		{
			_loader.removeEventListener( Event.COMPLETE, _loadCompleteHandler );
			_loader.removeEventListener( IOErrorEvent.IO_ERROR, _loadErrorHandler );
			_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _loadErrorHandler );
			_loader = null;
			destroy( false );
		}
	}
}
