package com.oynor.utils 
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	public class Wait 
	{
		/**
		 * Prevents any already started timeouts from firing and 
		 * will also prevent new ones.
		 */
		public static var abort:Boolean;

		private static var _timers:Dictionary = new Dictionary( true );
		private static var _callbacks:Dictionary = new Dictionary( true );
		private static var _callbackParams:Dictionary = new Dictionary( true );

		public function Wait () 
		{
			throw new Error( "Use static methods" );
		}

		/**
		 * Performs a call to the supplied method after the specified waiting period. 
		 * @param callback:Function The method to call after delay
		 * @param delayMS:uint The time to wait before callback in milliseconds. Default: 33 (roughly the duration of one frame in 30 fps)
		 * @param overwrite:Boolean Resets the timer if the callback function is already connected to a running timer
		 * @param callbackParams:Array Any parameters to pass on to the callback method
		 * @return Timer A reference to the timer instance created for the delay
		 */
		public static function forTimeout (callback:Function, delayMS:uint = 33, overwite:Boolean = false, callbackParams:Array = null):Timer 
		{
			if (abort) return null;
			
			var tm:Timer;
			if (overwite && _timers[callback])
			{
				tm = _timers[callback];
				tm.reset( );
				tm.delay = delayMS;
			}
			else
			{
				tm = new Timer( delayMS , 1 );
				tm.addEventListener( TimerEvent.TIMER_COMPLETE , _onComplete , false , 0 , true );
				_timers[callback] = tm;
				_callbacks[tm] = callback;
			}
			
			_callbackParams[tm] = callbackParams;
			tm.start( );

			return tm;
		}

		private static function _onComplete (e:TimerEvent):void 
		{
			var tm:Timer = e.target as Timer;
			tm.removeEventListener( TimerEvent.TIMER_COMPLETE , _onComplete );
			
			var callback:Function = _callbacks[tm];
			var callbackParams:Array = _callbackParams[tm];
			
			if (!abort) callback.apply( null , callbackParams );
			
			_callbacks[tm] = null;
			_callbackParams[tm] = null;
			_timers[callback] = null;
		}
	}
}