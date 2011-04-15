package com.oynor.minimal.data {
	import no.olog.utilfunctions.otrace;
	import flash.net.URLRequest;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLLoader;

	/**
	 * @author Oyvind Nordhagen
	 * @date 5. feb. 2011
	 */
	public class MinimalPoller {
		public var changeCallback:Function = _nullFunction;
		public var errorCallback:Function = _nullFunction;
		public var url:String;
		public var interval:uint;
		public var maxPolls:uint;
		private var _loader:URLLoader;
		private var _lastError:String;
		private var _lastResult:String;
		private var _timer:Timer;
		private var _request:URLRequest;

		public function MinimalPoller ( url:String, changeCallback:Function, interval:uint = 60000, maxPolls:uint = 0 ) {
			this.url = url;
			this.maxPolls = maxPolls;
			this.interval = interval;
			this.changeCallback = changeCallback;
			_init();
		}

		public function start ():void {
			otrace( "Starting poll timer at " + _timer.delay, 0, this );
			_poll();
			_timer.reset();
			_timer.start();
		}

		public function stop ():void {
			_timer.reset();
		}

		public function get lastError ():String {
			return _lastError;
		}

		public function get lastResult ():String {
			return _lastResult;
		}

		private function _errorHandler ( event:IOErrorEvent ):void {
			_lastError = event.text;
			_timer.reset();
			errorCallback();
		}

		private function _completeHandler ( event:Event ):void {
			if (_loader.data != _lastResult) {
				_lastResult = _loader.data;
				otrace( "New result " + _lastResult, 0, this );
				changeCallback();
			}
		}

		private function _init ():void {
			_request = new URLRequest( url );

			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, _completeHandler );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, _errorHandler );

			_timer = new Timer( interval );
			_timer.addEventListener( TimerEvent.TIMER, _timerHandler );
		}

		private function _timerHandler ( event:TimerEvent ):void {
			_poll();
		}

		private function _poll ():void {
			otrace( "Polling " + url, 0, this );
			_request.url = url;
			_loader.load( _request );
			if (maxPolls == 0 || _timer.repeatCount < maxPolls) _timer.delay = interval;
			else _timer.reset();
		}

		private function _nullFunction ():void {
			trace( "nullFunction in MinimalPoller" );
		}
	}
}
