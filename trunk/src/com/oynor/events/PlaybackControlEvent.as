package com.oynor.events
{
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 27. aug. 2010
	 */
	public class PlaybackControlEvent extends Event
	{
		public static const PLAY:String = "play";
		public static const PAUSE:String = "pause";
		public static const RESUME:String = "resume";
		public static const STOP:String = "stop";
		public static const SEEK:String = "seek";
		public static const SET_VOLUME:String = "setVolume";
		public static const TOGGLE_FULLSCREEN:String = "toggleFullscree";

		private var _value:Number;

		public function PlaybackControlEvent ( type:String , value:Number = 0 , bubbles:Boolean = false , cancelable:Boolean = false )
		{
			super( type , bubbles , cancelable );
			_value = value;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new PlaybackControlEvent( type , _value , bubbles , cancelable );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString ():String
		{
			return formatToString( "PlaybackEvent" , "type" , "value" , "bubbles" , "cancelable" , "eventPhase" );
		}

		public function get value () : Number
		{
			return _value;
		}
	}
}
