package com.oyvindnordhagen.network 
{
	import no.olog.OlogEvent;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Oyvind Nordhagen
	 * @date 26. apr. 2010
	 */
	[Event(name="change", type="flash.events.Event")]

	[Event(name="complete", type="flash.events.Event")]

	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

	[Event(name="ioError", type="flash.events.IOErrorEvent")]

	[Event(name="oout", type="no.olog.OlogEvent")]
	public class HTTPPoller extends HTTPRequest 
	{
		public var watchedVariableName:String;
		public var watchedVariableValue:String;
		private var _pollTimer:Timer;
		private var _isPolling:Boolean;

		public function HTTPPoller(url:String, intervalTime:int, GETvars:Object = null, POSTvars:Object = null, resultIsXML:Boolean = true)
		{
			isReusable = true;
			_rigTimer( intervalTime );
			super( url, GETvars, POSTvars, resultIsXML );
		}
		
		public function get isPolling():Boolean
		{
			return _isPolling;
		}

		public function startPolling():void
		{
			_isPolling = true;
			_pollTimer.start( );
		}

		public function stopPolling():void
		{
			_pollTimer.reset( );
			_isPolling = false;
		}

		private function _rigTimer(intervalTime:int):void 
		{
			_pollTimer = new Timer( intervalTime );
			_pollTimer.addEventListener( TimerEvent.TIMER, _onPollTimer );
		}

		private function _onPollTimer(e:TimerEvent):void 
		{
			dispatchEvent( new OlogEvent( OlogEvent.TRACE, "Polling " + _url, 0, this ) );
			load( );
		}

		override protected function _onLoadComplete(e:Event):void
		{
			super._onLoadComplete( e );
			
			if (!watchedVariableName || !watchedVariableValue) return;
			
			if (_lastResultXML.descendants( watchedVariableName )[0] == undefined)
			{
				dispatchEvent(new OlogEvent(OlogEvent.TRACE, "Poll result is missing watched variable \"" + watchedVariableName + "\"", 3, this) );
				return;
			}
			
			if (_resultIsXML && _lastResultXML.descendants( watchedVariableName )[0] != watchedVariableValue)
			{
				watchedVariableValue = _lastResultXML.descendants( watchedVariableName )[0];
				if (_isPolling) dispatchEvent( new Event( Event.CHANGE ) );
			}
			else
			{
				var resultParts:Array = _lastResultString.split("=");
				if (resultParts[0] == watchedVariableName && resultParts[1] != watchedVariableValue)
				{
					watchedVariableValue = resultParts[1];
					if (_isPolling) dispatchEvent( new Event( Event.CHANGE ) );
				}
			}
		}
	}
}
